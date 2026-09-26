#import "../../template.typ": *

#show: deck.with(
  title: "Clase 04 — Introducción a HTTP",
  author: "Juan Zurita",
)

// ============================================================
// Helpers reutilizables
// ============================================================

// Caja para mostrar una petición o respuesta HTTP cruda
#let http-box(label: "", tone: "request", body) = {
  let accent = if tone == "response" { palette.vanilla-custard.darken(25%) } else { palette.iron-grey }
  block(
    width: 100%,
    inset: (x: 5mm, y: 4mm),
    radius: 2mm,
    fill: palette.beige.darken(3%),
    stroke: (left: 4pt + accent),
  )[
    #text(size: 10pt, tracking: 0.15em, weight: "bold", fill: palette.charcoal)[#upper(label)]
    #v(2mm)
    #text(font: "Liberation Mono", size: 11.5pt, fill: palette.gunmetal)[#body]
  ]
}

// Píldora numerada, reutilizada para piezas de una petición/respuesta
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

// Tarjeta para una familia de códigos de estado
#let family-card(range, name, desc, fill: palette.iron-grey) = block(
  width: 100%,
  height: 100%,
  inset: (x: 5mm, y: 4mm),
  radius: 2mm,
  fill: fill,
)[
  #text(size: 20pt, weight: "bold", fill: palette.beige)[#range]
  #v(1mm)
  #text(size: 13pt, tracking: 0.1em, weight: "bold", fill: palette.vanilla-custard)[#upper(name)]
  #v(2mm)
  #text(size: 12pt, fill: palette.beige)[#desc]
]

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
  title: "Introducción a HTTP",
  subtitle: "El idioma que usan tu navegador, tu app y una IA para hablarse",
  author: "Juan Zurita",
  date: "Clase 04 · Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Cliente y servidor", page: "04"),
    (name: "HTTP: protocolo de comunicación", page: "06"),
    (name: "Anatomía de una petición y métodos", page: "08"),
    (name: "Headers y JSON", page: "11"),
    (name: "Anatomía de una respuesta y códigos", page: "15"),
    (name: "Kahoot: repaso de HTTP", page: "19"),
    (name: "Cierre e integración", page: "20"),
  ),
)

// ============================================================
// Apertura
// ============================================================
#activity-slide(
  kind: "Preguntas",
  title: "Antes de empezar...",
  duration: "5 min",
)[
  #v(4mm)
  #text(size: 20pt, weight: "bold")[¿Alguna vez pensaste cómo funciona WhatsApp cuando mandas un mensaje?]

  #v(6mm)
  Guarda lo que escribiste. Vamos a volver a leerlo al final de la clase.
]

// ============================================================
// Cliente y servidor
// ============================================================
#section-slide(
  number: "01",
  title: "Cliente y servidor",
  subtitle: "Quién pide y quién responde",
)

#image-slide(
  title: "El modelo cliente-servidor",
  section: "Cliente y servidor",
  position: "right",
  media-width: slide-width * 50%,
  picture: image("./images/01-cliente-servidor.png", width: slide-width * 50%, height: slide-height, fit: "contain"),
)[
  #v(4mm)
  - #text(weight: "bold")[Cliente]: Aplicación que *solicita un recurso*.
  - #text(weight: "bold")[Servidor]: Recurso que ofrece servicios a través de una red.


  - #text(weight: "bold")[Petición (request)]: Mensaje enviado para procesar una solicitud
  - #text(weight: "bold")[Respuesta (response)]: Resultado de una solicitud.
]


// ============================================================
// Anatomía de una petición
// ============================================================
#section-slide(
  number: "02",
  title: "HTTP",
  subtitle: "Protocolo de comunicación",
)

#content-slide(
  title: "HTTP: protocolo de comunicación",
  section: "Cliente y servidor",
)[
  Para que el pedido se entienda, cliente y servidor necesitan hablar el
  *mismo idioma*, con las mismas reglas. Ese idioma es #text(weight: "bold")[HTTP] (HyperText Transfer Protocol).

  #v(6mm)
  - Conjunto de reglas para construir solicitudes y respuestas. 

  - Si lo interceptas, lo puedes leer como cualquier mensaje
  - HTTP es stateless #text(weight: "bold")[(sin estado)]
  - Corre sobre #text(weight: "bold")[internet]

  #v(6mm)
  #text(weight: "bold")[Cada vez que abres una app, ves una foto o le hablas a un modelo de IA por su API, hay una petición HTTP detrás.]
]

