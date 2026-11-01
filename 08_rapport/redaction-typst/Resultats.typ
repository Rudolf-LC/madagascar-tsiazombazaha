// Résultats — volet écologie (§3.1, §3.2, §3.4 validés).
// Règle (guide GEEFT, critère 49) : pas de comparaison avec la littérature ni
// d'interprétation ici — tout va en Discussion.
// Valeurs : issues des CSV à la date de rédaction. La saisie continue : chaque valeur
// citée porte son n et un // TODO date-jeu-de-données pour revalidation avant dépôt.
// Figures : importées depuis leur chemin canonique, jamais copiées.

= Résultats <debut-corps>

== Revue de littérature

// Ce qu’on écrit en Résultats : les deux, dans cet ordre.

// Caractériser le corpus retenu. Un tableau : source, année, type de document, objet (flore, faune, gestion…), effort de prospection, nombre d’espèces citées. Tes deux esquisses de tableaux dans ResultatsEcologie.typ vont déjà dans ce sens.
// Un court état des lieux factuel de ce que ces documents rapportent :
// quels groupes ont été inventoriés, quand et avec quel effort ;
// combien d’espèces ou d’occurrences sont documentées ;
// quels groupes n’ont jamais été étudiés.

// Par exemple, ton projet de stage mentionne 205 occurrences GBIF issues d’un inventaire d’octobre 2008. C’est à revérifier avant de le citer.

// On reste descriptif : la comparaison avec tes propres relevés et l’interprétation des lacunes vont en Discussion (critère 49).

--------

// TODO : figure — diagramme PRISMA 2020 (Page et al., 2021) : branche « bases de données » (Google Scholar, Web of Science, Internet Archive Scholar) et branche « autres méthodes » (Google, documents internes) ; effectifs dans documents-brouillons/PRISMA_resultats.ods (valeurs à valider). Renvoi depuis le M&M (« Revue de la littérature »).
// TODO : tableau — documents retenus (référence, type, thème, données exploitées), à partir des esquisses ci-dessous.
// Rajaonson et al. (2010) fait partie des documents retenus : forêt visitée le 25/01/2009 (une journée), deux espèces de lémuriens trouvées (Avahi laniger, Eulemur rufus), aucun bambou (p. 37).

// Transféré du brouillon « redaction-foresterie-brouillon » — esquisses de tableaux :
// Tableau 1 — sources ayant prospecté la faune/flore de la forêt :
//   [Source][Effort de prospection en jours][Espèces animales (vern/scie)][Espèces végétales (vern/sci)]
//   [Romiguière (2025)], [4], [], [], [],],
//   [Document de transfert de gestion (2004)], [?], [], [], [],],
//   [DREDD], [?], [], [], [],],
//   [Mollusques (200~8)], [2 ?], [0], [], [],
//   [Lémuriens — Rajaonson et al. (2010)], [1], [2 (A. laniger, E. rufus)], [], [],
// Tableau 2 — sources identifiées ayant réalisé des relevés écologiques dans la forêt
// de Tsiazombazaha :
//   [Source], [Nombre de tiges], [Nombre d'espèces],
//   [], [], [],
//   [], [], [],
// TODO : saisir ces tableaux quand les sources seront consolidées.

== Analyse des données écologiques

L'inventaire porte sur 1~999 tiges, tiges mesurées et gaulis, réparties dans 28 placettes, pour une surface horizontale cumulée de 531,1~m² après correction de pente. Cinquante et une tiges (7 tiges mesurées et 44 gaulis) réparties dans 10 placettes n'ont pas pu être nommées ; elles sont exclues des calculs de diversité, de richesse et d'IVI, qui portent sur 1~948 tiges, mais conservées dans les calculs de structure forestière et de stock de carbone.

// Rédigé le 01/11/2026 à partir des sorties R du 31/10/2026 (diversité, structure, IVI, richesse) et du 01/11/2026 (carbone), après passage en gaulis des deux tiges de 7 cm de P06.
// Sources : analyse-tables/ (copies de 06_ecologie/analyse/sorties/) et, pour les fichiers non copiés, 06_ecologie/analyse/sorties/ (nom indiqué à chaque paragraphe).
// Règle (guide, critère 49) : résultats seulement ; comparaisons avec la littérature et interprétations en Discussion.
// Figures et tableaux : laissés en commentaires (« // FIGURE » / « // TABLEAU »), avec le code prêt à décommenter ; les renvois entre parenthèses en capitales sont à remplacer par les étiquettes Typst une fois les blocs activés. Les renvois « (ANNEXE : …) » visent les entrées de Annexes.typ.

=== Listes d'espèces et usages

// TODO : valeurs à produire. La liste définitive de la flore n'a pas été régénérée depuis la réconciliation et les corrections de flore.csv (anciens chiffres du 08/10/2026 conservés en commentaire en fin de sous-section). Seule la richesse des placettes (242 espèces) vient d'une sortie à jour (estimateurs_richesse_gamma.csv).
Les 28 placettes comptent 242 noms vernaculaires distincts. La liste de la flore réunit au total [X] espèces : [X] relevées dans les placettes, [X] notées seulement hors des placettes et [X] citées seulement par les sources complémentaires (ANNEXE : liste de la flore). Parmi elles, [X] sont rattachées à un nom scientifique : [X] à l'espèce, [X] au genre et [X] à la famille. Les polisin'ala ont décrit plusieurs types pour [X] espèces.
// Source : diversite_indeterminees.csv (export ajouté à analyse_diversite_alpha.R le 01/11/2026) ; 1 948 + 51 = 1 999 tiges (structure_resume.csv). Mise à jour du 01/11/2026 : « Valotra / Voamalimpangady » (P06, 2 gaulis) reconnu comme espèce indéterminée (auteur), d'où 51 tiges indéterminées et γ = 242.

