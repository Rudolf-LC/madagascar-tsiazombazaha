#show figure.where(kind: "annexe"): set figure.caption(position: top)
#set figure(numbering: "1")
#show figure.where(kind: "annexe"): set block(breakable: true)

// Formatage des valeurs importées des CSV (autorisé par l'auteur le 01/11/2026) :
// arrondi à `decimales`, virgule décimale, signe moins typographique ; les textes et « NA » sont rendus tels quels.
#let nombre(x, decimales: 2) = {
  if x.match(regex("^-?[0-9]+(\.[0-9]+)?([eE]-?[0-9]+)?$")) == none { return x }
  let v = calc.round(float(x), digits: decimales)
  let parties = str(calc.abs(v)).split(".")
  let dec = if parties.len() > 1 { parties.at(1) } else { "" }
  while dec.len() < decimales { dec += "0" }
  let signe = if v < 0 { "−" } else { "" }
  if decimales == 0 { signe + parties.at(0) } else { signe + parties.at(0) + "," + dec }
}

// Grands tableaux : import csv() depuis analyse-tables/ (copies des sorties R, 01/11/2026) ; petits tableaux : saisie manuelle.
#let placettesN = csv("analyse-tables/structure_N_placettes.csv").slice(1)
#let placettesG = csv("analyse-tables/structure_G_placettes.csv").slice(1)
#let placettesAlpha = csv("analyse-tables/diversite_alpha_placettes.csv").slice(1)
#let classesN = csv("analyse-tables/structure_classes_ic95.csv").slice(1)
#let classesG = csv("analyse-tables/structure_G_classes.csv").slice(1)
#let pointsNMDS = csv("analyse-tables/diversite_beta_nmds_points.csv").slice(1)
#let ivi = csv("analyse-tables/ivi_especes.csv").slice(1)
#let rarefaction = csv("analyse-tables/courbe_raréfaction_extrapolation.csv").slice(1)
#let methodes = (Rarefaction: "Interpolation", Observed: "Observé", Extrapolation: "Extrapolation")

= Annexes

// Structure proposée le 01/11/2026 : une entrée par annexe, dans l'ordre de premier renvoi dans le texte (M&M puis Résultats).
// Les renvois du texte sont pour l'instant écrits « (ANNEXE : …) » en clair : Resultats.typ et MaterielMethodes.typ compilent seuls et ne voient pas ces étiquettes. Les remplacer par @annexe-… une fois les fichiers réunis dans main.typ.
// Tableaux tirés des CSV : saisie manuelle arrondie à deux décimales, ou import csv() — l'import brut affiche les décimales à point et non arrondies ; à arbitrer (pas de fonction personnalisée).

#figure(
  [
    // TODO : Carte d'intervention du projet (Inter Aide). Source et droits de reproduction à vérifier. Renvoi : Introduction ou M&M, Site d'étude.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Zone d'intervention du projet EcoBois],
) <annexe-carte-ecobois>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Code, date, fokontany, motif et présence d'une trace GPS des 21 sorties (metadonnees_enquete-de-terrain_2_sorties.csv), sans élément nominatif. Renvoi : M&M, Méthodologie du volet social et Dispositif d'échantillonnage (dates des journées de relevés).
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste des sorties de terrain],
) <annexe-sorties>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Genre, classe d'âge, lien au VOI et fokontany des personnes rencontrées, sans élément identifiant (TODO déjà noté en M&M, Collecte des données). Renvoi : M&M, Méthodologie du volet social.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Description de l'échantillon des entretiens],
) <annexe-echantillon-social>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Canevas mis au propre et numéroté (guide, critère 35). Renvoi : M&M, Collecte des données.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Canevas d'entretien],
) <annexe-canevas>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Résumé du protocole effectivement appliqué (seuils, variables, classes), liste du matériel et fiche de relevé vierge. Renvoi : M&M, Dispositif d'échantillonnage et Relevés par placette.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Protocole de relevé et matériel],
) <annexe-protocole>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Tableau des fichiers CSV (actuellement en M&M, Saisie des données, avec un TODO « annexe ? ») et accès aux données brutes (guide, critère 79). Renvoi : M&M, Saisie des données.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Fichiers de données et clés de correspondance],
) <annexe-fichiers-donnees>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Correspondance entre libellés français et codes de premier et de second niveau de Cook (1995). Renvoi : M&M, Identification des espèces et des usages ; Résultats, Listes d'espèces et usages.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Codes des catégories d'usage],
) <annexe-codes-cook>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Par espèce réconciliée : nom vernaculaire, rattachement botanique, nombre de types, usages (codes Cook), source de chaque mention (placettes, hors placettes, Romiguière, transfert 2004). Liste définitive à régénérer avant saisie. Renvoi : Résultats, Listes d'espèces et usages.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste de la flore],
) <annexe-flore>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Par espèce : nom vernaculaire, rattachement taxonomique lorsqu'il existe, type d'observation (vue, indice) et source (cheminements, transfert 2004, GBIF, Rajaonson et al., 2010). Renvoi : Résultats, Listes d'espèces et usages.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste de la faune],
) <annexe-faune>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Types de traces d'activités humaines rencontrés et observations phénologiques (phenologie.csv), à titre indicatif. Renvoi : Résultats, Listes d'espèces et usages.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Observations complémentaires],
) <annexe-observations>

