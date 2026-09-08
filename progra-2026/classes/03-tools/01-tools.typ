#import "../../template.typ": *

#show: deck.with(
  title: "Clase 06 — Tools",
  author: "Juan Zurita",
)

// Bloques de código un poco más compactos que el cuerpo
#show raw.where(block: true): set text(size: 11pt)

// ============================================================
// Helpers
// ============================================================

// Caja para mostrar una petición / respuesta / fragmento de código.
#let code-box(label: "", tone: "request", body) = {
  let accent = if tone == "response" {
    palette.vanilla-custard.darken(25%)
  } else {
    palette.iron-grey
  }
  block(
    width: 100%,
    inset: (x: 5mm, y: 4mm),
    radius: 2mm,
    fill: palette.beige.darken(3%),
    stroke: (left: 4pt + accent),
  )[
    #text(size: 10pt, tracking: 0.15em, weight: "bold", fill: palette.charcoal)[#upper(label)]
    #v(2mm)
    #body
  ]
}

// Tabla con el estilo del deck: encabezado oscuro + filas alternadas
#let deck-table(cols, headers, rows, size: 13pt) = table(
  columns: cols,
  stroke: none,
  inset: (x: 5mm, y: 3.5mm),
  align: left + horizon,
  fill: (_, y) => if y == 0 {
    palette.iron-grey
  } else if calc.even(y) {
    palette.beige.darken(5%)
  } else {
    palette.beige.darken(1%)
  },
  table.header(
    ..headers.map(h => text(fill: palette.beige, weight: "bold", size: size)[#h]),
  ),
  ..rows.flatten().map(c => text(size: size, fill: palette.gunmetal)[#c]),
)

// Título
#title-slide(
  title: "Tools",
  subtitle: "Darle manos al modelo: cuando el LLM llama a tu código",
  author: "Juan Zurita",
  date: "Clase 06 · Septiembre 2026",
)

#contents-slide(
  entries: (
    (name: "Por qué un modelo necesita herramientas", page: "03"),
    (name: "Qué es un tool y su anatomía", page: "06"),
    (name: "Talleres: fecha, web y código", page: "11"),
    (name: "Breve historia de la IA", page: "14"),
    (name: "De LLM a agente", page: "17"),
    (name: "Cierre", page: "19"),
  ),
)

// Recordar lo que hicimos la anterior sesión.
#content-slide(
  title: "De dónde venimos",
  section: "Repaso",
)[
  #v(2mm)
  La clase pasada le hablamos a un modelo por su API.

  #v(4mm)
  - #text(weight: "bold")[`POST /chat/completions`] con `model` y `messages`
  - Roles: `system`, `user`, `assistant`
  - La API es stateless: la memoria es la lista `messages`
  - Armamos un chatbot dentro de un bucle

  #v(6mm)
  #text(weight: "bold")[Hoy: le damos herramientas para hacer lo que solo no puede.]
]

// Preguntas reflexivas (preguntas exageradas) e.g. ¿cuánto es 4573×892?  La idea es que ellos solos no pueden, pero con una herramienta como una calculadora sí.
#activity-slide(
  kind: "Preguntas",
  title: "Sin ayuda, ¿puedes?",
  duration: "5 min",
)[
  #v(3mm)
  Respóndelas de memoria, sin tocar nada:

  #v(5mm)
  - ¿Cuánto es #text(weight: "bold")[4573 × 892]?
  - ¿Qué hora es #text(weight: "bold")[ahora mismo] en Tokio?
  - ¿Va a llover mañana donde vives?
  - ¿Qué salió en las noticias esta semana?
]

//
// Limitaciones de los modelos. Los modelos se limitan a sus datos entrenados, pero para eso les podamos dar herramientas. Este será un slide con imagen width 50%
#image-slide(
  title: "Lo que un modelo solo no puede",
  section: "Motivación",
  position: "right",
  media-width: slide-width * 50%,
)[
  #v(4mm)
  - Su conocimiento tiene #text(weight: "bold")[fecha de corte]
  - No calcula: predice texto
  - No navega la web ni lee tu base de datos
  - No sabe la hora ni ve tus archivos

  #v(6mm)
  #text(weight: "bold")[Para todo eso, le pasamos herramientas.]
]

// Explicación de los tools.
#content-slide(
  title: "Qué es un tool",
  section: "Tools",
)[
  #v(2mm)
  Un tool es una #text(weight: "bold")[función que tú defines] y que el modelo
  puede pedir usar.

  #v(5mm)
  + Le describes la función al modelo
  + El modelo responde: "quiero llamar `fecha_actual()`"
  + Tú ejecutas la función en tu código
  + Le devuelves el resultado y responde con él

  #v(6mm)
  #text(weight: "bold")[El modelo nunca ejecuta nada. Solo pide. Tú controlas.]
]

