#import "../../template.typ": *

#show: deck.with(
  title: "Clase 03 — Ingeniería de Prompts",
  author: "Juan Zurita",
)

// ============================================================
// Helpers reutilizables
// ============================================================

// Caja para mostrar un prompt literal (tono: "pobre" o "bueno")
#let prompt-box(label: "", tone: "pobre", body) = {
  let accent = if tone == "bueno" { palette.vanilla-custard.darken(25%) } else { palette.charcoal.lighten(35%) }
  block(
    width: 100%,
    inset: (x: 5mm, y: 4mm),
    radius: 2mm,
    fill: palette.beige.darken(3%),
    stroke: (left: 4pt + accent),
  )[
    #text(size: 10pt, tracking: 0.15em, weight: "bold", fill: palette.charcoal)[#upper(label)]
    #v(2mm)
    #text(font: "Liberation Mono", size: 12.5pt, fill: palette.gunmetal)[#body]
  ]
}

// Caja para simular la respuesta de un LLM
#let response-box(label: "RESPUESTA DEL LLM", body) = block(
  width: 100%,
  inset: (x: 5mm, y: 4mm),
  radius: 2mm,
  fill: white,
  stroke: (left: 4pt + palette.gunmetal),
)[
  #text(size: 10pt, tracking: 0.15em, weight: "bold", fill: palette.gunmetal)[#label]
  #v(2mm)
  #text(size: 13pt, fill: palette.charcoal)[#body]
]

// Caja para simular el razonamiento interno de un LLM, antes de su respuesta
#let reasoning-box(body) = block(
  width: 100%,
  inset: (x: 5mm, y: 3.5mm),
  radius: 2mm,
  fill: palette.beige.darken(6%),
  stroke: (left: 4pt + palette.charcoal.lighten(45%)),
)[
  #text(size: 9pt, tracking: 0.15em, weight: "bold", fill: palette.charcoal.lighten(10%))[RAZONAMIENTO DEL MODELO]
  #v(2mm)
  #text(size: 11pt, fill: palette.charcoal, style: "italic")[#body]
]

// Tarjeta de especificación (para la revelación del encargo real)
#let spec-card(label, value) = block(
  width: 100%,
  height: 100%,
  inset: (x: 5mm, y: 5mm),
  radius: 2mm,
  fill: palette.gunmetal,
)[
  #text(size: 10pt, tracking: 0.15em, weight: "bold", fill: palette.vanilla-custard)[#upper(label)]
  #v(3mm)
  #text(size: 16pt, fill: palette.beige)[#value]
]

// Píldora numerada para listar piezas de un prompt
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

// ============================================================
// Portada
// ============================================================
#title-slide(
  title: "Ingeniería de Prompts",
  subtitle: "Aprender a pedir: del deseo vago a la instrucción precisa",
  author: "Juan Zurita",
  date: "Clase 03 · Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Simulación de apertura: el folleto imposible", page: "03"),
    (name: "Lo que el modelo no puede saber", page: "07"),
    (name: "Anatomía de un prompt", page: "12"),
    (name: "Técnicas: few-shot y razonamiento", page: "16"),
    (name: "Prompting para programar", page: "24"),
    (name: "Antipatrones: cómo se rompe un prompt", page: "26"),
    (name: "Iterar: un prompt se depura, no se escribe", page: "28"),
    (name: "Adivina el prompt y cierre", page: "31"),
  ),
)

// ============================================================
// Apertura
// ============================================================
#section-slide(
  number: "01",
  title: "Antes de que yo explique nada",
  subtitle: "Primero lo vives, después le ponemos nombre",
)

#activity-slide(
  kind: "Encargo",
  title: "Diseñen el folleto",
  duration: "10 min",
)[
  En grupos de 3 o 4. Tienen una sola instrucción, y es esta:

  #v(5mm)
  #align(center)[
    #box(fill: palette.beige, inset: (x: 10mm, y: 7mm), radius: 2mm)[
      #text(size: 26pt, weight: "bold", fill: palette.gunmetal)[
        «Hagan un folleto para un curso de pastelería.»
      ]
    ]
  ]
]

#activity-slide(
  kind: "Revelación",
  title: "Lo que yo quería en realidad",
  duration: "3 min",
)[
  #v(1mm)
  #grid(
    columns: (1fr, 1fr),
    rows: 30mm,
    column-gutter: 6mm,
    row-gutter: 5mm,
    spec-card("Público", "Niños de educación básica, no adultos, no adolescentes"),
    spec-card("Duración", "Dos semanas exactas, no un semestre, no un taller de un día"),
    spec-card("Contenido", "Solo masitas, nada de tortas, panes ni postres finos"),
    spec-card("Costo", "100 Bs por participante, y los ingredientes NO están incluidos"),
  )

  #v(6mm)
  #align(center)[
    #text(size: 22pt, weight: "bold", fill: palette.gunmetal)[
      ¿Cuántos folletos sirven?
    ]
  ]
]

