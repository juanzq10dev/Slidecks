#import "../../template.typ": *

#show: deck.with(
  title: "Clase 05 — OpenRouter",
  author: "Juan Zurita",
)

// Bloques de código un poco más compactos que el cuerpo
#show raw.where(block: true): set text(size: 11pt)

// ============================================================
// Helpers
// ============================================================

// Caja para mostrar una petición / respuesta / fragmento de código.
// El cuerpo se pasa como bloque de código (```lang ... ```), así URLs
// con `//` y comentarios no rompen el parser de Typst.
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

// ============================================================
// Portada
// ============================================================
#title-slide(
  title: "OpenRouter",
  subtitle: "Hablarle a una IA por su API: el mismo POST con JSON de siempre",
  author: "Juan Zurita",
  date: "Clase 05 · Septiembre 2026",
)

#contents-slide(
  entries: (
    (name: "Qué es OpenRouter y por qué usarlo", page: "04"),
    (name: "La llamada: chat completions y roles", page: "06"),
    (name: "Actividad 1: nuestra primera llamada", page: "08"),
    (name: "La respuesta, comparar modelos, costo", page: "09"),
    (name: "Construir un chatbot", page: "12"),
    (name: "Features avanzadas y actividad 2", page: "17"),
    (name: "Cierre y reflexión", page: "19"),
  ),
)

// ============================================================
// Hook / Warm up
// ============================================================
#activity-slide(
  kind: "Preguntas",
  title: "¿Qué viajó por la red?",
  duration: "5 min",
)[
  #v(2mm)
  La última vez que le escribiste a ChatGPT, Gemini o Claude ¿Qué crees que pasó?:

  #v(4mm)
  - ¿Tu mensaje salió de tu computadora? ¿a qué servidor llegó?
  - ¿Qué #text(weight: "bold")[método HTTP] crees que se usó?
  - ¿En qué #text(weight: "bold")[formato] viajó tu texto?
  - Cuando la respuesta "se escribió sola" en pantalla, ¿qué pasaba?

]

// ============================================================
// Qué es OpenRouter
// ============================================================
#image-slide(
  title: "Un intermediario entre tu código y los modelos",
  section: "Qué es OpenRouter",
  position: "right",
  media-width: slide-width * 50%,
  picture: image("./images/02-open-router.png", width: 100%),
)[
  #v(3mm)
  OpenRouter recibe tu petición y la #text(weight: "bold")[reenvía] al proveedor
  del modelo que elegiste.

  #v(4mm)
  - #text(weight: "bold")[Sin OpenRouter]: una cuenta, una API key y un formato
    distinto con OpenAI, con Anthropic, con Google...
  - #text(weight: "bold")[Con OpenRouter]: una cuenta, una key, un formato.
    Cambias de modelo cambiando un string.
  - Imita la API de OpenAI, así que tu código no cambia entre modelos.
  - Un solo saldo y un solo panel de gastos para todos los proveedores.
]

// ============================================================
// ¿Por qué OpenRouter?
// ============================================================
#content-slide(
  title: "¿Por qué OpenRouter?",
  section: "Qué es OpenRouter",
)[
  #v(2mm)
  - #text(weight: "bold")[Una sola credencial] en vez de una cuenta y una API key
    por empresa
  - #text(weight: "bold")[Un solo formato]: imita la API de OpenAI, así que el
    código no cambia entre modelos
  - #text(weight: "bold")[Comparar es trivial]: mismo request, cambias el string
    `"model"`, mides costo y calidad
  - #text(weight: "bold")[Respaldo automático]: `"models": [principal, respaldo]`
    → si un proveedor se cae, enruta a otro
  - #text(weight: "bold")[Un solo saldo] y un solo panel de gastos
  - #text(weight: "bold")[Modelos `:free`] para practicar sin tarjeta —
    `meta-llama/llama-3.3-70b-instruct:free`

  #v(5mm)
  #text(size: 14pt, style: "italic")[El costo: una capa más en el camino y un
  pequeño margen sobre el precio del proveedor.]
]

