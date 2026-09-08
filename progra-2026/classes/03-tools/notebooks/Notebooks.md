# Notebooks de la Clase 06 — Tools

Propuesta de notebooks a partir de `01-tools.typ`. **Aún no implementados.**

El deck tiene 3 talleres (slide de contenidos: "Talleres: fecha, web y código").
Siguiendo el patrón de la Clase 02 (`openrouter/01…02…03`: un notebook corto y
autocontenido por paso), se proponen **3 notebooks**.

| Notebook | Slides que cubre | Contenido |
|----------|------------------|-----------|
| `01-tools.ipynb` — El ciclo de un tool | "Anatomía: la definición", "Anatomía: el ciclo en código", "Taller: Tool: la fecha de hoy" (p. 7–8, 11) | Setup (`httpx`, API key, `pedir()`). Definir `fecha_actual()`, describirla en `tools` (el JSON Schema del deck), correr la vuelta completa: 1ª llamada → `finish_reason: "tool_calls"` → ejecutar la función → turno `role: "tool"` → 2ª llamada. Imprimir el `tool_call` que pidió el modelo. |
| `02-tools.ipynb` — Búsqueda web con OpenRouter | "Taller: Tool: buscar en la web" (p. 12) | Agregar `"plugins": [{"id": "web"}]` (o el sufijo `:online`). Misma pregunta con y sin búsqueda para comparar. Inspeccionar las fuentes/anotaciones que vienen en la respuesta. |
| `03-tools.ipynb` — Ejecutar código como tool | "Taller: Tool: ejecutar código" (p. 13) | `ejecutar_python(codigo)` que corre el código y captura `stdout`. Describirla en `tools`. Pedir "¿cuánto es 4573 × 892?", luego otra tarea (ordenar una lista, contar palabras). Nota de seguridad: se ejecuta lo que el modelo escriba. Opcional: cerrar con el bucle `while` (mini-agente) que enlaza con la sección "De LLM a agente". |

## Notas

- **El deck solo nombra `01-tools.ipynb`** (slide p. 11). Si se van con 3
  notebooks, hay que actualizar los slides de los talleres de web y código para
  que apunten a `02-tools.ipynb` y `03-tools.ipynb`, y ajustar el `README.md`.
- **Alternativa (1 notebook):** `01-tools.ipynb` con las 3 secciones seguidas.
  No se toca el deck y el setup se comparte, pero rompe el patrón de la Clase 02
  y el notebook queda largo (~18 celdas).
- Las secciones "Breve historia de la IA" y "En el mundo real" son puramente
  expositivas → sin notebook.
