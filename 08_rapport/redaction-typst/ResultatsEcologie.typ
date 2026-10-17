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

// Transféré du brouillon « redaction-foresterie-brouillon » — esquisses de tableaux :
// Tableau 1 — sources ayant prospecté la faune/flore de la forêt :
//   [Source][Effort de prospection en jours][Espèces animales (vern/scie)][Espèces végétales (vern/sci)]
//   [Romiguière (2025)], [4], [], [], [],],
//   [Document de transfert de gestion (2004)], [?], [], [], [],],
//   [DREDD], [?], [], [], [],],
//   [Mollusques (200~8)], [2 ?], [0], [], [],
//   [Lémuriens], [1 ou 2], [0], [], [],
// Tableau 2 — sources identifiées ayant réalisé des relevés écologiques dans la forêt
// de Tsiazombazaha :
//   [Source], [Nombre de tiges], [Nombre d'espèces],
//   [], [], [],
//   [], [], [],
// TODO : saisir ces tableaux quand les sources seront consolidées.

== Analyse des données écologiques

=== Listes d'espèces et usages => à refaire // en cours d'être refait CF Claue, donner les infos nécessaires

// // TODO date-jeu-de-données : liste définitive issue de la fusion PR #2 ; revalider avant dépôt.

// Au total, 335 noms vernaculaires normalisés ont été relevés dans les relevés de terrain et les sources complémentaires ; leur réconciliation manuelle aboutit à 230 identités d'espèces perçues localement. Sur les 229 identités de la liste définitive, 130 disposent d'une identification botanique au sens large : 61 avec un taxon proposé (genre, espèce) et 69 avec une correspondance concordante vers au moins deux genres différents à partir des deux sources utilisées (Schatz, 2001 ; dictionnaire des noms malgaches de végétaux // TODO : référence exacte de la source en ligne à préciser).

// Les identités comportent en moyenne 1,60 ± 0,64 types phénotypiques (IC 95 % : [1,50 ; 1,70] ; n = 180 espèces pour lesquelles le nombre de types est documenté, en retenant le maximum observé). Cette moyenne masque une distribution dissymétrique : 86 espèces n'ont qu'un type décrit, 81 en ont deux, 12 en ont trois et une en a quatre. Les distinctions rapportées entre types sont le plus souvent liées à la taille ou à la couleur des feuilles, au port, ou à l'habitat (forêt ou village).

// // Esquisse du brouillon « redaction-foresterie-brouillon » (« Diversité spécifique /
// // Chao2 ») : « X noms vernaculaires ont été relevés. En moyenne, chaque nom
// // vernaculaire correspond à X±y types vernaculaires. » Tableau [Nombre de types][Nombre
// // de noms vernaculaires] : 1→X, 2→Y, 3→Z, 4→W — correspond à la distribution validée
// // ci-dessus (86 / 81 / 12 / 1).

// // Valeurs recalculées sur liste_especes_vegetales_definitive.csv le 2026-10-08 (règle : max observé).
// // La note §3.1 donnait n=181, 1,59±0,64, 89/79/12/1 — écart de version, le CSV fait foi.

// Soixante-dix espèces ont au moins un usage rapporté et classé ; parmi elles, le nombre moyen d'usages est de 1,27 ± 0,51. Les 28 mentions « aucun » correspondent à un usage non rapporté lors de l'enquête, et non à une plante sans usage — dix de ces espèces ont d'ailleurs un usage rapporté par une autre source. Dix-sept espèces supplémentaires ont une mention d'usage non renseignée (NA), sans qu'on puisse conclure à l'absence d'usage.

// La répartition des usages par catégorie du standard Cook (1995) est dominée par les matériaux : 48 espèces sur les 70 à usage rapporté et classé (Tableau @tab-usages). Les usages détaillés de cette catégorie relèvent presque tous de la construction et du bois d'œuvre — poutres, planches, menuiserie, charpente, manches d'outils, tressage. Viennent ensuite les usages médicinaux (11 espèces), les usages sociaux et rituels (9 espèces, dont des usages magiques et un usage anti-foudre), l'alimentation (3), les combustibles (2), les usages environnementaux (2) et les poisons (1).

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
//   caption: [Répartition des 69 espèces à usage rapporté par catégorie de premier niveau de la classification Cook (1995). Les usages cités sont les usages de second niveau ; leurs codes figurent en annexe.],
// ) <tab-usages>

