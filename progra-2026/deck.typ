#import "template.typ": *

#show: deck.with(
  title: "NGLC — 2026",
  author: "Juan Zurita",
)

#title-slide(
  title: "NGLC — 2026",
  subtitle: "Plantilla de presentación",
  author: "Juan Zurita",
  date: "Agosto 2026",
)

#contents-slide(
  entries: (
    (name: "Introducción"),
    (name: "Objetivos", page: "04"),
    (name: "Cronograma", page: "05"),
    (name: "Recursos", page: "06"),
    (name: "Cierre", page: "07"),
  ),
)

#section-slide(
  number: "01",
  title: "Introducción",
  subtitle: "Contexto y motivación",
)

#content-slide(
  title: "Objetivos del programa",
  section: "Introducción",
)[
  - Fortalecer las capacidades técnicas del equipo 
  - Alinear el roadmap 2026 con los objetivos del NGLC
  - Definir hitos medibles por trimestre

  #v(6mm)
  #text(weight: "bold")[Próximos pasos]
  + Revisar cronograma con los líderes de área
  + Confirmar recursos y presupuesto
  + Publicar el plan definitivo
]

#two-column-slide(
  title: "Antes y después",
  section: "Introducción",
  left-content: [
    #text(weight: "bold")[Situación actual]
    - Procesos manuales y dispersos
    - Comunicación reactiva entre equipos
    - Métricas revisadas trimestralmente
  ],
  right-content: [
    #text(weight: "bold")[Situación propuesta]
    - Flujos automatizados y centralizados
    - Sincronización semanal entre equipos
    - Métricas revisadas en tiempo real
  ],
)

#image-slide(
  title: "Impacto esperado",
  section: "Introducción",
  position: "right",
)[
  - Reducción del 30% en tiempos de entrega
  - Mayor trazabilidad de decisiones
  - Onboarding de nuevos miembros más rápido

  #v(6mm)
  Reemplaza el marcador `picture:` con
  `image("archivo.jpg", width: 130mm, height: slide-height, fit: "cover")`
  cuando tengas el recurso final.
]