Les polisn'ala ont cité des usages pour 70 des 261 espèces de la liste ; 18 espèces n'ont que la mention « aucun » et 173 n'ont aucune mention d'usage. La catégorie d'usage de Cook (1995) la plus représentée est celle des matériaux, avec 49 espèces, suivie des médicaments (11 espèces) et des usages sociaux (8 espèces) (@tab-usages).
// Source : usages_cook_categories.csv et usages_cook_resume.csv (analyse_usages_cook.R, 01/11/2026) : usages de flore.csv (via reconciliation-taxonomique.csv et normalisation-usages.csv) réunis avec ceux de liste-especes-usages-types.csv, classés par correspondance-usages-cook.csv.
// Correction du 01/11/2026 : le référentiel du 12/10 seul donnait 52 espèces (36 lignes de flore.csv, surtout P21 à P28, absentes). L'ancien brouillon (08/10) donnait 70.
// Mise à jour du 01/11/2026 : « Hazodandy » ajouté à la réconciliation (espèce propre) et « Valotra / Voamalimpangady » rattaché à « Espèce indéterminée » (auteur) ; usages des grands arbres reportés dans une colonne « usages » de grands-arbres.csv et de l'ODS, et lus par le script ; espèces indéterminées exclues des usages.
// Le total de la liste de la flore (paragraphe précédent) est laissé en [X] ; les 261 espèces sont celles du référentiel et de flore.csv réunis.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    inset: 8pt,
    table.header([*Catégorie d'usage (Cook, 1995)*], [*Nombre d'espèces*], [*Usages cités*]),
    [Matériaux], [49], [Balai, batan, bois de construction, canaux d'irrigation, construction de maison, corde, fixation de toiture, guitare, manche de bêche, menuiserie, panier, pilon, pirogue, planche, plancher, poutre, tressage],
    [Médicaments], [11], [Aphrodisiaque, douleurs dentaires, fatigue, gonflements, usage médicinal non précisé],
    [Usages sociaux], [8], [Anti-foudre, magie],
    [Alimentation], [3], [Écorce sucrée, fruit comestible, thé],
    [Combustibles], [2], [Bois de chauffage],
    [Usages environnementaux], [2], [Haie],
    [Poisons des non-vertébrés], [1], [Insecticide],
  ),
  caption: [Nombre d'espèces citées pour chaque catégorie d'usage de premier niveau de la classification de Cook (1995) : 70 espèces à usage classé sur les 261 de la liste ; une espèce peut relever de plusieurs catégories. Les usages cités relèvent du second niveau ; leurs codes figurent en annexe.],
) <tab-usages>

Les espèces faunistiques relevées sont au nombres de [X] : [X] observées directement ou indirectement au cours des cheminements, et [X] citées seulement par les sources complémentaires (ANNEXE : liste de la faune). Les traces d'activités humaines rencontrées et les observations phénologiques sont données en annexe, à titre indicatif (ANNEXE : OBSERVATIONS COMPLÉMENTAIRES).
// TODO : valeurs à tirer de la liste de faune une fois nettoyée (« T1-T2-faune », notes de sortie, transfert de gestion 2004, GBIF, Rajaonson et al., 2010).

// --- Ancien brouillon (chiffres du 08/10/2026, antérieurs à la réconciliation : NE PAS CITER) ---
// Au total, 335 noms vernaculaires normalisés ; 230 identités ; 130 avec une identification botanique au sens large (61 avec un taxon proposé, 69 avec une correspondance vers au moins deux genres).
// Types : 1,60 ± 0,64 par identité (n = 180) ; 86 espèces à un type, 81 à deux, 12 à trois, une à quatre.
// Usages : 70 espèces à usage rapporté et classé (1,27 ± 0,51 usages par espèce) ; matériaux 48, médicaments 11, usages sociaux 9, alimentation 3, combustibles 2, usages environnementaux 2, poisons des non-vertébrés 1.
// #figure(
//   table(
//     columns: (auto, auto, auto),
//     align: (left, center, left),
//     inset: 8pt,
//     [*Catégorie d'usage (Cook, 1995)*], [*Nombre d'espèces*], [*Usages cités*],
//     [Matériaux], [48], [Balai, batan, bois de construction, canaux d'irrigation, construction de maison, corde, fixation de toiture, guitare, manche de bêche, menuiserie, panier, pilon, pirogue, planche, plancher, poutre, tressage],
//     [Médicaments], [11], [Aphrodisiaque, douleurs dentaires, fatigue, gonflements, usage médicinal],
//     [Usages sociaux], [9], [Anti-foudre, magie],
//     [Alimentation], [3], [Écorce sucrée, fruit comestible, thé],
//     [Combustibles], [2], [Bois de chauffage],
//     [Usages environnementaux], [2], [Haie],
//     [Poisons des non-vertébrés], [1], [Insecticide],
//   ),
//   caption: [Répartition des espèces à usage cité par catégorie de premier niveau de la classification de Cook (1995). Les usages cités relèvent du second niveau ; leurs codes figurent en annexe.],
// ) <tab-usages-ancien>