#section-slide(
  number: "03",
  title: "Anatomía de una petición",
  subtitle: "¿Cómo el cliente pide una respuesta al servidor?",
)

#two-column-slide(
  title: "Las piezas de una petición",
  section: "Petición",
  left-content: [
    #stack(
      dir: ttb,
      spacing: 5mm,
      pieza("1", "Método", "el verbo: qué acción quiere hacer (leer, crear, borrar...)"),
      pieza("2", "URL", "a quién y a qué recurso exacto se dirige el pedido"),
      pieza("3", "Headers", "metadatos: formato, idioma, credenciales, quién pregunta"),
      pieza("4", "Body", "el contenido del pedido — no siempre existe"),
    )
  ],
  right-content: [
    #text(size: 13pt)[Mandar un mensaje por WhatsApp, visto como petición HTTP:]
    #v(2mm)
    #http-box(label: "Petición HTTP", tone: "request")[
      POST /v1/mensajes HTTP/1.1 \
      Host: api.whatsapp.com \
      Content-Type: application/json \
      Authorization: Bearer token-de-ana \
      #v(2mm)
      #h(0mm){ \
      #h(4mm) "para": "+506 8888 8888", \
      #h(4mm) "texto": "¿Nos vemos a las 3?" \
      }
    ]

    #v(3mm)
    #text(size: 13pt, style: "italic")[Línea 1: método + URL. Líneas 2–4: headers. Tras la línea en blanco: el body en JSON.]
  ],
)

