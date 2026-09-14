#import "../../template.typ": *

#show: deck.with(
  title: "Clase 04 — JSON",
  author: "Juan Zurita",
)

// ============================================================
// Helpers
// ============================================================

// Caja para mostrar un fragmento de JSON crudo
#let json-box(label: "JSON", tone: "ok", body) = {
  let accent = if tone == "bad" {
    palette.iron-grey
  } else {
    palette.vanilla-custard.darken(25%)
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
    #set smartquote(enabled: false)
    #text(font: "Liberation Mono", size: 12pt, fill: palette.gunmetal)[#body]
  ]
}

// Tabla con el estilo del deck
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
  title: "JSON en 20 minutos",
  subtitle: "El formato en el que casi todo body de HTTP viaja",
  author: "Juan Zurita",
  date: "Clase 04 · Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Qué es y para qué sirve", page: "03"),
    (name: "Sintaxis básica", page: "06"),
    (name: "Tipos de datos", page: "08"),
    (name: "Objetos, listas y anidamiento", page: "10"),
    (name: "JSON en el código", page: "13"),
    (name: "HTTP y JSON en acción", page: "17"),
  ),
)

// ============================================================
// 01 · Qué es
// ============================================================
#section-slide(
  number: "01",
  title: "Qué es y para qué sirve",
)

#content-slide(
  title: "JSON: JavaScript Object Notation",
  section: "Qué es",
)[
  Un formato de #text(weight: "bold")[texto] para representar datos
  estructurados de forma que cualquier lenguaje pueda leerlos y escribirlos.

  #v(6mm)
  - Nació de JavaScript, pero hoy es #text(weight: "bold")[independiente del lenguaje]
  - Es solo texto: se puede leer, guardar en un archivo o mandar por la red
  - Legible para una persona y fácil de parsear para una máquina

  #v(6mm)
  #text(weight: "bold")[Dónde lo van a ver:] respuestas de APIs, archivos de
  configuración (`package.json`, `tsconfig.json`), y el body de casi toda
  petición POST.
]

#content-slide(
  title: "El mismo dato, en JSON",
  section: "Qué es",
)[
  #v(2mm)
  #json-box(label: "Una estudiante")[
    #h(0mm){ \
    #h(4mm) "nombre": "Ana", \
    #h(4mm) "edad": 21, \
    #h(4mm) "activo": true, \
    #h(4mm) "cursos": \["Programación", "Bases de Datos"\] \
    }
  ]

  #v(5mm)
  - Si sabés leer un diccionario de Python, ya sabés leer esto
  - `{ }` agrupa datos con nombre · `[ ]` es una lista ordenada
  - El orden de las claves no importa
]

// ============================================================
// 02 · Sintaxis
// ============================================================
#section-slide(
  number: "02",
  title: "Sintaxis básica",
)

#content-slide(
  title: "Cuatro reglas y ya",
  section: "Sintaxis",
)[
  #v(2mm)
  + Todo son pares #text(weight: "bold")[clave: valor], dentro de un objeto `{ }`
  + Las claves #text(weight: "bold")[siempre entre comillas dobles] `"..."`
  + `:` separa la clave del valor · `,` separa un par del siguiente
  + #text(weight: "bold")[Sin] coma después del último elemento · #text(weight: "bold")[sin] comentarios

  #v(6mm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 6mm,
    json-box(label: "Válido", tone: "ok")[
      #h(0mm){ \
      #h(4mm) "id": 7, \
      #h(4mm) "nombre": "Sofía" \
      }
    ],
    json-box(label: "Inválido", tone: "bad")[
      #h(0mm){ \
      #h(4mm) id: 'Sofía', \
      #h(4mm) "activo": true,  \
      }
    ],
  )
]

// ============================================================
// 03 · Tipos
// ============================================================
#section-slide(
  number: "03",
  title: "Tipos de datos",
)

