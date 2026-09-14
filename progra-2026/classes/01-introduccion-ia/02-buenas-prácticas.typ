#import "../../template.typ": *

#let two-col-table(col1, col2, rows) = table(
  columns: (1fr, 1.6fr),
  inset: 8pt,
  align: (left + horizon, left + horizon),
  stroke: (x, y) => (
    bottom: if y == 0 { 1.4pt + palette.vanilla-custard } else { 0.6pt + palette.charcoal.lighten(70%) },
  ),
  fill: (x, y) => if y == 0 { palette.beige } else { none },
  table.header(
    text(weight: "bold", fill: palette.gunmetal)[#col1],
    text(weight: "bold", fill: palette.gunmetal)[#col2],
  ),
  ..rows.flatten(),
)

#show: deck.with(
  title: "Clase 02 — Buenas Prácticas en el Uso de IA",
  author: "Juan Zurita",
)

// ============================================================
// Portada
// ============================================================
#title-slide(
  title: "Buenas Prácticas en el Uso de IA",
  subtitle: "El estudiante como protagonista: pensar, cuestionar, decidir",
  author: "Juan Zurita",
  date: "Clase 02 · Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Apertura: antes de cortar nada", page: "03"),
    (name: "La IA es como un cuchillo", page: "04"),
    (name: "Las 4D", page: "06"),
    (name: "Delegación y descripción", page: "09"),
    (name: "Discernimiento y diligencia", page: "13"),
    (name: "Dilemas éticos", page: "15"),
    (name: "Síntesis y cierre", page: "19"),
  ),
)

// ============================================================
// Apertura
// ============================================================
#activity-slide(
  kind: "Preguntas",
  title: "Antes de cortar nada...",
  duration: "5 min",
)[
  #v(4mm)
  Piensa en la última vez que usaste IA para algo que *importaba de verdad*.

  #v(6mm)
  - ¿Revisaste el resultado o confiaste de una?

]

// ============================================================
// Sección 01 — La metáfora del cuchillo
// ============================================================
#section-slide(
  number: "01",
  title: "La IA es como un cuchillo, el resultado depende del cocinero.",
  subtitle: "Una herramienta, no un reemplazo del criterio",
)

#activity-slide(
  kind: "Preguntas",
  title: "¿Qué te hace \"buen cocinero\"?",
  duration: "5 min",
)[
  #v(4mm)
  #text(size: 20pt, weight: "bold")[¿Qué sabes hacer tú que la IA no puede reemplazar?]

  #v(6mm)
  #text(size: 20pt, weight: "bold")[¿En qué momento decides tú y no el modelo?]
  #v(6mm)
]

// ============================================================
// Sección 02 — Construyendo el criterio
// ============================================================
#section-slide(
  number: "02",
  title: "Las 4D",
  subtitle: "Los pilares del buen uso, entre todos",
)

#activity-slide(
  kind: "Actividad",
  title: "Escribe la instrucción que usarías hoy",
  duration: "6 min",
)[
  Piensa en una tarea real y pendiente: un ensayo, una tarea, un resumen, un
  proyecto de código.

  #v(6mm)
  - Escribe, tal como lo harías *hoy mismo*, la instrucción que le darías a
    una IA para resolverla.
  - Guárdalo, no lo borres.
]

#image-slide(
  title: "Anthropic le puso nombre a esto: las 4D",
  section: "Buenas prácticas",
  media-width: slide-width / 2,
  picture: image("images/03-4d-framework.png", width: slide-width / 2, height: slide-height, fit: "contain"),
)[
  Anthropic (los creadores de Claude), junto con los profesores
  Rick Dakan y Joseph Feller, las agruparon en cuatro competencias:

  #v(6mm)
  + #text(weight: "bold")[Delegación]
  + #text(weight: "bold")[Descripción]
  + #text(weight: "bold")[Discernimiento]
  + #text(weight: "bold")[Diligencia]

  #v(6mm)
  No es una lista de pasos que sigues una sola vez: es un *ciclo*. Si una
  falla, las otras tres se debilitan.
]