#content-slide(
  title: "Los métodos y su equivalente CRUD",
  section: "Métodos",
)[
  #v(3mm)
  #deck-table(
    (auto, auto, 1fr),
    ("Método", "CRUD", "Qué hace"),
    (
      ([#text(weight: "bold")[GET]], "Read", "Leer u obtener un recurso, sin modificarlo"),
      ([#text(weight: "bold")[POST]], "Create", "Crear un recurso nuevo o procesar datos"),
      ([#text(weight: "bold")[PUT]], "Update", "Reemplazar un recurso por completo"),
      ([#text(weight: "bold")[PATCH]], "Update", "Modificar una parte de un recurso"),
      ([#text(weight: "bold")[DELETE]], "Delete", "Eliminar un recurso"),
    ),
    size: 15pt,
  )

  #v(5mm)
  #text(size: 14pt, style: "italic")[Son un acuerdo, no una obligación técnica: un buen servidor los respeta — GET nunca debería borrar nada.]
]

#section-slide(
  number: "04",
  title: "Headers y JSON",
  subtitle: "Los detalles que acompañan a cada mensaje",
)

#content-slide(
  title: "Headers que vas a ver todo el tiempo",
  section: "Headers",
)[
  #v(3mm)
  #deck-table(
    (auto, 1fr, auto),
    ("Header", "Para qué sirve", "Ejemplo"),
    (
      ([#text(weight: "bold")[Content-Type]], "En qué formato viene el body", [`application/json`]),
      ([#text(weight: "bold")[Authorization]], "Credenciales de quien hace la petición", [`Bearer sk-xxxx`]),
      ([#text(weight: "bold")[Host]], "A qué servidor exacto va dirigida", [`openrouter.ai`]),
      ([#text(weight: "bold")[Accept]], "En qué formato el cliente espera la respuesta", [`application/json`]),
      ([#text(weight: "bold")[User-Agent]], "Qué cliente pregunta: navegador, app, script", [`curl/8.4.0`]),
    ),
    size: 13.5pt,
  )

  #v(5mm)
  #text(size: 14pt, style: "italic")[Ningún header es obligatorio siempre — dependen de qué necesita saber el servidor para responder bien.]
]

#content-slide(
  title: "El body y JSON",
  section: "Headers",
)[
  El #text(weight: "bold")[body] es el contenido del mensaje. No todas las
  peticiones lo llevan (un GET normalmente no), pero cuando lleva datos
  estructurados casi siempre viene en #text(weight: "bold")[JSON] (JavaScript
  Object Notation).

  #v(4mm)
  #http-box(label: "Ejemplo de body en JSON", tone: "request")[
    #h(0mm){ \
    #h(4mm) "nombre": "Ana", \
    #h(4mm) "edad": 21, \
    #h(4mm) "activo": true, \
    #h(4mm) "cursos": ["Programación", "Bases de Datos"] \
    }
  ]

  #v(4mm)
  - Pares de #text(weight: "bold")[clave-valor], como un diccionario de Python
  - Soporta texto, números, booleanos, listas y objetos anidados
  - El header #text(weight: "bold")[`Content-Type: application/json`] le avisa al servidor cómo leerlo
]

#two-column-slide(
  title: "Query params: datos que viajan en la URL",
  section: "Petición",
  left-content: [
    #text(size: 13pt)[Buscar mensajes de un chat, filtrando desde la propia URL:]
    #v(2mm)
    #http-box(label: "Petición con query params", tone: "request")[
      GET /v1/mensajes?chat=ana&limite=20 HTTP/1.1 \
      Host: api.whatsapp.com \
      Authorization: Bearer token-de-ana
    ]

    #v(3mm)
    #text(size: 13pt, style: "italic")[Todo lo que va después del `?` son parámetros. Sin body.]
  ],
  right-content: [
    - Empiezan con #text(weight: "bold")[`?`] y se separan entre sí con #text(weight: "bold")[`&`]
    - Cada uno es un par #text(weight: "bold")[`clave=valor`]
    - Sirven para #text(weight: "bold")[filtrar, ordenar, paginar o buscar] — no para cambiar datos
    - Son parte de la #text(weight: "bold")[URL]: quedan en el historial, se comparten y se cachean
    - Típicos de #text(weight: "bold")[GET], donde no hay body para llevar esos datos
  ],
)

#section-slide(
  number: "05",
  title: "Anatomía de una respuesta",
  subtitle: "El servidor siempre contesta algo, incluso cuando falla",
)


#two-column-slide(
  title: "Las piezas de una respuesta",
  section: "Respuesta",
  left-content: [
    #stack(
      dir: ttb,
      spacing: 5mm,
      pieza("1", "Código de estado", "un número de tres dígitos que resume qué pasó"),
      pieza("2", "Headers", "metadatos de la respuesta: formato, tamaño, caché"),
      pieza("3", "Body", "el contenido de vuelta — la página, los datos, el error"),
    )
  ],
  right-content: [
    #text(size: 13pt)[Lo que responde el servidor de WhatsApp al enviar el mensaje:]
    #v(2mm)
    #http-box(label: "Respuesta HTTP", tone: "response")[
      HTTP/1.1 201 Created \
      Content-Type: application/json \
      #v(2mm)
      #h(0mm){ \
      #h(4mm) "id": "msg-8f3a1c", \
      #h(4mm) "estado": "entregado" \
      }
    ]

    #v(3mm)
    #text(size: 13pt, style: "italic")[Línea 1: versión + código de estado. Luego los headers. Tras la línea en blanco: el body.]
  ],
)


#content-slide(
  title: "Familias de códigos de estado",
  section: "Respuesta",
)[
  #v(3mm)
  #deck-table(
    (auto, auto, auto, 1fr),
    ("Familia", "Ejemplos", "Significado", "Descripción"),
    (
      ([#text(weight: "bold")[1xx]], "100, 101", "Informativo", "La petición se recibió, el proceso sigue"),
      ([#text(weight: "bold")[2xx]], "200, 201", "Éxito", "Todo salió como se esperaba"),
      ([#text(weight: "bold")[3xx]], "301, 302", "Redirección", "El recurso está en otra dirección"),
      ([#text(weight: "bold")[4xx]], "400, 404", "Error del cliente", "Tu petición tiene un problema"),
      ([#text(weight: "bold")[5xx]], "500, 503", "Error del servidor", "El servidor falló procesando una petición correcta"),
    ),
    size: 13.5pt,
  )
]

#content-slide(
  title: "Códigos que vas a ver seguido",
  section: "Respuesta",
)[
  #v(3mm)
  #deck-table(
    (auto, auto, 1fr),
    ("Código", "Significado", "Cuándo aparece"),
    (
      ([#text(weight: "bold")[200]], "OK", "La petición funcionó y viene el resultado"),
      ([#text(weight: "bold")[201]], "Created", "Se creó un recurso nuevo (típico tras un POST)"),
      ([#text(weight: "bold")[400]], "Bad Request", "El body o los parámetros están mal formados"),
      ([#text(weight: "bold")[401]], "Unauthorized", "Falta el token o es inválido"),
      ([#text(weight: "bold")[403]], "Forbidden", "Estás autenticado, pero no tienes permiso"),
      ([#text(weight: "bold")[404]], "Not Found", "El recurso o la URL no existe"),
      ([#text(weight: "bold")[429]], "Too Many Requests", "Superaste el límite de peticiones (rate limit)"),
      ([#text(weight: "bold")[500]], "Internal Server Error", "El servidor falló procesando tu petición"),
    ),
    size: 13pt,
  )
]

#activity-slide(
  kind: "Kahoot",
  title: "Breve repaso de HTTP",
  duration: "8 min",
)[
  #v(4mm)
  #text(size: 20pt, weight: "bold")[Entremos a Kahoot]

  #v(8mm)
  - Link: #text(style: "italic", fill: palette.charcoal)[(pendiente)]
]

// ============================================================
// Cierre e integración
// ============================================================

#activity-slide(
  kind: "Reflexión",
  title: "Vuelve a tu respuesta inicial",
  duration: "6 min",
)[
  Saca lo que escribiste al comienzo de la clase sobre qué pasa cuando
  mandas un mensaje por WhatsApp.

  #v(6mm)
  - ¿Qué parte acertaste sin saberlo?
  - ¿Qué le cambiarías ahora, con las palabras correctas: cliente, servidor,
    petición, método, código de estado?
  - Compártelo con la persona de al lado
]

#content-slide(
  title: "Lo que construimos hoy",
  section: "Síntesis",
)[
  + #text(weight: "bold")[Cliente-servidor]: el cliente siempre pide, el
    servidor siempre responde
  + #text(weight: "bold")[Petición]: método, URL, headers y, a veces, body
  + #text(weight: "bold")[Métodos]: GET lee, POST crea, PUT/PATCH modifican,
    DELETE elimina
  + #text(weight: "bold")[Respuesta]: código de estado, headers y body de
    vuelta
  + #text(weight: "bold")[Códigos]: 2xx éxito, 4xx tu error, 5xx su error
  + #text(weight: "bold")[JSON]: el formato que casi todo body va a usar
  + #text(weight: "bold")[DevTools / curl]: cómo ver y probar todo esto sin
    escribir una sola línea de código
]

#content-slide(
  title: "Conectemos con lo que viene",
  section: "Síntesis",
)[
  La próxima clase vamos a usar #text(weight: "bold")[OpenRouter] para
  hablarle a modelos de IA por su API — y ahora ya saben exactamente qué va
  a pasar bajo el capó:

  #v(5mm)
  - Nuestro código va a ser el #text(weight: "bold")[cliente]
  - Vamos a mandar una #text(weight: "bold")[petición POST] con un body en
    #text(weight: "bold")[JSON]
  - Vamos a leer el #text(weight: "bold")[código de estado] de la respuesta
    antes de confiar en el resultado
  - Y si algo falla, el error va a venir en un formato que ya reconocen

  #v(6mm)
  #text(weight: "bold")[Nada de esto va a ser nuevo — solo un caso más del mismo protocolo.]
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
  - "An overview of HTTP", MDN Web Docs — #link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview")[developer.mozilla.org]
  - "HTTP request methods", MDN Web Docs — #link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods")[developer.mozilla.org]
  - "HTTP response status codes", MDN Web Docs — #link("https://developer.mozilla.org/en-US/docs/Web/HTTP/Status")[developer.mozilla.org]
  - RFC 9110 — HTTP Semantics, IETF — #link("https://www.rfc-editor.org/rfc/rfc9110")[rfc-editor.org]
  - OpenRouter API Reference — #link("https://openrouter.ai/docs/api-reference/overview")[openrouter.ai/docs]

  #v(6mm)
  #text(size: 13pt, style: "italic")[
    El enfoque de clase (simulación primero, formalización después) sigue el
    ciclo de aprendizaje experiencial: vivir, observar, conceptualizar, aplicar.
  ]
]