#content-slide(
  title: "Los seis tipos que existen",
  section: "Tipos",
)[
  #v(3mm)
  #deck-table(
    (auto, 1fr, auto),
    ("Tipo", "Descripción", "Ejemplo"),
    (
      ([#text(weight: "bold")[string]], "Texto, siempre entre comillas dobles", [`"hola"`]),
      ([#text(weight: "bold")[number]], "Entero o decimal, sin distinción", [`21` · `3.14`]),
      ([#text(weight: "bold")[boolean]], "Verdadero o falso, en minúscula", [`true` · `false`]),
      ([#text(weight: "bold")[null]], "Ausencia de valor", [`null`]),
      ([#text(weight: "bold")[object]], "Colección de pares clave-valor", [`{ }`]),
      ([#text(weight: "bold")[array]], "Lista ordenada de valores", [`[ ]`]),
    ),
    size: 15pt,
  )

  #v(5mm)
  #text(size: 14pt, style: "italic")[No hay fechas ni tipos especiales: una fecha
  viaja como string (`"2026-08-29"`) y se interpreta del lado que la recibe.]
]

// ============================================================
// 04 · Estructuras
// ============================================================
#section-slide(
  number: "04",
  title: "Objetos, listas y anidamiento",
)

#two-column-slide(
  title: "Objeto vs. lista",
  section: "Estructuras",
  left-content: [
    #text(weight: "bold")[Objeto `{ }`] — datos con nombre
    #v(2mm)
    #json-box(label: "objeto")[
      #h(0mm){ \
      #h(4mm) "ciudad": "San José", \
      #h(4mm) "poblacion": 340000 \
      }
    ]
    #v(3mm)
    Se accede por clave: `dato["ciudad"]`
  ],
  right-content: [
    #text(weight: "bold")[Lista `[ ]`] — valores en orden
    #v(2mm)
    #json-box(label: "lista")[
      \[ \
      #h(4mm) "rojo", \
      #h(4mm) "verde", \
      #h(4mm) "azul" \
      \]
    ]
    #v(3mm)
    Se accede por posición: `dato[0]`
  ],
)

#content-slide(
  title: "Se combinan sin límite",
  section: "Estructuras",
)[
  #v(2mm)
  #json-box(label: "Objetos y listas anidados")[
    #h(0mm){ \
    #h(4mm) "curso": "Programación", \
    #h(4mm) "activo": true, \
    #h(4mm) "docente": { "nombre": "Juan", "email": "juan\@uni.cr" }, \
    #h(4mm) "estudiantes": \[ \
    #h(8mm) { "nombre": "Ana", "nota": 92 }, \
    #h(8mm) { "nombre": "Luis", "nota": 78 } \
    #h(4mm) \] \
    }
  ]

  #v(4mm)
  - Un valor puede ser otro objeto o una lista de objetos
  - Así se representan estructuras tan complejas como haga falta
  - Para leer `"docente"` → `dato["docente"]["nombre"]`
]

// ============================================================
// 05 · En el código
// ============================================================
#section-slide(
  number: "05",
  title: "JSON en el código",
)

#content-slide(
  title: "Texto afuera, estructura adentro",
  section: "En el código",
)[
  JSON viaja como #text(weight: "bold")[texto], pero en el código se trabaja como
  diccionarios y listas nativos. Convertir de uno a otro:

  #v(5mm)
  #deck-table(
    (auto, auto, 1fr),
    ("Dirección", "Python", "JavaScript"),
    (
      ([texto → estructura], [`json.loads(s)`], [`JSON.parse(s)`]),
      ([estructura → texto], [`json.dumps(d)`], [`JSON.stringify(d)`]),
    ),
    size: 14pt,
  )

  #v(5mm)
  - Un objeto JSON se vuelve un `dict`; una lista JSON, un `list`
  - `requests` y `fetch` ya traen un atajo: `.json()` parsea la respuesta
  - El header `Content-Type: application/json` avisa que el body es JSON
]