#activity-slide(
  kind: "Preguntas",
  title: "¿De quién fue el error?",
  duration: "6 min",
)[
  #v(3mm)
  #text(size: 19pt, weight: "bold")[¿Alguno acertó las tres especificaciones? ¿Cuántas acertó tu grupo?]

  #v(5mm)
  #text(size: 19pt, weight: "bold")[¿Qué diste por hecho sin que nadie te lo dijera?]

  #v(5mm)
  #text(size: 19pt, weight: "bold")[¿El error fue de ustedes... o del encargo que les di?]
]

// ============================================================
// Lo que el modelo no puede saber
// ============================================================
#section-slide(
  number: "02",
  title: "Lo que el modelo no puede saber",
  subtitle: "Tu prompt no es un resumen del encargo: es el encargo completo",
)

#two-column-slide(
  title: "Lo que entra y lo que se queda afuera",
  section: "Contexto",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Lo que el modelo ve]
    - El texto que escribiste. Punto.
    - Los archivos o el código que le pegaste
    - Lo que se dijo antes en *esta* conversación

    #v(4mm)
    #text(size: 14pt, style: "italic")[Nada más. No hay una vía secundaria.]
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Lo que se queda en tu cabeza]
    - Tu pantalla, tu error, tu proyecto
    - La consigna que te dio el profesor
    - Para quién es y quién lo va a leer
    - Cómo se ve, para ti, un trabajo "bien hecho"

    #v(4mm)
    #text(size: 14pt, style: "italic")[Exactamente igual que mi encargo del folleto.]
  ],
)

#content-slide(
  title: "Y ante el vacío, no pregunta: asume",
  section: "Contexto",
)[
  Cuando falta un dato, el modelo no se detiene. Completa con *lo más probable*
  según todo lo que leyó en su entrenamiento — que es lo más común, no lo tuyo.

  #v(5mm)
  - Pides "un curso de pastelería" y asume adultos, porque es lo más frecuente
  - Pides "arregla mi código" y asume Python, porque es lo más frecuente
  - Pides "hazlo más corto" y asume la mitad, porque es lo más frecuente

  #v(6mm)
  #text(weight: "bold")[Ya lo vieron en la clase 01: el modelo predice lo más
  probable. Tu contexto es lo único que puede cambiar esa probabilidad.]
]

#statement-slide(
  statement: "El modelo no adivina lo que tienes en la cabeza. Solo trabaja con lo que escribiste.",
)

#content-slide(
  title: "Lo que suele fallar",
  section: "Contexto",
)[
  #v(2mm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 12mm,
    row-gutter: 14mm,
    [
      #text(weight: "bold", fill: palette.gunmetal)[Ambigüedad]

      "Un curso de pastelería" ¿para quién? ¿de cuánto tiempo? ¿de qué?
    ],
    [
      #text(weight: "bold", fill: palette.gunmetal)[Contexto ausente]

      El modelo no vio tu código, tu consigna ni tu conversación previa.
    ],
    [
      #text(weight: "bold", fill: palette.gunmetal)[Formato implícito]

      Tú esperabas una tabla. Nunca lo dijiste. Te dieron tres párrafos.
    ],
    [
      #text(weight: "bold", fill: palette.gunmetal)[Éxito no definido]

      Si no dices cómo se ve "bien hecho", cualquier respuesta cumple.
    ],
  )
]

// ============================================================
// Anatomía
// ============================================================
#section-slide(
  number: "03",
  title: "Anatomía de un prompt",
  subtitle: "Cinco piezas que le quitan trabajo de adivinación al modelo",
)

#content-slide(
  title: "Las cinco piezas",
  section: "Anatomía",
)[
  #v(1mm)
  #stack(
    dir: ttb,
    spacing: 5.5mm,
    pieza("1", "Rol", "quién es el que responde y con qué criterio juzga"),
    pieza("2", "Contexto", "lo que el modelo no puede saber por su cuenta"),
    pieza("3", "Tarea", "el verbo concreto: analiza, corrige, compara, traduce"),
    pieza("4", "Formato", "estructura, extensión, tono, idioma de la salida"),
    pieza("5", "Restricciones", "los límites: qué no hacer, qué no inventar"),
  )

  #v(6mm)
  #text(size: 15pt)[
    Se conecta con las #text(weight: "bold")[3P] de la clase pasada: *Producto*
    es formato, *Proceso* es tarea, *Desempeño* es rol y restricciones.
  ]
]