// ============================================================
// Chat completions: messages y roles
// ============================================================
#content-slide(
  title: "Chat completions: el campo messages y los roles",
  section: "La llamada",
)[
  La llamada es #text(weight: "bold")[`POST /api/v1/chat/completions`] con un body
  JSON de dos campos clave: `model` y `messages`.

  `messages` es una #text(weight: "bold")[lista ordenada] de turnos; cada turno
  es un objeto con `role` y `content`:

  #v(2mm)
  #deck-table(
    (auto, 1fr),
    ("Rol", "Qué es"),
    (
      ([#text(weight: "bold")[`system`]], "Instrucciones de fondo: quién es el modelo, tono, reglas. Es el system prompt de la clase 03"),
      ([#text(weight: "bold")[`user`]], "Lo que pregunta o pide la persona"),
      ([#text(weight: "bold")[`assistant`]], "Lo que respondió el modelo antes — así se sostiene el hilo"),
    ),
    size: 13.5pt,
  )

  #v(2mm)
  #code-box(label: "body mínimo", tone: "request")[
```json
{
  "model": "meta-llama/llama-3.3-70b-instruct:free",
  "messages": [
    { "role": "system", "content": "Eres un tutor breve para principiantes." },
    { "role": "user", "content": "¿Qué es una API?" }
  ]
}
```
  ]
]

// ============================================================
// Variables de entorno (en Colab)
// ============================================================
#content-slide(
  title: "La API key es un secreto: variables de entorno en Colab",
  section: "Configuración",
)[
  La key va en el header `Authorization: Bearer sk-or-...`.
  #text(weight: "bold")[Quien tiene tu key gasta tus créditos] — nunca la
  escribas en una celda ni la subas a git.

  #v(4mm)
  #text(weight: "bold")[En Colab] se usa el panel de secretos:
  + Abre el ícono de la #text(weight: "bold")[llave 🔑] en la barra izquierda
  + Crea un secreto `OPENROUTER_API_KEY` con tu key y activa "acceso al notebook"
  + Léelo desde el código:

  #v(3mm)
  #code-box(label: "leer el secreto en Colab", tone: "request")[
```python
from google.colab import userdata
import os

os.environ["OPENROUTER_API_KEY"] = userdata.get("OPENROUTER_API_KEY")
API_KEY = os.environ["OPENROUTER_API_KEY"]
```
  ]

  #v(2mm)
  #text(size: 13pt, style: "italic")[Fuera de Colab el patrón equivalente es un
  archivo `.env` (en `.gitignore`) leído con `python-dotenv`.]
]

// ============================================================
// Actividad 1: primera llamada
// ============================================================
#activity-slide(
  kind: "Taller",
  title: "Nuestra primera llamada",
  duration: "10 min",
)[
  #v(1mm)
  En el notebook `01-openrouter.ipynb`, con la key ya cargada:

  #v(4mm)
  + Ejecuta las celdas de preparación (`import`, `BASE_URL`, `HEADERS`, `show`)
  + Completa #text(weight: "bold")[una] llamada: `model` de un `:free` y un
    `messages` con tu pregunta
  + Ejecútala e imprime `r.status_code` y `choices[0].message.content`
  + Repite la pregunta con un `system` distinto. ¿Cambió el tono?

  #v(6mm)
  Cierre: 2 personas leen su respuesta y el `total_tokens` que gastó.
]

// ============================================================
// La respuesta
// ============================================================
#content-slide(
  title: "La respuesta: usage y finish_reason",
  section: "La respuesta",
)[
  #v(1mm)
  #code-box(label: "respuesta HTTP 200", tone: "response")[
```json
{
  "id": "gen-abc123",
  "model": "meta-llama/llama-3.3-70b-instruct:free",
  "choices": [
    { "message": { "role": "assistant", "content": "Una API es..." },
      "finish_reason": "stop" }
  ],
  "usage": { "prompt_tokens": 24, "completion_tokens": 57, "total_tokens": 81 }
}
```
  ]

  #v(3mm)
  - El texto vive en #text(weight: "bold")[`choices[0].message.content`] —
    bajar por clave y por posición, como en la clase de JSON
  - #text(weight: "bold")[`usage`]: tokens de entrada, de salida y total.
    Mídelo, no lo adivines
  - #text(weight: "bold")[`finish_reason`]: `stop` terminó solo ·
    `length` lo cortó `max_tokens`
]