#content-slide(
  title: "Delegación",
  section: "4D",
)[
  No todos los trabajos los puede hacer la IA. 

  #v(6mm)
  - #text(weight: "bold")[Conciencia del objetivo]: un objetivo vago
    ("ayúdame con mi presentación") produce una delegación pobre
  - #text(weight: "bold")[Conciencia de la herramienta]: cada IA tiene
    fortalezas distintas, no todas sirven para lo mismo
  - #text(weight: "bold")[Delegar la tarea]: la IA es buena en trabajo
    repetitivo y detectar patrones; tú decides juicio, matices y relaciones
]

#content-slide(
  title: "¿Qué delegar y qué no?",
  section: "4D",
)[
  #two-col-table("Delegar a la IA", "Quedarte tú", (
    (
      [Buscar y resumir información repetitiva],
      [Decidir qué información le importa a tu audiencia],
    ),
    (
      [Generar un primer borrador rápido],
      [Juzgar si ese borrador dice lo que tú quieres decir],
    ),
    (
      [Detectar errores de ortografía o formato],
      [Evaluar si el argumento central tiene sentido],
    ),
    (
      [Adaptar un texto a otro tono o idioma],
      [Decidir sobre personas, por ejemplo qué nota merece un compañero],
    ),
  ))
]

#content-slide(
  title: "Descripción",
  section: "4D",
)[
  Las 3 P para describir lo que quieres:

  #v(6mm)
  #two-col-table("P", "Ejemplo", (
    (
      [*Producto (¿Qué?)*\ Formato, audiencia, extensión y tono],
      [Pide "un correo de 150 palabras para compradores internacionales" en vez de "escríbeme un correo"],
    ),
    (
      [*Proceso (¿Cómo?)*\ Cómo quieres que piense],
      [Pide "antes de responder, considera dos contraargumentos" en vez de dejarla improvisar],
    ),
    (
      [*Desempeño*\ Cómo debe comportarse],
      [Pide "pregúntame si algo no está claro, no asumas" en vez de que invente supuestos],
    ),
  ))

  #v(6mm)
  #text(weight: "bold")[Si le pides algo vago, te devuelve algo vago. Siempre.]
]

#activity-slide(
  kind: "Taller",
  title: "Vuelve a tu propio caso",
  duration: "8 min",
)[
  Piensa en la situación que describiste al inicio de la clase.

  #v(4mm)
  - ¿Qué le tocaba realmente a la IA, y qué te tocaba a ti?
  - Reescribe tu instrucción original aplicando las 3P: *producto*, *proceso*
    y *desempeño*.
]

#content-slide(
  title: "Discernimiento",
  section: "4D",
)[
  Tu capacidad de juzgar si lo que te devolvió la IA es correcto, apropiado y
  bien razonado *antes* de usarlo.

  #v(6mm)
  #two-col-table("Qué revisar", "Pregúntate", (
    (
      [*Del producto*],
      [¿Es correcto?, ¿le sirve a la audiencia?, ¿es coherente? Que se vea profesional no significa que sea verdad],
    ),
    (
      [*Del proceso*],
      [¿De verdad razonó el problema, o solo organizó información de forma atractiva?],
    ),
    (
      [*Del desempeño*],
      [¿El tono y el nivel de detalle encajan con lo que necesitabas?],
    ),
  ))

  #v(6mm)
  #text(weight: "bold")[Lee cada respuesta como si la hubiera escrito tu
  competencia: con escepticismo.]
]

#content-slide(
  title: "Diligencia",
  section: "4D",
)[
  La responsabilidad no se delega:
  #v(2mm)
  - #text(weight: "bold")[Al crear]: elige la herramienta adecuada; cuidado
    con meter datos sensibles en plataformas sin políticas claras
  - #text(weight: "bold")[Al ser transparente]: declara cuándo y cómo usaste
    IA; la confianza se construye siendo abierto, no ocultándolo
  - #text(weight: "bold")[Al entregar]: tú respondes por el resultado final,
    revísalo como sistema completo, no solo la última entrega

  #v(6mm)
  #text(weight: "bold")[Que la IA haya hecho parte del trabajo
  tu responsabilidad sobre el resultado final.]
]