// // Règle de gestion des tableaux (décision auteur, phase de saisie en cours) :
// //   - petits tableaux du corps : saisie manuelle, à mettre à jour à la main quand les
// //     CSV évoluent (tout est évolutif tant que la saisie des 28 placettes n'est pas finie) ;
// //   - gros tableaux d'annexe (liste des 230 espèces, association espèce×usage) :
// //     import CSV dynamique (Typst csv()) — à mettre en place quand les annexes sont
// //     créées ; en attendant, renvoi annexe en commentaire.
// // Ce tableau : valeurs vérifiées sur usages_especes_par_classe.csv le 2026-10-08 —
// // revalider à chaque évolution du CSV tant que la saisie n'est pas close.

// === Diversité animale // inclus dans liste esp/usages en fait

// // Transféré du brouillon « redaction-foresterie-brouillon » — placeholders X à compléter.

// Nos observations et nos échanges ont pu relever X noms vernaculaires d'espèces animales.
// L'identification taxonomique des espèces animales n'a pas été abordée. Les identifications rapportées
// dans la table X sont celles issues de la littérature.

// // Tableau esquisse (brouillon) :
// //   [Taxon][Nombre d'espèces vernaculaires][Nombre d'espèces vernaculaires]
// //   [Mammifères], [], [], (note de bas de page : il convient d'exclure Homo sapiens)
// //   [Serpents], [], [],
// //   [Oiseaux], [], [],
// //   [Mollusques], [], [],
// //   [0], [], [],

// La liste complète des espèces comportant les noms détaillés, les correspondances taxonomique et les sources
// pour l'observation de chaque espèce est disponible en annexe.

// // En attente (ne pas rédiger) : diversité bêta (§3.5), IVI (§3.6), estimateurs de
// // richesse (§3.7), stock de carbone (§3.3 — valeurs disponibles mais chantier en cours
// // de validation par l'autre session), analyses complémentaires (§3.8).

=== Structure forestière

// Valeurs : analyse_tables/structure_resume.csv (n = 28 placettes, 1 998 tiges).
// TODO date-jeu-de-données : reporter la date d'exécution du CSV avant dépôt.
// Arrondis (arbitrage auteur, 2026-10-15) : deux décimales par défaut ; densités à
// l'hectare arrondies à l'unité.
// Figures : chemins analyse_figures/ (consigne auteur), en remplacement des chemins
// 06_ecologie/analyse/sorties/ du brouillon précédent.

L'inventaire porte sur 1~998 tiges réparties dans 28 placettes, pour une surface horizontale cumulée de 549,4~m². La densité moyenne est de 36~365~±~13~461 tiges/ha et la surface terrière moyenne de 35,95~±~26,79~m²/ha (@tab-structure).
// TODO : valeur à valider. 549,4 m² vient de l'état d'avancement (note P2 du
// 09/10/2026), pas d'un CSV de sortie.

// Ligne N (tiges/m²) retirée du tableau : redondante avec N (tiges/ha) (guide, critère 52).
// Elle reste dans le CSV : 3,64 ± 1,35 [3,11 ; 4,16].
// ATTENTION : alignement des valeurs (centré, comme dans main.typ, ou à droite) à voir
// avec le référent.
#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 8pt,
    [*Indicateur (unité)*], [*Moyenne ± écart-type (n = 28)*], [*IC 95 %*],
    [Tiges par placette (tiges)], [71,36 ± 26,45], [[61,10 ; 81,61]],
    [Densité N (tiges/ha)], [36~365 ± 13~461], [[31~146 ; 41~585]],
    [Surface terrière G (m²/ha)], [35,95 ± 26,79], [[25,57 ; 46,34]],
  ),
  caption: [Indicateurs de structure forestière du dispositif (28 placettes). Moyenne entre placettes ± écart-type ; IC 95 % : intervalle de confiance à 95 % calculé par la loi de Student entre placettes. Indicateurs rapportés à la surface horizontale. Les gaulis (tiges < 1,30 m) sont inclus dans N et exclus de G.],
) <tab-structure>