=== Structure forestière

// Source : structure_resume.csv (copie de structure_resume_indices.csv) ; surface : courbe_raréfaction_extrapolation.csv (531,09 m² à 28 placettes) et message du script de structure (531,1 m²).
// Arrondis : deux décimales ; densités à l'hectare arrondies à l'unité (arbitrage auteur, 15/10/2026).
 Une placette compte en moyenne 71,39 tiges (écart-type : 26,41). La densité est estimée à 37~569~±~2~552 tiges/ha et la surface terrière à 37,30~±~5,30~m²/ha (moyenne ± erreur-type ; @tab-structure).
// Écart-type pour la dispersion entre placettes (tiges par placette), erreur-type pour les estimations à l'hectare (N, G) : arbitrage auteur du 01/11/2026 ; erreurType ajouté à resumer() (fonctionsStructure.R) et exporté dans structure_resume_indices.csv.

// Tableau de structure : valeurs de structure_resume.csv (31/10/2026), saisies à la main.
#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: 8pt,
    table.header([*Indicateur (unité)*], [*Moyenne*], [*Écart-type*], [*Erreur-type*], [*IC 95 %*]),
    [Tiges par placette (tiges)], [71,39], [26,41], [4,99], [[61,15 ; 81,63]],
    [Densité N (tiges/ha)], [37~569], [13~506], [2~552], [[32~332 ; 42~806]],
    [Surface terrière G (m²/ha)], [37,30], [28,04], [5,30], [[26,43 ; 48,17]],
  ),
  caption: [Indicateurs de structure forestière (28 placettes). Moyenne entre placettes ; écart-type : dispersion entre placettes ; erreur-type de la moyenne ; IC 95 % : intervalle de confiance à 95 % par la loi de Student. Indicateurs rapportés à la surface horizontale. Les gaulis (tiges de plus de 1,30 m de haut et de CBH < 8 cm) sont inclus dans N et exclus de G. Valeurs par placette en annexe.],
) <tab-structure>
// Ligne N (tiges/m²) non reprise : redondante avec N (tiges/ha) (guide, critère 52) ; CSV : 3,76 ± 1,35 [3,23 ; 4,28].

// Source : 06_ecologie/analyse/sorties/structure_classes_ic95.csv.
La densité décroît de 28~426 tiges/ha dans la classe de diamètre 0-2,5~cm, qui comprend les gaulis, à 446 tiges/ha dans la classe 7,5-10~cm. Au-delà de 10~cm, elle ne dépasse pas 268 tiges/ha et varie irrégulièrement d'une classe à l'autre. Aucune tige de diamètre supérieur à 35~cm n'a été mesurée dans les placettes (@fig-hist-classes).
// La classe 27,5-30 cm est absente du CSV (aucune tige) : emplacement vide sur l'histogramme.

// FIGURE : histogramme tracé directement en Typst (01/11/2026) à partir de analyse-tables/structure_classes_ic95.csv (copie de la sortie R du 31/10/2026). Échelle logarithmique (le SVG de R utilise une échelle symétrique-logarithmique) ; niveaux de gris, sans titre dans l'image.
#let classesDiam = csv("analyse-tables/structure_classes_ic95.csv").slice(1).map(r => r.map(float))
#figure(
  {
    set text(size: 8pt)
    let largeur = 13cm
    let hauteur = 6.5cm
    let marge = 1.6cm
    let nbClasses = 14
    let pas = largeur / nbClasses
    // Échelle logarithmique de 10 à 100 000 tiges/ha ; valeurs ≤ 10 ramenées à l'axe
    let y = v => if v <= 10 { 0pt } else { hauteur * (calc.log(v, base: 10) - 1) / 4 }
    let graduations = ("10", "100", "1\u{202F}000", "10\u{202F}000", "100\u{202F}000")
    // Marge haute pour le titre de l'axe des ordonnées
    pad(top: 0.6cm, box(width: largeur + marge + 0.3cm, height: hauteur + 1.4cm, {
      // Grille et graduations de l'axe des ordonnées
      for k in range(5) {
        let dy = hauteur - hauteur * k / 4
        place(dx: marge, dy: dy, line(length: largeur, stroke: (paint: luma(200), thickness: 0.4pt, dash: "dashed")))
        place(dx: 0pt, dy: dy - 0.5em, box(width: marge - 0.15cm, align(right, graduations.at(k))))
      }
      // Barres et intervalles de confiance
      for r in classesDiam {
        let i = int(calc.round(r.at(0) / 2.5))
        let x = marge + pas * i
        let h = y(r.at(1))
        place(dx: x + pas * 0.1, dy: hauteur - h, rect(width: pas * 0.8, height: h, fill: luma(175), stroke: 0.4pt + black))
        let bas = y(r.at(2))
        let haut = y(r.at(3))
        let cx = x + pas / 2
        place(dx: cx, dy: hauteur - haut, line(start: (0pt, 0pt), end: (0pt, haut - bas), stroke: 0.6pt + black))
        place(dx: cx - pas * 0.15, dy: hauteur - haut, line(length: pas * 0.3, stroke: 0.6pt + black))
        if r.at(2) > 10 {
          place(dx: cx - pas * 0.15, dy: hauteur - bas, line(length: pas * 0.3, stroke: 0.6pt + black))
        }
      }
      // Axes
      place(dx: marge, dy: 0pt, line(start: (0pt, 0pt), end: (0pt, hauteur), stroke: 0.6pt + black))
      place(dx: marge, dy: hauteur, line(length: largeur, stroke: 0.6pt + black))
      // Graduations de l'axe des abscisses (bornes de classes tous les 5 cm)
      for k in range(8) {
        let x = marge + pas * 2 * k
        place(dx: x, dy: hauteur, line(start: (0pt, 0pt), end: (0pt, 3pt), stroke: 0.6pt + black))
        place(dx: x - 0.5cm, dy: hauteur + 5pt, box(width: 1cm, align(center, str(5 * k))))
      }
      place(dx: marge, dy: hauteur + 0.75cm, box(width: largeur, align(center)[Diamètre à hauteur de poitrine (cm)]))
      place(dx: 0pt, dy: -0.45cm, box(width: largeur, align(left)[Densité (tiges/ha, échelle logarithmique)]))
    }))
  },
  caption: [Densité de tiges par classe de diamètre de 2,5~cm (moyenne entre 28 placettes ; barres d'erreur : IC 95~% par la loi de Student). Axe des ordonnées en échelle logarithmique ; les bornes inférieures négatives ou inférieures à 10~tiges/ha sont ramenées à l'axe, sans trait horizontal. Les gaulis (tiges de plus de 1,30~m de haut et de CBH < 8~cm) sont inclus dans la classe 0-2,5~cm ; la classe 27,5-30~cm ne compte aucune tige. Données en annexe.],
) <fig-hist-classes>

