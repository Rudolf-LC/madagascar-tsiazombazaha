// main.typ — assemblage du mémoire.
// Compilation : typst compile main.typ memoire.pdf

// Imports

#import "@preview/glossarium:0.5.10": make-glossary, register-glossary, print-glossary, gls, glspl
#show: make-glossary

// ---------- Police ----------
// Accessibilité + rigueur académique : Source Serif 4 (Adobe, SIL OFL) — serif de
// corps à grande hauteur d'x (plus lisible en petit corps que Times/Liberation),
// dessin moderne, chiffres alignés. Installation : paquet "Source Serif 4"
// (Google Fonts) ou fonts-sourceserifpro.
// Alternatives : "Atkinson Hyperlegible" (Braille Institute, basse vision, sans-serif),
// "Lexend" (lecture fluide, sans-serif), "Liberation Serif" (métrique Times).
#set text(font: "Source Serif 4", size: 11pt, lang: "fr", region: "FR")

// ---------- Corps de texte : justifié, avec césures ----------
#set par(justify: true, leading: 1.3em)
#set text(hyphenate: true)

// ---------- Titres : 11 pt, numérotation 1.1.1 (critère 122, quatre niveaux max, critère 123) ----------
#set heading(numbering: "1.1")
#show heading: set text(size: 11pt)
#show heading: set block(above: 1.6em, below: 1.1em)
#show heading.where(level: 1): it => { // Chaque titre de niveau 1 commence sur une nouvelle page.
  pagebreak(weak: true) 
  it
}

// ---------- Pagination : recto/verso, numéro côté extérieur, en-tête + filet ----------
#set page(
  paper: "a4",
  binding: left,
  margin: (inside: 2cm, outside: 2cm, top: 3cm, bottom: 2cm),
  header: context {
    let debut = query(<debut-corps>).first().location().page()
    if here().page() >= debut {
      let pg = counter(page).get().first()
      let gauche = [Étude sociale et écologique de Tsiazombazaha]
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

// ---------- Figures et tableaux ----------
// Titre des tableaux au-dessus, titre des figures en dessous (défaut).
#show figure.where(kind: table): set figure.caption(position: top)
// Titres (captions) justifiés — 11 pt minimum (accessibilité).
#show figure.caption: set par(justify: true)
#show figure.caption: set text(size: 11pt)
// Tableaux : texte justifié, centrage vertical ; en-têtes en gras.
#show table.cell: set par(justify: true)
#show table.cell: set align(horizon)
#show table.cell.where(y: 0): set text(weight: "bold")
// Colonnes numériques : à centrer horizontalement — réglé tableau par tableau
// dans les fichiers (align: ..., center pour les colonnes de chiffres).

// ---------- Pièces liminaires : titres non numérotés (Tableau 1 du guide) ----------
#set heading(numbering: none, outlined: false)
#include "Couverture.typ"
#include "PageDeTitre.typ"
#include "Dedicace.typ"
#include "Remerciements.typ"
#include "Resume.typ"

#outline(title: [Table des matières], depth: 4)

// ---------- Corps du texte : numérotation à partir de l'introduction ----------
#set heading(numbering: "1.1", outlined: true)
#include "Introduction.typ"
#include "Problematique.typ"
#include "MaterielMethodes.typ"
#include "ResultatsEcologie.typ"
#include "Discussion.typ"
#include "Conclusion.typ"
#include "ApresPropos.typ"
#include "References.typ"
#include "Listes.typ"
#include "Annexes.typ"
