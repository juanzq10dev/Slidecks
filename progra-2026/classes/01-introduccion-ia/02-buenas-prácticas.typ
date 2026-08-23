#import "../../template.typ": *

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
  - En una palabra: ¿cómo te sentiste seguro, apurado, dudoso?

  #v(6mm)
  Compártela con la persona de al lado.
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
  title: "El framework 4D",
  subtitle: "Los pilares del buen uso, entre todos",
)

#activity-slide(
  kind: "Actividad",
  title: "Escribe el prompt que usarías hoy",
  duration: "6 min",
)[
  Piensa en una tarea real y pendiente: un ensayo, una tarea, un resumen, un
  proyecto de código.

  #v(6mm)
  - Escribe, tal como lo harías *hoy mismo*, el prompt que le darías a una IA
    para resolverla.
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
  No es una lista de pasos ni un checklist: es un *ciclo*. Si una falla, las
  otras tres se debilitan.
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
  title: "Descripción",
  section: "4D",
)[
  Las 3 P para describir lo que quieres:

  #v(6mm)
  - #text(weight: "bold")[Producto (¿Qué?)]:
    - Formato, audiencia, extensión y tono
    - ("un correo de 150 palabras para compradores internacionales..." funciona mucho mejor que "escríbeme un correo")
  - #text(weight: "bold")[Proceso (¿Cómo?)]: 
    - Cómo quieres que piense: ¿analiza varios ángulos?, ¿considera contraargumentos?, ¿va por pasos?
  - #text(weight: "bold")[Desempeño]: 
    - Cómo debe comportarse: ¿te pregunta antes de asumir?, ¿cuestiona tus supuestos?

  #v(6mm)
  #text(weight: "bold")[Input vago = output vago. Siempre.]
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
  - #text(weight: "bold")[Del producto] 
    - ¿Es correcto?, ¿le sirve a la audiencia?, ¿es coherente? 
    - Que se vea profesional no significa que sea verdad
  - #text(weight: "bold")[Del proceso] 
    - ¿De verdad razonó el problema, o solo organizó información de forma atractiva?
  - #text(weight: "bold")[Del desempeño]
    - ¿El tono y el nivel de detalle encajan con lo que necesitabas?

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
  title: "¿Lo publicarías así?",
  duration: "8 min",
)[
  #text(style: "italic")[
    "La IA te entregó un reporte con muy buena redacción, pero una de las
    estadísticas que cita no aparece en ninguna fuente que puedas encontrar."
  ]

  #v(6mm)
  En grupos debatan:
  - ¿Qué D falló primero en este caso: discernimiento o diligencia?
  - ¿Qué harían antes de entregarlo?
  - ¿Cómo se vería aplicar esa D *bien* en esta misma situación?

  #v(4mm)
  Compartimos 2 posturas distintas en plenaria.
]

// ============================================================
// Síntesis y cierre
// ============================================================
#content-slide(
  title: "Un ciclo, no una lista",
  section: "Síntesis",
)[
  Las 4D no se aplican una vez y en orden, se retroalimentan todo el tiempo:
  lo que discierne hoy mejora cómo describes mañana.

  #v(6mm)
  Y aplican distinto según el modo de trabajo:
  - #text(weight: "bold")[Automatización] — tareas rutinarias, la IA ejecuta
  - #text(weight: "bold")[Aumentación] — resolución conjunta, tú y la IA
    piensan juntos
  - #text(weight: "bold")[Agencia] — la IA opera con más independencia, tu
    diligencia importa aún más
]

#statement-slide(
  statement: "Que la IA haya escrito el primer borrador no reduce tu responsabilidad sobre el resultado final.",
  attribution: "AI Fluency Framework, Anthropic",
)

#activity-slide(
  kind: "Taller integrador",
  title: "Vuelve al prompt que escribiste",
  duration: "12 min",
)[
  Saca la tarea y el prompt que escribiste al inicio de esta sección.
  Revísalo con las cuatro preguntas:

  #v(4mm)
  + #text(weight: "bold")[Delegación]: ¿qué parte le toca de verdad a la IA?
  + #text(weight: "bold")[Descripción]: reescribe tu prompt con las 3P
  + #text(weight: "bold")[Discernimiento]: ¿qué revisarías antes de creerle?
  + #text(weight: "bold")[Diligencia]: ¿qué declararías y quién responde por
    el resultado final?
]

#content-slide(
  title: "Lo que construimos hoy",
  section: "Síntesis",
)[
  + *Delegación*: decide qué le toca a la IA y qué a ti, antes de empezar
  + *Descripción*: un input vago siempre produce un output vago
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
  El framework de las 4D (Delegación, Descripción, Discernimiento,
  Diligencia) fue desarrollado por Anthropic junto con los profesores
  Rick Dakan (Ringling College of Art and Design) y Joseph Feller
  (University College Cork).

  #v(6mm)
  - AI Fluency Framework — #link("https://aifluencyframework.org/")[aifluencyframework.org]
  - AI Fluency: Framework & Foundations, Claude Academy — #link("https://academy.claude.com/courses/ai-fluency-framework-foundations")[academy.claude.com]
  - AI Fluency: Framework & Foundations, Coursera — #link("https://www.coursera.org/learn/ai-fluency-framework-foundations")[coursera.org]
  - "What is the 4D Framework for AI Fluency", Karaza — #link("https://www.karaza.ai/what-is-the-4d-framework-for-ai-fluency/")[karaza.ai]
]