#content-slide(
  title: "Cómo se llega a cada valor",
  section: "En el código",
)[
  #v(1mm)
  #json-box(label: "respuesta ya parseada a dict")[
    #h(0mm)res = { \
    #h(4mm) "curso": "Programación", \
    #h(4mm) "docente": { "nombre": "Juan" }, \
    #h(4mm) "estudiantes": \[ { "nombre": "Ana", "nota": 92 } \] \
    }
  ]

  #v(3mm)
  #deck-table(
    (1fr, auto, auto),
    ("Qué quiero leer", "Python", "JavaScript"),
    (
      ([Nombre del curso], [`res["curso"]`], [`res.curso`]),
      ([Nombre del docente], [`res["docente"]["nombre"]`], [`res.docente.nombre`]),
      ([Nota de la 1ª estudiante], [`res["estudiantes"][0]["nota"]`], [`res.estudiantes[0].nota`]),
    ),
    size: 12.5pt,
  )

  #v(3mm)
  - Objeto → se baja por #text(weight: "bold")[clave]; lista → por #text(weight: "bold")[posición] (desde `0`)
  - Cada `[...]` o `.` baja #text(weight: "bold")[un nivel] en la estructura
  - Clave que no existe: `KeyError` en Python, `undefined` en JavaScript
]

#content-slide(
  title: "Lo esencial",
  section: "Síntesis",
)[
  + #text(weight: "bold")[JSON es texto] estructurado, legible por cualquier lenguaje
  + Todo vive dentro de un objeto `{ }` de pares `"clave": valor`
  + Seis tipos: string, number, boolean, null, object, array
  + Objetos y listas se anidan sin límite
  + En el código se parsea a `dict` / `list` y se serializa de vuelta a texto

  #v(6mm)
  #text(weight: "bold")[Cuando le hablemos a una IA por su API, el body que
  mandamos y la respuesta que leemos van a ser JSON.]
]

// ============================================================
// 06 · A practicar
// ============================================================
#section-slide(
  number: "06",
  title: "HTTP y JSON en acción",
  subtitle: "APIs reales y un caso por resolver",
)

#activity-slide(
  kind: "Demo en vivo",
  title: "Exploremos APIs reales",
)[
  Vamos a pedirle datos a APIs públicas desde Python y a leer juntos
  lo que responden. Carpeta: `api-examples/`

  #v(4mm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 10mm,
    row-gutter: 3mm,
    [#text(weight: "bold")[PokeAPI] — datos de Pokémon],
    [#text(weight: "bold")[Rick and Morty] — personajes y episodios],
    [#text(weight: "bold")[NASA] — la foto astronómica del día],
    [#text(weight: "bold")[Países] — capital, población, bandera],
  )

  #v(5mm)
  En cada una, fíjense en:
  - La #text(weight: "bold")[petición]: método, URL y qué le cambiamos
  - El #text(weight: "bold")[código de estado] que vuelve
  - El #text(weight: "bold")[JSON] de la respuesta: ¿cómo llegamos al dato que queremos?
]

#activity-slide(
  kind: "Juego",
  title: "HTTP Detective",
)[
  Cada quien recibe un #text(weight: "bold")[caso misterioso] y lo resuelve
  solo con peticiones HTTP. Se juega en `http-game/client/template.ipynb`.

  #v(4mm)
  + #text(weight: "bold")[Login] con tu carnet → recibes un token (ya viene resuelto)
  + Mira el caso: ¿a qué hora fue el incidente?
  + Revisa el registro de accesos y el detalle del acceso sospechoso
  + Resuelve: manda el acceso #text(weight: "bold")[justo antes] del incidente

  #v(4mm)
  #text(size: 14pt)[Pistas: el token va en el header `Authorization: Bearer <token>` ·
  si ves 401, 404 o 405, lean el código: les dice qué falló · pueden intentar
  las veces que necesiten.]
]