#import "../../template.typ": *

#show: deck.with(
  title: "Clase 01 — Introducción a la Inteligencia Artificial",
  author: "Juan Zurita",
)

// Barra de atención reutilizable para la sección de Transformers
#let attn-row(word, ratio, label) = grid(
  columns: (32mm, 1fr, 30mm),
  align: (right + horizon, left + horizon, right + horizon),
  column-gutter: 4mm,
  text(size: 14pt, weight: "bold", fill: palette.gunmetal)[#word],
  box(width: 100%, height: 6mm, fill: palette.charcoal.lighten(80%), radius: 1mm)[
    #box(width: ratio, height: 100%, fill: palette.vanilla-custard.darken(15%), radius: 1mm)
  ],
  text(size: 11pt, fill: palette.charcoal)[#label],
)

// ============================================================
// Portada
// ============================================================
#title-slide(
  title: "Introducción a la Inteligencia Artificial",
  subtitle: "LLMs, Transformers, Temperatura, HuggingFace y Prompting",
  author: "Juan Zurita",
  date: "Clase 01 · Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Bienvenida y competencias", page: "03"),
    (name: "¿Qué es la Inteligencia Artificial?", page: "06"),
    (name: "Large Language Models (LLM)", page: "10"),
    (name: "Transformers y atención", page: "14"),
    (name: "Temperatura y entropía", page: "18"),
    (name: "Hugging Face", page: "22"),
    (name: "Buenas prácticas en el uso de IA", page: "25"),
    (name: "Ingeniería de prompts", page: "28"),
    (name: "Síntesis y cierre", page: "33"),
  ),
)

// ============================================================
// Bienvenida y competencias
// ============================================================

#activity-slide(
  kind: "Preguntas",
  title: "Antes de empezar...",
  duration: "5 min",
)[
  #v(4mm)
  #text(size: 20pt, weight: "bold")[¿Qué es la Inteligencia Artificial para ti?]

  #v(6mm)
  + Escríbela en un papel
  + Dos o tres personas la comparten con toda la clase

  #v(6mm)
  #text(size: 20pt, weight: "bold")[¿Cómo utilizas la IA en tú día a día? ]
  #v(6mm)
]

// ============================================================
// ¿Qué es la Inteligencia Artificial?
// ============================================================
#section-slide(
  number: "01",
  title: "¿Qué es la Inteligencia Artificial?",
  subtitle: "De reglas fijas a patrones aprendidos",
)

#image-slide(
  title: "Intentando imitar el razonamiento humano...",
  section: "IA",
  media-width: slide-width / 2,
  picture: image("images/02-gatos-vs-no-gatos.png", width: slide-width / 2, height: slide-height, fit: "contain"),
)[
  - Sistemas capaces de aprender por sí solos. 
  - Se inspira en cómo aprendemos por ejemplos y patrones.

  *Ejemplos:*
  - Sistemas de recomendación (Netflix, Spotify).
  - Asistentes de voz.
  - Algoritmos de detección.
]

#content-slide(
  title: "Inteligencia artificial...",
)[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 10mm,
    align(horizon)[
      #image("images/01-ai-branches.png", width: 100%, fit: "contain")
    ],
    [
      #text(size: 18pt)[
        - Sistema que *aprende patrones a partir de datos* 
        - Toma decisiones o generar resultados.
        - No sigue instrucciones escritas a mano paso a paso.
      ]

      #v(8mm)
      *La evolución...*
      + *Reglas fijas*: "si pasa X, haz Y" (todo escrito por humanos)
      + *Machine Learning*: el sistema aprende reglas a partir de ejemplos
      + *Deep Learning*: redes neuronales con muchas capas aprenden patrones complejos
      + *LLMs*: deep learning aplicado a lenguaje, entrenado con textos masivos
    ],
  )
]

// #activity-slide(
//   kind: "Simulación",
//   title: "Cadena de problemas",
//   duration: "6 min",
// )[
//   En grupos de 3, van a *actuar* como un sistema de reglas fijas y luego como uno que aprende.

//   #v(4mm)
//   - *Ronda 1 — Reglas fijas*: reciben una tarjeta con instrucciones exactas
//     ("si la palabra empieza con vocal, levanta la mano izquierda..."). Síganlas al pie de la letra.
//   - *Ronda 2 — Aprendizaje por ejemplos*: reciben solo 5 ejemplos resueltos, sin instrucciones.
//     Deben *inferir* la regla y aplicarla a un caso nuevo.

//   #v(6mm)
//   Cierre en plenaria: ¿qué ronda se pareció más a cómo creen que funciona un LLM?
// ]
#section-slide(
  number: "02",
  title: "Large Language Models (LLM)",
  subtitle: "El arte de predecir la siguiente palabra",
)

