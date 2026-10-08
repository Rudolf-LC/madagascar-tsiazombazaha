// Résultats — volet écologie (§3.1, §3.2, §3.4 validés).
// Règle (guide GEEFT, critère 49) : pas de comparaison avec la littérature ni
// d'interprétation ici — tout va en Discussion.
// Valeurs : issues des CSV à la date de rédaction. La saisie continue : chaque valeur
// citée porte son n et un // TODO date-jeu-de-données pour revalidation avant dépôt.
// Figures : importées depuis leur chemin canonique, jamais copiées.

= Résultats

== Listes d'espèces et usages (§3.1)

// TODO date-jeu-de-données : liste définitive issue de la fusion PR #2 ; revalider avant dépôt.

Au total, 335 noms vernaculaires normalisés ont été relevés dans les relevés de terrain et les sources complémentaires ; leur réconciliation manuelle aboutit à 230 identités d'espèces perçues localement. Sur les 229 identités de la liste définitive, 130 disposent d'une identification botanique au sens large : 61 avec un taxon proposé (genre, espèce) et 69 avec une correspondance concordante vers au moins deux genres différents à partir des deux sources utilisées (Schatz, 2001 ; dictionnaire des noms malgaches de végétaux // TODO : référence exacte de la source en ligne à préciser).

Les identités comportent en moyenne 1,60 ± 0,64 types phénotypiques (IC 95 % : [1,50 ; 1,70] ; n = 180 espèces pour lesquelles le nombre de types est documenté, en retenant le maximum observé). Cette moyenne masque une distribution dissymétrique : 86 espèces n'ont qu'un type décrit, 81 en ont deux, 12 en ont trois et une en a quatre. Les distinctions rapportées entre types sont le plus souvent liées à la taille ou à la couleur des feuilles, au port, ou à l'habitat (forêt ou village).

// Valeurs recalculées sur liste_especes_vegetales_definitive.csv le 2026-10-08 (règle : max observé).
// La note §3.1 donnait n=181, 1,59±0,64, 89/79/12/1 — écart de version, le CSV fait foi.

Soixante-dix espèces ont au moins un usage rapporté et classé ; parmi elles, le nombre moyen d'usages est de 1,27 ± 0,51. Les 28 mentions « aucun » correspondent à un usage non rapporté lors de l'enquête, et non à une plante sans usage — dix de ces espèces ont d'ailleurs un usage rapporté par une autre source. Dix-sept espèces supplémentaires ont une mention d'usage non renseignée (NA), sans qu'on puisse conclure à l'absence d'usage.

La répartition des usages par catégorie du standard Cook (1995) est dominée par les matériaux : 48 espèces sur les 70 à usage rapporté et classé (Tableau @tab-usages). Les usages détaillés de cette catégorie relèvent presque tous de la construction et du bois d'œuvre — poutres, planches, menuiserie, charpente, manches d'outils, tressage. Viennent ensuite les usages médicinaux (11 espèces), les usages sociaux et rituels (9 espèces, dont des usages magiques et un usage anti-foudre), l'alimentation (3), les combustibles (2), les usages environnementaux (2) et les poisons (1).

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, left),
    inset: 8pt,
    [*Catégorie d'usage (Cook, 1995)*], [*Nombre d'espèces*], [*Usages cités*],
    [Matériaux], [48], [balai, batan, bois de construction, canaux d'irrigation, construction de maison, corde, fixation de toiture, guitare, manche de bêche, menuiserie, panier, pilon, pirogue, planche, plancher, poutre, tressage],
    [Médicaments], [11], [aphrodisiaque, douleurs dentaires, fatigue, gonflements, usage médicinal],
    [Usages sociaux], [9], [anti-foudre, magie],
    [Alimentation], [3], [écorce sucrée, fruit comestible, thé],
    [Combustibles], [2], [bois de chauffage],
    [Usages environnementaux], [2], [haie],
    [Poisons des non-vertébrés], [1], [insecticide],
  ),
  caption: [Répartition des 69 espèces à usage rapporté par catégorie de premier niveau de la classification Cook (1995). Les usages cités sont les usages de second niveau ; leurs codes figurent en annexe.],
) <tab-usages>

// Règle de gestion des tableaux (décision auteur, phase de saisie en cours) :
//   - petits tableaux du corps : saisie manuelle, à mettre à jour à la main quand les
//     CSV évoluent (tout est évolutif tant que la saisie des 28 placettes n'est pas finie) ;
//   - gros tableaux d'annexe (liste des 230 espèces, association espèce×usage) :
//     import CSV dynamique (Typst csv()) — à mettre en place quand les annexes sont
//     créées ; en attendant, renvoi annexe en commentaire.
// Ce tableau : valeurs vérifiées sur usages_especes_par_classe.csv le 2026-10-08 —
// revalider à chaque évolution du CSV tant que la saisie n'est pas close.