La densité de tiges décroît depuis la classe de diamètre 0–2,5~cm, qui inclut les gaulis, vers les grandes classes (@fig-hist-classes).
// Option retenue (arbitrage auteur, 2026-10-15) : pas de valeur par classe dans le texte,
// la figure porte les chiffres (guide, critère 51).
// ANNEXE : y placer structure_classes_ic95.csv (densité et IC 95 % par classe), données
// de la figure (guide, critère 80), et renvoyer à cette annexe en légende (critère 53).
// TODO : demander à la session R de déposer ce CSV dans analyse_tables/, puis vérifier la
// lecture « décroît » sur la figure à 28 placettes.

#figure(
  image("analyse_figures/structure_histogramme_classes.svg",
    alt: "Histogramme de la densité de tiges par classe de diamètre de 2,5 cm, en échelle symétrique-logarithmique : la classe 0-2,5 cm domine, puis la densité décroît vers les grandes classes."),
  caption: [Densité de tiges par classe de diamètre de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student). Axe des ordonnées en échelle symétrique-logarithmique : linéaire près de zéro, logarithmique au-delà. Pour les classes rares, la borne inférieure de l'IC est négative et la barre est tronquée à zéro. Les gaulis (< 1,30 m) sont inclus dans la classe 0–2,5~cm.],
) <fig-hist-classes>

La surface terrière se répartit sur l'ensemble des classes de diamètre (@fig-G-classes).
// Option retenue (arbitrage auteur, 2026-10-15) : pas de valeur par classe dans le texte,
// la figure porte les chiffres (guide, critère 51).
// ANNEXE : y placer structure_G_classes.csv (G et IC 95 % par classe), données de la
// figure (guide, critère 80), et renvoyer à cette annexe en légende (critère 53).
// TODO : demander à la session R de déposer ce CSV dans analyse_tables/, puis vérifier sur
// la figure à 28 placettes la position du maximum et d'un éventuel pic secondaire avant de
// les décrire.

#figure(
  image("analyse_figures/structure_G_classes.svg",
    alt: "Histogramme de la surface terrière par classe de diamètre de 5 cm, de 2,5 à 37,5 cm."),
  caption: [Surface terrière par classe de diamètre de 5~cm, bornes décalées depuis le seuil de mesure effectif de 2,5~cm (moyenne entre 28 placettes ; barres : IC 95 % par la loi de Student, tronquées à zéro). Les gaulis, non mesurés, sont exclus.],
) <fig-G-classes>

À l'échelle de la placette, la densité de la régénération (gaulis/ha) et celle des tiges de DBH ≥ 12,5~cm ne sont pas significativement corrélées au seuil de 5~% (Pearson r = −0,35 ; p = 0,07 ; @fig-regen).
// Valeurs lues sur la figure structure_regeneration.svg (aucun CSV de corrélation dans
// analyse_tables/).
// ATTENTION : la note §3.2 et l'ancien texte donnent r = −0,39 ; p = 0,058 ; n = 17.
// La figure, plus récente, fait foi.
// TODO : n placettes et p du Spearman à reprendre dans une sortie R.

#figure(
  image("analyse_figures/structure_regeneration.svg",
    alt: "Nuage de points par placette : densité de gaulis en fonction de la densité des tiges de DBH supérieur ou égal à 12,5 cm, tendance faiblement négative."),
  caption: [Densité de la régénération (gaulis/ha) en fonction de la densité des tiges de DBH ≥ 12,5~cm, par placette (n = TODO). Corrélation de Pearson r = −0,35 (p = 0,07, ns) ; corrélation de Spearman ρ = −0,33.],
) <fig-regen>

// TODO : indicateurs transects (chablis/ha, grands arbres DBH > 40 cm/ha) bloqués
// (3 945 m saisis sur ~6 000 m). Ne pas rédiger de valeurs.

=== Diversités alpha et bêta

En moyenne, une placette compte 30 espèces (@tab-div-alpha). Les nombres effectifs d'espèces communes (¹D) et d'espèces dominantes (²D) ont des moyennes proches ; la dispersion entre placettes est la plus forte pour ²D et pour l'α de Fisher. Les indices de chaque placette figurent en annexe.

// ANNEXE : y placer diversite_alpha_placettes.csv (absent de analyse_tables/, à demander
// à la session R) et renvoyer à cette annexe en légende du tableau.