// Anatomia de los tool: explicación y en otra parte del slideck código.
#content-slide(
  title: "Anatomía: la definición",
  section: "Tools",
)[
  #v(1mm)
  Cada tool se describe con tres cosas:

  #v(3mm)
  - #text(weight: "bold")[`name`]: cómo se llama la función
  - #text(weight: "bold")[`description`]: cuándo usarla. El modelo lee esto para decidir
  - #text(weight: "bold")[`parameters`]: qué datos necesita, en JSON Schema

  #v(3mm)
  #code-box(label: "un tool descrito para el modelo", tone: "request")[
```json
{
  "type": "function",
  "function": {
    "name": "clima",
    "description": "Clima actual de una ciudad",
    "parameters": {
      "type": "object",
      "properties": { "ciudad": { "type": "string" } },
      "required": ["ciudad"]
    }
  }
}
```
  ]
]

#content-slide(
  title: "Anatomía: el ciclo en código",
  section: "Tools",
)[
  #v(1mm)
  #code-box(label: "una vuelta completa: pedir, ejecutar, devolver", tone: "request")[
```python
mensajes = [{"role": "user", "content": "¿Qué clima hace en Quito?"}]

r = pedir(mensajes, tools)                    # 1ª llamada
llamada = r["choices"][0]["message"]["tool_calls"][0]

args = json.loads(llamada["function"]["arguments"])
resultado = clima(args["ciudad"])             # tú ejecutas la función

mensajes.append(r["choices"][0]["message"])
mensajes.append({
    "role": "tool",
    "tool_call_id": llamada["id"],
    "content": resultado,
})
respuesta = pedir(mensajes, tools)            # 2ª llamada: ahora sí contesta
```
  ]

  #v(3mm)
  - `finish_reason: "tool_calls"` avisa que el modelo quiere una herramienta
  - El resultado vuelve como un turno con `role: "tool"`
]

// Preguntas para los estudioantes ¿Esta tarea require un tool o no?
#activity-slide(
  kind: "Preguntas",
  title: "¿Tool o no?",
  duration: "5 min",
)[
  #v(3mm)
  Para cada tarea: ¿el modelo la hace solo, o necesita una herramienta?

  #v(5mm)
  - Resumir un correo largo
  - Calcular el 18% de 2.340
  - Decir qué películas se estrenan esta semana
  - Traducir un texto al inglés
  - Dar el clima de Bogotá ahora
  - Escribir un poema
]

// Prueba: la fecha de hoy.
#content-slide(
  title: "Prueba: ¿qué fecha es hoy?",
  section: "Tools",
)[
  #v(2mm)
  Pregúntale a un modelo, sin tools, qué día es hoy. Vas a ver una de tres:

  #v(5mm)
  + Responde con su fecha de corte
  + Inventa una fecha cualquiera
  + Avisa que no lo sabe

  #v(6mm)
  Ninguna sirve. #text(weight: "bold")[Con un tool que lea el reloj, sí.]
]

// Taller tool que nos diga la fecha actual.
#activity-slide(
  kind: "Taller",
  title: "Tool: la fecha de hoy",
  duration: "10 min",
)[
  #v(2mm)
  En el notebook `01-tools.ipynb`:

  #v(4mm)
  + Escribe `fecha_actual()`: devuelve la fecha de hoy como texto
  + Descríbela en el arreglo `tools`
  + Pregunta "¿qué fecha es hoy?" y corre el ciclo completo
  + Imprime la respuesta final del modelo

  #v(6mm)
  Cierre: alguien muestra el `tool_call` que pidió el modelo.
]

// Taller tool de web search (jupiter notebook via openrouter)
#activity-slide(
  kind: "Taller",
  title: "Tool: buscar en la web",
  duration: "15 min",
)[
  #v(2mm)
  OpenRouter trae búsqueda web lista para usar.

  #v(4mm)
  + Agrega `"plugins": [{ "id": "web" }]` al body, o usa el sufijo `:online`
  + Pregunta algo de esta semana: noticias, precios, estrenos
  + Corre la misma pregunta sin búsqueda y compara
  + Revisa las fuentes: vienen dentro de la respuesta

  #v(5mm)
  Cierre: ¿la versión con web fue más precisa?
]

