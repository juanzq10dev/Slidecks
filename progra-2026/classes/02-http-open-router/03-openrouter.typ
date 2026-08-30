#import "../../template.typ": *

#show: deck.with(
  title: "Clase 05 — OpenRouter",
  author: "Juan Zurita",
)

// Bloques de código un poco más compactos que el cuerpo
#show raw.where(block: true): set text(size: 11pt)

// ============================================================
// Helpers reutilizables
// ============================================================

// Caja para mostrar una petición / respuesta / fragmento de código.
// El cuerpo se pasa como bloque de código (```lang ... ```), así que
// URLs con `//` y comentarios `#` no rompen el parser de Typst.
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

// Píldora numerada, reutilizada de los decks anteriores
#let pieza(n, nombre, desc) = grid(
  columns: (10mm, 1fr),
  column-gutter: 4mm,
  align: (center + top, left + top),
  box(width: 8mm, height: 8mm, radius: 4mm, fill: palette.iron-grey)[
    #align(center + horizon)[#text(size: 10pt, weight: "bold", fill: palette.beige)[#n]]
  ],
  [
    #text(weight: "bold", fill: palette.gunmetal)[#nombre] #h(2mm)
    #text(size: 14pt, fill: palette.iron-grey)[#desc]
  ],
)

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
    (name: "De ChatGPT a tu código", page: "03"),
    (name: "Qué es OpenRouter", page: "06"),
    (name: "Anatomía de la llamada", page: "11"),
    (name: "Conversaciones y parámetros", page: "17"),
    (name: "Comparar modelos", page: "20"),
    (name: "Features avanzadas", page: "23"),
    (name: "Costo, límites y errores", page: "25"),
    (name: "Cierre y síntesis", page: "29"),
  ),
)

// ============================================================
// 01 · De ChatGPT a tu código
// ============================================================
#section-slide(
  number: "01",
  title: "De ChatGPT a tu código",
  subtitle: "Ya sabes cómo funciona por dentro — hoy solo lo escribimos tú y yo",
)

#activity-slide(
  kind: "Preguntas",
  title: "¿Qué viajó por la red?",
  duration: "5 min",
)[
  #v(2mm)
  La última vez que le pediste algo a ChatGPT, Gemini o Claude:

  #v(4mm)
  - ¿Tu mensaje salió de tu computadora? ¿a qué servidor llegó?
  - ¿Qué #text(weight: "bold")[método HTTP] crees que se usó?
  - ¿En qué #text(weight: "bold")[formato] viajó tu texto?
  - Cuando la respuesta "se escribió sola" en pantalla, ¿qué estaba pasando?

  #v(6mm)
  Escribe tu predicción. La volvemos a leer al final de la clase.
]

#content-slide(
  title: "Lo que prometimos la clase pasada",
  section: "De ChatGPT a tu código",
)[
  Al cerrar la clase de HTTP dijimos que hablarle a una IA por su API no iba
  a ser nada nuevo — solo un caso más del mismo protocolo. Hoy lo comprobamos.

  #v(5mm)
  - Nuestro código va a ser el #text(weight: "bold")[cliente]
  - Mandamos un #text(weight: "bold")[POST] con un body en #text(weight: "bold")[JSON]
  - Leemos el #text(weight: "bold")[código de estado] antes de confiar en la respuesta
  - La respuesta es #text(weight: "bold")[JSON] y la parseamos como cualquier otra
  - La credencial va en el header #text(weight: "bold")[`Authorization: Bearer ...`] — igual que el juego de detectives

  #v(6mm)
  #text(weight: "bold")[Lo único nuevo es a quién le hablamos y qué le pedimos.]
]

// ============================================================
// 02 · Qué es OpenRouter
// ============================================================
#section-slide(
  number: "02",
  title: "Qué es OpenRouter",
  subtitle: "Una API key y un formato para muchos modelos",
)

