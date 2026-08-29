# HTTP Detective

Juego educativo para practicar HTTP. Cada estudiante recibe un caso y debe
descubrir qué persona estuvo relacionada con un incidente, haciendo únicamente
peticiones HTTP.

## Correr el servidor

```bash
uv sync
uv run uvicorn main:app --reload
```

Servidor en `http://127.0.0.1:8000`. Docs automáticas en `/docs`.

Para usarlo en remoto usar: 

```bash
cloudflared tunnel --url localhost:8080
```

En `/docs`, el botón **Authorize** (candado) permite pegar el token una vez;
a partir de ahí todos los "Try it out" envían `Authorization: Bearer <token>`.
Los endpoints protegidos aparecen con un candado.

## Flujo del juego

```
POST /login            -> token + case_id
GET  /case             -> datos del caso (hora del incidente)
GET  /access-log       -> accesos registrados
GET  /access/{id}      -> detalle de un acceso -> person_id
GET  /people/{id}      -> nombre y rol de la persona
GET  /evidence         -> pistas que confirman el razonamiento
POST /case/resolve     -> { "access_id": "..." }  -> ¿correcto?
```

Todos los endpoints excepto `/login` y `/check` requieren el header
`Authorization: Bearer <token>`.

## Consultar avance

```
GET /check   -> { count, completed, students: [ { carnet, name, completed,
                  steps_done, last_step, attempts_used }, ... ] }
```

Endpoint público (sin token). Devuelve un estudiante por cada carnet que haya
iniciado sesión, ordenados por carnet. Por estudiante reporta si ya resolvió el
caso (`completed`) y en qué pasos del juego ha estado (`steps_done`, en orden;
`last_step` es el más reciente).

### results.csv

Cada acción de un estudiante reescribe `results.csv` junto al servidor con una
fila por estudiante:

```
carnet,name,completed,last_step,steps_done,attempts_used
2024001,Ana Perez,True,resolve,login|case|access-log|evidence|resolve,1
```

`steps_done` va separado por `|`. El archivo está en `.gitignore`. Las sesiones
siguen viviendo en memoria (reiniciar el servidor las borra), pero el último
`results.csv` queda en disco.

## Detalles de implementación

- **Login**: acepta `carnet` (obligatorio, solo dígitos) y `complete_name`
  (opcional). El token es un hash determinístico del carnet — simula el flujo
  "inicio sesión -> recibo un token -> lo reenvío". No hay lista de estudiantes
  válidos.
- **Casos**: hay un pool de casos en `cases.py`. Cada carnet se asigna a uno de
  forma determinística, así que estudiantes distintos investigan escenarios
  distintos.
- **Sesiones**: solo en memoria. Reiniciar el servidor borra todo el progreso.
- **Sin límites de intentos**: los estudiantes pueden explorar libremente.
- **Errores HTTP didácticos**: 401 (sin token / token inválido, con
  `WWW-Authenticate: Bearer`), 404 (`access_not_found`, `person_not_found`, o
  `not_found` genérico), 405 (con header `Allow`).

La respuesta correcta siempre es el acceso registrado inmediatamente antes de
`incident_time`.
