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
  table(
    columns: 5,
    align: (center, center, center, left, center),
    table.header([*Code*], [*Date*], [*Fokontany*], [*Motif*], [*Trace GPS*]),
    // Données depuis metadonnees_enquete-de-terrain_2_sorties.csv
    ("S1", "?", "Andriana", "Observation plantation tranobe IA", "Non"),
    ("S2", "16/06/26", "Manakana", "Chantier de plantation Manakana", "Non"),
    ("S3", "03/07/26", "Mizilo Gara", "Observation de Tsiazombazaha de loin et entretiens", "Non"),
    ("S4", "24/07/26", "Manakana", "Prospection des sources", "Oui"),
    ("S5", "06/08/26", "Mizilo Gara", "Tracé de la route de FIANTSO", "Oui"),
    ("S6", "07/08/26", "Mizilo Gara", "Observation de la flore agricole", "Non"),
    ("S7", "17/08/26", "Manakana", "Observation de la flore agricole", "Non"),
    ("S8", "18/08/26", "Manakana", "Une placette", "Oui"),
    ("S9", "19/08/26", "Manakana", "Chemin Manakana – Andriana", "Oui"),
    ("S10", "20/08/26", "Manakana", "Une placette", "Oui"),
    ("S11", "25/08/26", "Manakana", "Deux placettes", "Oui"),
    ("S12", "26/08/26", "Manakana", "Chemin Manakana – Ambila", "Oui"),
    ("S13", "27/08/26", "Manakana", "Quatre placettes", "Oui"),
    ("S14", "02/09/26", "Mizilo Gara", "Quatre placettes", "Oui"),
    ("S15", "03/09/26", "Mizilo Gara", "Assemblée générale du VOI", "Non"),
    ("S16", "04/09/26", "Mizilo Gara", "Une placette, une piscine naturelle, échanges", "Oui"),
    ("S17", "08/09/26", "Manakana", "Tournée Sarah – reboisement tranobe en natif", "Non"),
    ("S18", "09/09/26", "Andriana", "Tournée Sarah – reboisement VOI", "Non"),
    ("S19", "11/09/26", "Mizilo Gara", "Quatre placettes", "Oui"),
    ("S20", "15/09/26", "Andriana", "Quatre placettes", "Oui"),
    ("S21", "16/09/26", "Andriana", "Quatre placettes", "Oui"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste des 21 sorties de terrain. Source : métadonnées enquête de terrain, fichier metadonnees_enquete-de-terrain_2_sorties.csv, n = 21, date de collecte : 15/05–16/09/2026.],
) <annexe-sorties>

#pagebreak(weak: true)