#image-slide(
  title: "Un intermediario entre tu código y los modelos",
  section: "Qué es OpenRouter",
  position: "right",
  media-width: slide-width * 50%,
  picture: image("images/02-open-router.png", width: 100%),
)[
  #v(3mm)
  OpenRouter recibe tu petición y la #text(weight: "bold")[reenvía] al proveedor
  del modelo que elegiste.

  #v(4mm)
  - #text(weight: "bold")[Sin OpenRouter]: cuenta, API key y formato distinto
    con OpenAI, con Anthropic, con Google...
  - #text(weight: "bold")[Con OpenRouter]: una cuenta, una key, un formato.
    Cambias de modelo con un string.
  - Enruta a OpenAI, Anthropic, Google, Meta, DeepSeek... y te cobra todo
    en un solo lado.
]

#content-slide(
  title: "Por qué no ir directo a cada proveedor",
  section: "Qué es OpenRouter",
)[
  #v(2mm)
  - #text(weight: "bold")[Una sola credencial] en vez de una por empresa
  - #text(weight: "bold")[Un solo formato]: OpenRouter imita la API de OpenAI,
    así que el código no cambia entre modelos
  - #text(weight: "bold")[Comparar es trivial]: mismo request, cambias `"model"`,
    mides costo y calidad
  - #text(weight: "bold")[Respaldo automático]: si un proveedor se cae, enruta a otro
  - #text(weight: "bold")[Un solo saldo] y un solo panel de gastos
  - #text(weight: "bold")[Modelos gratis] para practicar sin tarjeta

  #v(5mm)
  #text(size: 14pt, style: "italic")[El costo: una capa más en el camino y un
  pequeño margen sobre el precio del proveedor.]
]

#content-slide(
  title: "Modelos y model IDs",
  section: "Qué es OpenRouter",
)[
  #v(2mm)
  - Formato #text(weight: "bold")[`proveedor/modelo`] — `openai/gpt-5.1`,
    `anthropic/claude-sonnet-4.5`, `google/gemini-2.5-flash`
  - Sufijo #text(weight: "bold")[`:free`] → variante gratuita con límites —
    `meta-llama/llama-3.3-70b-instruct:free`
  - #text(weight: "bold")[Cambiar de modelo = cambiar un string.] El resto de
    tu código no se toca
  - #text(weight: "bold")[`"models": [principal, respaldo]`] → si el primero
    falla, usa el segundo (esto es el _routing_)

  #v(6mm)
  #text(size: 14pt, style: "italic")[La lista de modelos y los precios cambian
  seguido. La verdad viva está en #link("https://openrouter.ai/models")[openrouter.ai/models].]
]

#content-slide(
  title: "Créditos y tokens",
  section: "Qué es OpenRouter",
)[
  #v(2mm)
  - OpenRouter cobra #text(weight: "bold")[por token] — no por petición ni por mes
  - Un #text(weight: "bold")[token] es un pedazo de palabra.
    ~1000 tokens ≈ 750 palabras en inglés (bastante menos en español)
  - Pagas #text(weight: "bold")[entrada] (tu prompt + todo el historial) y
    #text(weight: "bold")[salida] (la respuesta). La salida cuesta ~3–5× más
  - Modelos #text(weight: "bold")[`:free`]: 0 créditos, pero tope de
    ~50 peticiones/día y ~20/minuto
  - Cargar ~US\$10 una vez sube el tope diario a ~1000 (no expira)

  #v(6mm)
  #text(weight: "bold")[Para esta clase: usa un modelo `:free` o la key
  compartida que te doy. No necesitas tarjeta.]
]

// ============================================================
// 03 · Anatomía de la llamada
// ============================================================
#section-slide(
  number: "03",
  title: "Anatomía de la llamada",
  subtitle: "POST /chat/completions con un body en JSON",
)