// ============================================================
// Comparar modelos
// ============================================================
#content-slide(
  title: "Comparar modelos",
  section: "Comparar",
)[
  #v(2mm)
  Mismo `messages`, cambias solo el string `"model"` y comparas la misma tarea en
  tres ejes:

  #v(4mm)
  + #text(weight: "bold")[Calidad] — ¿la respuesta sirve para lo que necesitas?
  + #text(weight: "bold")[Costo] — mira `usage.total_tokens` y el precio del modelo
  + #text(weight: "bold")[Latencia] — ¿cuánto tardó en responder?

  #v(6mm)
  #text(weight: "bold")[Regla práctica:] empieza con el modelo pequeño y barato.
  Sube solo si la calidad no alcanza.

  #v(3mm)
  #text(size: 14pt, style: "italic")[Un clasificador de mensajes no necesita el
  modelo más caro. Un análisis legal, sí.]
]

// ============================================================
// Costo & Rate limit
// ============================================================
#content-slide(
  title: "Costo y rate limit",
  section: "Costo",
)[
  #v(2mm)
  - ~1000 tokens ≈ 750 palabras en inglés (bastante menos en español) ≈ media página
  - Pagas #text(weight: "bold")[entrada] (prompt + todo el historial) +
    #text(weight: "bold")[salida] (respuesta)
  - Cada respuesta trae `usage`: multiplica por tus llamadas y tus usuarios

  #v(4mm)
  #deck-table(
    (auto, auto, 1fr),
    ("Código", "Significado", "Cuándo aparece"),
    (
      ([#text(weight: "bold")[401]], "Unauthorized", "falta la API key o es inválida"),
      ([#text(weight: "bold")[402]], "Payment Required", "te quedaste sin créditos"),
      ([#text(weight: "bold")[429]], "Too Many Requests", "pasaste el rate limit (típico en modelos :free)"),
      ([#text(weight: "bold")[502 / 503]], "Bad Gateway / Unavailable", "el proveedor del modelo está caído"),
    ),
    size: 12.5pt,
  )

  #v(3mm)
  #text(size: 13pt, style: "italic")[Igual que en la clase de HTTP: revisa el
  código de estado antes de confiar en el body. Si un `:free` da `429` o `503`,
  prueba otro.]
]

// ============================================================
// Nueva sección: Construir un chatbot
// ============================================================
#section-slide(
  number: "02",
  title: "Construir un chatbot",
  subtitle: "HTTP no tiene memoria — la API tampoco",
)

// ------------------------------------------------------------
// Primera intuición: chatbot a mano
// ------------------------------------------------------------
#content-slide(
  title: "Primera intuición: la conversación a mano",
  section: "Chatbot",
)[
  #v(1mm)
  La API es #text(weight: "bold")[stateless]: no recuerda el mensaje anterior.
  Para sostener el hilo, reenvías #text(weight: "bold")[toda la lista `messages`]
  en cada llamada.

  #v(3mm)
  #code-box(label: "dos turnos, escritos uno por uno", tone: "request")[
```python
messages = [
    {"role": "system", "content": "Eres un tutor breve. Responde en 1-2 frases."},
    {"role": "user", "content": "¿Qué es una API?"},
]
respuesta = preguntar(messages)           # 1ª llamada

messages.append({"role": "assistant", "content": respuesta})
messages.append({"role": "user", "content": "Dame un ejemplo real."})
respuesta = preguntar(messages)           # 2ª llamada: se manda TODO otra vez
```
  ]

  #v(3mm)
  - Guardas la respuesta como `{"role": "assistant", ...}` y agregas el nuevo `user`
  - La #text(weight: "bold")[ventana de contexto] es cuántos tokens caben en
    `messages`; cuando se llena, hay que recortar los turnos viejos
]

// ------------------------------------------------------------
// Actividad: la conversación a mano (02-openrouter.ipynb)
// ------------------------------------------------------------
#activity-slide(
  kind: "Taller",
  title: "Dos turnos a mano",
  duration: "8 min",
)[
  #v(1mm)
  En el notebook `02-openrouter.ipynb`, con la key ya cargada:

  #v(4mm)
  + Ejecuta la preparación y la celda que define `preguntar(messages)`
  + Ejecuta los dos turnos: la primera pregunta, guardar la respuesta como
    `assistant` y la segunda pregunta
  + Imprime `messages` completo. ¿Cuántos mensajes hay y de qué `role` es cada uno?
  + En la celda vacía agrega un #text(weight: "bold")[tercer turno] que dependa
    de lo anterior (por ejemplo: "¿Y otro ejemplo?")

  #v(6mm)
  Pregunta: si no guardas la respuesta como `assistant`, ¿el modelo entiende
  "Dame un ejemplo real"? Pruébalo.
]

// ------------------------------------------------------------
// Intuición general: el for loop
// ------------------------------------------------------------
#content-slide(
  title: "Intuición general: el mismo patrón en un bucle",
  section: "Chatbot",
)[
  #v(1mm)
  #code-box(label: "chatbot de consola completo", tone: "request")[
```python
messages = [{"role": "system", "content": "Eres un asistente breve y claro."}]

while True:
    entrada = input("tú> ")
    if entrada.strip() in {"salir", "exit"}:
        break

    messages.append({"role": "user", "content": entrada})
    respuesta = preguntar(messages)          # manda la lista completa
    print("bot>", respuesta)

    messages.append({"role": "assistant", "content": respuesta})
```
  ]

  #v(3mm)
  - Cada vuelta: agregar `user` → llamar → imprimir → agregar `assistant`
  - `messages` crece con la conversación; es toda la "memoria" que hay
  - `preguntar()` es la misma función `POST` de la primera llamada
]