#pagebreak(weak: true)

#figure(
  [
    #table(
      columns: 6,
      align: (left, center, center, center, center, center),
      table.header([*Placette*], [*Surface (m²)*], [*Tiges mesurées*], [*Gaulis*], [*N (tiges/ha)*], [*G (m²/ha)*]),
      ..placettesN.zip(placettesG).map(((n, g)) => (n.at(0), nombre(n.at(1), decimales: 1), n.at(2), n.at(3), nombre(n.at(6), decimales: 0), nombre(g.at(4)))).flatten(),
    )
    #table(
      columns: 6,
      align: (left, center, center, center, center, center),
      table.header([*Placette*], [*S*], [*H′*], [*¹D*], [*²D*], [*α de Fisher*]),
      ..placettesAlpha.map(r => (r.at(0), r.at(1), nombre(r.at(2)), nombre(r.at(3)), nombre(r.at(4)), nombre(r.at(6)))).flatten(),
    )
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Indices par placette. Surface horizontale ; N : densité (tiges mesurées et gaulis) ; G : surface terrière (tiges mesurées). Indices alpha calculés sur toutes les tiges comptées, tiges indéterminées exclues ; ¹D et ²D sous leur forme brute. Sources : structure_N_placettes.csv, structure_G_placettes.csv, diversite_alpha_placettes.csv.],
) <annexe-indices-placettes>

#pagebreak(weak: true)

#figure(
  [
    #table(
      columns: 3,
      align: (left, center, center),
      table.header([*Classe de diamètre (cm)*], [*Densité (tiges/ha)*], [*IC 95 %*]),
      ..classesN.map(r => (nombre(r.at(0), decimales: 1) + " – " + nombre(str(float(r.at(0)) + 2.5), decimales: 1), nombre(r.at(1), decimales: 0), "[" + nombre(r.at(2), decimales: 0) + " ; " + nombre(r.at(3), decimales: 0) + "]")).flatten(),
    )
    #table(
      columns: 3,
      align: (left, center, center),
      table.header([*Classe de diamètre (cm)*], [*G (m²/ha)*], [*IC 95 %*]),
      ..classesG.map(r => (nombre(r.at(4), decimales: 1) + " – " + nombre(r.at(5), decimales: 1), nombre(r.at(1)), "[" + nombre(r.at(2)) + " ; " + nombre(r.at(3)) + "]")).flatten(),
    )
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Densité et surface terrière par classe de diamètre : moyenne entre 28 placettes et IC 95 % par la loi de Student (bornes inférieures négatives non tronquées, contrairement aux figures). La classe 0 – 2,5 cm inclut les gaulis ; les classes sans tige sont absentes. Sources : structure_classes_ic95.csv, structure_G_classes.csv.],
) <annexe-classes-diametre>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Volume, biomasse, carbone et CO₂ par compartiment avec IC 95 %, et stocks extrapolés à la forêt une fois la surface QGIS connue (carbone_stocks.csv). Renvoi : Résultats, Stock de carbone.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Détail des stocks de carbone],
) <annexe-carbone>

