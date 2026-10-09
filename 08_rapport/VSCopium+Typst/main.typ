// main.typ — assemblage du mémoire.
// Compilation : typst compile --root ../.. main.typ memoire.pdf
// (la racine du dépôt est la racine Typst, à cause des figures dans 06_ecologie/).

// ---------- Police ----------
// Accessibilité + rigueur académique : Source Serif 4 (Adobe, SIL OFL) — serif de
// corps à grande hauteur d'x (plus lisible en petit corps que Times/Liberation),
// dessin moderne, chiffres alignés. Installation : paquet "Source Serif 4"
// (Google Fonts) ou fonts-sourceserifpro.
// Alternatives : "Atkinson Hyperlegible" (Braille Institute, basse vision, sans-serif),
// "Lexend" (lecture fluide, sans-serif), "Liberation Serif" (métrique Times).
#set text(font: "Source Serif 4", size: 12pt, lang: "fr", region: "FR")

// ---------- Corps de texte : justifié, avec césures ----------
// Interligne élargi (1,3 em) pour la lisibilité ; césures automatiques pour
// éviter les « rivières » d'espaces créées par la justification.
#set par(justify: true, leading: 1.3em)
#set text(hyphenate: true)

// ---------- Titres : 11 pt, numérotation 1.1 ----------
#set heading(numbering: "1.1")
#show heading: set text(size: 11pt)
#show heading: set block(above: 1.6em, below: 1.1em)

// ---------- Pagination : « - page / total - » en bas à droite ----------
// Typst ne connaît pas le total de pages nativement. Méthode des docs Typst
// (guide « State ») : le numbering lit le state, et un update final (via
// `locate` + `final`, exécuté à la fin de la compilation) fixe le total.
#let nb-pages = state("nb-pages", 1)
#set page(paper: "a4", margin: 2.5cm, number-align: right, numbering: (..nums) => {
  "- " + str(nums.pos().first()) + " / " + str(nb-pages.get()) + " -"
})
// En fin de document, on fixe le total au numéro de la dernière page.
// `context` + `counter(page).final()` sont résolus après la passe complète :
// tous les pieds de page affichent alors le même total.
#context nb-pages.update(counter(page).final().first())

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

// ---------- Assemblage ----------
// Ordre final visé : page de titre, note d'accessibilité, remerciements, résumés,
// table des matières, corps (Introduction -> ... -> Conclusion), références, annexes.
#include "PrefaceAccessibilite.typ"
#include "Introduction.typ"
#include "MaterielMethodesEcologie.typ"
#include "ResultatsEcologie.typ"
#include "References.typ"