#two-column-slide(
  title: "La petición cruda",
  section: "Anatomía",
  left-content: [
    #code-box(label: "Petición con curl", tone: "request")[
```bash
curl https://openrouter.ai/api/v1/chat/completions \
 -H "Authorization: Bearer sk-or-v1-..." \
 -H "Content-Type: application/json" \
 -d '{
   "model": "openai/gpt-5.1",
   "messages": [
     { "role": "user",
       "content": "Explica qué es HTTP en una frase" }
   ]
 }'
```
    ]
    #v(2mm)
    #text(size: 13pt, style: "italic")[Exactamente la forma que viste en la
    clase de HTTP: método, URL, headers, body.]
  ],
  right-content: [
    #stack(
      dir: ttb,
      spacing: 5mm,
      pieza("1", "Método", "POST — estás creando algo: una respuesta nueva"),
      pieza("2", "URL", "/api/v1/chat/completions, siempre la misma"),
      pieza("3", "Headers", "Authorization con tu key + Content-Type: application/json"),
      pieza("4", "Body", "JSON con dos campos clave: model y messages"),
    )
    #v(3mm)
    #text(size: 13pt)[Headers opcionales `HTTP-Referer` y `X-Title` solo sirven
    para aparecer en los rankings públicos de OpenRouter.]
  ],
)