// L’inversion ²D > ¹D vient surtout de cette comparaison entre un estimateur corrigé et un estimateur brut.
// Le vrai problème est le mélange des estimateurs :
// ¹D = exp(H′) est calculé « brut », et il est biaisé vers le bas en petit échantillon ;
// ²D est corrigé, donc tiré vers le haut.
// Il faut demander à la session R d’utiliser des estimateurs homogènes. Deux options :
// (a) les deux bruts ;
// (b) les deux corrigés, avec les estimateurs asymptotiques de Hill (Chao et al., 2014, Ecological Monographs, 84(1), 45–67, https://doi.org/10.1890/13-0133.1 // REF?), disponibles dans iNEXT.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 8pt,
    [*Indice (unité)*], [*Moyenne ± écart-type (n = 28)*], [*IC 95 %*],
    [Richesse spécifique S = ⁰D (espèces)], [30 ± 6,19], [[27,6 ; 32,4]],
    [Indice de Shannon H′ (sans unité)], [3,06 ± 0,25], [[2,96 ; 3,15]],
    [exp(H′) = ¹D (espèces communes effectives)], [21,91 ± 5,06], [[19,95 ; 23,88]],
    [²D, inverse de Simpson (espèces dominantes effectives)], [22,56 ± 8,6], [[19,23 ; 25,89]],
    [α de Fisher (sans unité)], [22,49 ± 9,24], [[18,91 ; 26,07]],
  ),
  caption: [Indices de diversité alpha par placette : moyenne entre 28 placettes ± écart-type ; IC 95 % : intervalle de confiance à 95 % par la loi de Student entre placettes. Abondances : toutes les tiges comptées (tiges mesurées et gaulis). Espèces : identités réconciliées, chaque individu indéterminé comptant pour une espèce distincte dans sa placette.],
) <tab-div-alpha>

// Figures optionnelles (note alpha), gardées en réserve sur décision de l'auteur :
// boxplot des indices par placette ; nuage S en fonction de ln(N).

À l'échelle du dispositif, la richesse totale dépasse d'environ huit fois la richesse moyenne d'une placette (bêta multiplicatif, @tab-div-beta).

// Whittaker.  la session R doit recalculer avec γ / ᾱ (actuellement (γ / ᾱ) - 1 visiblement)
// ATTENTION : le CSV bêta utilise γ = 262, une valeur proche de ton gamma « toutes observations » (261). Or ᾱ ne porte que sur les placettes. γ doit donc porter sur les mêmes placettes, soit 243 ou 244, sinon le rapport mélange deux échelles. Il faut le préciser à la session R. Cela touche aussi le bêta additif (232) et la part d’espèces vues dans une seule commune (n = 262).

#figure(
  table(
    columns: (auto, auto),
    align: (left, center),
    inset: 8pt,
    [*Indice (unité)*], [*Valeur*],
    [Bêta multiplicatif de Whittaker (sans unité)], [7,73],
    [Bêta additif de Lande (espèces)], [232],
    [Dissimilarité de Bray-Curtis moyenne (sans unité)], [0,81 ± 0,09],
  ),
  caption: [Diversité bêta du dispositif (28 placettes ; richesse totale γ = 262 espèces ; richesse moyenne par placette ᾱ = 30 espèces). Dissimilarité de Bray-Curtis : moyenne ± écart-type sur les 378 paires de placettes, calculée sur les abondances des espèces réconciliées.],
) <tab-div-beta>

La dissimilarité de Jaccard entre deux placettes varie selon le niveau spatial qu'elles partagent (Kruskal-Wallis, p < 0,001 ; @fig-beta-gradient). Elle ne diffère pas significativement entre les paires d'un même transect et celles d'un même polisn'ala (p = 0,07, ns). Elle est plus élevée entre les paires d'une même commune qu'entre celles d'un même polisn'ala (p < 0,001), et plus élevée encore entre placettes de communes différentes (p < 0,001). En abondances (Bray-Curtis), en revanche, les paires d'une même commune et celles de communes différentes ne se distinguent pas (0,84 ± 0,06 contre 0,83 ± 0,06 ; p = 0,36, ns).
// Sources : diversite_beta_resume_rapport.csv (p-values Holm ; « 0 » écrit p < 0,001).
// TODO : le sens des écarts en Jaccard vient de la note bêta. Les moyennes de Jaccard par
// niveau ne sont pas dans analyse_tables/ : vérifier sur la figure ou les faire exporter.

