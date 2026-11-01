// Résultats — volet écologie (§3.1, §3.2, §3.4 validés).
// Règle (guide GEEFT, critère 49) : pas de comparaison avec la littérature ni
// d'interprétation ici — tout va en Discussion.
// Valeurs : issues des CSV à la date de rédaction. La saisie continue : chaque valeur
// citée porte son n et un // TODO date-jeu-de-données pour revalidation avant dépôt.
// Figures : importées depuis leur chemin canonique, jamais copiées.

= Résultats

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

// Rédigé le 01/11/2026 à partir des sorties R du 31/10/2026 (diversité, structure, IVI, richesse) et du 01/11/2026 (carbone), après passage en gaulis des deux tiges de 7 cm de P06.
// Sources : analyse-tables/ (copies de 06_ecologie/analyse/sorties/) et, pour les fichiers non copiés, 06_ecologie/analyse/sorties/ (nom indiqué à chaque paragraphe).
// Règle (guide, critère 49) : résultats seulement ; comparaisons avec la littérature et interprétations en Discussion.
// Figures et tableaux : laissés en commentaires (« // FIGURE » / « // TABLEAU »), avec le code prêt à décommenter ; les renvois entre parenthèses en capitales sont à remplacer par les étiquettes Typst une fois les blocs activés. Les renvois « (ANNEXE : …) » visent les entrées de Annexes.typ.

=== Listes d'espèces et usages

// TODO : valeurs à produire. La liste définitive de la flore n'a pas été régénérée depuis la réconciliation et les corrections de flore.csv (anciens chiffres du 08/10/2026 conservés en commentaire en fin de sous-section). Seule la richesse des placettes (243 espèces) vient d'une sortie à jour (estimateurs_richesse_gamma.csv).
Les 28 placettes comptent 243 espèces. Quarante-neuf tiges, 7 tiges mesurées et 42 gaulis répartis dans 10 placettes, n'ont pas pu être nommées ; elles sont exclues des calculs de diversité, de richesse et d'IVI, qui portent sur 1~950 tiges. La liste de la flore réunit au total [X] espèces : [X] relevées dans les placettes, [X] notées seulement hors des placettes et [X] citées seulement par les sources complémentaires (ANNEXE : liste de la flore). Parmi elles, [X] sont rattachées à un nom scientifique : [X] à l'espèce, [X] au genre et [X] à la famille. Le polisin'ala a décrit plusieurs types pour [X] espèces.
// Source : diversite_indeterminees.csv (export ajouté à analyse_diversite_alpha.R le 01/11/2026) ; 1 950 + 49 = 1 999 tiges (structure_resume.csv).

Des usages ont été cités pour [X] espèces. La catégorie de Cook (1995) la plus représentée est [X], avec [X] espèces, suivie de [X] (TABLEAU : USAGES PAR CATÉGORIE).
// TABLEAU : nombre d'espèces par catégorie d'usage de premier niveau (Cook, 1995), avec les usages cités ; codes de second niveau en annexe. Gabarit repris de l'ancien tableau <tab-usages> (commenté ci-dessous), valeurs à mettre à jour.

La liste de la faune compte [X] espèces : [X] observées directement ou par leurs indices de présence au cours des cheminements, et [X] citées seulement par les sources complémentaires (ANNEXE : liste de la faune). Les traces d'activités humaines rencontrées et les observations phénologiques sont données en annexe, à titre indicatif (ANNEXE : OBSERVATIONS COMPLÉMENTAIRES).
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
// ) <tab-usages>

=== Structure forestière

// Source : structure_resume.csv (copie de structure_resume_indices.csv) ; surface : courbe_raréfaction_extrapolation.csv (531,09 m² à 28 placettes) et message du script de structure (531,1 m²).
// Arrondis : deux décimales ; densités à l'hectare arrondies à l'unité (arbitrage auteur, 15/10/2026).
L'inventaire porte sur 1~999 tiges, tiges mesurées et gaulis, réparties dans 28 placettes, pour une surface horizontale cumulée de 531,1~m². Une placette compte en moyenne 71,39~±~26,41 tiges. La densité moyenne est de 37~569~±~13~506 tiges/ha et la surface terrière moyenne de 37,30~±~28,04~m²/ha (TABLEAU : STRUCTURE).

