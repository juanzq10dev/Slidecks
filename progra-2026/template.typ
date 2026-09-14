// ============================================================
// Slide deck template
// Palette: user-supplied 5-color scheme
//   Vanilla Custard #D7DFA3  ·  Charcoal #5A6061  ·  Beige #ECEFDF
//   Iron Grey #455457        ·  Gunmetal #343A3C
// ============================================================

#let palette = (
  vanilla-custard: rgb("#D7DFA3"),
  charcoal:        rgb("#5A6061"),
  beige:           rgb("#ECEFDF"),
  iron-grey:       rgb("#455457"),
  gunmetal:        rgb("#343A3C"),
)

#let slide-width = 338.67mm
#let slide-height = 190.5mm

#let slide-count = counter("slide-count")

// ------------------------------------------------------------
// Deck wrapper: call once, wraps every slide body
// ------------------------------------------------------------
#let deck(
  title: "",
  author: "",
  font: "Liberation Sans",
  body,
) = {
  set document(title: title, author: author)
  set page(
    width: slide-width,
    height: slide-height,
    margin: 0pt,
    fill: palette.beige,
  )
  set text(font: font, fill: palette.gunmetal, size: 20pt)
  set par(leading: 0.65em, justify: false)
  body
}

// ------------------------------------------------------------
// Shared chrome: footer rule + page number + running section label
// ------------------------------------------------------------
#let footer(section: none) = {
  place(bottom + left, dx: 14mm, dy: -9mm)[
    #rect(width: slide-width - 28mm, height: 1.2pt, fill: palette.charcoal.lighten(60%))
  ]
  place(bottom + right, dx: -14mm, dy: -6.5mm)[
    #text(size: 10pt, fill: palette.charcoal)[
      #context slide-count.display()
    ]
  ]
}

// ------------------------------------------------------------
// Title slide
// ------------------------------------------------------------
#let title-slide(
  title: "",
  subtitle: "",
  author: "",
  date: "",
  logo: none,
) = {
  slide-count.update(1)

  // full-height sidebar
  place(top + left, dx: 0mm, dy: 0mm)[
    #rect(width: 118mm, height: slide-height, fill: palette.gunmetal)
  ]
  // accent stripe between sidebar and content
  place(top + left, dx: 118mm, dy: 0mm)[
    #rect(width: 3mm, height: slide-height, fill: palette.vanilla-custard)
  ]
  // logo slot inside sidebar — pass `logo: image("your-logo.png", width: 26mm)`
  // to a title-slide() call; leave unset to keep the placeholder frame
  place(top + left, dx: 18mm, dy: 18mm)[
    #box(
      width: 32mm, height: 32mm,
      stroke: if logo == none {
        (paint: palette.vanilla-custard, thickness: 1pt, dash: "dashed")
      } else { none },
    )[
      #align(center + horizon)[
        #if logo != none {
          logo
        } else {
          text(size: 9pt, fill: palette.vanilla-custard, tracking: 0.1em)[LOGO]
        }
      ]
    ]
  ]
  // sidebar kicker text
  place(bottom + left, dx: 18mm, dy: -18mm)[
    #text(size: 13pt, fill: palette.beige, tracking: 0.15em)[#upper(author)]
    #v(2mm)
    #text(size: 11pt, fill: palette.vanilla-custard)[#date]
  ]

  // main content area
  place(left + horizon, dx: 140mm, dy: -6mm)[
    #box(width: 180mm)[
      #text(size: 42pt, weight: "bold", fill: palette.gunmetal)[#title]
      #v(6mm)
      #line(length: 22mm, stroke: 2pt + palette.iron-grey)
      #v(6mm)
      #text(size: 18pt, fill: palette.iron-grey)[#subtitle]
    ]
  ]

  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Contents / agenda slide