#content-slide(
  title: "La misma petición, dos encargos distintos",
  section: "Anatomía",
)[
  #v(1mm)
  #prompt-box(label: "Prompt pobre", tone: "pobre")[
    Explícame las listas en Python.
  ]

  #v(5mm)
  #prompt-box(label: "Prompt con anatomía", tone: "bueno")[
    Actúa como un tutor de programación para principiantes. \
    Estoy en mi primer semestre y ya entiendo variables y `if`, pero nunca he
    usado listas. \
    Explícame qué es una lista en Python y para qué sirve. \
    Usa máximo 200 palabras, una analogía cotidiana y dos ejemplos de código
    comentados. \
    No uses `comprehensions` ni términos que no hayas definido antes.
  ]

  #v(4mm)
  #text(size: 14pt)[Misma intención. La diferencia es cuánto tuvo que *adivinar* el modelo.]
]

#activity-slide(
  kind: "Taller",
  title: "Cirugía de prompt",
  duration: "12 min",
)[
  Tomen este prompt real y opérenlo:

  #v(3mm)
  #text(style: "italic", size: 18pt)["Prepara una exposición para explicar como funciona un LLM."]

  #v(5mm)
  + Escriban la versión con las *cinco piezas*
]

// ============================================================
// Técnicas
// ============================================================
#section-slide(
  number: "04",
  title: "Técnicas",
  subtitle: "Ejemplos, razonamiento y estructura",
)

#two-column-slide(
  title: "Zero-shot y few-shot",
  section: "Técnicas",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Zero-shot]
    - Pides la tarea directamente, sin ejemplos
    - Suficiente cuando la tarea es común y el formato da igual
    - "Resume este texto en un párrafo"

    #v(4mm)
    #text(size: 14pt, style: "italic")[Barato y rápido. Empieza siempre aquí.]
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Few-shot]
    - Das 2 o 3 ejemplos *resueltos* antes de la tarea real
    - Enseña el formato mucho mejor que describirlo con palabras
    - Indispensable cuando la salida tiene una forma rara o muy tuya

    #v(4mm)
    #text(size: 14pt, style: "italic")[Mostrar gana a explicar.]
  ],
)

#content-slide(
  title: "Few-shot en la práctica",
  section: "Técnicas",
)[
  #v(1mm)
  #prompt-box(label: "Few-shot", tone: "bueno")[
    Clasifica el mensaje de commit según su tipo. \
    #v(2mm)
    "Arregla el crash al abrir el menú" → fix \
    "Agrega login con Google" → feat \
    "Renombra variables en utils.py" → refactor \
    #v(2mm)
    "Corrige el typo en el README" →
  ]

  #v(5mm)
  #text(size: 15pt)[
    Nunca definí qué es `fix`, `feat` ni `refactor`. Los ejemplos hicieron
    todo el trabajo: le enseñaron el vocabulario, el formato y el estilo de
    respuesta al mismo tiempo.
  ]
]

#content-slide(
  title: "Cadena de pensamiento: pensar antes de responder",
  section: "Técnicas",
)[
  - "Razona paso a paso antes de dar la respuesta final"
  - Sirve en lógica, matemática, depuración y decisiones con varios criterios
  - Cuesta más tokens y tiempo: no lo uses para pedir una definición

  #v(4mm)
  #text(size: 14pt, style: "italic")[Los modelos de razonamiento ya lo hacen solos.]
]

#two-column-slide(
  title: "Cadena de pensamiento en la práctica",
  section: "Técnicas",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Sin cadena de pensamiento]
    #v(3mm)
    #prompt-box(label: "Prompt", tone: "pobre")[
      El botón "Guardar" de mi aplicación no hace nada. \
      ¿Qué reviso?
    ]
    #v(4mm)
    #response-box[
      Puede haber un problema con el código del botón. Revisa que el evento
      `onClick` esté correctamente configurado.
    ]
    #v(3mm)
    #text(size: 12.5pt, style: "italic")[Una sola hipótesis, la más obvia, y ya.]
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Con cadena de pensamiento]
    #v(3mm)
    #prompt-box(label: "Prompt", tone: "bueno")[
      El botón "Guardar" de mi aplicación no hace nada. ¿Qué reviso? \
      Razona paso a paso antes de dar la respuesta final.
    ]
    #v(3mm)
    #reasoning-box[
      Primero comprobaría si el evento `onClick` se está ejecutando. \
      Si se ejecuta, revisaría si la función intenta enviar la información al
      backend. \
      Después comprobaría si el endpoint responde correctamente. \
      Finalmente revisaría si el frontend procesa la respuesta.
    ]
    #v(3mm)
    #response-box(label: "RESPUESTA FINAL")[
      Revisa el problema en este orden: `onClick` → función → API →
      respuesta. Así puedes identificar en qué punto se rompe el flujo.
    ]
  ],
)

