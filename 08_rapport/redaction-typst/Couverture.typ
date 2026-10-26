// Page de couverture

#page(margin: (x: 2cm, top: 1.5cm, bottom: 2cm))[

  #grid(
    columns: (1fr, 1fr),
    align: (left + horizon, right + horizon),
    image("/images/logo-agroparistech.png", height: 2.2cm),
    image("/images/logo-inter-aide.png", height: 2.2cm),
  )

  #v(1fr)

  #align(center)[
    #text(size: 14pt)[Mémoire de fin d'études]

    #text(size: 12pt)[présenté pour l'obtention du diplôme d'ingénieur AgroParisTech \ et du diplôme d'établissement Sciences et ingénierie forestières]

    #v(1.5cm)
//
  #text(size: 12pt)[Diagnostic écologique et sociale de la forêt tropicale humide de Tsiazombazaha, sud-est de Madagascar]

    #v(1.5cm)

    // #image("/08_rapport/Images/TODO.jpg", width: 70%)

    #text(size: 14pt)[Ewen LE COEUR]
  ]

  #v(1fr)

d  #align(center)[
    Soutenu le 17 novembre 2026 à Montpellier

    #v(0.5em)

    devant le jury composé de

    #v(0.5em)

    #grid(
      columns: 2,
      column-gutter: 1em,
      row-gutter: 0.9em,
      align: (right, left),
      [Rapporteur·e externe], […], // TODO : titre, prénom, nom, fonction
      [Tutrice de stage], [Mme. Léna Aguilhon, cheffe de secteur agriculture et agroforesterie du Malawi, Madagascar et Éthiopie, Inter Aide.],
      [Enseignant référent], [M. le professeur Alexandre Gaudin, enseignant-chercheur en socio-anthropologie de l'environnement, UFR G-ENV, AgroParisTech.],
    )
  ]
]

#counter(page).update(1)

// Verso de la couverture

#pagebreak(weak: true)

#place(top + right)[
    // Si une photo est ajoutée, ses sources vont au verso de la couverture
]

// Notice d'accessibilité

#pagebreak(weak: true)

#place(bottom + right)[
  Ce document a été composé pour faciliter sa lecture : corps de texte en Source Serif 4 de 11 points, interligne élargi, césures automatiques, textes alternatifs pour les figures et langue déclarée pour les lecteurs d'écran. Les figures sont décrites en légende ; leurs données exactes figurent en annexe. Le document reste lisible en impression noir et blanc.

  \
  Le document est prévu pour être lu en format livre imprimé, deux pages côte à côte. Si vous le lisez sous format numérique, l'auteur vous encourage à adapter les paramètres de votre lecteur PDF pour suivre cette disposition afin d'améliorer votre confort de lecture.
]

// Licence

#pagebreak(weak: true)

#place(bottom + right)[
  // #image("/08_rapport/Images/TODO.jpg", width: 70%) // LICENCE CCO
  Ce document et les données écologiques récoltées sont sous licence Creative Commons Zero v1.0 Universal (https://creativecommons.org/publicdomain/zero/1.0/). Les données, les scripts, les photographies et le code source du mémoire sont disponibles en libre accès sur le dépôt GitHub suivant : https://github.com/Rudolf-LC/madagascar-tsiazombazaha/

  \
  Conformément au réglement général sur la protection des données, les transcriptions des entretiens n'ont pas été déposées sur ce dépôt. Pour les obtenir, veuillez contacter directement l'auteur à l'adresse suivante : ewenlc\@proton.me
]