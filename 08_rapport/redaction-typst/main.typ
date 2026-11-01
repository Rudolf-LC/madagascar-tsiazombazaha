// main.typ — assemblage du mémoire.
// Pour compiler dans la console : typst compile main.typ memoire.pdf

// Imports

// Police
#set text(font: "Source Serif 4", size: 11pt, lang: "fr", region: "FR")

// Corps de texte
#set par(justify: true, leading: 1em, first-line-indent: 1.5em)
#set text(hyphenate: true)

// Titres
#set heading(numbering: "1.1")
#show heading: set text(size: 11pt)
#show heading: set block(above: 1.6em, below: 1.1em)
#show heading.where(level: 1): it => { 
  pagebreak(weak: true) 
  it
} // Chaque titre de niveau 1 commence sur une nouvelle page.

// Pagination
#set page(
  paper: "a4",
  binding: left,
  margin: (inside: 2cm, outside: 2cm, top: 3cm, bottom: 2cm),
  header: context {
    let debut = query(<debut-corps>).first().location().page()
    if here().page() >= debut {
      let pg = counter(page).get().first()
      let gauche = [Caractérisation écologique et sociale de Tsiazombazaha]
      let num = counter(page).display("1")
      set text(size: 10pt)
      if calc.odd(pg) {
        grid(
          columns: (1fr, auto),
          align(left, gauche), align(right, num),
        )
      } else {
        grid(
          columns: (auto, 1fr),
          align(left, num), align(right, gauche),
        )
      }
      v(-0.5em)
      line(length: 100%, stroke: 1pt)
    }
  }
)
#set footnote.entry(separator: line(length: 30%, stroke: 0.5pt))

// Figures et tableaux
#show figure.where(kind: table): set figure.caption(position: top)
#show figure.caption: set par(justify: true)
#show figure.caption: set text(size: 11pt)
#show table.cell: set par(justify: true)
#show table.cell: set align(horizon)
#show table.cell.where(y: 0): set text(weight: "bold")

// Pièces liminaires
// #set heading(numbering: none, outlined: false)
// #include "Couverture.typ"
// #include "PageDeTitre.typ"
// #include "Dedicace.typ"
// #include "Remerciements.typ"
// #include "Resume.typ"
// #outline(title: [Table des matières], depth: 4)

// Corps du texte
#set heading(numbering: "1.1", outlined: true)
// #include "Introduction.typ"
// #include "Problematique.typ"
#include "MaterielMethodes.typ"
#include "Resultats.typ"
// #include "ResultatsSocio.typ"
// #include "Discussion.typ"
// #include "Conclusion.typ"
// #include "ApresPropos.typ"
// #include "References.typ"
// #include "Listes.typ"
// #include "Annexes.typ"
