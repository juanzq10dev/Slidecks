# Cliente — HTTP Detective

`template.ipynb` es la plantilla para resolver el caso desde Python, haciendo
**solo peticiones HTTP**.

## Abrir el notebook

Con `uv` (recomendado):

```bash
cd client
uv run jupyter notebook template.ipynb
```

`uv` instala las dependencias (`httpx`, Jupyter) la primera vez.

En VS Code: abre `template.ipynb` y, al elegir kernel, selecciona el intérprete
de `client/.venv` (créalo antes con `uv sync`).

Sin `uv`:

```bash
pip install httpx notebook
jupyter notebook template.ipynb
```

## Usar

1. Ejecuta las celdas de **Preparación** (`import httpx` y el ayudante `show`).
2. En la sección **1. Login** (ya resuelta), edita como texto dentro de la
   llamada:
   - la URL del servidor que te dé el instructor,
   - tu carnet (solo dígitos),
   - tu nombre completo.
   Al ejecutarla deja el `token` listo para el resto de pasos.
3. Completa las celdas marcadas con `TODO`, una por una, ejecutándolas para ver
   qué responde el servidor. Usa **la misma URL base** del login en cada
   petición y añade el header `Authorization`.

## Pistas HTTP

- Todos los endpoints excepto `/login` necesitan el header
  `Authorization: Bearer <token>`, es decir
  `headers={"Authorization": f"Bearer {token}"}`.
- `GET` para consultar; `POST` con cuerpo JSON para `/login` y `/case/resolve`.
- Un parámetro en la ruta (como `/access/A17`) va dentro de la URL, no en el body.
- Revisa siempre `respuesta.status_code`: 200 ok, 401 sin token / token malo,
  404 recurso inexistente, 405 método equivocado.

## Objetivo

El acceso correcto es el registrado **inmediatamente antes** de la hora del
incidente (`incident_time` en `GET /case`).