#figure(
  image("analyse_figures/diversite_beta_gradient.svg",
    alt: "Boîtes à moustaches de la dissimilarité de Jaccard entre paires de placettes, pour quatre niveaux spatiaux ordonnés du même transect aux communes différentes."),
  caption: [Dissimilarité de Jaccard (présence-absence, espèces réconciliées) entre paires de placettes, selon le niveau spatial partagé : même transect (n = 37 paires), même polisn'ala (n = 16), même commune (n = 70), entre communes (n = 255, paires ne partageant ni transect, ni polisn'ala, ni commune). Test global : Kruskal-Wallis, p < 0,001. Comparaisons deux à deux : test de Wilcoxon avec correction de Holm ; \*\*\* p(H₀) < 0,001 ; ns : non significatif.],
) <fig-beta-gradient>
// TODO : définir les moustaches en légende (guide, critère 59). Par défaut dans ggplot2 :
// 1,5 fois l'écart interquartile, à confirmer avec la session R.

Dans l'ordination NMDS, les placettes d'un même transect ne forment pas de groupe distinct (@fig-beta-nmds). Par ailleurs, 71,8~% des espèces ne sont observées que dans une seule commune, contre 53,2~% attendus si les placettes étaient réparties au hasard entre communes (test par permutation, p = 0,001).
// TODO : vérifier la lecture de la NMDS sur la figure à 28 placettes.
// TODO : nombre de permutations (999 d'après la note) à confirmer, absent du CSV.
// La note donne 71,3 % et 53 % ; le CSV (0,718 et 0,532, n = 262 espèces) fait foi.
// La ligne « noms vernaculaires bruts » du CSV (80,6 %) est un contrôle de la
// réconciliation : à citer en M&M ou en Discussion, pas ici.

#figure(
  image("analyse_figures/diversite_beta_nmds.svg",
    alt: "Plan d'ordination NMDS à deux dimensions des 28 placettes, un symbole par transect, sans regroupement net par transect."),
  caption: [Ordination NMDS en deux dimensions des 28 placettes, sur la dissimilarité de Bray-Curtis (abondances, espèces réconciliées) ; stress = 0,22. Deux points proches correspondent à des placettes de composition proche. Chaque symbole représente un transect. Coordonnées par placette en annexe.],
) <fig-beta-nmds>
// ANNEXE : diversite_beta_nmds_points.csv (coordonnées avec transect, polisn'ala et
// commune) et diversite_beta_paires.csv (378 paires).

=== Richesse spécifique totale

// ATTENTION (gamma observé) : 244 dans le CSV et sur la figure, 243 dans la note §3.7.
// Vérification en cours par l'auteur (espèce inconnue ou en-tête compté ?).

