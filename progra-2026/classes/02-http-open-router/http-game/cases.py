"""Case data for HTTP Detective.

Each student is deterministically assigned ONE case from this pool based on
their carnet, so two students with different carnets normally investigate
different scenarios and cannot simply share the final answer.

Every case is self-contained:

    - ``accesses``  maps every access_id in the log to its details.
    - ``people``    maps every person_id to a name and role.
    - ``correct_access_id`` is always the access registered immediately
      before ``incident_time`` (that is the deduction the student must make).
"""

import hashlib

CASES: list[dict] = [
    {
        "case_id": "CASE-1842",
        "title": "El incidente del Laboratorio 3",
        "location": "Laboratorio 3",
        "date": "2026-08-29",
        "incident_time": "18:42",
        "description": "Se produjo un incidente en el Laboratorio 3 a las 18:42.",
        "hint": "Consulta el registro de accesos del laboratorio.",
        "log_hint": "Investiga el acceso inmediatamente anterior al incidente.",
        "correct_access_id": "C92",
        "accesses": {
            "A17": {"time": "18:15", "status": "accepted", "person_id": "P05"},
            "B04": {"time": "18:31", "status": "accepted", "person_id": "P09"},
            "C92": {"time": "18:41", "status": "accepted", "person_id": "P17"},
            "D11": {"time": "18:55", "status": "accepted", "person_id": "P23"},
        },
        "people": {
            "P05": {"name": "Lucía", "role": "professor"},
            "P09": {"name": "Tomás", "role": "student"},
            "P17": {"name": "Sofía", "role": "student"},
            "P23": {"name": "Guard", "role": "security"},
        },
        "evidence": [
            {"id": "E01", "description": "El incidente ocurrió a las 18:42."},
            {"id": "E02", "description": "El acceso registrado inmediatamente antes del incidente es relevante para la investigación."},
        ],
    },
    {
        "case_id": "CASE-2306",
        "title": "La alarma del Laboratorio 1",
        "location": "Laboratorio 1",
        "date": "2026-09-03",
        "incident_time": "09:15",
        "description": "La alarma del Laboratorio 1 se activó a las 09:15.",
        "hint": "Alguien entró justo antes de que sonara la alarma. Revisa los accesos.",
        "log_hint": "El acceso relevante es el más cercano anterior a las 09:15.",
        "correct_access_id": "K03",
        "accesses": {
            "K01": {"time": "08:40", "status": "accepted", "person_id": "P21"},
            "K02": {"time": "09:03", "status": "denied", "person_id": "P28"},
            "K03": {"time": "09:12", "status": "accepted", "person_id": "P30"},
            "K04": {"time": "09:20", "status": "accepted", "person_id": "P34"},
        },
        "people": {
            "P21": {"name": "Marco", "role": "technician"},
            "P28": {"name": "Renata", "role": "student"},
            "P30": {"name": "Iván", "role": "technician"},
            "P34": {"name": "Camila", "role": "professor"},
        },
        "evidence": [
            {"id": "E01", "description": "La alarma se activó a las 09:15."},
            {"id": "E02", "description": "Un acceso 'denied' significa que la puerta no se abrió: esa persona no entró."},
            {"id": "E03", "description": "Busca el último acceso aceptado antes de la alarma."},
        ],
    },
    {
        "case_id": "CASE-3517",
        "title": "El expediente perdido de la Biblioteca",
        "location": "Biblioteca Central",
        "date": "2026-09-07",
        "incident_time": "14:05",
        "description": "Un expediente desapareció de la Biblioteca Central alrededor de las 14:05.",
        "hint": "Consulta quién accedió al depósito antes de las 14:05.",
        "log_hint": "Investiga el acceso inmediatamente anterior al incidente.",
        "correct_access_id": "M12",
        "accesses": {
            "M10": {"time": "13:20", "status": "accepted", "person_id": "P40"},
            "M11": {"time": "13:47", "status": "accepted", "person_id": "P44"},
            "M12": {"time": "14:01", "status": "accepted", "person_id": "P47"},
            "M13": {"time": "14:30", "status": "accepted", "person_id": "P51"},
            "M14": {"time": "15:00", "status": "accepted", "person_id": "P40"},
        },
        "people": {
            "P40": {"name": "Beatriz", "role": "librarian"},
            "P44": {"name": "Hugo", "role": "student"},
            "P47": {"name": "Elena", "role": "professor"},
            "P51": {"name": "Nicolás", "role": "student"},
        },
        "evidence": [
            {"id": "E01", "description": "El expediente desapareció alrededor de las 14:05."},
            {"id": "E02", "description": "El acceso registrado inmediatamente antes del incidente es relevante para la investigación."},
        ],
    },
    {
        "case_id": "CASE-4788",
        "title": "El cortocircuito del Taller de Electrónica",
        "location": "Taller de Electrónica",
        "date": "2026-09-11",
        "incident_time": "20:30",
        "description": "Un cortocircuito dañó los equipos del Taller de Electrónica a las 20:30.",
        "hint": "Revisa quién usó el taller esa noche.",
        "log_hint": "El acceso más cercano anterior a las 20:30 es el que debes investigar.",
        "correct_access_id": "T07",
        "accesses": {
            "T05": {"time": "19:50", "status": "accepted", "person_id": "P60"},
            "T06": {"time": "20:10", "status": "accepted", "person_id": "P63"},
            "T07": {"time": "20:28", "status": "accepted", "person_id": "P66"},
            "T08": {"time": "20:45", "status": "accepted", "person_id": "P69"},
        },
        "people": {
            "P60": {"name": "Paula", "role": "professor"},
            "P63": {"name": "Sebastián", "role": "student"},
            "P66": {"name": "Diego", "role": "student"},
            "P69": {"name": "Ana", "role": "technician"},
        },
        "evidence": [
            {"id": "E01", "description": "El cortocircuito ocurrió a las 20:30."},
            {"id": "E02", "description": "El acceso registrado inmediatamente antes del incidente es relevante para la investigación."},
        ],
    },
    {
        "case_id": "CASE-5921",
        "title": "La muestra contaminada del Laboratorio 5",
        "location": "Laboratorio 5",
        "date": "2026-09-15",
        "incident_time": "11:55",
        "description": "Una muestra del Laboratorio 5 apareció contaminada a las 11:55.",
        "hint": "Alguien manipuló la muestra poco antes. Consulta el registro de accesos.",
        "log_hint": "Investiga el acceso inmediatamente anterior al incidente.",
        "correct_access_id": "L32",
        "accesses": {
            "L30": {"time": "11:10", "status": "accepted", "person_id": "P70"},
            "L31": {"time": "11:33", "status": "accepted", "person_id": "P73"},
            "L32": {"time": "11:52", "status": "accepted", "person_id": "P76"},
            "L33": {"time": "12:05", "status": "accepted", "person_id": "P79"},
        },
        "people": {
            "P70": {"name": "Fernanda", "role": "researcher"},
            "P73": {"name": "Bruno", "role": "student"},
            "P76": {"name": "Valentina", "role": "researcher"},
            "P79": {"name": "Óscar", "role": "student"},
        },
        "evidence": [
            {"id": "E01", "description": "La contaminación se detectó a las 11:55."},
            {"id": "E02", "description": "El acceso registrado inmediatamente antes del incidente es relevante para la investigación."},
        ],
    },
    {
        "case_id": "CASE-6033",
        "title": "La caída de la Sala de Servidores",
        "location": "Sala de Servidores",
        "date": "2026-09-19",
        "incident_time": "03:12",
        "description": "Los servidores se apagaron de forma inesperada a las 03:12.",
        "hint": "Muy poca gente entra de madrugada. Revisa los accesos.",
        "log_hint": "Investiga el acceso inmediatamente anterior al incidente.",
        "correct_access_id": "S03",
        "accesses": {
            "S01": {"time": "02:30", "status": "accepted", "person_id": "P80"},
            "S02": {"time": "02:58", "status": "denied", "person_id": "P83"},
            "S03": {"time": "03:09", "status": "accepted", "person_id": "P86"},
            "S04": {"time": "03:40", "status": "accepted", "person_id": "P89"},
        },
        "people": {
            "P80": {"name": "Ramiro", "role": "sysadmin"},
            "P83": {"name": "Julia", "role": "student"},
            "P86": {"name": "Andrés", "role": "sysadmin"},
            "P89": {"name": "Clara", "role": "security"},
        },
        "evidence": [
            {"id": "E01", "description": "Los servidores se apagaron a las 03:12."},
            {"id": "E02", "description": "Un acceso 'denied' significa que la persona no llegó a entrar."},
            {"id": "E03", "description": "Busca el último acceso aceptado antes de la caída."},
        ],
    },
]


def assign_case(carnet: str) -> dict:
    """Deterministically map a carnet to one case from the pool."""
    digest = hashlib.sha256(carnet.encode()).hexdigest()
    index = int(digest, 16) % len(CASES)
    return CASES[index]


def build_access_log(case: dict) -> list[dict]:
    """The public access log: only access_id + time, in chronological order."""
    entries = [
        {"access_id": access_id, "time": data["time"]}
        for access_id, data in case["accesses"].items()
    ]
    entries.sort(key=lambda entry: entry["time"])
    return entries