#content-slide(
  title: "El campo messages y los roles",
  section: "Anatomía",
)[
  #v(1mm)
  `messages` es una #text(weight: "bold")[lista ordenada] de turnos. Cada turno
  es un objeto con `role` y `content`:

  #v(3mm)
  #deck-table(
    (auto, 1fr),
    ("Rol", "Qué es"),
    (
      ([#text(weight: "bold")[`system`]], "Las instrucciones de fondo: quién es el modelo, tono, reglas. Es el system prompt de la clase 03"),
      ([#text(weight: "bold")[`user`]], "Lo que pregunta o pide la persona"),
      ([#text(weight: "bold")[`assistant`]], "Lo que respondió el modelo antes — así recuerda la conversación"),
    ),
    size: 13.5pt,
  )

  #v(4mm)
  #code-box(label: "messages con contexto", tone: "request")[
```json
[
  { "role": "system", "content": "Eres un tutor breve para principiantes." },
  { "role": "user", "content": "¿Qué es una API?" }
]
```
  ]
]

#content-slide(
  title: "La misma llamada, en Python",
  section: "Anatomía",
)[
  #v(1mm)
  #code-box(label: "httpx — el mismo cliente del juego de detectives", tone: "request")[
```python
import os, httpx

r = httpx.post(
    "https://openrouter.ai/api/v1/chat/completions",
    headers={"Authorization": f"Bearer {os.environ['OPENROUTER_API_KEY']}"},
    json={
        "model": "openai/gpt-5.1",
        "messages": [
            {"role": "system", "content": "Eres un tutor breve."},
            {"role": "user", "content": "¿Qué es una API?"},
        ],
    },
)
r.raise_for_status()
print(r.json()["choices"][0]["message"]["content"])
```
  ]

  #v(2mm)
  - `json=...` serializa el dict y pone `Content-Type: application/json` solo
  - `r.json()` parsea la respuesta — igual que con PokeAPI o la NASA
]

#content-slide(
  title: "La respuesta",
  section: "Anatomía",
)[
  #v(1mm)
  #code-box(label: "Respuesta HTTP 200", tone: "response")[
```json
{
  "id": "gen-abc123",
  "model": "openai/gpt-5.1",
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
  - #text(weight: "bold")[`usage`]: cuántos tokens costó (mídelo, no lo adivines)
  - #text(weight: "bold")[`finish_reason`]: `stop` terminó solo · `length` lo cortó `max_tokens`
]

#activity-slide(
  kind: "Taller",
  title: "Tu primera llamada",
  duration: "10 min",
)[
  #v(1mm)
  En el notebook `openrouter.ipynb`, con la key que te di:

  #v(4mm)
  + Ejecuta la celda de preparación (`import`, `BASE_URL`, `show`)
  + Completa #text(weight: "bold")[una] llamada: `model` de un `:free`, un
    `messages` con tu pregunta
  + Ejecútala e imprime `r.status_code` y `choices[0].message.content`
  + Pídele lo mismo pero con un `system` distinto. ¿Cambió el tono?

  #v(6mm)
  Cierre: 2 personas leen su respuesta y el `total_tokens` que gastó.
]

// ============================================================
// 04 · Conversaciones y parámetros
// ============================================================
#section-slide(
  number: "04",
  title: "Conversaciones y parámetros",
  subtitle: "La API no recuerda nada — y tú controlas cómo responde",
)

#content-slide(
  title: "HTTP no tiene memoria — la API tampoco",
  section: "Conversaciones",
)[
  Recuerda la clase de HTTP: el protocolo es #text(weight: "bold")[stateless].
  Cada petición empieza de cero. La API de un modelo funciona igual: no sabe
  qué le preguntaste hace dos mensajes.

  #v(5mm)
  #text(weight: "bold")[Para sostener una conversación, reenvías toda la lista
  `messages` en cada llamada:]

  #v(3mm)
  + Mandas `system` + `user`
  + Recibes la respuesta y la agregas a la lista como `{"role": "assistant", ...}`
  + Agregas el nuevo `user`
  + Mandas #text(weight: "bold")[la lista completa] otra vez

  #v(5mm)
  #text(size: 14pt, style: "italic")[La #text(weight: "bold")[ventana de contexto]
  es cuántos tokens caben en `messages`. Cuando se llena, hay que recortar los
  turnos viejos.]
]

#content-slide(
  title: "Parámetros que cambian la respuesta",
  section: "Conversaciones",
)[
  #v(2mm)
  #deck-table(
    (auto, 1fr, auto),
    ("Parámetro", "Qué hace", "Cuándo tocarlo"),
    (
      ([#text(weight: "bold")[`temperature`]], "0 = siempre lo más probable · 1+ = más variado y creativo", "Bajo: extraer datos · Alto: ideas"),
      ([#text(weight: "bold")[`max_tokens`]], "Techo de la respuesta, en tokens", "Controlar costo y largo"),
      ([#text(weight: "bold")[`seed`]], "Fija el azar: misma entrada → misma salida", "Pruebas reproducibles"),
      ([#text(weight: "bold")[`top_p`]], "Otra forma de recortar opciones raras", "Casi siempre déjalo en 1"),
    ),
    size: 13pt,
  )

  #v(5mm)
  #text(size: 14pt)[Conecta con la clase 03: #text(weight: "bold")[`temperature`
  baja] cuando quieres precisión y repetibilidad, #text(weight: "bold")[alta]
  cuando quieres lluvia de ideas.]
]

// ============================================================
// 05 · Comparar modelos
// ============================================================
#section-slide(
  number: "05",
  title: "Comparar modelos",
  subtitle: "Mismo prompt, distinto model — y decides con datos",
)

#content-slide(
  title: "Tres ejes para elegir",
  section: "Comparar",
)[
  #v(2mm)
  Cambias solo el string `"model"` y comparas la misma tarea en:

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

#activity-slide(
  kind: "Taller",
  title: "Compáralo tú",
  duration: "10 min",
)[
  #v(1mm)
  Toma el mismo `messages` y córrelo en dos modelos:

  #v(4mm)
  - Uno #text(weight: "bold")[`:free`] pequeño
  - Uno grande de pago (con la key compartida)

  #v(5mm)
  Anota para cada uno:
  + `total_tokens` de `usage`
  + ¿La respuesta cambió en algo que te importe?
  + ¿Notaste diferencia de tiempo?

  #v(5mm)
  Cierre: ¿para qué tarea usarías cada uno?
]

// ============================================================
// 06 · Features avanzadas
// ============================================================
#section-slide(
  number: "06",
  title: "Features avanzadas",
  subtitle: "Streaming y salidas estructuradas",
)

#two-column-slide(
  title: "Dos que vas a querer pronto",
  section: "Features",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Streaming — `"stream": true`]
    - La respuesta llega en pedacitos, no de golpe
    - Viaja como #text(weight: "bold")[Server-Sent Events]
      (`text/event-stream` — otro `Content-Type` de la clase 04)
    - #text(weight: "bold")[No] baja el costo ni el tiempo total: mejora la
      percepción, ves texto ya
    - Es lo que hace que ChatGPT parezca "escribir" frente a ti
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Salidas estructuradas]
    - `"response_format": { "type": "json_schema", ... }`
    - Obligas al modelo a responder un #text(weight: "bold")[JSON con la forma
      exacta] que pediste
    - Ideal para extraer datos: nombre, fecha, monto → `dict` listo para usar
    - No todos los modelos lo soportan — revisa en openrouter.ai/models
  ],
)

// ============================================================
// 07 · Costo, límites y errores
// ============================================================
#section-slide(
  number: "07",
  title: "Costo, límites y errores",
  subtitle: "Pagas por token, y los errores ya los reconoces",
)

#content-slide(
  title: "Hacer cuentas",
  section: "Costo",
)[
  #v(2mm)
  - ~1000 tokens ≈ 750 palabras ≈ media página
  - Pagas #text(weight: "bold")[entrada] (prompt + historial) + #text(weight: "bold")[salida] (respuesta)

  #v(4mm)
  #text(weight: "bold")[Ejemplo] (precio ilustrativo: US\$3 entrada / US\$12 salida por millón):
  - Un chat de 12 turnos ≈ 8000 tokens de entrada acumulada + 2500 de salida
  - ≈ US\$0.024 + US\$0.030 ≈ #text(weight: "bold")[US\$0.05 por conversación]

  #v(5mm)
  #text(size: 14pt, style: "italic")[Multiplica por tus usuarios y tus llamadas.
  Ahí es donde eliges modelo. `usage` viene en cada respuesta — mide, no adivines.]
]

#content-slide(
  title: "Errores que vas a ver",
  section: "Costo",
)[
  #v(2mm)
  #deck-table(
    (auto, auto, 1fr),
    ("Código", "Significado", "Cuándo aparece"),
    (
      ([#text(weight: "bold")[400]], "Bad Request", "model id mal escrito o body inválido"),
      ([#text(weight: "bold")[401]], "Unauthorized", "falta la API key o es inválida"),
      ([#text(weight: "bold")[402]], "Payment Required", "te quedaste sin créditos"),
      ([#text(weight: "bold")[403]], "Forbidden", "bloqueo de moderación o permisos"),
      ([#text(weight: "bold")[429]], "Too Many Requests", "pasaste el rate limit (típico en modelos :free)"),
      ([#text(weight: "bold")[502 / 503]], "Bad Gateway / Unavailable", "el proveedor del modelo está caído"),
    ),
    size: 12.5pt,
  )

  #v(3mm)
  #code-box(label: "El body de un error", tone: "response")[
```json
{ "error": { "code": 402, "message": "Insufficient credits", "metadata": {} } }
```
  ]

  #v(1mm)
  #text(size: 13pt, style: "italic")[Igual que en la clase de HTTP: revisa el
  código de estado antes de confiar en el body.]
]

#content-slide(
  title: "La API key es un secreto",
  section: "Costo",
)[
  Va en el header `Authorization: Bearer sk-or-...` — igual que el token del
  juego de detectives. #text(weight: "bold")[Quien tiene tu key gasta tus créditos.]

  #v(5mm)
  #text(weight: "bold")[Nunca] la escribas en el notebook ni la subas a git. El patrón correcto:

  #v(3mm)
  + Guárdala en un archivo #text(weight: "bold")[`.env`]: `OPENROUTER_API_KEY=sk-or-...`
  + Agrega #text(weight: "bold")[`.env` al `.gitignore`]
  + Léela con `os.environ["OPENROUTER_API_KEY"]` (o con `python-dotenv`)

  #v(5mm)
  #text(size: 14pt, style: "italic")[¿Se te escapó a un commit? Revócala en
  openrouter.ai y crea otra. Borrarla del archivo no basta: queda en el historial.]
]

// ============================================================
// 08 · Cierre y síntesis
// ============================================================
#section-slide(
  number: "08",
  title: "Cierre y síntesis",
  subtitle: "De vuelta a tu predicción del inicio",
)

#activity-slide(
  kind: "Taller",
  title: "Caso real",
  duration: "20 min",
)[
  #v(1mm)
  Elige uno y ármalo en el notebook:

  #v(3mm)
  - #text(weight: "bold")[Resumidor]: pegas un texto largo → devuelve 3 bullets
  - #text(weight: "bold")[Clasificador]: mensaje → categoría (usa few-shot de la clase 03)
  - #text(weight: "bold")[Extractor]: texto libre → JSON con campos fijos (usa `response_format`)

  #v(5mm)
  Requisitos:
  + Un `system` claro
  + Revisar `status_code` antes de leer la respuesta
  + Imprimir `usage` al final
]

#statement-slide(
  statement: "Le hablaste a un modelo de otra empresa, en otro continente, y fue el mismo POST con JSON de siempre.",
)

#content-slide(
  title: "Lo que construimos hoy",
  section: "Síntesis",
)[
  + #text(weight: "bold")[OpenRouter]: una API key y un formato para muchos modelos
  + #text(weight: "bold")[La llamada]: POST a `/chat/completions` con `model` + `messages`
  + #text(weight: "bold")[`messages`]: lista de roles `system` / `user` / `assistant`
    — el `system` es el system prompt de la clase 03
  + #text(weight: "bold")[La respuesta]: `choices[0].message.content` y `usage` (tokens)
  + #text(weight: "bold")[Sin memoria]: reenvías todo el historial en cada llamada
  + #text(weight: "bold")[Parámetros]: `temperature`, `max_tokens`, `seed`
  + #text(weight: "bold")[Costo y errores]: pagas por token; 401 / 402 / 429 ya los reconoces
  + #text(weight: "bold")[La API key es un secreto]: `.env`, nunca a git
]

#activity-slide(
  kind: "Reflexión",
  title: "Vuelve a tu predicción",
  duration: "6 min",
)[
  #v(2mm)
  Saca lo que escribiste al comienzo sobre qué pasaba cuando le hablabas a ChatGPT.

  #v(6mm)
  - ¿Qué acertaste sin saberlo?
  - ¿Qué te sorprendió?
  - Con esto ya funcionando: #text(weight: "bold")[¿qué vas a construir?]

  #v(6mm)
  Compártelo con la persona de al lado.
]

// ============================================================
// Fuentes
// ============================================================
#content-slide(
  title: "Fuentes",
  section: "Referencias",
)[
  #set text(size: 14pt)
  #v(2mm)
  - OpenRouter Quickstart — #link("https://openrouter.ai/docs/quickstart")[openrouter.ai/docs/quickstart]
  - OpenRouter API Reference — #link("https://openrouter.ai/docs/api-reference/overview")[openrouter.ai/docs]
  - OpenRouter — modelos y precios — #link("https://openrouter.ai/models")[openrouter.ai/models]
  - "Chat Completions", OpenAI API Reference — #link("https://platform.openai.com/docs/api-reference/chat")[platform.openai.com]
  - "What are tokens and how to count them", OpenAI Help — #link("https://help.openai.com/en/articles/4936856")[help.openai.com]

  #v(6mm)
  #text(size: 13pt, style: "italic")[
    El enfoque de clase (simulación primero, formalización después) sigue el
    ciclo de aprendizaje experiencial: vivir, observar, conceptualizar, aplicar.
  ]
]