// ------------------------------------------------------------
#let contents-slide(
  title: "Contents",
  entries: (),
) = {
  slide-count.step()

  // La altura disponible para la lista es fija (52mm a ~178mm). El espaciado
  // por defecto entre bloques hacía que la lista se saliera de la diapositiva
  // con más de 6 entradas, así que aquí se controla explícitamente y se
  // reduce cuando hay más entradas para que siempre quepan.
  let n = entries.len()
  let icon-size = if n <= 6 { 9mm } else if n == 7 { 8.5mm } else { 8mm }
  let name-size = if n <= 6 { 17pt } else if n == 7 { 16.5pt } else { 15.5pt }
  let entry-gap = if n <= 6 { 8mm } else if n == 7 { 6mm } else { 4.5mm }

  place(top + left, dx: 14mm, dy: 16mm)[
    #text(size: 30pt, weight: "bold", fill: palette.gunmetal)[#title]
  ]
  place(top + left, dx: 14mm, dy: 34mm)[
    #rect(width: 26mm, height: 2.4pt, fill: palette.vanilla-custard)
  ]

  place(top + left, dx: 14mm, dy: 52mm)[
    #box(width: slide-width - 28mm)[
      #set block(spacing: 0mm)
      #for (i, entry) in entries.enumerate() [
        #grid(
          columns: (14mm, 1fr, 20mm),
          align: (center + horizon, left + horizon, right + horizon),
          [
            #box(
              width: icon-size, height: icon-size, radius: icon-size / 2,
              fill: if calc.even(i) { palette.iron-grey } else { palette.charcoal },
            )[
              #align(center + horizon)[
                #text(size: 11pt, fill: palette.beige, weight: "bold")[#(i + 1)]
              ]
            ]
          ],
          [
            #text(size: name-size, fill: palette.gunmetal)[#entry.name]
          ],
          [
            #text(size: 12pt, fill: palette.charcoal)[#entry.at("page", default: "")]
          ],
        )
        #if i < entries.len() - 1 [
          #v(entry-gap * 0.5)
          #line(length: slide-width - 28mm, stroke: 0.6pt + palette.charcoal.lighten(70%))
          #v(entry-gap * 0.5)
        ]
      ]
    ]
  ]

  footer(section: title)
  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Content slide: header + free-form body
