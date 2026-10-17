// Page de couverture — liminaire (guide GEEFT, § 2.2, critère 88).
// Pas de titre « = » : la couverture ne doit ni être numérotée comme section
// ni apparaître dans la table des matières.
// Pas de numéro de page sur la couverture (critère 85) ; la numérotation
// reprend à 1 sur la page suivante (dernière ligne du fichier).

#page(numbering: none, margin: (x: 2cm, top: 1.5cm, bottom: 2cm))[

  // ---------- Logos ----------
  // AgroParisTech en haut à gauche, organisme d'accueil en haut à droite (critère 88).
  // Chemins depuis la racine du dépôt (compilation avec --root ../..).
  // TODO : remplacer par les noms réels des fichiers de 08_rapport/Images/.
  // TODO : logo AgroParisTech officiel GEEFT = lien de la note 11 du guide.
  #grid(
    columns: (1fr, 1fr),
    align: (left + horizon, right + horizon),
    image("/images/logo-agroparistech.png", height: 2.2cm),
    image("/images/logo-inter-aide.png", height: 2.2cm),
  )

  #v(1fr)

  #align(center)[
    #text(size: 14pt)[Mémoire de fin d'études]

    #text(size: 12pt)[présenté pour l'obtention des titres d'Ingénieur AgroParisTech et d'Ingénieur forestier]

    #v(1.5cm)

    // ---------- Titre du mémoire ----------
    #text(size: 18pt, weight: "bold")[Conserver les forêts pour le bénéfice des populations rurales pauvres du Sud-Est de Madagascar : cas d'étude sociale et écologique de la forêt de Tsiazombazaha]
    // Conserver les forêts pour réduire la pauvreté dans le Sud-Est de Madagascar : cas d'étude sociale et écologique de la forêt de Tsiazombazaha

    #v(1.5cm)

    // ---------- Illustration (facultative, critère 88) ----------
    // Si une photo est ajoutée, ses sources vont au verso de la couverture (Tableau 1 du guide).
    // #image("/08_rapport/Images/TODO.jpg", width: 70%)

    // ---------- Auteur : format « Prénom NOM » (critère 88) ----------
    #text(size: 14pt)[Ewen LE COEUR]
  ]

  #v(1fr)

  // ---------- Soutenance et jury ----------
  #align(center)[
    Soutenu le 17 novembre 2026 à Montpellier

    #v(0.5em)

    devant le jury composé de

    #v(0.5em)

    // Pour chaque membre : titre (Dr, Pr), prénom, nom, fonction (critère 88).
    #grid(
      columns: 2,
      column-gutter: 1em,
      row-gutter: 0.9em,
      align: (right, left),
      [Rapporteur·e externe], […], // TODO : titre, prénom, nom, fonction,
      [Tutrice de stage], [Mme. Léna Aguilhon, cheffe de secteur agriculture et agroforesterie du Malawi, Madagascar et Éthiopie, Inter Aide.],
      [Enseignant référent], [M. le professeur Alexandre Gaudin, enseignant-chercheur en socio-anthropologie de l'environnement, UFR G-ENV, AgroParisTech.],
    )
  ]
]

// La pagination démarre après la couverture (critère 85).
#counter(page).update(1)