#content-slide(
  title: "Descomposición: partir la tarea en pasos",
  section: "Técnicas",
)[
  - Una tarea gigante en un prompt = respuesta mediocre en todo
  - Pártela: primero el esquema, luego cada sección, luego la revisión
  - Cada paso se revisa antes de seguir al siguiente

  #v(4mm)
  #text(size: 14pt, style: "italic")[Igual que dividir un programa en funciones.]
]

#two-column-slide(
  title: "Descomposición en la práctica",
  section: "Técnicas",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Sin descomposición]
    #v(3mm)
    #prompt-box(label: "Prompt", tone: "pobre")[
      Mi API tarda 5 segundos en responder. Arréglalo.
    ]
    #v(3mm)
    #response-box[
      Puedes optimizar las consultas a la base de datos, agregar índices,
      utilizar caché y reducir la cantidad de datos que devuelve la API.
    ]
    #v(3mm)
    #text(size: 12.5pt, style: "italic")[Tira todas las causas a la vez, sin orden ni prioridad. ¿Por dónde empiezas?]
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Con descomposición]
    #v(3mm)
    #prompt-box(label: "Prompt", tone: "bueno")[
      Mi API tarda 5 segundos en responder. \
      #v(2mm)
      Identifica las posibles causas. \
      Explica cómo comprobar cada causa. \
      Determina cuál debería investigar primero. \
      Propón una solución.
    ]
    #v(3mm)
    #response-box[
      Las posibles causas son la base de datos, lógica del backend, servicios
      externos o una respuesta demasiado grande. \
      #v(2mm)
      Primero mide cuánto tarda cada etapa. Si la consulta a la base de datos
      consume 4 de los 5 segundos, optimiza esa consulta antes de modificar
      el frontend o agregar caché.
    ]
  ],
)