// ------------------------------------------------------------
#let content-slide(
  title: "",
  section: none,
  body,
) = {
  slide-count.step()

  let header-parts = ()
  if section != none {
    header-parts.push(text(size: 11pt, fill: palette.charcoal, tracking: 0.15em)[#upper(section)])
  }
  header-parts.push(text(size: 26pt, weight: "bold", fill: palette.gunmetal)[#title])
  header-parts.push(rect(width: 18mm, height: 2pt, fill: palette.vanilla-custard))

  place(top + left, dx: 14mm, dy: 14mm)[
    #box(width: slide-width - 28mm)[
      #stack(dir: ttb, spacing: 3mm, ..header-parts)
    ]
  ]

  place(top + left, dx: 14mm, dy: 50mm)[
    #box(width: slide-width - 28mm, height: slide-height - 66mm)[
      #set text(size: 16pt, fill: palette.iron-grey)
      #set list(indent: 2mm, marker: [•])
      #set enum(indent: 2mm)
      #body
    ]
  ]

  footer(section: section)
  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Section divider slide
// ------------------------------------------------------------
#let section-slide(
  number: none,
  title: "",
  subtitle: "",
) = {
  slide-count.step()

  place(top + left, dx: 0mm, dy: 0mm)[
    #rect(width: slide-width, height: slide-height, fill: palette.gunmetal)
  ]
  place(bottom + left, dx: 0mm, dy: 0mm)[
    #rect(width: slide-width, height: 4mm, fill: palette.vanilla-custard)
  ]

  if number != none {
    place(top + left, dx: 16mm, dy: 8mm)[
      #text(size: 90pt, weight: "bold", fill: palette.charcoal)[#number]
    ]
  }

  place(left + horizon, dx: 32mm, dy: -4mm)[
    #box(width: 260mm)[
      #text(size: 38pt, weight: "bold", fill: palette.beige)[#title]
      #if subtitle != "" {
        v(6mm)
        line(length: 20mm, stroke: 2pt + palette.vanilla-custard)
        v(6mm)
        text(size: 16pt, fill: palette.vanilla-custard)[#subtitle]
      }
    ]
  ]

  place(bottom + right, dx: -14mm, dy: -10mm)[
    #text(size: 10pt, fill: palette.beige)[
      #context slide-count.display()
    ]
  ]

  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Two-column slide: header + two content columns
// ------------------------------------------------------------
#let two-column-slide(
  title: "",
  section: none,
  left-content: [],
  right-content: [],
) = {
  slide-count.step()

  let header-parts = ()
  if section != none {
    header-parts.push(text(size: 11pt, fill: palette.charcoal, tracking: 0.15em)[#upper(section)])
  }
  header-parts.push(text(size: 26pt, weight: "bold", fill: palette.gunmetal)[#title])
  header-parts.push(rect(width: 18mm, height: 2pt, fill: palette.vanilla-custard))

  place(top + left, dx: 14mm, dy: 14mm)[
    #box(width: slide-width - 28mm)[
      #stack(dir: ttb, spacing: 3mm, ..header-parts)
    ]
  ]

  let col-height = slide-height - 66mm

  place(top + left, dx: 14mm, dy: 50mm)[
    #box(width: slide-width - 28mm, height: col-height)[
      #grid(
        columns: (1fr, 0.4mm, 1fr),
        column-gutter: 8mm,
        align: (left + top, center + top, left + top),
        [
          #set text(size: 16pt, fill: palette.iron-grey)
          #set list(indent: 2mm, marker: [•])
          #set enum(indent: 2mm)
          #left-content
        ],
        rect(width: 0.4mm, height: col-height, fill: palette.charcoal.lighten(65%)),
        [
          #set text(size: 16pt, fill: palette.iron-grey)
          #set list(indent: 2mm, marker: [•])
          #set enum(indent: 2mm)
          #right-content
        ],
      )
    ]
  ]

  footer(section: section)
  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Image + text slide: full-height media column + text column
// pass `picture: image("your-file.jpg", width: 130mm, height: slide-height, fit: "cover")`
// leave unset to keep the placeholder frame
// ------------------------------------------------------------
#let image-slide(
  title: "",
  section: none,
  picture: none,
  position: "right", // "left" or "right" — which side the media sits on
  media-width: 130mm,
  body,
) = {
  slide-count.step()
  let media-dx = if position == "left" { 0mm } else { slide-width - media-width }
  let stripe-dx = if position == "left" { media-width } else { slide-width - media-width - 3mm }
  let text-dx = if position == "left" { media-width + 3mm + 14mm } else { 14mm }
  let text-width = slide-width - media-width - 3mm - 28mm

  // media column
  place(top + left, dx: media-dx, dy: 0mm)[
    #box(width: media-width, height: slide-height, fill: palette.gunmetal, clip: true)[
      #align(center + horizon)[
        #if picture != none {
          picture
        } else {
          box(
            width: media-width - 24mm, height: slide-height - 24mm,
            stroke: (paint: palette.vanilla-custard, thickness: 1pt, dash: "dashed"),
          )[
            #align(center + horizon)[
              #text(size: 11pt, fill: palette.vanilla-custard, tracking: 0.15em)[IMAGE]
            ]
          ]
        }
      ]
    ]
  ]
  // accent stripe between media and text
  place(top + left, dx: stripe-dx, dy: 0mm)[
    #rect(width: 3mm, height: slide-height, fill: palette.vanilla-custard)
  ]

  let header-parts = ()
  if section != none {
    header-parts.push(text(size: 11pt, fill: palette.charcoal, tracking: 0.15em)[#upper(section)])
  }
  header-parts.push(text(size: 24pt, weight: "bold", fill: palette.gunmetal)[#title])
  header-parts.push(rect(width: 16mm, height: 2pt, fill: palette.vanilla-custard))

  place(top + left, dx: text-dx, dy: 14mm)[
    #box(width: text-width)[
      #stack(dir: ttb, spacing: 3mm, ..header-parts)
    ]
  ]

  place(top + left, dx: text-dx, dy: 50mm)[
    #box(width: text-width, height: slide-height - 66mm)[
      #set text(size: 15pt, fill: palette.iron-grey)
      #set list(indent: 2mm, marker: [•])
      #set enum(indent: 2mm)
      #body
    ]
  ]

  // footer confined to the text column so the page number never lands
  // on top of the (potentially dark) media column
  place(bottom + left, dx: text-dx, dy: -9mm)[
    #rect(width: text-width, height: 1.2pt, fill: palette.charcoal.lighten(60%))
  ]
  place(bottom + left, dx: text-dx, dy: -6.5mm)[
    #box(width: text-width)[
      #align(right)[
        #text(size: 10pt, fill: palette.charcoal)[
          #context slide-count.display()
        ]
      ]
    ]
  ]
  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Activity slide: distinct full-bleed treatment for exercises,