#pagebreak(weak: true)

#figure(
  table(
    columns: 5,
    align: (left, center, center, left, left),
    table.header([*Placette*], [*NMDS1*], [*NMDS2*], [*Itinéraire*], [*Commune*]),
    ..pointsNMDS.map(r => (r.at(0), nombre(r.at(1)), nombre(r.at(2)), r.at(3), r.at(5))).flatten(),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Coordonnées des 28 placettes dans l'ordination NMDS (dissimilarité de Bray-Curtis, deux dimensions, stress = 0,23), avec leur itinéraire et leur commune. Source : diversite_beta_nmds_points.csv.],
) <annexe-beta>
// ATTENTION : colonne polisin'ala retirée — le CSV contient des noms réels (Morafeno, Célestin, Claude JEAN, Séraphin) à côté de codes ENQ. Si la colonne est utile, la remplacer par des codes anonymes (polisin'ala A, B…) dans une copie du CSV pour le rapport.

#pagebreak(weak: true)

#figure(
  table(
    columns: 8,
    align: (center, left, center, center, center, center, center, center),
    table.header([*Rang*], [*Espèce*], [*Tiges*], [*Placettes*], [*DR (%)*], [*DoR (%)*], [*FR (%)*], [*IVI*]),
    ..ivi.map(r => (r.at(0), r.at(1), r.at(2), r.at(3), nombre(r.at(5)), nombre(r.at(6)), nombre(r.at(7)), nombre(r.at(8)))).flatten(),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Indice de valeur d'importance (IVI) des 124 espèces (28 placettes ; 479 tiges mesurées, gaulis et tiges indéterminées exclus). DR : densité relative ; DoR : dominance relative ; FR : fréquence relative ; IVI = (DR + DoR + FR) / 3, sur 100. Espèces : identités réconciliées. Source : ivi_especes.csv.],
) <annexe-ivi>

#pagebreak(weak: true)

#figure(
  table(
    columns: 6,
    align: (center, left, center, center, center, center),
    table.header([*Placettes*], [*Méthode*], [*Surface (m²)*], [*Richesse (espèces)*], [*IC 95 %*], [*Couverture*]),
    ..rarefaction.map(r => (r.at(1), methodes.at(r.at(2)), nombre(r.at(10), decimales: 1), nombre(r.at(4)), "[" + nombre(r.at(5)) + " ; " + nombre(r.at(6)) + "]", nombre(r.at(7)))).flatten(),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Courbe de raréfaction-extrapolation de la richesse spécifique (modèle d'incidence, ordre q = 0) : richesse et couverture d'échantillonnage selon le nombre de placettes et la surface horizontale cumulée ; IC 95 % par bootstrap. Les estimateurs asymptotiques figurent dans le corps du texte. Source : courbe_raréfaction_extrapolation.csv.],
) <annexe-richesse>

#pagebreak(weak: true)

#figure(
  [
    // TODO : Description des fichiers déposés avec le mémoire (données écologiques, scripts R, transcriptions anonymisées des entretiens) et de leurs conditions d'accès. Renvoi : M&M, Saisie des données et Méthodologie du volet social.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Métadonnées des fichiers complémentaires],
) <annexe-metadonnees>

#pagebreak(weak: true)

// Liste initiale de l'auteur (conservée pour mémoire) :
// - Carte d'intervention du projet EcoBois (?)
// - Canevas d'entretien
// - Liste des enquetes / sorties
// - Protocole des relevés de terrain (si besoin) / Matériel utilisé
// - Feuille de relevé
// - Liste des plantes établie (nom vernaculaire) avec IVI
// - Autres espèces de plantes observées/mentionnées en dehors des placettes
// - Liste des animaux
// - Table des logiciels et programmes utilisés
// - Métadonnées des fichiers complémentaires du rapport (données écologiques, transcription des entretiens)
// Non repris : « Table des logiciels » (versions déjà données en M&M, Conventions) ; « Autres espèces hors placettes » fusionné dans la liste de la flore (colonne source).
