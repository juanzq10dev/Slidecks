import csv
import hashlib
from pathlib import Path

from fastapi import Depends, FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel

from cases import assign_case, build_access_log

app = FastAPI(title="HTTP Detective")

TOKEN_SECRET = "http-detective-classroom-secret"

SESSIONS: dict[str, dict] = {}

# Pasos del juego, en orden. Se registran en la sesión conforme el estudiante
# los va tocando, para poder consultar su avance desde GET /check.
GAME_STEPS = ["login", "case", "access-log", "access", "people", "evidence", "resolve"]

# El progreso se vuelca a este CSV en cada acción de un estudiante, así el
# instructor siempre tiene la foto actual (y sobrevive a un reinicio).
RESULTS_CSV = Path(__file__).with_name("results.csv")

# Declares the "Bearer token" auth scheme so Swagger UI (/docs) shows an
# "Authorize" button and a padlock on every protected endpoint. auto_error=False
# lets us return our own JSON body + WWW-Authenticate header instead of FastAPI's.
bearer_scheme = HTTPBearer(
    auto_error=False,
    description="Token recibido en POST /login. Se envía como: Authorization: Bearer <token>",
)


# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #
def make_token(carnet: str) -> str:
    """Deterministic opaque token derived from the carnet."""
    return hashlib.sha256(f"{carnet}:{TOKEN_SECRET}".encode()).hexdigest()


def collect_students() -> list[dict]:
    """Avance de cada estudiante que haya iniciado sesión, ordenado por carnet."""
    students = []
    for session in SESSIONS.values():
        steps_done = session.get("steps_done", [])
        students.append(
            {
                "carnet": session["student_id"],
                "name": session["complete_name"] or session["student_id"],
                "completed": session["case_solved"],
                "steps_done": steps_done,
                "last_step": steps_done[-1] if steps_done else None,
                "attempts_used": session["attempts_used"],
            }
        )
    students.sort(key=lambda s: s["carnet"])
    return students


def write_results_csv() -> None:
    """Reescribe results.csv con el progreso actual de todos los estudiantes."""
    fields = ["carnet", "name", "completed", "last_step", "steps_done", "attempts_used"]
    with RESULTS_CSV.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fields)
        writer.writeheader()
        for student in collect_students():
            writer.writerow(
                {
                    "carnet": student["carnet"],
                    "name": student["name"],
                    "completed": student["completed"],
                    "last_step": student["last_step"] or "",
                    "steps_done": "|".join(student["steps_done"]),
                    "attempts_used": student["attempts_used"],
                }
            )


def mark_step(session: dict, step: str) -> None:
    """Registra que el estudiante llegó a este paso del juego y actualiza el CSV."""
    done = session.setdefault("steps_done", [])
    if step not in done:
        done.append(step)
    write_results_csv()


def error(status: int, code: str, message: str, headers: dict | None = None) -> JSONResponse:
    return JSONResponse(
        status_code=status,
        content={"error": code, "message": message},
        headers=headers,
    )