#activity-slide(
  kind: "Actividad",
  title: "La cadena de palabras",
  duration: "8 min",
)[

  #v(4mm)
  1. Alguien dice la primera palabra de una oración
  2. La siguiente persona dice *solo una palabra más probable* que continúe la frase.
  3. Continúa.
  4. Nadie sabe hacia dónde va la frase cada quien predice desde el contexto inmediato
]

#activity-slide(
  kind: "Preguntas",
  title: "La cadena de palabras",
  duration: "2 min",
)[
    #v(4mm)
  #text(size: 20pt, weight: "bold")[¿La oración final tuvo sentido? ]


  #v(6mm)
  #text(size: 20pt, weight: "bold")[¿Alguien "pensó" el final desde el inicio?]
  #v(6mm)

]


// ============================================================
// Large Language Models
// ============================================================

#content-slide(
  title: "¿Qué es realmente un LLM?",
  section: "LLMs",
)[
  Un LLM es un modelo entrenado con una tarea absurdamente simple:
  *dado un fragmento de texto, predice la palabra (token) más probable que sigue.*

  #v(6mm)
  - Se entrena con billones de palabras de texto real
  - Repite esa predicción una y otra vez para "aprender" gramática, hechos y estilo
  - No hay una base de datos de respuestas, hay probabilidades aprendidas
  - Generar una respuesta = encadenar miles de estas predicciones, una por una
]

#content-slide(
  title: "Temperatura.",
  section: "LLMs",
)[
  La temperatura controla qué tan variadas son las respuestas de un modelo de IA.
  #v(6mm)
  - *Temperatura baja (cerca a 0)*: produce respuestas concentradas en las opciones más probables. 
  - *Temperatura baja (cerca a 1)*: aumentando la posibilidad de elegir palabras menos probables.
  #v(6mm)
  #text(weight: "bold")[Entropía] es la medida de *cuánta sorpresa* hay en esa elección:
  - Temperatura baja = entropía baja; 
  - Temperatura alta= entropía alta.

  Veamos como funciona un LLM en vivo:


  - https://chyams-llm-explorer.hf.space/?__theme=system&utm_source=chatgpt.com

  ¿Quién sabe que significa GPT? 

  - https://poloclub.github.io/transformer-explainer/

]  

#two-column-slide(
  title: "Lo que SÍ y NO hace un LLM",
  section: "LLMs",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[SÍ hace]
    - Reconoce patrones lingüísticos complejos
    - Generaliza a partir de ejemplos en el prompt
    - Combina información de formas nuevas
    - Mantiene coherencia dentro de una conversación
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[NO hace]
    - No "sabe" si algo es verdadero, puede alucinar
    - No tiene memoria entre conversaciones (salvo que se la den)
    - No verifica sus propias fuentes
    - No tiene intenciones ni consciencia
  ],
)

#statement-slide(
  statement: "La IA no entiende el mundo. Entiende patrones.",
)

// 

// ============================================================
// Hugging Face
// ============================================================
#section-slide(
  number: "05",
  title: "Hugging Face",
  subtitle: "El ecosistema abierto de modelos de IA",
)

#content-slide(
  title: "El \"GitHub\" de los modelos de IA",
  section: "Hugging Face",
)[
  Hugging Face es una plataforma donde la comunidad publica, comparte y prueba modelos de IA abiertamente.

  #v(6mm)
  - #text(weight: "bold")[Hub] — miles de modelos preentrenados, listos para descargar o usar vía API
  - #text(weight: "bold")[Datasets] — conjuntos de datos públicos para entrenar o evaluar modelos
  - #text(weight: "bold")[Spaces] — demos interactivas de modelos, corriendo en el navegador
  - #text(weight: "bold")[Transformers] — la librería en Python que conecta todo esto con tu código

  #v(6mm)
  Cada modelo tiene una #text(weight: "bold")[model card]: su tarea, limitaciones, licencia y forma de uso.
]

#activity-slide(
  kind: "Actividad",
  title: "Exploradores de Hugging Face",
  duration: "10 min",
)[
  En parejas, entren a huggingface.co/models y busquen *un modelo* que les llame la atención.

  #v(4mm)
  Identifiquen y anoten:
  - ¿Para qué *tarea* fue creado? (texto, imagen, audio...)
  - ¿Qué *licencia* tiene? ¿Se puede usar comercialmente?
  - ¿Cuántas *descargas* o *likes* tiene — qué tan popular es?
  - ¿Tiene un *Space* donde se pueda probar sin instalar nada?

  #v(6mm)
  Cierre: 3 parejas comparten su modelo en 30 segundos cada una.
]

// ============================================================
// Buenas prácticas
// ============================================================
#section-slide(
  number: "06",
  title: "Buenas prácticas en el uso de IA",
  subtitle: "Usar IA bien es una habilidad, no un accidente",
)