// TABLEAU : indicateurs de structure (moyenne ± écart-type entre placettes, IC 95 % par la loi de Student, n = 28).
// #figure(
//   table(
//     columns: (auto, auto, auto),
//     align: (left, center, center),
//     inset: 8pt,
//     [*Indicateur (unité)*], [*Moyenne ± écart-type (n = 28)*], [*IC 95 %*],
//     [Tiges par placette (tiges)], [71,39 ± 26,41], [[61,15 ; 81,63]],
//     [Densité N (tiges/ha)], [37~569 ± 13~506], [[32~332 ; 42~806]],
//     [Surface terrière G (m²/ha)], [37,30 ± 28,04], [[26,43 ; 48,17]],
//   ),
//   caption: [Indicateurs de structure forestière (28 placettes). Moyenne entre placettes ± écart-type ; IC 95 % : intervalle de confiance à 95 % par la loi de Student. Indicateurs rapportés à la surface horizontale. Les gaulis (tiges de plus de 1,30 m de haut et de CBH < 8 cm) sont inclus dans N et exclus de G. Valeurs par placette en annexe.],
// ) <tab-structure>
// Ligne N (tiges/m²) non reprise : redondante avec N (tiges/ha) (guide, critère 52) ; CSV : 3,76 ± 1,35 [3,23 ; 4,28].

// Source : 06_ecologie/analyse/sorties/structure_classes_ic95.csv.
La densité décroît de 28~426 tiges/ha dans la classe de diamètre 0-2,5~cm, qui comprend les gaulis, à 446 tiges/ha dans la classe 7,5-10~cm. Au-delà de 10~cm, elle ne dépasse pas 268 tiges/ha et varie irrégulièrement d'une classe à l'autre. Aucune tige de diamètre supérieur à 35~cm n'a été mesurée dans les placettes (FIGURE : CLASSES DE DIAMÈTRE).
// ATTENTION : la classe 27,5-30 cm est absente du CSV (aucune tige) ; à vérifier sur la figure.

// FIGURE : histogramme de la densité par classe de diamètre de 2,5 cm.
// #figure(
//   image("analyse-figures/structure_histogramme_classes.svg",
//     alt: "Histogramme de la densité de tiges par classe de diamètre de 2,5 cm, en échelle symétrique-logarithmique : la classe 0-2,5 cm domine, puis la densité décroît vers les grandes classes."),
//   caption: [Densité de tiges par classe de diamètre de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student, tronquées à zéro). Axe des ordonnées en échelle symétrique-logarithmique : linéaire près de zéro, logarithmique au-delà. Les gaulis sont inclus dans la classe 0-2,5~cm. Données en annexe.],
// ) <fig-hist-classes>

// Source : 06_ecologie/analyse/sorties/structure_G_classes.csv.
La surface terrière la plus élevée est celle de la classe 2,5-7,5~cm (10,43~m²/ha), suivie de la classe 22,5-27,5~cm (9,62~m²/ha). Les classes de 27,5 à 37,5~cm ont chacune une surface terrière inférieure à 1,7~m²/ha (FIGURE : G PAR CLASSE).

// FIGURE : surface terrière par classe de diamètre de 5 cm.
// #figure(
//   image("analyse-figures/structure_G_classes.svg",
//     alt: "Histogramme de la surface terrière par classe de diamètre de 5 cm, de 2,5 à 37,5 cm, avec un maximum dans la première classe et un second dans la classe 22,5-27,5 cm."),
//   caption: [Surface terrière par classe de diamètre de 5~cm, à partir du seuil de mesure de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student, tronquées à zéro). Les gaulis, non mesurés, sont exclus. Données en annexe.],
// ) <fig-G-classes>

// TODO : densité de chablis et de grands arbres (CBH ≥ 126 cm) à l'hectare — en attente des longueurs de transects (M&M, Transects). Ne rédiger aucune valeur avant.

=== Stock de carbone