#figure(
  table(
    columns: 6,
    align: (center, center, center, left, left, left),
    table.header([*Code*], [*Genre*], [*Âge*], [*Profession*], [*Lien au VOI*], [*Fokontany*]),
    // Données anonymisées depuis metadonnees_enquete-de-terrain_3_enquetes.csv
    ("ENQ01", "H", "?", "Responsable programme", "N/A", "Manakara"),
    ("ENQ02", "H", "30", "Coordinateur socio-environnemental", "N/A", "Manakana"),
    ("ENQ03", "H", "65", "Agriculteur", "Vice-président", "Mizilo Gara"),
    ("ENQ04", "H", "57", "Agriculteur", "Polisn'ala", "Mizilo Gara"),
    ("ENQ05", "H", "?", "Président fokontany", "?", "Mizilo Gara"),
    ("ENQ06", "H", "?", "?", "Aucun", "Tsiazombazaha / Ampasipotsy"),
    ("ENQ07", "F", "?", "?", "Aucun", "Tsiazombazaha / Ampasipotsy"),
    ("ENQ08", "H", "36", "Agriculteur", "Aucun", "Mizilo Gara"),
    ("ENQ09", "H", "40", "Agriculteur", "Aucun", "Mizilo Gara"),
    ("ENQ10", "H", "62", "?", "Observateur", "Mizilo Gara"),
    ("ENQ11", "H", "?", "Agriculteur, maire", "Membre", "Mizilo Gara"),
    ("ENQ12", "H", "66", "Agriculteur", "Secrétaire", "Mizilo Gara"),
    ("ENQ13", "H", "35", "Instituteur", "Membre", "Mizilo Gara"),
    ("ENQ14", "F", "28", "Agricultrice, vannière", "Membre", "Mizilo Gara"),
    ("ENQ15", "H", "47", "Agriculteur", "Ancien membre", "Mizilo Gara"),
    ("ENQ16", "F", "37", "Agricultrice, vannière", "Ancienne membre", "Mizilo Gara"),
    ("ENQ17", "H", "?", "Président fokontany", "", "Andriana"),
    ("ENQ18", "H", "?", "Agriculteur, éleveur", "Président du VOI", "Andriana"),
    ("ENQ19", "H", "?", "Agriculteur", "Pépiniériste, polisn'ala", "Andriana"),
    ("ENQ20", "H", "?", "?", "Pépiniériste", "Andriana"),
    ("ENQ21", "F", "54", "Agent communautaire", "Membre", "Andriana"),
    ("ENQ22", "H", "26", "Agriculteur", "Polisn'ala", "Andriana"),
    ("ENQ23", "H", "?", "?", "Conseiller, polisn'ala", "Andriana"),
    ("ENQ24", "H", "?", "?", "Polisn'ala, comité feu", "Ampasipotsy"),
    ("ENQ25", "F", "?", "?", "Membre", "Ampasipotsy"),
    ("ENQ26", "H", "?", "Président fokontany", "Comité feu", "Ampasipotsy"),
    ("ENQ27", "H", "?", "?", "Vice-président", "Ambahatrazo"),
    ("ENQ28", "H", "?", "?", "Trésorier", "Manakana"),
    ("ENQ29", "H", "?", "Président fokontany", "Polisn'ala", "Manakana"),
    ("ENQ30", "H", "?", "Vice-président fokontany", "", "Manakana"),
    ("ENQ31", "H", "?", "?", "", "Manakana"),
    ("ENQ32", "H", "?", "?", "", "Manakana"),
    ("ENQ33", "H", "50", "Agriculteur", "Polisn'ala", "Manakana"),
    ("ENQ34", "F", "38", "Agent communautaire", "Aucun", "Ambalavolo"),
    ("ENQ35", "H", "25", "Agriculteur", "Aucun", "Ambalavolo"),
    ("ENQ36", "F", "21", "Agricultrice, commerçante", "Aucun", "Ambalavolo"),
    ("ENQ37", "H", "51", "Agriculteur, polisn'ala", "Polisn'ala", "Ambalavolo"),
    ("ENQ38", "H", "49", "Ampazaka, agriculteur", "Membre", "Amborodra"),
    ("ENQ39", "H", "65", "Agriculteur", "Ancien membre", "Amborodra"),
    ("ENQ40", "H", "55", "Agriculteur, président fokontany", "Membre", "Amborodra"),
    ("ENQ41", "H", "40", "Agriculteur, adjoint", "Membre", "Amborodra"),
    ("ENQ42", "H", "69", "Agriculteur", "Membre", "Amborodra"),
    ("ENQ43", "H", "?", "Agriculteur", "Polisn'ala", "Manakana"),
    ("ENQ44", "F", "?", "Technicienne", "Aucun", "Manakana"),
    ("ENQ45", "H", "43", "Agriculteur", "Membre", "Manakana"),
    ("ENQ46", "H", "35", "Agriculteur, mpanzaka", "Pépiniériste", "Manakana"),
    ("ENQ47", "F", "30", "Agricultrice", "Aucun / Membre", "Manakana"),
    ("ENQ48", "H", "47", "Agriculteur", "Membre", "Manakana"),
    ("ENQ49", "F", "38", "", "Membre", "Manakana"),
    ("ENQ50", "H", "?", "?", "Polisn'ala", "Andriana"),
    ("ENQ51", "H", "?", "?", "Membre", "Andriana"),
    ("ENQ52", "H", "?", "?", "Membre", "Andriana"),
    ("ENQ100", "H", "54", "Agriculteur, ampazaka", "Polisn'ala", "Mizilo Gara"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Description de l'échantillon des entretiens (n = 52). Genre : H = homme, F = femme ; Âge : en années (2026) ; Lien au VOI : polisn'ala = gardien de la forêt. Source : métadonnées enquête de terrain, fichier metadonnees_enquete-de-terrain_3_enquetes.csv, date de collecte : 15/05–16/09/2026. // TODO : valeurs d'âge à valider pour les cas manquants.],
) <annexe-echantillon-social>

#pagebreak(weak: true)

#figure(
  [
#lorem(150) // TODO : Insérer ici le canevas d'entretien mis au propre et numéroté. À fournir par l'auteur.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Canevas d'entretien. // TODO : Document à insérer. Renvoi : M&M, Collecte des données.],
) <annexe-canevas>

#pagebreak(weak: true)

#figure(
  [
#lorem(150) // TODO : Insérer ici le protocole de relevé (seuils, variables, classes), la liste du matériel et la fiche de relevé vierge.
  ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Protocole de relevé et matériel. // TODO : Documents à insérer. Renvoi : M&M, Dispositif d'échantillonnage et Relevés par placette.],
) <annexe-protocole>

#pagebreak(weak: true)

#figure(
  table(
    columns: 3,
    align: (left, left, left),
    table.header([*Fichier*], [*Description*], [*Format*]),
    ("structure_N_placettes.csv", "Densité par placette (28 placettes)", "CSV"),
    ("structure_G_placettes.csv", "Surface terrière par placette (28 placettes)", "CSV"),
    ("diversite_alpha_placettes.csv", "Indices alpha par placette (richesse, Shannon, Simpson, Fisher)", "CSV"),
    ("structure_classes_ic95.csv", "Densité par classe de diamètre avec IC 95 %", "CSV"),
    ("structure_G_classes.csv", "Surface terrière par classe de diamètre", "CSV"),
    ("diversite_beta_nmds_points.csv", "Coordonnées NMDS des placettes", "CSV"),
    ("ivi_especes.csv", "Indice de valeur d'importance par espèce", "CSV"),
    ("courbe_rarefaction_extrapolation.csv", "Courbe de raretéfaction-extrapolation", "CSV"),
    ("carbone_stocks.csv", "Stocks de carbone par compartiment", "CSV"),
    ("metadonnees_enquete-de-terrain_1_entretiens.csv", "Métadonnées des 52 entretiens", "CSV"),
    ("metadonnees_enquete-de-terrain_2_sorties.csv", "Métadonnées des 21 sorties de terrain", "CSV"),
    ("metadonnees_enquete-de-terrain_3_enquetes.csv", "Métadonnées des personnes enquêtées", "CSV"),
    ("correspondance-usages-cook.csv", "Correspondance usages locaux – classification Cook (1995)", "CSV"),
    ("liste-especes-usages-types.csv", "Liste des espèces avec usages et types", "CSV"),
    ("phenologie.csv", "Observations phénologiques", "CSV"),
    ("autres-observations-flore.csv", "Autres observations floristiques hors placettes", "CSV"),
    ("animaux-T1-T2.csv", "Observations faunistiques (transects T1–T2)", "CSV"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Fichiers de données et clés de correspondance. Tous les fichiers sont disponibles en annexe numérique. Source : données de terrain 2026 et référentiels projet. // REF? Critère 79 du guide GEEFT à vérifier.],
) <annexe-fichiers-donnees>

#pagebreak(weak: true)

#figure(
  table(
    columns: 4,
    align: (left, center, left, left),
    table.header([*Usage normalisé*], [*Cook N1*], [*Cook N1 (libellé)*], [*Cook N2 (libellé)*]),
    // Données depuis correspondance-usages-cook.csv
    ("anti_foudre", "800", "sociale_culturelle", "Religious Uses"),
    ("aucun", "", "", ""),
    ("balai", "600", "materiaux", "Wood"),
    ("batan", "600", "materiaux", "Wood"),
    ("bois_chauffage", "700", "combustible", "Fuelwood"),
    ("bois_construction", "600", "materiaux", "Wood"),
    ("canaux_irrigation", "600", "materiaux", "Wood"),
    ("construction_maison", "600", "materiaux", "Wood"),
    ("corde", "600", "materiaux", "Fibres"),
    ("douleurs_dentaires", "1100", "medicinale", "Pain"),
    ("ecorce_sucree", "100", "alimentaire", "Bark"),
    ("fatigue", "1100", "medicinale", "Ill-defined Symptoms"),
    ("fixation_toiture", "600", "materiaux", "Fibres"),
    ("fruit_comestible", "100", "alimentaire", "Infructescences"),
    ("gonflements", "1100", "medicinale", "Inflammation"),
    ("guitare", "600", "materiaux", "Wood"),
    ("haie", "1200", "environnementale", "Boundaries/Barriers/Supports"),
    ("insecticide", "1000", "poison", "Arthropoda"),
    ("magie", "800", "sociale_culturelle", "Religious Uses"),
    ("manche_beche", "600", "materiaux", "Wood"),
    ("medicinale", "1100", "medicinale", "Unspecified Medicinal Disorders"),
    ("menuiserie", "600", "materiaux", "Wood"),
    ("panier", "600", "materiaux", "Cane etc."),
    ("pilon", "600", "materiaux", "Wood"),
    ("plancher", "600", "materiaux", "Wood"),
    ("planche", "600", "materiaux", "Wood"),
    ("pirogue", "600", "materiaux", "Wood"),
    ("poutre", "600", "materiaux", "Wood"),
    ("the", "100", "alimentaire", "Unspecified Parts"),
    ("tressage", "600", "materiaux", "Cane etc."),
    ("aphrodisiaque", "1100", "medicinale", "Genitourinary System Disorders"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Correspondance entre usages locaux normalisés et classification Cook (1995). Niveau 1 : catégorie principale ; Niveau 2 : sous-catégorie. Source : référentiel projet, fichier correspondance-usages-cook.csv. // REF? Cook (1995) à citer.],
) <annexe-codes-cook>

#pagebreak(weak: true)

#figure(
  table(
    columns: 5,
    align: (left, left, center, left, left),
    table.header([*Nom vernaculaire réconcilié*], [*Nom binomial*], [*Types*], [*Usages (Cook N1)*], [*Source*]),
    // Données depuis liste-especes-usages-types.csv (extrait partiel)
    ("Aboladitra", "Sideroxylon gerrardianum", "NA", "materiaux", "Placettes"),
    ("Alampogna", "++", "1", "aucun", "Hors placettes"),
    ("Ambilazo", "Calliandra alternans", "NA", "aucun", "Placettes"),
    ("Ambora", "++", "1-3", "aucun", "Transfert 2004"),
    ("Ampaliala", "Ficus soroceoides", "1-2", "aucun", "Placettes"),
    ("Andragnoy", "NA", "1-3", "materiaux", "Hors placettes"),
    ("Angavoady", "Thecacoris cometia", "1-2", "aucun", "Placettes"),
    ("Angavoala", "NA", "1", "aucun", "Placettes"),
    ("Babogna", "Mascarenhasia", "1", "materiaux", "Placettes"),
    ("Bararaky", "++", "1", "materiaux", "Hors placettes"),
    ("Bararata", "++", "NA", "aucun", "Hors placettes"),
    ("Belakevigna", "NA", "1", "aucun", "Placettes"),
    ("Beronono", "NA", "2", "aucun", "Placettes"),
    ("Besaroviky", "NA", "NA", "aucun", "Placettes"),
    ("Bevoroviky", "NA", "NA", "aucun", "Placettes"),
    ("Bevorovoka", "NA", "NA", "aucun", "Placettes"),
    ("Dikadika", "NA", "NA", "aucun", "Placettes"),
    ("Dingadigana", "++", "NA", "aucun", "Transfert 2004"),
    ("Dintogna", "NA", "1", "aucun", "Placettes"),
    ("Elatrangidigna", "++", "2", "aucun", "Placettes"),
    ("Espèce indéterminée", "NA", "1", "sociale_culturelle", "Placettes"),
    ("Fagnamohazo", "NA", "2", "aucun", "Placettes"),
    ("Fagnentsoagnana", "NA", "NA", "aucun", "Placettes"),
    ("Fagnidy", "++", "1", "sociale_culturelle,medicinale", "Hors placettes"),
    ("Fagnotavahatra", "NA", "NA", "aucun", "Placettes"),
    ("Fanakaragna", "NA", "NA", "aucun", "Placettes"),
    ("Fanalaotra", "NA", "1", "materiaux", "Placettes"),
    ("Fandemo", "NA", "2", "aucun", "Placettes"),
    ("Fandramanagna", "++", "1-3", "medicinale,alimentaire", "Transfert 2004"),
    ("Fandrenakanga", "++", "1", "aucun", "Placettes"),
    ("Fantsihena", "NA", "2", "aucun", "Placettes"),
    ("Fantsikahitra", "++", "1-2", "materiaux", "Placettes"),
    ("Fantsikala", "++", "1-2", "poison", "Placettes"),
    ("Fantsinakoho", "++", "1", "aucun", "Placettes"),
    ("Fantsinakohoala", "++", "1", "aucun", "Placettes"),
    ("Faralaotra", "Colubrina faraloatra", "2", "aucun", "Placettes"),
    ("Faritafoka", "NA", "1", "sociale_culturelle", "Hors placettes"),
    ("Foraha", "Calophyllum", "NA", "aucun", "Placettes"),
    ("Fotsikazo", "NA", "1", "aucun", "Placettes"),
    ("Fotsivavogna", "NA", "1", "aucun", "Placettes"),
    ("Goaviala", "++", "2", "aucun", "Placettes"),
    ("Hafiky", "NA", "NA", "aucun", "Placettes"),
    ("Hafipotsy", "Dombeya spectabilis", "2", "aucun", "Placettes"),
    ("Hafona", "NA", "2", "aucun", "Placettes"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste de la flore observée. Espèces : identités réconciliées ; « ++ » = espèce non identifiée taxonomiquement ; « NA » = non applicable. Usages : classification Cook (1995), niveau 1. Sources : placettes, hors placettes, transfert 2004, Romiguière. // TODO : Liste complète à régénérer avant la version finale.],
) <annexe-flore>

#pagebreak(weak: true)

#figure(
  table(
    columns: 4,
    align: (left, left, center, left),
    table.header([*Nom vernaculaire*], [*Taxonomie*], [*Type d'observation*], [*Source*]),
    // Données depuis animaux-T1-T2.csv et autres-observations-flore.csv (faune)
    ("Sanglier", "Potamochoerus larvatus", "Recherche de nourriture", "Transects T1–T2"),
    ("Vitsika", "Formicidae", "Maison", "Transects T1–T2"),
    ("Toloho", "Cuculidae", "Vocalisation", "Transects T1–T2"),
    ("Tetso", "Accipitridae", "Vocalisation", "Transects T1–T2"),
    ("Kitreoka", "NA", "Vocalisation", "Transect T2"),
    ("Leromba", "NA", "Vocalisation", "Transect T2"),
    ("Boeza", "NA", "Vocalisation", "Transect T2"),
    ("Vorondreo", "NA", "Vocalisation", "Transect T2"),
    ("Anjay", "NA", "Vocalisation", "Transect T2"),
    ("Boizo", "NA", "Vocalisation", "Transect T2"),
    ("Papango", "Psittacidae", "Vocalisation", "Transect T2"),
    ("Goaika", "NA", "Vocalisation", "Transect T2"),
    ("Akoragna", "NA", "?", "Transect T2"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Liste de la faune observée. Type d'observation : vue ou indice (vocalisation, trace). Sources : transects T1–T2 (2026), transfert 2004, GBIF, Rajaonson et al. (2010). // TODO : Compléter avec les observations hors transects et valider les identifications taxonomiques.],
) <annexe-faune>

#pagebreak(weak: true)

#figure(
  table(
    columns: 5,
    align: (center, left, left, left, left),
    table.header([*Placette*], [*Type*], [*Espèce*], [*Nombre*], [*Remarque*]),
    // Données depuis phenologie.csv
    ("P07", "Fruit", "Vayivayi", "0–2", "Baie rouge encore accrochée à la plante"),
    ("P14", "Fleur", "Kasakasa", ">10", "Herbacée"),
    ("P16", "Fruit", "Hazo mainty", ">10", "Cauliflorie, fruits ronds déjà sec"),
    ("P18", "Fleur", "Fagnamo hazo", "0–2", "Cauliflorie, une unique grappe"),
    ("P20", "Fleur", "Hazo mainty", ">10", "Cauliflorie, sorte de petits bâtons en bas du tronc, en haut du même tronc déjà fruits"),
    ("P20", "Fruit", "Hazo mainty", ">10", "Cauliflorie, fruits ronds déjà sec en hauteur"),
    ("P26", "Fruit", "Hasina (type petites feuilles)", "3–10", "Trois grappes, cauliflorie"),
    ("P27", "Fleur", "Sp. inconnue", "3–10", "Un arbre, cauliflorie"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Observations phénologiques complémentaires. Type : Fleur ou Fruit ; Nombre : classes 0–2, 3–10, >10. Source : phenologie.csv, n = 8 observations, date de collecte : 2026.],
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
  table(
    columns: 6,
    align: (left, center, center, center, center, center),
    table.header([*Compartiment*], [*Volume (m³/ha)*], [*IC 95 % Volume*], [*Biomasse (tMS/ha)*], [*IC 95 % Biomasse*], [*Carbone (tC/ha)*]),
    // Données depuis carbone_stocks.csv (valeurs arrondies à 2 décimales)
    ("Grands arbres (transects 10 m)", "48,02", "[32,78 ; 63,29]", "27,85", "[19,01 ; 36,71]", "15,71"),
    ("Tiges placettes (flore)", "343,84", "[230,54 ; 474,65]", "199,43", "[133,71 ; 275,29]", "112,48"),
    ("Bois mort au sol", "22,47", "[9,62 ; 37,86]", "13,03", "[5,58 ; 21,96]", "6,13"),
    ("Bois mort sur pied", "9,92", "[2,90 ; 18,45]", "5,75", "[1,68 ; 10,70]", "2,70"),
    ("Total", "424,25", "[285,84 ; 594,25]", "246,06", "[159,98 ; 344,66]", "137,02"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Détail des stocks de carbone par compartiment (vivant et mort). Volume : m³/ha ; Biomasse : tonnes de matière sèche/ha ; Carbone : tonnes de C/ha. IC 95 % : intervalle de confiance à 95 %. Source : carbone_stocks.csv, n = 28 placettes, date : 2026. // TODO : Extrapolation à la surface forestière totale à ajouter une fois la surface QGIS connue.],
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
  table(
    columns: 3,
    align: (left, left, left),
    table.header([*Fichier*], [*Description*], [*Conditions d'accès*]),
    ("donnees_ecologiques.csv", "Données brutes des relevés écologiques (placettes, transects)", "Accès libre"),
    ("scripts_R/", "Scripts R pour les analyses statistiques et graphiques", "Accès libre"),
    ("transcriptions_anonymisees/", "Transcriptions anonymisées des 52 entretiens (PDF)", "Accès restreint – demande motivée"),
    ("metadonnees/", "Métadonnées complètes des sorties et entretiens", "Accès libre"),
    ("referentiels/", "Référentiels taxonomiques et d'usages (Cook 1995)", "Accès libre"),
    ("cartes/", "Cartes de localisation et d'intervention (QGIS)", "Accès libre"),
  ),
  kind: "annexe",
  supplement: [Annexe],
  caption: [Métadonnées des fichiers complémentaires déposés avec le mémoire. Format : CSV, PDF, scripts R. // TODO : Préciser les modalités d'accès et le DOI ou lien de dépôt une fois disponibles.],
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