// simulations, and discussion prompts — a visual cue that it's
// the students' turn to act, not just listen.
// ------------------------------------------------------------
#let activity-slide(
  kind: "Actividad",
  title: "",
  duration: none,
  body,
) = {
  slide-count.step()

  place(top + left, dx: 0mm, dy: 0mm)[
    #rect(width: slide-width, height: slide-height, fill: palette.vanilla-custard)
  ]

  place(top + left, dx: 14mm, dy: 14mm)[
    #box(fill: palette.gunmetal, inset: (x: 4mm, y: 2mm), radius: 2mm)[
      #text(size: 11pt, fill: palette.beige, tracking: 0.15em, weight: "bold")[#upper(kind)]
    ]
  ]

  if duration != none {
    place(top + right, dx: -14mm, dy: 14mm)[
      #box(stroke: 1pt + palette.gunmetal, inset: (x: 4mm, y: 2mm), radius: 2mm)[
        #text(size: 11pt, fill: palette.gunmetal, weight: "bold")[#duration]
      ]
    ]
  }

  place(top + left, dx: 14mm, dy: 32mm)[
    #box(width: slide-width - 28mm)[
      #text(size: 30pt, weight: "bold", fill: palette.gunmetal)[#title]
    ]
  ]

  place(top + left, dx: 14mm, dy: 58mm)[
    #box(width: slide-width - 28mm, height: slide-height - 74mm)[
      #set text(size: 16pt, fill: palette.gunmetal)
      #set list(indent: 2mm, marker: [→])
      #set enum(indent: 2mm)
      #body
    ]
  ]

  place(bottom + right, dx: -14mm, dy: -10mm)[
    #text(size: 10pt, fill: palette.gunmetal)[
      #context slide-count.display()
    ]
  ]

  pagebreak(weak: true)
}

// ------------------------------------------------------------
// Statement slide: full-bleed pull-quote for anchoring a single
// idea (a metaphor punchline, a key takeaway) so it sticks.
// ------------------------------------------------------------
#let statement-slide(
  statement: "",
  attribution: none,
) = {
  slide-count.step()

  place(top + left, dx: 0mm, dy: 0mm)[
    #rect(width: slide-width, height: slide-height, fill: palette.gunmetal)
  ]
  place(top + left, dx: 0mm, dy: 0mm)[
    #rect(width: 4mm, height: slide-height, fill: palette.vanilla-custard)
  ]

  place(left + horizon, dx: 32mm, dy: -6mm)[
    #box(width: slide-width - 64mm)[
      #text(size: 34pt, weight: "bold", fill: palette.beige)[#statement]
      #if attribution != none {
        v(8mm)
        text(size: 14pt, fill: palette.vanilla-custard)[— #attribution]
      }
    ]
  ]

  place(bottom + right, dx: -14mm, dy: -10mm)[
    #text(size: 10pt, fill: palette.beige)[
      #context slide-count.display()
    ]
  ]

  pagebreak(weak: true)
}