== Structure forestière (§3.2)

// TODO date-jeu-de-données : 24 placettes saisies sur 28 (4 restent à saisir) ;
// 549,4 m2 horizontaux ; N total = 1 761 tiges. TOUS ces effectifs, surfaces et n
// évolueront avec la saisie finale — revalider chaque valeur sur les CSV à jour avant dépôt.
// Arbitrage auteur : 28 placettes au total ; G actuellement calculé sur les placettes
// saisies comportant des mesures de CBH (24) — la note « une placette sans mesure ? »
// est résolue : ce sont les 4 placettes non saisies, pas une anomalie de données.

Sur l'ensemble du dispositif, 1 761 tiges ont été comptées sur 25 placettes (549,4 m2 horizontaux). La densité moyenne est de 35 901 ± 15 885 tiges/ha (IC 95 % : [29 344 ; 42 458] ; n = 25), soit 70,4 ± 31,2 tiges par placette de 20 m2 et 3,59 ± 1,59 tiges/m2. La surface terrière moyenne est de 36,3 ± 27,7 m2/ha (IC 95 % : [24,6 ; 48,0] ; n = 24 placettes saisies comportant des tiges mesurées). Les indicateurs principaux sont récapitulés dans le Tableau @tab-structure.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: 8pt,
    [*Indicateur*], [*Moyenne*], [*Écart-type*], [*IC 95 %*], [*n*],
    [Nombre total de tiges comptées, tiges], [1 761], [—], [—], [25],
    [Tiges par placette, tiges], [70,4], [31,2], [[57,6 ; 83,3]], [25],
    [Densité N, tiges/m2], [3,59], [1,59], [[2,93 ; 4,25]], [25],
    [Densité N, tiges/ha], [35 901], [15 885], [[29 344 ; 42 458]], [25],
    [Surface terrière G, m2/ha], [36,3], [27,7], [[24,6 ; 48,0]], [24],
  ),
  caption: [Indicateurs de structure forestière : moyenne, écart-type et intervalle de confiance à 95 % (t de Student entre placettes). Valeurs vérifiées sur structure_resume_indices.csv le 2026-10-08 — évolutives tant que la saisie n'est pas close (24 placettes saisies sur 28).],
) <tab-structure>
// TODO date-jeu-de-données : mettre à jour ce tableau manuellement à chaque évolution de
// structure_resume_indices.csv. Le G porte sur n = 24 (placettes saisies avec mesures).


La distribution des effectifs par classe de diamètre décroît régulièrement depuis les plus petites classes (Figure @fig-hist-classes) : 26 010 tiges/ha (IC 95 % : [20 427 ; 31 593]) dans la classe 0–2,5 cm, qui inclut les gaulis, puis 6 138 tiges/ha [4 742 ; 7 534] en 2,5–5 cm et 1 469 tiges/ha [1 033 ; 1 906] en 5–7,5 cm. Les classes supérieures à 10 cm ne représentent plus que quelques dizaines de tiges par hectare.

#figure(
  image("../../06_ecologie/analyse/sorties/structure_histogramme_classes.png"),
  caption: [Densité de tiges par classe de diamètre de 2,5 cm (moyenne entre placettes, barres = IC 95 % par t de Student). L'échelle de l'axe des ordonnées est symétrique-logarithmique : linéaire près de zéro, logarithmique au-delà, afin de représenter les intervalles de confiance dont la borne inférieure descend à zéro ; pour certaines classes rares, la borne inférieure de l'IC est négative et la barre est tronquée à zéro (étiquettes : IC réel). Les gaulis (< 1,30 m) sont inclus dans la classe 0–2,5 cm.],
) <fig-hist-classes>

// Légende conforme aux conventions de la note §3.2 : symlog expliqué, troncature à 0 expliquée,
// gaulis explicités. Chaque figure renvoie à l'annexe contenant les données exactes (guide,
// critère 173) : // TODO : créer l'annexe données-structure et renvoyer ici.

Le profil de surface terrière est plus régulier (Figure @fig-G-classes) : après un maximum de 10,0 m2/ha dans la première classe [2,5–7,5], la surface terrière se maintient entre 3,8 et 4,6 m2/ha dans les classes intermédiaires, puis remonte à 9,2 m2/ha dans la classe [22,5–27,5]. La classe [22,5–27,5] concentre à elle seule un quart de la surface terrière totale. Au total, les petites tiges dominent largement les effectifs, mais leur contribution à la surface terrière reste faible — la section étant proportionnelle au carré du diamètre.

#figure(
  image("../../06_ecologie/analyse/sorties/structure_G_classes.png"),
  caption: [Surface terrière par classe de diamètre de 5 cm, bornes décalées depuis le seuil de mesure effectif de 2,5 cm (moyenne entre placettes, barres = IC 95 % par t de Student). Les gaulis, non mesurés, sont exclus.],
) <fig-G-classes>