// Source : 06_ecologie/analyse/sorties/carbone_stocks.csv (01/11/2026 ; E = 0,10, ρ = 0,58, facteurs MDP, graine 2026). Fichier à copier dans analyse-tables/.
Les tiges des placettes représentent un stock de 112,48~tC/ha (IC 95~% : [75,41~; 155,27]) et les grands arbres des transects un stock de 15,71~tC/ha ([10,72~; 20,70]) (TABLEAU : CARBONE). Le volume de bois mort au sol est de 22,47~m³/ha ([9,62~; 37,86]), pour un stock de 6,13~tC/ha ([2,62~; 10,32]) ; celui du bois mort sur pied est de 9,92~m³/ha ([2,90~; 18,45]), pour un stock de 2,70~tC/ha ([0,79~; 5,03]).
// TODO : stock total à l'hectare et stock de la forêt entière — à faire exporter par le script (pas de somme à la main) ; stock de la forêt en attente de la surface QGIS (500 ha provisoires dans le script).
// TODO : la surface prospectée pour les grands arbres ne compte que T05, T06 et T16 (3 930 m) ; valeur à reprendre après récupération des longueurs de T19 et T20.

// TABLEAU : stocks par compartiment (IC 95 % par bootstrap, 1 000 rééchantillonnages).
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     align: (left, center, center, center),
//     inset: 8pt,
//     [*Compartiment*], [*Biomasse (tMS/ha)*], [*Carbone (tC/ha)*], [*CO₂ (tCO₂/ha)*],
//     [Tiges des placettes], [199,43], [112,48 [75,41 ; 155,27]], [412,80 [276,77 ; 569,83]],
//     [Grands arbres des transects], [27,85], [15,71 [10,72 ; 20,70]], [57,65 [39,36 ; 75,98]],
//     [Bois mort au sol], [13,03], [6,13 [2,62 ; 10,32]], [22,48 [9,63 ; 37,88]],
//     [Bois mort sur pied], [5,75], [2,70 [0,79 ; 5,03]], [9,92 [2,91 ; 18,46]],
//   ),
//   caption: [Stocks de biomasse, de carbone et de CO₂ par compartiment. Entre crochets : IC 95 % par bootstrap (1~000 rééchantillonnages des placettes ou des transects). Biomasse vivante : biomasse aérienne seule ; le carbone et le CO₂ du vivant incluent la biomasse souterraine ($R = "0,20"$). Paramètres : $E = "0,10"$, $rho = "0,58"$~g/cm³, $"CF" = "0,47"$. Détail des volumes et des stocks extrapolés en annexe.],
// ) <tab-carbone>

=== Diversité alpha

// Source : diversite_alpha_resume.csv ; valeurs par placette : 06_ecologie/analyse/sorties/diversite_alpha_placettes.csv.
Une placette compte en moyenne 29,32~±~6,29 espèces. L'indice de Shannon moyen est de 3,03~±~0,26, soit 21,41~±~5,35 espèces communes effectives (¹D) ; l'inverse de Simpson donne 15,95~±~4,63 espèces dominantes effectives (²D) et l'alpha de Fisher 22,04~±~9,31 (TABLEAU : ALPHA). L'écart-type entre placettes est le plus élevé pour l'alpha de Fisher. Les indices de chaque placette figurent en annexe (ANNEXE : INDICES PAR PLACETTE).
// ¹D et ²D en forme brute (arbitrage auteur, 01/11/2026) ; ²D recalculé (1 / Σp²) dans fonctionsDiversite.R, alpha relancé le 01/11/2026. L'ancienne valeur corrigée (22,05) était supérieure à ¹D.

// TABLEAU : indices alpha (moyenne ± écart-type, IC 95 %, n = 28).
// #figure(
//   table(
//     columns: (auto, auto, auto),
//     align: (left, center, center),
//     inset: 8pt,
//     [*Indice (unité)*], [*Moyenne ± écart-type (n = 28)*], [*IC 95 %*],
//     [Richesse spécifique S = ⁰D (espèces)], [29,32 ± 6,29], [[26,88 ; 31,76]],
//     [Indice de Shannon H′ (sans unité)], [3,03 ± 0,26], [[2,93 ; 3,13]],
//     [exp(H′) = ¹D (espèces communes effectives)], [21,41 ± 5,35], [[19,33 ; 23,48]],
//     [²D, inverse de Simpson (espèces dominantes effectives)], [15,95 ± 4,63], [[14,15 ; 17,75]],
//     [Alpha de Fisher (sans unité)], [22,04 ± 9,31], [[18,43 ; 25,65]],
//   ),
//   caption: [Indices de diversité alpha par placette : moyenne entre 28 placettes ± écart-type ; IC 95 % par la loi de Student. Abondances : toutes les tiges comptées (tiges mesurées et gaulis), tiges indéterminées exclues. ¹D et ²D sous leur forme brute. Espèces : identités réconciliées. Valeurs par placette en annexe.],
// ) <tab-div-alpha>