def get_session(
    credentials: HTTPAuthorizationCredentials | None = Depends(bearer_scheme),
) -> dict | JSONResponse:
    """Resolve the session from the Authorization: Bearer header.

    Used as a dependency. Returns the session dict, or a ready-to-return
    JSONResponse on failure (the endpoint just returns it as-is).
    """
    if credentials is None:
        return error(
            401,
            "unauthorized",
            "Falta el header Authorization. Usa: Authorization: Bearer <token>",
            headers={"WWW-Authenticate": "Bearer"},
        )

    session = SESSIONS.get(credentials.credentials.strip())
    if session is None:
        return error(
            401,
            "invalid_token",
            "Token inválido o desconocido. Inicia sesión en POST /login.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return session


# --------------------------------------------------------------------------- #
# Generic HTTP errors (educational)
# --------------------------------------------------------------------------- #
@app.exception_handler(404)
async def not_found_handler(request: Request, exc) -> JSONResponse:
    return JSONResponse(
        status_code=404,
        content={"error": "not_found", "message": "El recurso solicitado no existe."},
    )


@app.exception_handler(405)
async def method_not_allowed_handler(request: Request, exc) -> JSONResponse:
    # Starlette computes the allowed methods and puts them in exc.headers["Allow"].
    allow = getattr(exc, "headers", {}).get("Allow", "")
    return JSONResponse(
        status_code=405,
        content={
            "error": "method_not_allowed",
            "message": f"Método no permitido en esta ruta. Métodos permitidos: {allow}",
        },
        headers={"Allow": allow} if allow else None,
    )


# --------------------------------------------------------------------------- #
# Welcome
# --------------------------------------------------------------------------- #
@app.get("/")
async def root() -> dict:
    return {
        "game": "HTTP Detective",
        "goal": "Descubre qué persona estuvo relacionada con el incidente del laboratorio.",
        "start": "POST /login con { \"carnet\": \"...\", \"complete_name\": \"...\" }",
        "flow": [
            "POST /login",
            "GET /case",
            "GET /access-log",
            "GET /access/{access_id}",
            "GET /people/{person_id}",
            "GET /evidence",
            "POST /case/resolve",
        ],
        "check": "GET /check (público, sin token) para ver el avance de todos",
    }


# --------------------------------------------------------------------------- #
# Progreso del estudiante (público, sin autenticación)
# --------------------------------------------------------------------------- #
@app.get("/check")
async def check_students():
    """Consulta pública del avance de todos los estudiantes.

    No requiere token. Devuelve un estudiante por cada carnet que haya iniciado
    sesión, con su nombre, si completó el caso y en qué pasos del juego ha estado.
    El mismo progreso se guarda en results.csv junto al servidor.
    """
    students = collect_students()
    return {
        "count": len(students),
        "completed": sum(1 for s in students if s["completed"]),
        "students": students,
    }


# --------------------------------------------------------------------------- #
# 2. Authentication
# --------------------------------------------------------------------------- #
class LoginRequest(BaseModel):
    carnet: str
    complete_name: str | None = None


@app.post("/login")
async def login(body: LoginRequest) -> JSONResponse:
    carnet = body.carnet.strip()
    if not carnet.isdigit():
        return error(
            401,
            "invalid_credentials",
            "Carnet no reconocido.",
        )

    case = assign_case(carnet)
    token = make_token(carnet)

    SESSIONS[token] = {
        "student_id": carnet,
        "complete_name": (body.complete_name or "").strip() or None,
        "case_id": case["case_id"],
        "token": token,
        "attempts_used": 0,
        "case_solved": False,
        "steps_done": ["login"],
    }
    write_results_csv()

    return JSONResponse(
        status_code=200,
        content={"token": token, "case_id": case["case_id"]},
    )


# --------------------------------------------------------------------------- #
# 3. Get the case
# --------------------------------------------------------------------------- #
@app.get("/case")
async def get_case(session: dict | JSONResponse = Depends(get_session)):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "case")
    case = assign_case(session["student_id"])
    return {
        "case_id": case["case_id"],
        "title": case["title"],
        "location": case["location"],
        "date": case["date"],
        "incident_time": case["incident_time"],
        "description": case["description"],
        "hint": case["hint"],
    }


# --------------------------------------------------------------------------- #
# 4. Access log
# --------------------------------------------------------------------------- #
@app.get("/access-log")
async def get_access_log(session: dict | JSONResponse = Depends(get_session)):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "access-log")
    case = assign_case(session["student_id"])
    return {
        "location": case["location"],
        "entries": build_access_log(case),
        "hint": case["log_hint"],
    }


# --------------------------------------------------------------------------- #
# 5. Investigate an access
# --------------------------------------------------------------------------- #
@app.get("/access/{access_id}")
async def get_access(access_id: str, session: dict | JSONResponse = Depends(get_session)):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "access")
    case = assign_case(session["student_id"])
    access = case["accesses"].get(access_id)
    if access is None:
        return error(404, "access_not_found", "El acceso solicitado no existe.")

    return {
        "access_id": access_id,
        "time": access["time"],
        "location": case["location"],
        "status": access["status"],
        "person_id": access["person_id"],
    }


# --------------------------------------------------------------------------- #
# 6. Person information
# --------------------------------------------------------------------------- #
@app.get("/people/{person_id}")
async def get_person(person_id: str, session: dict | JSONResponse = Depends(get_session)):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "people")
    case = assign_case(session["student_id"])
    person = case["people"].get(person_id)
    if person is None:
        return error(404, "person_not_found", "La persona solicitada no existe.")

    return {
        "person_id": person_id,
        "name": person["name"],
        "role": person["role"],
    }


# --------------------------------------------------------------------------- #
# 7. Evidence
# --------------------------------------------------------------------------- #
@app.get("/evidence")
async def get_evidence(session: dict | JSONResponse = Depends(get_session)):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "evidence")
    case = assign_case(session["student_id"])
    return {
        "incident": {
            "time": case["incident_time"],
            "location": case["location"],
        },
        "evidence": case["evidence"],
    }


# --------------------------------------------------------------------------- #
# 8. Resolve the case
# --------------------------------------------------------------------------- #
class ResolveRequest(BaseModel):
    access_id: str


@app.post("/case/resolve")
async def resolve_case(
    body: ResolveRequest, session: dict | JSONResponse = Depends(get_session)
):
    if isinstance(session, JSONResponse):
        return session

    mark_step(session, "resolve")
    case = assign_case(session["student_id"])

    if body.access_id.strip() == case["correct_access_id"]:
        session["case_solved"] = True
        write_results_csv()
        return {
            "status": "solved",
            "correct": True,
            "message": "¡Caso resuelto!",
            "score": 100,
        }

    session["attempts_used"] += 1
    write_results_csv()
    return {
        "status": "incorrect",
        "correct": False,
        "message": "Ese acceso no corresponde al incidente. Sigue investigando.",
        "attempts_used": session["attempts_used"],
    }