// TODO : valeurs vérifiées sur structure_G_classes.csv (10,0 / 4,6 / 3,9 / 3,8 / 9,2 / 1,5 / 1,8).
// La phrase « un quart de la surface terrière totale » : 9,2/36,3 ≈ 25 % — vision « par placette »,
// cohérente avec le G moyen cité. À revalider si le G évolue.

La régénération a été confrontée aux tiges de DBH ≥ 12,5 cm placette par placette : la corrélation est négative (Pearson r = −0,39 ; p = 0,058 ; n = 17 placettes comptant des tiges de cette taille), à la limite de la significativité.

// ATTENTION (note §3.2) : la corrélation naïve positive entre gaulis et classes adjacentes
// (2,5–5 cm) est un artefact mécanique — ne pas la rapporter comme résultat ; mention
// méthodologique placée en M&M. Figure structure_regeneration.png : à insérer ici ou en
// discussion ? // TODO : arbitrer, puis #figure <fig-regen> avec légende complète.

== Diversité alpha (§3.4)

// TODO date-jeu-de-données : 24 placettes, 743 observations, 1 761 tiges — double
// contrôle R/Python. Revalider les cinq indices avant dépôt.

La richesse spécifique moyenne par placette est de 29,0 ± 6,1 espèces (IC 95 % : [26,5 ; 31,6] ; n = 24). L'indice de Shannon moyen est H' = 3,01 ± 0,23 [2,92 ; 3,11]. Les nombres effectifs d'espèces qui en dérivent sont proches : exp(H') = 20,8 ± 4,4 espèces communes effectives [19,0 ; 22,7] et ²D = 20,8 ± 6,9 espèces dominantes effectives [17,9 ; 23,7] // TODO : vérifier l'arrondi — le CSV donne 20,77 pour ²D : arrondir à 20,8 est cohérent. L'indice α de Fisher, indépendant du nombre de tiges comptées, vaut 19,6 ± 5,5 [17,3 ; 21,9]. L'ensemble des indices par placette figure en annexe.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: 8pt,
    [*Indice*], [*Moyenne*], [*Écart-type*], [*IC 95 %*], [*n*],
    [Richesse spécifique S (= ⁰D), espèces], [29,0], [6,1], [[26,5 ; 31,6]], [24],
    [Shannon H', sans unité], [3,01], [0,23], [[2,92 ; 3,11]], [24],
    [exp(H') = ¹D, espèces communes effectives], [20,8], [4,4], [[19,0 ; 22,7]], [24],
    [²D (Simpson inverse), espèces dominantes effectives], [20,8], [6,9], [[17,9 ; 23,7]], [24],
    [α de Fisher, sans unité], [19,6], [5,5], [[17,3 ; 21,9]], [24],
  ),
  caption: [Indices de diversité alpha par placette : moyenne, écart-type et intervalle de confiance à 95 % (t de Student entre placettes). Valeurs vérifiées sur diversite_alpha_resume.csv le 2026-10-08 — évolutives tant que la saisie n'est pas close.],
) <tab-div-alpha>
// TODO date-jeu-de-données : mettre à jour ce tableau manuellement à chaque évolution de
// diversite_alpha_resume.csv (24 placettes saisies sur 28 au 2026-10-08).


L'égalité des nombres effectifs d'espèces communes et dominantes (¹D ≈ ²D ≈ 21) traduit une régularité marquée des abondances au sein des placettes : aucune espèce ne domine numériquement le sous-bois en moyenne. Ce résultat masque néanmoins des contrastes locaux : la placette la plus riche compte 46 espèces (H' = 3,42) // TODO : vérifier le code placette (note : P15) dans le CSV avant citation ; à l'opposé, une placette de richesse moyenne (26 espèces) présente un H' de 2,39 et un ²D de 6,9 : une seule espèce y domine très fortement la régénération.

// Figures optionnelles (note §3.4, à demander à la session R si la discussion en a
// besoin — ce ne sont pas des livrables exigés) :
//   - boxplot des indices par placette (S, H', ¹D, ²D, Fisher) : visualiser P15/P23 et
//     l'asymétrie de ²D — serait à insérer ici ;
//   - nuage S vs ln(N) par placette : effort d'échantillonnage et justification de
//     Fisher α (lien S ∝ α·ln(N)) — serait à insérer ici ou en discussion.
// Décision auteur : gardées en commentaire, à revisiter plus tard.

// En attente (ne pas rédiger) : diversité bêta (§3.5), IVI (§3.6), estimateurs de
// richesse (§3.7), stock de carbone (§3.3 — valeurs disponibles mais chantier en cours
// de validation par l'autre session), analyses complémentaires (§3.8).