// Taller tool search tool que ejecute el código.
#activity-slide(
  kind: "Taller",
  title: "Tool: ejecutar código",
  duration: "15 min",
)[
  #v(2mm)
  Un tool que recibe código Python y devuelve lo que imprime.

  #v(4mm)
  + Escribe `ejecutar_python(codigo)` que corre el código y captura la salida
  + Descríbela en `tools`
  + Pide "¿cuánto es 4573 × 892?" y deja que el modelo escriba el cálculo
  + Prueba otra: ordenar una lista, contar palabras de un texto

  #v(5mm)
  #text(weight: "bold")[Cuidado:] ejecutas lo que el modelo escriba. Solo en tu
  máquina y revisando antes qué pidió.
]

// Título; breve historia de la IA.
#section-slide(
  number: "02",
  title: "Breve historia de la IA",
  subtitle: "De las reglas a mano al agente, en unas pocas décadas",
)

// Qué había antes de los Transformers.
#content-slide(
  title: "Antes de los Transformers",
  section: "Historia",
)[
  #v(2mm)
  #deck-table(
    (auto, 1fr),
    ("Época", "Cómo se hacía"),
    (
      ("1950–80", "IA simbólica: reglas y sistemas expertos escritos a mano"),
      ("1990s", "Aprendizaje estadístico: árboles, SVM, un modelo por tarea"),
      ("2000s", "Lenguaje con n‑gramas: contar qué palabra suele seguir a cuál"),
      ("2013", "word2vec: cada palabra pasa a ser un vector con significado"),
      ("2014–16", "RNN y LSTM: leen palabra por palabra, con memoria corta"),
    ),
    size: 13.5pt,
  )

  #v(3mm)
  #text(size: 14pt, style: "italic")[El cuello de botella era la lectura
  secuencial: frases largas se olvidaban por el camino.]
]

// Línea del tiempo de modelos, puede ser bullet list y una tabla.
#content-slide(
  title: "Del Transformer en adelante",
  section: "Historia",
)[
  #v(2mm)
  #deck-table(
    (auto, 1fr),
    ("Año", "Hito"),
    (
      ("2017", "El Transformer mira toda la frase a la vez, sin leerla en orden"),
      ("2018", "GPT y BERT: preentrenar con texto masivo y luego afinar"),
      ("2020", "GPT-3: pocas instrucciones, muchas tareas distintas"),
      ("2022", "ChatGPT lleva los LLM a todo el mundo"),
      ("2023", "GPT-4, Claude y Llama abren la carrera"),
      ("2024", "Multimodal y tool use como estándar"),
      ("2025", "Agentes: el modelo encadena herramientas solo"),
    ),
    size: 13.5pt,
  )

  #v(3mm)
  #text(size: 14pt, style: "italic")[La arquitectura casi no cambió. Cambiaron la
  escala, los datos y lo que dejamos que el modelo haga.]
]

// De LLM a Agentes, Con imagen con 50% width
#image-slide(
  title: "De LLM a agente",
  section: "Agentes",
  position: "right",
  media-width: slide-width * 50%,
)[
  #v(3mm)
  Un agente es el mismo ciclo de tools, pero sin ti en el medio.

  #v(5mm)
  + El modelo llama un tool
  + Lee el resultado
  + Decide el siguiente paso
  + Repite hasta terminar

  #v(6mm)
  #text(weight: "bold")[El bucle `while` que armaste ya es un agente pequeño.]
]

// Ejemplos de uso real.
#content-slide(
  title: "En el mundo real",
  section: "Agentes",
)[
  #v(2mm)
  - Editores de código que leen y escriben tus archivos
  - Asistentes que buscan en la web antes de responder
  - Bots de soporte que consultan tu base de datos
  - Flujos que agendan reuniones o mandan correos

  #v(6mm)
  Todos son lo mismo: #text(weight: "bold")[tools descritos en JSON] y un modelo
  que decide cuándo usarlos.
]

// Cierre de la clase: resumen
#content-slide(
  title: "Lo que vimos hoy",
  section: "Cierre",
)[
  #v(2mm)
  + Un modelo solo predice texto: no calcula ni navega
  + Un tool es una función que tú defines y el modelo pide usar
  + Se describe con `name`, `description` y `parameters`
  + El ciclo: describir, pedir, ejecutar, devolver
  + Tú siempre ejecutas: el modelo nunca toca tu código
  + Encadenar tools sin humano en el medio es un agente
]

#activity-slide(
  kind: "Reflexión",
  title: "¿Qué le darías de herramienta?",
  duration: "5 min",
)[
  #v(3mm)
  Piensa en algo que haces cada semana en la computadora.

  #v(5mm)
  - ¿Qué tool necesitaría un modelo para ayudarte?
  - ¿Qué datos le pasarías?
  - ¿Qué le dejarías ejecutar y qué no?

  #v(6mm)
  Compártelo con la persona de al lado.
]