#activity-slide(
  kind: "Dilema ético",
  title: "¿A quién le tocaba decidir?",
  duration: "5 min",
)[
  #text(style: "italic")[
    "Un estudiante le pidió a la IA que decidiera qué compañero de equipo
    merecía la nota más alta, basándose en los mensajes del chat grupal."
  ]

  #v(6mm)
  En grupos debatan:
  - ¿Qué D falló primero en este caso?
  - ¿Qué harían antes de entregarlo?
]

#activity-slide(
  kind: "Dilema ético",
  title: "¿Bastaba con eso?",
  duration: "5 min",
)[
  #text(style: "italic")[
    "Alguien le pidió a la IA 'escribe algo para explicarle a mis papás por
    qué llegué tarde', sin dar más contexto, y envió la respuesta tal cual
    aunque sonaba a excusa genérica."
  ]

  #v(6mm)
  En grupos debatan:
  - ¿Qué D falló primero en este caso?
  - ¿Qué harían antes de entregarlo?
]

#activity-slide(
  kind: "Dilema ético",
  title: "¿Lo publicarías así?",
  duration: "5 min",
)[
  #text(style: "italic")[
    "La IA te entregó un reporte con muy buena redacción, pero una de las
    estadísticas que cita no aparece en ninguna fuente que puedas encontrar."
  ]

  #v(6mm)
  En grupos debatan:
  - ¿Qué D falló primero en este caso?
  - ¿Qué harían antes de entregarlo?
]

#activity-slide(
  kind: "Dilema ético",
  title: "¿Quién responde?",
  duration: "5 min",
)[
  #text(style: "italic")[
    "Un estudiante entregó un ensayo generado casi completo por la IA sin
    decirlo, y cuando el profesor preguntó de dónde salió un argumento,
    contestó 'no sé, así me lo dio la IA'."
  ]

  #v(6mm)
  En grupos debatan:
  - ¿Qué D falló primero en este caso?
  - ¿Qué harían antes de entregarlo?
]

// ============================================================
// Síntesis y cierre
// ============================================================

#statement-slide(
  statement: "Que la IA haya hecho parte del trabajo no reduce tu responsabilidad sobre el resultado final.",
  attribution: "AI Fluency Framework, Anthropic",
)

#activity-slide(
  kind: "Taller integrador",
  title: "Vuelve a la instrucción que escribiste",
  duration: "12 min",
)[
  Saca la tarea y la instrucción que escribiste al inicio de esta sección.
  Revísalo con las cuatro preguntas:

  #v(4mm)
  + #text(weight: "bold")[Delegación]: ¿qué parte le toca de verdad a la IA?
  + #text(weight: "bold")[Descripción]: reescribe tu instrucción con las 3P
  + #text(weight: "bold")[Discernimiento]: ¿qué revisarías antes de creerle?
  + #text(weight: "bold")[Diligencia]: ¿qué declararías y quién responde por
    el resultado final?
]

#content-slide(
  title: "Lo que construimos hoy",
  section: "Síntesis",
)[
  + *Delegación*: decide qué le toca a la IA y qué a ti, antes de empezar
  + *Descripción*: una instrucción vaga siempre produce un resultado vago
  + *Discernimiento*: lee cada respuesta con el escepticismo de un rival
  + *Diligencia*: la responsabilidad del resultado final es siempre tuya
  + Las 4D funcionan como un *ciclo*: una debilidad afecta a las demás
]

// ============================================================
// Fuentes
// ============================================================
#content-slide(
  title: "Fuentes",
  section: "Referencias",
)[
  #set text(size: 14pt)
  El modelo de las 4D (Delegación, Descripción, Discernimiento,
  Diligencia) fue desarrollado por Anthropic junto con los profesores
  Rick Dakan (Ringling College of Art and Design) y Joseph Feller
  (University College Cork).

  #v(6mm)
  - AI Fluency Framework — #link("https://aifluencyframework.org/")[aifluencyframework.org]
  - AI Fluency: Framework & Foundations, Claude Academy — #link("https://academy.claude.com/courses/ai-fluency-framework-foundations")[academy.claude.com]
  - AI Fluency: Framework & Foundations, Coursera — #link("https://www.coursera.org/learn/ai-fluency-framework-foundations")[coursera.org]
  - "What is the 4D Framework for AI Fluency", Karaza — #link("https://www.karaza.ai/what-is-the-4d-framework-for-ai-fluency/")[karaza.ai]
]