=== Diversité bêta

// Sources : diversite_beta_resume_rapport.csv, diversite_beta_resume.csv, diversite_beta_whittaker.csv, diversite_beta_bray_niveaux.csv, diversite_beta_mono_commune.csv.
La richesse de l'ensemble des placettes ($gamma$ = 243 espèces) est 8,29 fois plus élevée que la richesse moyenne d'une placette ($macron(alpha)$ = 29,32 espèces). Le bêta additif est de 213,68 espèces. La dissimilarité de Bray-Curtis moyenne entre les 378 paires de placettes est de 0,81~±~0,09.

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

Sur les 243 espèces, 69,5~% ne sont observées que dans une seule commune, contre 49,6~% en moyenne lorsque les communes sont réattribuées au hasard aux placettes (999 permutations ; $p$ = 0,001).
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
Les 28 placettes totalisent 243 espèces observées. Tous les estimateurs donnent une richesse supérieure, de 287,19 espèces (bootstrap) à 384,89 espèces (jackknife d'ordre 2). Chao2, estimateur principal, donne 333,97 espèces (IC 95~% : [297,66~; 394,39]) ; toutes les autres estimations, sauf celle du bootstrap, sont comprises dans cet intervalle (TABLEAU : ESTIMATEURS).

// TABLEAU : estimateurs de la richesse totale.
// #figure(
//   table(
//     columns: (auto, auto, auto, auto),
//     align: (left, left, center, center),
//     inset: 8pt,
//     [*Estimateur*], [*Modèle (unité)*], [*Estimation (espèces)*], [*IC 95 %*],
//     [Chao2 (principal)], [Incidence (placette)], [333,97], [[297,66 ; 394,39]],
//     [Jackknife d'ordre 1], [Incidence (placette)], [339,43], [[295,35 ; 383,50]],
//     [Jackknife d'ordre 2], [Incidence (placette)], [384,89], [[346,08 ; 438,33]],
//     [ICE], [Incidence (placette)], [368,94], [[327,49 ; 430,71]],
//     [Bootstrap], [Incidence (placette)], [287,19], [[263,89 ; 310,49]],
//     [Chao1], [Abondance (tige)], [298,48], [[273,87 ; 342,73]],
//     [ACE], [Abondance (tige)], [316,34], [[298,73 ; 333,94]],
//   ),
//   caption: [Estimateurs asymptotiques de la richesse spécifique totale (28 placettes ; richesse observée $gamma_"obs"$ = 243 espèces, identités réconciliées, tiges indéterminées exclues). Chao2 est l'estimateur principal ; les autres sont donnés à titre de comparaison.],
// ) <tab-gamma>
// TODO : méthode de calcul des IC par estimateur (note §3.7 : transformation logarithmique pour Chao2, jackknife 2 et ICE ; approximation normale pour bootstrap, jackknife 1 et ACE ; intervalle exact pour Chao1) à confirmer dans estimation_richesse_specifique.R avant de l'écrire en légende.

À 28 placettes (531,1~m²), la couverture d'échantillonnage est de 0,88 (IC 95~% : [0,86~; 0,90]). Extrapolée à 112 placettes, soit quatre fois la surface prospectée (2~124~m²), la richesse atteint 330,39 espèces ([295,72~; 365,06]) pour une couverture de 0,995 (FIGURE : RARÉFACTION).
// TODO (à faire, auteur) : lire la courbe (SVG du 31/10/2026) et décrire sa forme (plateau ou non).

// FIGURE : courbe de raréfaction-extrapolation (incidence, q = 0).
// #figure(
//   image("analyse-figures/courbe_raréfaction_extrapolation.svg",
//     alt: "Courbe de richesse spécifique en fonction de la surface cumulée, interpolée jusqu'à 531 m² puis extrapolée jusqu'à environ 2 124 m², avec sa bande de confiance."),
//   caption: [Richesse spécifique (modèle d'incidence, ordre $q$ = 0) en fonction de la surface horizontale cumulée : interpolation de 1 à 28 placettes (point de référence : 531,1~m², 243 espèces), puis extrapolation jusqu'à 112 placettes, soit quatre fois la surface prospectée. Bande grise : IC 95~% par bootstrap. Données en annexe.],
// ) <fig-rarefaction>

== Enquête sociale

// Ici on abordera les résultats des entretiens dans l'ordre des questions de la problématique !