#two-column-slide(
  title: "Buenas prácticas vs. riesgos",
  section: "Buenas prácticas",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Hacer]
    - Verificar hechos importantes con otra fuente
    - Revisar y entender el código o texto antes de usarlo
    - Declarar cuándo usaste IA en un trabajo
    - Proteger datos personales y sensibles
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Evitar]
    - Copiar respuestas sin revisar (alucinaciones)
    - Pegar información confidencial en un chat
    - Delegar todo el pensamiento crítico al modelo
    - Asumir que "suena seguro" significa "es correcto"
  ],
)

#activity-slide(
  kind: "Dilema ético",
  title: "¿Qué harías tú?",
  duration: "8 min",
)[
  #text(style: "italic")[
    "Un compañero te pasa un ensayo generado casi por completo con IA para
    entregarlo como tarea. Tiene buena forma, pero no estás seguro de que los
    datos que cita sean reales."
  ]

  #v(6mm)
  En grupos de 3-4:
  - ¿Qué harían en esa situación?
  - ¿Qué principio de buenas prácticas está en juego?
  - ¿Cómo se vería usar la IA *bien* en ese mismo caso?

  #v(4mm)
  Compartimos 2 posturas distintas en plenaria.
]

// ============================================================
// Ingeniería de prompts
// ============================================================
#section-slide(
  number: "07",
  title: "Ingeniería de prompts",
  subtitle: "Comunicarse con precisión con un modelo",
)

#content-slide(
  title: "Anatomía de un buen prompt",
  section: "Prompts",
)[
  Un prompt efectivo casi siempre incluye estas piezas:

  #v(4mm)
  + *Rol* — "Actúa como un editor técnico..."
  + *Contexto* — la información de fondo que el modelo necesita
  + *Tarea* — qué quieres exactamente que haga
  + *Formato* — cómo quieres la respuesta (lista, tabla, tono, extensión)
  + *Restricciones* — qué evitar o qué límites respetar

  #v(6mm)
  Mientras más de estas piezas incluyas, menos tiene que *adivinar* el modelo.
]

#two-column-slide(
  title: "Técnicas de prompting",
  section: "Prompts",
  left-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Zero-shot / Few-shot]
    - *Zero-shot*: pides la tarea directamente, sin ejemplos
    - *Few-shot*: das 2-3 ejemplos resueltos antes de la tarea real
    - Few-shot ayuda cuando el formato de salida es específico
  ],
  right-content: [
    #text(weight: "bold", fill: palette.iron-grey)[Chain-of-thought / Rol]
    - *Chain-of-thought*: pides "piensa paso a paso" antes de responder
    - *Role prompting*: le das una identidad experta ("actúa como...")
    - Ambas mejoran tareas de razonamiento o precisión
  ],
)

#statement-slide(
  statement: "Un prompt es una receta, no un deseo: mientras más preciso seas, mejor sale el platillo.",
)

#activity-slide(
  kind: "Taller",
  title: "Mejora el prompt",
  duration: "10 min",
)[
  Prompt original (deficiente): #text(style: "italic")["Escríbeme algo sobre marketing."]

  #v(4mm)
  En parejas, reescríbanlo aplicando la anatomía de un buen prompt:
  - Agreguen *rol*, *contexto*, *tarea* clara, *formato* y *restricciones*
  - Pruébenlo si tienen acceso a una IA — comparen el resultado con el del prompt original
  - Iteren una vez más basados en la respuesta obtenida

  #v(6mm)
  Cierre: 2 parejas comparten su prompt final y qué cambiaron.
]

// ============================================================
// Síntesis y cierre
// ============================================================
#content-slide(
  title: "Lo que vimos hoy",
  section: "Síntesis",
)[
  + *IA*: sistemas que aprenden patrones a partir de datos
  + *LLM*: predice la siguiente palabra, una y otra vez
  + *Transformer*: arquitectura basada en atención — mira todo el contexto a la vez
  + *Temperatura / entropía*: el dial entre lo predecible y lo creativo
  + *Hugging Face*: el ecosistema abierto donde viven estos modelos
  + *Buenas prácticas*: usar IA con criterio, no en automático
  + *Prompting*: comunicarte con precisión para obtener mejores resultados
]

#content-slide(
  title: "Volvamos a tu palabra inicial",
  section: "Síntesis",
)[
  Recuerda la palabra que escribiste al comienzo de la clase para describir la IA.

  #v(6mm)
  - ¿La cambiarías ahora?
  - ¿Qué palabra nueva usarías?
  - Compártela con la persona de al lado — en una frase, explica por qué

  #v(8mm)
  #text(weight: "bold")[Para la próxima clase]: trae un prompt que hayas escrito
  esta semana y estemos listos para diseccionarlo en grupo.
]