// Version R (SVG, échelle symétrique-logarithmique), conservée en réserve :
// #figure(
//   image("analyse-figures/structure_histogramme_classes.svg",
//     alt: "Histogramme de la densité de tiges par classe de diamètre de 2,5 cm, en échelle symétrique-logarithmique : la classe 0-2,5 cm domine, puis la densité décroît vers les grandes classes."),
//   caption: [Densité de tiges par classe de diamètre de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student, tronquées à zéro). Axe des ordonnées en échelle symétrique-logarithmique : linéaire près de zéro, logarithmique au-delà. Les gaulis sont inclus dans la classe 0-2,5~cm. Données en annexe.],
// ) <fig-hist-classes>

// Source : 06_ecologie/analyse/sorties/structure_G_classes.csv.
La surface terrière la plus élevée est celle de la classe 2,5-7,5~cm (10,43~m²/ha), suivie de la classe 22,5-27,5~cm (9,62~m²/ha). Les classes de 27,5 à 37,5~cm ont chacune une surface terrière inférieure à 1,7~m²/ha (@fig-G-classes).

// FIGURE : histogramme tracé directement en Typst (01/11/2026) à partir de analyse-tables/structure_G_classes.csv (copie de la sortie R du 31/10/2026, inchangée après la mise à jour de la réconciliation). Échelle linéaire ; niveaux de gris, sans titre dans l'image.
#let classesG = csv("analyse-tables/structure_G_classes.csv").slice(1).map(r => r.map(float))
#figure(
  {
    set text(size: 8pt)
    let largeur = 13cm
    let hauteur = 6cm
    let marge = 1.2cm
    let nbClasses = 7
    let pas = largeur / nbClasses
    let gMax = 16
    // Échelle linéaire de 0 à 16 m²/ha ; bornes négatives ramenées à zéro
    let y = v => if v <= 0 { 0pt } else { hauteur * v / gMax }
    // Marge haute pour le titre de l'axe des ordonnées
    pad(top: 0.6cm, box(width: largeur + marge + 0.3cm, height: hauteur + 1.4cm, {
      // Grille et graduations de l'axe des ordonnées
      for k in range(5) {
        let dy = hauteur - hauteur * k / 4
        place(dx: marge, dy: dy, line(length: largeur, stroke: (paint: luma(200), thickness: 0.4pt, dash: "dashed")))
        place(dx: 0pt, dy: dy - 0.5em, box(width: marge - 0.15cm, align(right, str(4 * k))))
      }
      // Barres et intervalles de confiance
      for r in classesG {
        let i = int(calc.round((r.at(4) - 2.5) / 5))
        let x = marge + pas * i
        let h = y(r.at(1))
        place(dx: x + pas * 0.1, dy: hauteur - h, rect(width: pas * 0.8, height: h, fill: luma(175), stroke: 0.4pt + black))
        let bas = y(r.at(2))
        let haut = y(r.at(3))
        let cx = x + pas / 2
        place(dx: cx, dy: hauteur - haut, line(start: (0pt, 0pt), end: (0pt, haut - bas), stroke: 0.6pt + black))
        place(dx: cx - pas * 0.1, dy: hauteur - haut, line(length: pas * 0.2, stroke: 0.6pt + black))
        if r.at(2) > 0 {
          place(dx: cx - pas * 0.1, dy: hauteur - bas, line(length: pas * 0.2, stroke: 0.6pt + black))
        }
      }
      // Axes
      place(dx: marge, dy: 0pt, line(start: (0pt, 0pt), end: (0pt, hauteur), stroke: 0.6pt + black))
      place(dx: marge, dy: hauteur, line(length: largeur, stroke: 0.6pt + black))
      // Graduations de l'axe des abscisses (bornes de classes, de 2,5 à 37,5 cm)
      let bornes = ("2,5", "7,5", "12,5", "17,5", "22,5", "27,5", "32,5", "37,5")
      for k in range(8) {
        let x = marge + pas * k
        place(dx: x, dy: hauteur, line(start: (0pt, 0pt), end: (0pt, 3pt), stroke: 0.6pt + black))
        place(dx: x - 0.5cm, dy: hauteur + 5pt, box(width: 1cm, align(center, bornes.at(k))))
      }
      place(dx: marge, dy: hauteur + 0.75cm, box(width: largeur, align(center)[Diamètre à hauteur de poitrine (cm)]))
      place(dx: 0pt, dy: -0.45cm, box(width: largeur, align(left)[Surface terrière (m²/ha)]))
    }))
  },
  caption: [Surface terrière par classe de diamètre de 5~cm, à partir du seuil de mesure de 2,5~cm (moyenne entre 28 placettes ; barres d'erreur : IC 95~% par la loi de Student). Les bornes inférieures négatives sont ramenées à zéro, sans trait horizontal. Les gaulis, non mesurés, sont exclus. Données en annexe.],
) <fig-G-classes>

// Version R (SVG), conservée en réserve :
// #figure(
//   image("analyse-figures/structure_G_classes.svg",
//     alt: "Histogramme de la surface terrière par classe de diamètre de 5 cm, de 2,5 à 37,5 cm, avec un maximum dans la première classe et un second dans la classe 22,5-27,5 cm."),
//   caption: [Surface terrière par classe de diamètre de 5~cm, à partir du seuil de mesure de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student, tronquées à zéro). Les gaulis, non mesurés, sont exclus. Données en annexe.],
// ) <fig-G-classes>

// Source : transects_grands_arbres.csv, transects_grands_arbres_resume.csv, transects_chablis.csv (analyse_transects.R, créé et lancé le 01/11/2026).
Le long de 5~305~m de chemins répartis sur cinq transects, soit 53~050~m² de bande prospectée, 77 arbres de CBH $>=$ 126~cm ont été relevés. La densité de grands arbres est estimée à 14,51~±~3,42 arbres/ha (erreur-type). Elle varie selon les transects de 7,73 arbres/ha (T05) à 43,33 arbres/ha (T19).
// ATTENTION : longueur de T19 incertaine (« 300 ? » dans l'ODS) ; la densité de T19 et l'estimation globale en dépendent.

Les chablis n'ont été dénombrés, à ce jour, que le long de deux itinéraires : 2 petits bois (diamètre inférieur à 30~cm) et 5 bois moyens ou gros sur T01 ; 20 petits bois, 20 bois moyens (30 à 60~cm) et 18 gros bois (plus de 60~cm) sur T02. Faute de longueur prospectée, aucune densité n'est calculée.
// TODO (auteur) : mettre à jour ce paragraphe après correction des chablis (définition, transects T19 et T20, longueurs, unité des classes) ; le script analyse_transects.R n'exporte pour l'instant que les effectifs.

=== Stock de carbone

// Source : 06_ecologie/analyse/sorties/carbone_stocks.csv (01/11/2026 ; E = 0,10, ρ = 0,58, facteurs MDP, graine 2026). Fichier à copier dans analyse-tables/.
Les tiges des placettes représentent un stock de 112,48~tC/ha (IC 95~% : [75,39~; 156,52]) et les grands arbres des transects, prospectés sur 5~305~m de chemins, un stock de 19,68~tC/ha ([13,21~; 31,18]) (TABLEAU : CARBONE). Le volume de bois mort au sol est de 22,47~m³/ha ([9,48~; 37,66]), pour un stock de 6,13~tC/ha ([2,58~; 10,27]) ; celui du bois mort sur pied est de 9,92~m³/ha ([2,87~; 18,63]), pour un stock de 2,70~tC/ha ([0,78~; 5,08]).
// TODO : stock total à l'hectare et stock de la forêt entière — à faire exporter par le script (pas de somme à la main) ; stock de la forêt en attente de la surface QGIS (500 ha provisoires dans le script).
// Longueurs prospectées pour les grands arbres (transects.csv, 01/11/2026, d'après le tableau de l'onglet grands-arbres de l'ODS) : T05 1 940 m, T06 1 800 m, T16 205 m, T19 300 m, T20 1 060 m, soit 53 050 m² (message du script carbone). Les IC des autres compartiments changent légèrement (bootstrap à graine fixe, tirages décalés).
// ATTENTION : T19 = « 300 ? » dans l'ODS (valeur incertaine) ; T16 = 190 m auparavant dans transects.csv, « ~ 205 » dans l'ODS.

// TABLEAU : stocks par compartiment (IC 95 % par bootstrap, 1 000 rééchantillonnages).
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     align: (left, center, center, center),
//     inset: 8pt,
//     [*Compartiment*], [*Biomasse (tMS/ha)*], [*Carbone (tC/ha)*], [*CO₂ (tCO₂/ha)*],
//     [Tiges des placettes], [199,43], [112,48 [75,39 ; 156,52]], [412,80 [276,68 ; 574,42]],
//     [Grands arbres des transects], [34,89], [19,68 [13,21 ; 31,18]], [72,22 [48,47 ; 114,43]],
//     [Bois mort au sol], [13,03], [6,13 [2,58 ; 10,27]], [22,48 [9,48 ; 37,68]],
//     [Bois mort sur pied], [5,75], [2,70 [0,78 ; 5,08]], [9,92 [2,87 ; 18,64]],
//   ),
//   caption: [Stocks de biomasse, de carbone et de CO₂ par compartiment. Entre crochets : IC 95 % par bootstrap (1~000 rééchantillonnages des placettes ou des transects). Biomasse vivante : biomasse aérienne seule ; le carbone et le CO₂ du vivant incluent la biomasse souterraine ($R = "0,20"$). Paramètres : $E = "0,10"$, $rho = "0,58"$~g/cm³, $"CF" = "0,47"$. Détail des volumes et des stocks extrapolés en annexe.],
// ) <tab-carbone>

=== Diversité alpha

// Source : diversite_alpha_resume.csv ; valeurs par placette : 06_ecologie/analyse/sorties/diversite_alpha_placettes.csv.
Une placette compte en moyenne 29,29~±~6,28 espèces. L'indice de Shannon moyen est de 3,03~±~0,27, soit 21,38~±~5,37 espèces communes effectives (¹D) ; l'inverse de Simpson donne 15,93~±~4,65 espèces dominantes effectives (²D) et l'alpha de Fisher 22,01~±~9,32 (TABLEAU : ALPHA). L'écart-type entre placettes est le plus élevé pour l'alpha de Fisher. Les indices de chaque placette figurent en annexe (ANNEXE : INDICES PAR PLACETTE).
// ¹D et ²D en forme brute (arbitrage auteur, 01/11/2026) ; ²D recalculé (1 / Σp²) dans fonctionsDiversite.R, alpha relancé le 01/11/2026. L'ancienne valeur corrigée (22,05) était supérieure à ¹D.

// TABLEAU : indices alpha (moyenne ± écart-type, IC 95 %, n = 28).
// #figure(
//   table(
//     columns: (auto, auto, auto),
//     align: (left, center, center),
//     inset: 8pt,
//     [*Indice (unité)*], [*Moyenne ± écart-type (n = 28)*], [*IC 95 %*],
//     [Richesse spécifique S = ⁰D (espèces)], [29,29 ± 6,28], [[26,85 ; 31,72]],
//     [Indice de Shannon H′ (sans unité)], [3,03 ± 0,27], [[2,93 ; 3,13]],
//     [exp(H′) = ¹D (espèces communes effectives)], [21,38 ± 5,37], [[19,29 ; 23,46]],
//     [²D, inverse de Simpson (espèces dominantes effectives)], [15,93 ± 4,65], [[14,13 ; 17,74]],
//     [Alpha de Fisher (sans unité)], [22,01 ± 9,32], [[18,40 ; 25,62]],
//   ),
//   caption: [Indices de diversité alpha par placette : moyenne entre 28 placettes ± écart-type ; IC 95 % par la loi de Student. Abondances : toutes les tiges comptées (tiges mesurées et gaulis), tiges indéterminées exclues. ¹D et ²D sous leur forme brute. Espèces : identités réconciliées. Valeurs par placette en annexe.],
// ) <tab-div-alpha>

=== Diversité bêta

// Sources : diversite_beta_resume_rapport.csv, diversite_beta_resume.csv, diversite_beta_whittaker.csv, diversite_beta_bray_niveaux.csv, diversite_beta_mono_commune.csv.
La richesse de l'ensemble des placettes ($gamma$ = 242 espèces) est 8,26 fois plus élevée que la richesse moyenne d'une placette ($macron(alpha)$ = 29,29 espèces). Le bêta additif est de 212,71 espèces. La dissimilarité de Bray-Curtis moyenne entre les 378 paires de placettes est de 0,81~±~0,09.

Dans l'ordination NMDS, de stress 0,23, (FIGURE : NMDS) [description de la disposition des placettes par itinéraire].
// TODO (à faire, auteur) : lire la figure NMDS (SVG du 31/10/2026) et décrire la disposition des placettes par itinéraire ; coordonnées dans diversite_beta_nmds_points.csv.

// FIGURE : ordination NMDS des 28 placettes, un symbole par itinéraire.
// #figure(
//   image("analyse-figures/diversite_beta_nmds.svg",
//     alt: "Plan d'ordination NMDS à deux dimensions des 28 placettes, un symbole par itinéraire."),
//   caption: [Ordination NMDS en deux dimensions des 28 placettes, sur la dissimilarité de Bray-Curtis (abondances, espèces réconciliées) ; stress = 0,23. Deux points proches correspondent à des placettes de composition proche. Chaque symbole représente un itinéraire. Coordonnées en annexe.],
// ) <fig-beta-nmds>

Les dissimilarités moyennes les plus faibles sont celles des paires de placettes d'un même itinéraire (Jaccard : 0,71~±~0,07 ; Bray-Curtis : 0,64~±~0,10 ; 37 paires), puis celles des paires d'un même polisin'ala (0,74~±~0,09 ; 0,76~±~0,06 ; 16 paires). Les paires d'une même commune (0,89~±~0,04 ; 0,83~±~0,07 ; 70 paires) et celles de communes différentes (0,86~±~0,04 ; 0,83~±~0,06 ; 255 paires) ont des dissimilarités voisines (TABLEAU : DISSIMILARITÉS PAR NIVEAU ; FIGURE : GRADIENT).
// ATTENTION : Jaccard « même commune » = 0,885 dans le CSV (trois décimales) ; arrondi ici à 0,89, à vérifier sur la valeur complète.
// Comparaison descriptive seulement (paires non indépendantes, M&M) : aucun test cité.

// TABLEAU : dissimilarités moyennes (± écart-type) par niveau partagé.
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     align: (left, center, center, center),
//     inset: 8pt,
//     [*Niveau partagé par la paire*], [*Paires*], [*Jaccard*], [*Bray-Curtis*],
//     [Même itinéraire], [37], [0,71 ± 0,07], [0,64 ± 0,10],
//     [Même polisin'ala (itinéraires différents)], [16], [0,74 ± 0,09], [0,76 ± 0,06],
//     [Même commune (polisin'ala différents)], [70], [0,89 ± 0,04], [0,83 ± 0,07],
//     [Communes différentes], [255], [0,86 ± 0,04], [0,83 ± 0,06],
//   ),
//   caption: [Dissimilarités moyennes ± écart-type entre paires de placettes selon le niveau le plus fin qu'elles partagent. Jaccard : présence-absence ; Bray-Curtis : abondances ; espèces réconciliées. Comparaison descriptive : les paires ne sont pas indépendantes.],
// ) <tab-beta-niveaux>
// Vérifié dans analyse_diversite_beta.R (01/11/2026) : case_when ordonné (même transect > même polisin'ala > même commune > communes différentes), chaque paire est classée au niveau le plus fin qu'elle partage ; les niveaux sont exclusifs.

// FIGURE : boîtes à moustaches de la dissimilarité de Jaccard par niveau (sans étoiles de significativité, figure du 31/10/2026).
// #figure(
//   image("analyse-figures/diversite_beta_gradient.svg",
//     alt: "Boîtes à moustaches de la dissimilarité de Jaccard entre paires de placettes, pour quatre niveaux ordonnés du même itinéraire aux communes différentes."),
//   caption: [Dissimilarité de Jaccard (présence-absence, espèces réconciliées) entre paires de placettes selon le niveau partagé : même itinéraire (37 paires), même polisin'ala (16), même commune (70), communes différentes (255). Boîtes : quartiles ; trait : médiane ; moustaches : valeurs extrêmes dans la limite de 1,5 fois l'écart interquartile ; points : valeurs au-delà.],
// Moustaches : geom_boxplot sans argument coef (défaut ggplot2 : 1,5 × IQR), vérifié le 01/11/2026.
// ) <fig-beta-gradient>

Sur les 242 espèces, 69,4~% ne sont observées que dans une seule commune, contre 49,4~% en moyenne lorsque les communes sont réattribuées au hasard aux placettes (999 permutations ; $p$ = 0,001).
// La ligne « noms vernaculaires bruts » du CSV (80,6 % contre 61,7 %) est un contrôle de la réconciliation : à citer en Discussion si besoin, pas ici.

=== Espèces dominantes

// Source : ivi_especes.csv (31/10/2026, relancé le 01/11/2026 après passage en gaulis des tiges de 7 cm de P06). IVI sur 100.
Le classement porte sur 124 espèces, représentées par 479 tiges mesurées dans les 28 placettes, hors tiges indéterminées. L'IVI le plus élevé est celui de Babogna (6,59), devant Ambora (5,03) et Hazomainty (4,96) (TABLEAU : IVI). Babogna a aussi la dominance relative la plus forte (9,96~%) et la fréquence relative la plus forte (4,59~%, 14 placettes) ; la densité relative la plus forte est celle de Hazomainty (6,05~%, 29 tiges). Six espèces ont un IVI supérieur à 3,5 ; l'IVI est inférieur à 1,5 à partir du rang 19.

Les trois composantes divergent pour certaines espèces. Ramiavogna et Sary, avec deux tiges chacune, ont une dominance relative de 5,00~% et de 4,50~%. Hasina, présente dans 12 placettes, a une fréquence relative de 3,93~% pour une dominance relative de 1,26~%. Cinquante-quatre espèces ne sont représentées que par une tige mesurée et 66 ne sont présentes que dans une placette ; à partir du rang 66, aucune espèce ne compte plus de deux tiges mesurées. Le classement complet figure en annexe (ANNEXE : IVI).

// TABLEAU : les quinze espèces de plus fort IVI.
// #figure(
//   table(
//     columns: (auto, auto, auto, auto, auto, auto),
//     align: (center, left, center, center, center, center),
//     inset: 8pt,
//     [*Rang*], [*Espèce*], [*DR (%)*], [*DoR (%)*], [*FR (%)*], [*IVI*],
//     [1], [Babogna], [5,22], [9,96], [4,59], [6,59],
//     [2], [Ambora], [4,59], [7,23], [3,28], [5,03],
//     [3], [Hazomainty], [6,05], [4,55], [4,26], [4,96],
//     [4], [Menafatagna], [4,59], [5,03], [3,61], [4,41],
//     [5], [Voapaka], [2,92], [5,87], [2,62], [3,80],
//     [6], [Tsimahamasasokona], [4,38], [3,35], [3,61], [3,78],
//     [7], [Randripody], [3,76], [1,33], [3,28], [2,79],
//     [8], [Hasina], [3,13], [1,26], [3,93], [2,78],
//     [9], [Hazombary], [3,55], [2,41], [1,64], [2,53],
//     [10], [Sagnira], [1,67], [3,48], [1,64], [2,26],
//     [11], [Kijy], [1,46], [3,24], [1,97], [2,22],
//     [12], [Ramiavogna], [0,42], [5,00], [0,66], [2,02],
//     [13], [Sary], [0,42], [4,50], [0,66], [1,86],
//     [14], [Tsirika], [2,71], [0,62], [1,97], [1,77],
//     [15], [Kabokala], [0,63], [3,63], [0,98], [1,75],
//   ),
//   caption: [Les quinze espèces de plus fort indice de valeur d'importance (IVI) sur l'ensemble du dispositif (28 placettes ; 479 tiges mesurées, gaulis et tiges indéterminées exclus). DR : densité relative ; DoR : dominance relative (part de la surface terrière) ; FR : fréquence relative (part des occurrences en placette). IVI = (DR + DoR + FR) / 3, la somme sur les 124 espèces valant 100. Espèces : identités réconciliées. Classement complet en annexe.],
// ) <tab-ivi>

=== Richesse spécifique totale

// Sources : estimateurs_richesse_gamma.csv ; 06_ecologie/analyse/sorties/courbe_raréfaction_extrapolation.csv.
Les 28 placettes totalisent 242 espèces observées. Tous les estimateurs donnent une richesse supérieure, de 285,83 espèces (bootstrap) à 382,00 espèces (jackknife d'ordre 2). Chao2, estimateur principal, donne 331,16 espèces (IC 95~% : [295,46~; 390,70]) ; toutes les autres estimations, sauf celle du bootstrap, sont comprises dans cet intervalle (TABLEAU : ESTIMATEURS).

// TABLEAU : estimateurs de la richesse totale.
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     align: (left, left, center, center),
//     inset: 8pt,
//     [*Estimateur*], [*Modèle (unité)*], [*Estimation (espèces)*], [*IC 95 %*],
//     [Chao2 (principal)], [Incidence (placette)], [331,16], [[295,46 ; 390,70]],
//     [Jackknife d'ordre 1], [Incidence (placette)], [337,46], [[293,77 ; 381,16]],
//     [Jackknife d'ordre 2], [Incidence (placette)], [382,00], [[343,43 ; 435,23]],
//     [ICE], [Incidence (placette)], [365,80], [[324,92 ; 426,81]],
//     [Bootstrap], [Incidence (placette)], [285,83], [[262,64 ; 309,01]],
//     [Chao1], [Abondance (tige)], [298,66], [[273,52 ; 343,87]],
//     [ACE], [Abondance (tige)], [315,49], [[297,90 ; 333,08]],
//   ),
//   caption: [Estimateurs asymptotiques de la richesse spécifique totale (28 placettes ; richesse observée $gamma_"obs"$ = 242 espèces, identités réconciliées, tiges indéterminées exclues). Chao2 est l'estimateur principal ; les autres sont donnés à titre de comparaison.],
// ) <tab-gamma>
// TODO : méthode de calcul des IC par estimateur (note §3.7 : transformation logarithmique pour Chao2, jackknife 2 et ICE ; approximation normale pour bootstrap, jackknife 1 et ACE ; intervalle exact pour Chao1) à confirmer dans estimation_richesse_specifique.R avant de l'écrire en légende.

À 28 placettes (531,1~m²), la couverture d'échantillonnage est de 0,88 (IC 95~% : [0,86~; 0,90]). Extrapolée à 112 placettes, soit quatre fois la surface prospectée (2~124~m²), la richesse atteint 327,76 espèces ([293,03~; 362,49]) pour une couverture de 0,996 (FIGURE : RARÉFACTION).
// TODO (à faire, auteur) : lire la courbe (SVG du 31/10/2026) et décrire sa forme (plateau ou non).

// FIGURE : courbe de raréfaction-extrapolation (incidence, q = 0).
// #figure(
//   image("analyse-figures/courbe_raréfaction_extrapolation.svg",
//     alt: "Courbe de richesse spécifique en fonction de la surface cumulée, interpolée jusqu'à 531 m² puis extrapolée jusqu'à environ 2 124 m², avec sa bande de confiance."),
//   caption: [Richesse spécifique (modèle d'incidence, ordre $q$ = 0) en fonction de la surface horizontale cumulée : interpolation de 1 à 28 placettes (point de référence : 531,1~m², 242 espèces), puis extrapolation jusqu'à 112 placettes, soit quatre fois la surface prospectée. Bande grise : IC 95~% par bootstrap. Données en annexe.],
// ) <fig-rarefaction>

== Enquête sociale

// Ici on abordera les résultats des entretiens dans l'ordre des questions de la problématique !