Les 28 placettes totalisent 244 espèces observées. Tous les estimateurs donnent une richesse supérieure à cette valeur (@tab-gamma). Les sept estimations vont de 288,19 espèces (bootstrap) à 385,89 espèces (jackknife d'ordre 2) ; Chao2 donne 334,97 espèces (IC à 95~% : [298,66~; 395,39]). Toutes les estimations, à l'exception du bootstrap, se situent dans cet intervalle.

Les 28 placettes totalisent 244 espèces observées. Tous les estimateurs donnent une richesse supérieure à cette valeur (@tab-gamma). Les sept estimations vont de 288,19 espèces (bootstrap) à 385,89 espèces (jackknife d'ordre 2) ; Chao2, estimateur principal, donne 334,97 espèces (IC à 95~% : [298,66~; 395,39]).
// Pas de test de différence entre estimateurs : comparaison et interprétation à réserver à la Discussion.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, left, center, center),
    inset: 8pt,
    [*Estimateur*], [*Modèle (unité)*], [*Estimation (espèces)*], [*IC 95 %*],
    [Chao2 (principal)], [Incidence (placette)], [334,97], [[298,66 ; 395,39]],
    [Jackknife d'ordre 2], [Incidence (placette)], [385,89], [[347,08 ; 439,33]],
    [ICE], [Incidence (placette)], [370,99], [[329,32 ; 433,02]],
    [Bootstrap], [Incidence (placette)], [288,19], [[264,89 ; 311,49]],
    [Jackknife d'ordre 1], [Incidence (placette) / abondance vérifier !], [340,43], [[296,35 ; 384,50]],
    [Chao1], [Abondance (tige)], [326,62], [[299,10 ; 374,57]],
    [ACE], [Abondance (tige)], [345,44], [[327,00 ; 363,87]],
  ),
  caption: [Estimateurs asymptotiques de la richesse spécifique totale (28 placettes~; richesse observée γ#sub[obs] = 244 espèces, identités réconciliées). Chao2 est l'estimateur principal ; les autres estimateurs sont rapportés à titre indicatif. IC 95~% : transformation logarithmique pour Chao2, le jackknife d'ordre 2 et ICE ; approximation normale pour le bootstrap, le jackknife d'ordre 1 et ACE ; intervalle exact pour Chao1.],
) <tab-gamma>
// TODO : méthodes de calcul des IC reprises de la note §3.7, à confirmer avec la session R.

La courbe de raréfaction-extrapolation n'atteint pas de plateau, ni sur la surface prospectée ni dans la plage extrapolée, et sa bande de confiance s'élargit au-delà du point de référence (@fig-rarefaction).
// TODO : lecture faite sur le SVG, à confirmer. courbe_raréfaction_extrapolation.csv est
// absent de analyse_tables/ : à placer en annexe (guide, critère 80).
// ATTENTION (M&M) : extrapolation jusqu'à quatre fois la surface prospectée, alors que les
// auteurs de la méthode recommandent au plus le double. Choix à justifier en M&M.

#figure(
  image("analyse_figures/courbe_raréfaction_extrapolation.svg",
    alt: "Courbe de richesse spécifique en fonction de la surface cumulée, croissante sans plateau jusqu'à environ 2 200 m², avec une bande de confiance qui s'élargit au-delà de la surface prospectée."),
  caption: [Richesse spécifique (modèle d'incidence, ordre q = 0) en fonction de la surface horizontale cumulée : interpolation de 1 à 28 placettes (point de référence : 549,4~m², 244 espèces), puis extrapolation jusqu'à 112 placettes, soit quatre fois la surface prospectée. Bande grise : IC 95~% par bootstrap.],
) <fig-rarefaction>
// TODO : vérifier sur la figure les styles de trait (interpolation, extrapolation, point de
// référence) et la ligne verticale à 549,4 m², puis les décrire en légende.

=== Espèces dominantes

// REPRISE (état au 2026-10-15) : recalcul de ivi_especes.csv en cours (28 placettes ;
// nombre d'espèces à confirmer). Tous les chiffres ci-dessous viennent de l'ancien CSV :
// PROVISOIRES. Après recalcul : (1) relire le nouveau CSV ; (2) revérifier les
// affirmations [IVI-1] à [IVI-5] ; (3) mettre à jour tableau et légende ; (4) restaurer
// la phrase d'effectifs [IVI-0]. La note NOTE_CONTEXTE_3_6_IVI.md est obsolète (24
// placettes, 488 tiges) : le CSV prime.
// Arbitrages auteur : IVI normalisé (÷ 3) ; interprétations (espèce structurante,
// turnover, espèces rares mais localement dominantes) réservées à la Discussion.
// Arrondis : deux décimales.

// [IVI-0] À restaurer après recalcul : « Le classement porte sur [N] espèces, représentées
// par [n] tiges mesurées dans [p] placettes (@tab-ivi). »
// Ancien CSV, non retenu : 129 espèces dont au moins 4 indéterminées, 488 tiges, 24 placettes.

L'IVI le plus élevé est celui de Babogna (6,52~%), devant Ambora (4,97~%) et Hazomainty (4,89~%) (@tab-ivi).
// [IVI-1] Vérifier : rangs 1 à 3 et leurs IVI.
Babogna présente la dominance relative la plus forte (9,93~%) et la fréquence relative la plus forte (4,50~%, 14 placettes) ; la densité relative la plus forte est celle de Hazomainty (5,94~%, 29 tiges).
// [IVI-2] Vérifier : maxima de DoR, FR et DR sur tout le CSV. Une espèce hors du top 15 ne
// peut détenir un maximum que si sa composante dépasse celle du top (IVI ≥ composante / 3).
Six espèces ont un IVI supérieur à 3,5~%, et il est inférieur à 1,5~% à partir du rang 18.
// [IVI-3] Vérifier : nombre d'espèces à IVI > 3,5 ; premier rang à IVI < 1,5.

Les trois composantes divergent pour certaines espèces. Ramiavogna et Sary, représentées par deux tiges chacune, atteignent une dominance relative de 4,98~% et de 4,48~%. Hasina, présente dans 12 placettes, a une fréquence relative de 3,86~% mais une dominance relative de 1,26~%.
// [IVI-4] Vérifier : nbTiges, DoR, nbPlacettes, FR de ces trois espèces.
Du rang 76 au rang 129, chaque espèce n'est représentée que par une ou deux tiges mesurées.
// [IVI-5] Vérifier : plage de rangs où nbTiges ≤ 2 (le nombre total d'espèces change).

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (center, left, center, center, center, center),
    inset: 8pt,
    [*Rang*], [*Espèce*], [*DR (%)*], [*DoR (%)*], [*FR (%)*], [*IVI (%)*],
    [1], [Babogna], [5,12], [9,93], [4,50], [6,52],
    [2], [Ambora], [4,51], [7,20], [3,22], [4,97],
    [3], [Hazomainty], [5,94], [4,53], [4,18], [4,89],
    [4], [Menafatagna], [4,51], [5,01], [3,54], [4,35],
    [5], [Voapaka], [2,87], [5,85], [2,57], [3,76],
    [6], [Tsimahamasasokona], [4,30], [3,33], [3,54], [3,72],
    [7], [Randripody], [3,69], [1,33], [3,22], [2,74],
    [8], [Hasina], [3,07], [1,26], [3,86], [2,73],
    [9], [Hazombary], [3,48], [2,40], [1,61], [2,50],
    [10], [Sagnira], [1,64], [3,47], [1,61], [2,24],
    [11], [Kijy], [1,43], [3,23], [1,93], [2,20],
    [12], [Ramiavogna], [0,41], [4,98], [0,64], [2,01],
    [13], [Vilogna], [2,25], [0,76], [2,57], [1,86],
    [14], [Sary], [0,41], [4,48], [0,64], [1,84],
    [15], [Tsirika], [2,66], [0,61], [1,93], [1,74],
  ),
  caption: [Les quinze espèces de plus fort indice de valeur d'importance (IVI), pour l'ensemble du dispositif (28 placettes ; tiges mesurées uniquement, gaulis exclus). DR : densité relative (part des tiges) ; DoR : dominance relative (part de la surface terrière) ; FR : fréquence relative (part des occurrences en placette). IVI = (DR + DoR + FR) / 3, la somme sur l'ensemble des espèces valant 100~%. Espèces : identités réconciliées ; traitement des individus indéterminés à préciser. Classement complet en annexe.],
) <tab-ivi>
// TODO : tableau et légende à régénérer après recalcul (valeurs, rangs, nombre de
// placettes, traitement des indéterminés).
// ANNEXE : liste complète (ivi_especes.csv) par import dynamique csv() dans Annexes.typ
// (« Liste des plantes établie ... avec IVI ») ; renvoyer à l'annexe en légende.
// OPTION : courbe rang-IVI ou part cumulée de l'IVI, à demander à la session R.

=== Bois mort et stock de carbone (§3.3) => à faire

// En attente de validation (ne pas rédiger — cf. note de contexte PR #5 : paramètres
// E et ρ provisoires, valeurs préliminaires ; et M&M « Analyses en attente »).
// Contenu du brouillon « redaction-foresterie-brouillon » (« Diversité végétale >
// Statistiques descriptives »), à revalider avant rédaction :
//   « Le volume de bois mort estimé est de 38 m³/ha (IC à 95 % : [18 ; 58 m³/ha]).
//   Cette valeur est cohérente avec les forêts tropicales humides primaires
//   (20–60 m³/ha ; Chao et al., 2008), bien que légèrement élevée pour une forêt
//   secondaire. La marge d'erreur élevée (±15 m³/ha) est due à la faible longueur
//   totale des transects (120 m) et à la présence de quelques grands bois
//   (ex. : 141 cm de circonférence). »