#content-slide(
  title: "Estructura: separa la instrucción del material",
  section: "Técnicas",
)[
  Cuando pegas un texto, un error o código dentro del prompt, el modelo puede
  confundir *qué* es la instrucción y *qué* es el material a procesar.

  #v(5mm)
  #prompt-box(label: "Con delimitadores", tone: "bueno")[
    Encuentra el error de lógica en el código entre triple backtick. \
    Explica primero la causa y después la corrección. \
    #v(2mm)
    \`\`\` \
    #h(4mm) def promedio(nums): \
    #h(8mm) return sum(nums) / len(nums) + 1 \
    \`\`\`
  ]

  #v(4mm)
  #text(size: 15pt)[
    Delimitadores, títulos en mayúscula, viñetas: cualquier estructura visible
    ayuda. #text(weight: "bold")[Un prompt bien formateado se lee mejor — para
    el modelo y para ti.]
  ]
]

// ============================================================
// Prompting para programar
// ============================================================
#section-slide(
  number: "05",
  title: "Prompting para programar",
  subtitle: "Su caso de uso número uno este semestre",
)

#two-column-slide(
  title: "Pedir ayuda con código",
  section: "Programación",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Siempre incluye]
    - El *código real*, no tu descripción de él
    - El *mensaje de error completo*, copiado tal cual
    - Lenguaje y versión (`Python 3.12`)
    - Qué esperabas que pasara vs. qué pasó
    - Qué ya intentaste (para que no te lo repita)
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Y pide esto]
    - "Explícame la causa *antes* de darme el código"
    - "No cambies nada que no esté relacionado con el error"
    - "Comenta cada línea que modificaste"
    - "Si te falta información para responder, pregúntame primero"
  ],
)

// ============================================================
// Antipatrones
// ============================================================
#section-slide(
  number: "06",
  title: "Antipatrones",
  subtitle: "Las formas más comunes de romper un prompt",
)

#two-column-slide(
  title: "Lo que rompe un prompt",
  section: "Antipatrones",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[El problema]
    - #text(weight: "bold")[Vaguedad]: "hazlo mejor", "más profesional"
    - #text(weight: "bold")[Sobrecarga]: seis tareas distintas en un solo mensaje
    - #text(weight: "bold")[Pregunta dirigida]: "¿verdad que mi solución está bien?"
    - #text(weight: "bold")[Negación sola]: "no seas aburrido"
    - #text(weight: "bold")[Contexto perdido]: das por hecho lo que nunca dijiste
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[El remedio]
    - Define *mejor* con un criterio medible o un ejemplo
    - Una tarea por mensaje; encadena en pasos
    - Pregunta neutral: "¿qué fallas tiene esta solución?"
    - Di qué *sí* quieres, no solo qué evitar
    - Pega el material; el modelo no tiene tu pantalla
  ],
)

// ============================================================
// Iterar
// ============================================================
#section-slide(
  number: "07",
  title: "Iterar",
  subtitle: "Un prompt no se escribe: se depura",
)

#content-slide(
  title: "No siempre lo lograrás a la primera",
  section: "Iteración",
)[
  Nadie escribe un programa de 200 líneas y espera que compile a la primera.
  Con los prompts pasa igual.

  #v(5mm)
  + #text(weight: "bold")[Ejecuta] la versión más simple posible
  + #text(weight: "bold")[Observa] la salida: ¿qué específicamente está mal?
  + #text(weight: "bold")[Aísla] la causa: ¿faltó contexto, formato o restricción?
  + #text(weight: "bold")[Cambia una sola cosa] y vuelve a ejecutar
  + #text(weight: "bold")[Guarda] la versión que funcionó

  #v(6mm)
  #text(weight: "bold")[Si cambias cinco cosas a la vez y mejora, no sabes cuál
  de las cinco lo logró.]
]


#activity-slide(
  kind: "Preguntas",
  title: "La trampa cómoda",
  duration: "6 min",
)[
  #v(3mm)
  #text(size: 19pt, weight: "bold")[Si la IA te da el código funcionando y tú no entiendes por qué funciona... ¿aprendiste algo?]

  #v(6mm)
  #text(size: 19pt, weight: "bold")[¿Qué prompt te habría hecho aprender, en vez de solo resolver?]

  #v(6mm)
  #text(size: 15pt)[
    Discútanlo en grupo. Después escriban *un prompt de estudio* que puedan reutilizar.
  ]
]

// ============================================================
// Cierre integrador
// ============================================================
#section-slide(
  number: "08",
  title: "Adivina el prompt",
  subtitle: "Todo lo de hoy, en una sola ronda",
)

#image-slide(
  title: "El objetivo",
  section: "Adivina el prompt",
  picture: image("images/05-vaca-en-el-campo.jpeg", width: slide-width / 2, height: slide-height, fit: "cover"),
  media-width: slide-width / 2,
  position: "right",
)[

  #v(4mm)
  Escribir la instrucción que produzca
  una imagen lo más parecida posible a esta.

  #v(4mm)

  #v(5mm)
  #text(weight: "bold", fill: palette.gunmetal)[
    Todo lo de hoy sirve aquí: anatomía, formato, restricciones e iteración.
  ]
]

#statement-slide(
  statement: "Saber preguntar es una habilidad técnica. Se practica, se depura y se mejora.",
)

#content-slide(
  title: "Lo que construimos hoy",
  section: "Síntesis",
)[
  + #text(weight: "bold")[Contexto]: el modelo solo ve tu prompt; lo que no escribiste, no existe
  + #text(weight: "bold")[Anatomía]: rol, contexto, tarea, formato, restricciones
  + #text(weight: "bold")[Few-shot]: mostrar dos ejemplos gana a explicar el formato
  + #text(weight: "bold")[Razonamiento]: pedir los pasos vence a exigir la respuesta de golpe
  + #text(weight: "bold")[Estructura]: separa la instrucción del material con delimitadores
  + #text(weight: "bold")[Antipatrones]: vaguedad, sobrecarga y preguntas que se autoconfirman
  + #text(weight: "bold")[Iteración]: un prompt se depura como se depura código
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
  - Prompt engineering overview, Anthropic — #link("https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview")[docs.anthropic.com]
  - Prompt engineering interactive tutorial, Anthropic — #link("https://github.com/anthropics/prompt-eng-interactive-tutorial")[github.com/anthropics]
  - AI Fluency Framework (las 4D), Anthropic · Rick Dakan · Joseph Feller — #link("https://aifluencyframework.org/")[aifluencyframework.org]
  - "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models", Wei et al., 2022 — #link("https://arxiv.org/abs/2201.11903")[arxiv.org/abs/2201.11903]
  - "Language Models are Few-Shot Learners", Brown et al., 2020 — #link("https://arxiv.org/abs/2005.14165")[arxiv.org/abs/2005.14165]

  #v(6mm)
  #text(size: 13pt, style: "italic")[
    El enfoque de clase (simulación primero, definición después) sigue el ciclo
    de aprendizaje experiencial: vivir, observar, conceptualizar, aplicar.
  ]
]