// ------------------------------------------------------------
// Actividad: chatbot de consola (03-openrouter.ipynb)
// ------------------------------------------------------------
#activity-slide(
  kind: "Taller",
  title: "Tu chatbot de consola",
  duration: "10 min",
)[
  #v(1mm)
  En el notebook `03-openrouter.ipynb`, con la key ya cargada:

  #v(4mm)
  + Ejecuta la preparación y la celda de `preguntar(messages)`
  + Corre el bucle y conversa 3 o 4 turnos. Haz una pregunta que solo tenga
    sentido si recuerda lo anterior
  + Escribe `salir` y ejecuta la última celda: mira la "memoria" y cuántos
    mensajes quedaron
  + Cambia el `system` (un pirata, un profe de matemáticas...) y vuelve a conversar

  #v(6mm)
  Cierre: si la charla sigue 100 turnos, ¿qué pasa con los tokens que pagas en
  cada llamada?
]

// ============================================================
// Features avanzadas
// ============================================================
#two-column-slide(
  title: "Features avanzadas",
  section: "Features",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Streaming — `"stream": true`]
    - La respuesta llega en pedacitos, no de golpe
    - Viaja como #text(weight: "bold")[Server-Sent Events]
      (`text/event-stream`)
    - #text(weight: "bold")[No] baja el costo ni el tiempo total: mejora la
      percepción, ves texto de inmediato
    - Es lo que hace que ChatGPT parezca "escribir" frente a ti
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Salidas estructuradas]
    - `"response_format": { "type": "json_schema", ... }`
    - Obligas al modelo a responder un #text(weight: "bold")[JSON con la forma
      exacta] que pediste
    - Ideal para extraer datos: nombre, fecha, monto → `dict` listo para usar
    - No todos los modelos lo soportan — revísalo en openrouter.ai/models
  ],
)

// ============================================================
// Actividad 2: caso real
// ============================================================
#activity-slide(
  kind: "Taller",
  title: "Caso real",
  duration: "20 min",
)[
  #v(1mm)
  Elige uno y ármalo en el notebook:

  #v(3mm)
  - #text(weight: "bold")[Resumidor]: pegas un texto largo → devuelve 3 bullets
  - #text(weight: "bold")[Clasificador]: mensaje → categoría (few-shot: ejemplos en el `system`)
  - #text(weight: "bold")[Extractor]: texto libre → JSON con campos fijos (usa `response_format`)

  #v(5mm)
  Requisitos:
  + Un `system` claro
  + Revisar `r.status_code` antes de leer la respuesta
  + Imprimir `r.json()["usage"]` al final
]

// ============================================================
// Cierre y reflexión
// ============================================================
#activity-slide(
  kind: "Reflexión",
  title: "¿Qué construiste? ¿Qué te sorprendió?",
  duration: "6 min",
)[
  #v(2mm)
  Saca lo que escribiste al inicio sobre qué pasaba cuando le hablabas a ChatGPT.

  #v(6mm)
  - ¿Qué acertaste sin saberlo?
  - ¿Qué te sorprendió?
  - Le hablaste a un modelo de otra empresa, en otro continente, y fue el
    #text(weight: "bold")[mismo POST con JSON de siempre]
  - Con esto ya funcionando: #text(weight: "bold")[¿qué vas a construir?]

  #v(6mm)
  Compártelo con la persona de al lado.
]
