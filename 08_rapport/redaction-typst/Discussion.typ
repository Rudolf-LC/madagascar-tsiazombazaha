// Discussion. // probablement un peu détruite par les push/pull...

= Discussion

// sujets de discussion
- Concept de dette d'extinction. Il sert à interpréter les résultats (richesse, régénération, espèces rares).
- L’absence d’analyse de la trame écologique peut aller en Discussion, comme limite et comme perspective : les petits fragments situés à 5, 10 et 15 km sont des relais potentiels.

Hending et al. (2023) :
Discussion : comparaison avec tes résultats de structure (§3.2) et de diversité (§3.4). Il faudra écrire que leur forêt est de type transitionnel, dans le Nord-Ouest, et que la tienne est une forêt humide de l’Est. La transposition reste donc prudente. Comme ton dispositif ne permet pas de tester lisière contre cœur, la source sert de grille de lecture, pas de point de comparaison direct.

Brown et al. (2018) :
Elle compare lisière et intérieur dans une forêt tropicale humide de Madagascar. Elle ne trouve pas de différence de biomasse aérienne, mais une diversité phylogénétique et fonctionnelle plus faible en lisière.
Elle sert surtout au §3.3 carbone, pour nuancer l’idée qu’un fragment perd forcément du carbone.
// REF? : je n’ai vu que des résumés. Les auteurs complets, la revue (Journal of Applied Ecology) et surtout le site d’étude sont à vérifier avant citation. https://doi.org/10.1111/1365-2664.12985

== Limites méthodologiques

// Limites organisées selon le plan de la méthodologie (guide, critère 66) ; déplacées depuis Matériel et méthodes (auteur, 31/10/2026).
// TODO : ajouter des renvois précis aux sections, figures et tableaux des Résultats (critère 67).

=== Inventaire floristique

Les placettes ont été choisies sur place le long des itinéraires suivis avec les guides, et non tirées au hasard. Les résultats valent donc pour les milieux accessibles depuis ces itinéraires ; la recherche d'une diversité de milieux a pu, en outre, surreprésenter des situations particulières. Les estimateurs de richesse doivent être lus comme des bornes inférieures pour les assemblages couverts, et leur extrapolation à la forêt entière reste une généralisation.

Les placettes d'un même itinéraire, proches les unes des autres, ne sont pas indépendantes. La variabilité entre placettes est donc probablement sous-estimée, et les intervalles de confiance trop étroits. Avec 28 placettes de 20~m², l'effort est faible au regard de la diversité de la forêt : les grosses tiges, rares à cette échelle, sont mal échantillonnées, ce qui rend la surface terrière et le stock de carbone particulièrement incertains. Le dispositif n'étant pas stratifié selon la distance à la lisière, l'effet de lisière décrit par Hending et al. (2023) ne peut pas être testé.
// TODO : renvoyer à la courbe de raréfaction-extrapolation et à l'écart entre richesse observée et estimée (Résultats).
// TODO : point libre — ...

=== Identification des espèces

Les espèces ont été identifiées par leur nom vernaculaire, donné par les polisin'ala, sans contrôle indépendant ni récolte d'échantillons d'herbier. La réconciliation des noms en identités reste approximative : un même nom peut regrouper plusieurs espèces, et une même espèce porter plusieurs noms. Les tiges d'espèce indéterminée, exclues des indices, réduisent légèrement la richesse mesurée. Enfin, chaque polisin'ala ayant accompagné des itinéraires différents, l'effet de l'observateur sur la composition se confond avec celui du lieu, et la comparaison des dissimilarités par niveau ne permet pas de les séparer.
// TODO : point libre — part des noms rattachés à une espèce, au genre ou à la famille (Résultats §3.1).

=== Transects

Les chablis et les grands arbres ont été recensés le long des chemins existants, à vue depuis le sentier. Ces chemins ne sont pas représentatifs de la forêt : ils suivent de préférence les crêtes et les terrains faciles, longent parfois les lisières et traversent des zones plus fréquentées, donc plus perturbées. La densité de chablis et de grands arbres qui en est tirée peut ainsi s'écarter de celle de l'intérieur de la forêt, dans un sens difficile à prévoir ; la détection, limitée à quelques dizaines de mètres du sentier, peut en outre manquer des individus.

Ce biais pèse directement sur le stock de carbone. Les deux dispositifs se complètent par la taille des arbres : les placettes de 20~m² ne contiennent aucune tige de DBH supérieur à 40~cm, de sorte que les gros arbres ne sont comptés que par les transects. Le stock porté par les gros arbres, qui concentrent l'essentiel de la biomasse dans une forêt tropicale humide mature, dépend donc entièrement de relevés le long des chemins, sur une surface prospectée encore incomplète. La part du carbone attribuée aux tiges de petit et moyen diamètre est ainsi probablement surestimée, et le stock total sous-estimé. Le compartiment des gros arbres doit être lu comme une borne basse, et la répartition du stock entre classes de diamètre comme un effet du dispositif plutôt que comme un trait de la forêt.
// Vérification du 01/11/2026 (calcul de contrôle, hors sorties R) : DBH maximal de 33,4 cm dans les placettes ; 49 grands arbres (DBH 40 à 72 cm) sur 3,93 ha de transects de longueur connue (T05, T06, T16) ; 29 grands arbres de T19, T20 et T21 non utilisés faute de longueur. Le calcul de l'AGB des grands arbres est correct (15,71 tC/ha retrouvés).
// REF? Répartition de la biomasse par taille dans les forêts tropicales matures : Slik, J. W. F., et al. (2013). Large trees drive forest aboveground biomass variation in moist lowland forests across the tropics. Global Ecology and Biogeography, 22(12), 1261-1271. https://doi.org/10.1111/geb.12092 ; Lutz, J. A., et al. (2018). Global importance of large-diameter trees. Global Ecology and Biogeography, 27(7), 849-864. https://doi.org/10.1111/geb.12747 — non lus, à vérifier avant de citer.
// TODO : point libre — statut final des indicateurs (longueurs des transects à récupérer sur le GPS).

=== Évolution du couvert forestier

Faute de temps, l'évolution du couvert n'a pas fait l'objet d'une analyse propre : elle repose sur des informations existantes, l'analyse de Romiguière (2025) fondée sur les cartes de Vieilledent et al. (2018) et les données de Global Forest Watch. Ces sources, établies à l'échelle nationale ou mondiale, décrivent mal la trajectoire propre d'un fragment de quelques centaines d'hectares.
// TODO : point libre — ...

=== Volet social

Les personnes interrogées ont été identifiées principalement par le bureau du VOI et les chefs de fokontany. Ce recrutement expose à un biais de sélection, au profit de personnes proches du VOI ou des autorités locales. L'échantillon est en outre majoritairement masculin (43 hommes et 10 femmes), ce qui limite la portée des résultats sur les usages et les perceptions des femmes. Les entretiens, traduits en direct et consignés par des notes plutôt qu'enregistrés, passent par un double filtre, celui de l'interprète et celui de la prise de notes ; les citations restent des propos traduits. Enfin, les documents de transfert de gestion, rédigés en malgache, n'ont été exploités que ponctuellement, ce qui limite l'analyse des règles formelles de gestion.
// TODO : fusionner avec « Pistes ouvertes > Enquête sociale » (traduction, refus d'entretien, discours adapté à une ONG), qui relève aussi des limites.
// TODO : point libre — ...

== Recommandations stratégiques


VIs à vis de :
- VOI
- Reboisements tranobe
- Reboisements VOI
- Etudes à mener : écologie, hydrographie
- Diagnostic agraires et actions

Il y a un besoin urgent d'arrêter les reboisements en acacia car sa capacité de propagation a déjà condamné des terrains agricoles, et il est déjà très présent dans la zone. L'eucalyptus est un bois de meilleure qualité, et ce sont des bois de meilleure qualité pour les poutres de construction qui manquent. De plus il ne se propage pas naturellement.

Évaluer les espèces héliophiles auprès des tranobe. Les essences sont plutôt choisies pour la qualité du bois final que pour leur caractère pionnier dans beaucoup de cas. Vérifier les taux de reprises.

Une concertation dans les méthodes avec les ONG XXX et XXX semble importante pour assurer une meilleure efficacité des actions.

Projets d'agroforesterie : très pertinent. Demandes de culture de rente. Nécessité de réfléchir en filière. S'informer sur l'usine de stockage/transformation qui s'ouvre au carrefour d'Ambila.

=== Études complémentaires

La priorité est de fiabiliser l'identification des espèces. Les relevés reposent sur des noms vernaculaires, sans contrôle botanique. Une récolte d'échantillons d'herbier sur les placettes, suivie d'une identification par des botanistes, par exemple ceux du Missouri Botanical Garden à Antananarivo ou des étudiants de l'ESSA spécialisés en écologie, permettrait de rattacher les identités locales à des noms scientifiques, de séparer les espèces regroupées sous un même nom et de confirmer la présence d'espèces endémiques ou menacées en rattachant chaque espèce identifiée à son statut sur la Liste rouge de l'UICN. Ce travail rendrait les indices de diversité comparables à ceux d'autres forêts et donnerait une base solide à tout suivi ultérieur.
// TODO : coût et durée indicatifs ; partenaires effectivement envisageables (à confirmer avec Inter Aide).

L'évolution du couvert forestier mériterait ensuite une analyse propre. Une classification supervisée ou non supervisée d'images satellites anciennes et récentes permettrait de retracer la trajectoire du fragment depuis la fin des années 1960, de repérer les zones dégradées ou défrichées et de suivre leur évolution dans le temps. Elle fournirait aussi un indicateur de suivi simple à renouveler pour Inter Aide et pour le VOI.
// TODO : sources d'images envisagées (archives anciennes, Landsat, Sentinel-2 ?) et compétences ou prestataires nécessaires. // REF?

Enfin, un suivi de la faune par indices kilométriques d'abondance, relevés le long des chemins de ronde par des polisin'ala formés à la notation des observations et des indices de présence, compléterait la liste d'espèces établie ici.
// TODO : point libre — fréquence des relevés, espèces cibles.

// Propositions non retenues pour l'instant (auteur, 31/10/2026) :
// - suivi écologique par placettes permanentes, plan systématique ou stratifié, placettes plus grandes ;
// - cartographie GPS des chemins de ronde et des transects.

== Pistes ouvertes
=== Enquête sociale
Traduction

Zone d'étude vaste sur de nombreux sujets couplé à la traduction : difficulté de creuseur en profondeur

Le fokontany de Tsararano dans la commune de Vohimasina Sud n'est pas membre du VOI mais semble être l'origine de nombreux feux pouvant affecter la forêt (Charpentier, 2026).
De plus, les populations de l'Ouest du FKT semblent se situer à une distance proche de la forêt, et il se pourrait tout à fait qu'elle.
Le fokontany d'Ambahatrazo n'est pas adhérant du VOI, mais comporte une partie de la forêt de Tsiazombazaha / des populations proches de la forêt.
La présente étude a omis ces deux fokontany par contraintes temporelles et logistiques, mais certains ménages proches de la forêt interagissent probablemen,t avec celle-ci, ouen tout cas intéragissaient avant.
La raison de non-adhésion de ces FKT au VOI reste également à élucider.

Plusieurs acteurs n'ont pas souhaité non rencontrer en raison de leurs contraintes propres ou par manque de temps de notre part.
Les raisons de refus évoquées par les paysans sont : absence de rémunération de l'entretien, manque de temps, distribution alimentaire organisée par une autre organisme,
réunion avec d'autres membres d'Inter Aide, maladie ou décès d'un proche, aucune raison.

Voici la liste des acteurs pertinents, avec
// Tableau esquisse (brouillon) :
// [Acteurs][Lieu][Sujet]
// [Yanck], [FKT Manakana], [Écotourisme],
// [Village proche forêt], [?], [Relation à la forêt],
// [Village d'Amboign], [FKT Andriana], [Coupes, relation à la forêt],
// [DREDD], [COM Manakara], [Mise en place du VOI, coupes, gestion avant le VOI, vision long terme de la forêt],
// [Tribunal], [COM Manakara], [Sanctions des coupes et défrichements],
// FOLUR, COM Manakara, X, Reboisements actuels
// FIANTSO, COM X, Mise en place du VOI et vision écotourisme
// ADRA, ?, Reboisements en projet

Enfin, refus de parler aux étrangers : peur du blanc héritée de la colonisation (n'oublions pas l'éthymologie de Tsiazombazaha), peur générale de l'étranger (blanc ou malgache) liée au contexte rural isolé pauvre et au contexte insulaire de Madagascar.
Certaines informations ont été perdues et de nombreux entretiens avortés au dernier moment par les personnes, d'une part à cause de cette peur. On ne sait pas si un entretien se fera jusqu'au moment où il est terminé (les gens peuvent ne pas se présenter ou partir pendant ou avant sans prévenir).
Rappelons qu'on m'a répété que la mentalité Antemoro est aussi de changer d'avis au dernier moment et de ne pas prévoir à l'avance. // adoucir ce paragraphe, le rendre plus acceptable scientifiquement
Discours adapaté à une ONG, à un blanc en particulier : rater certaines choses, moins de mention des conflits, de l'histoire lié à la colonisation, orienté sur recevoir quelque chose à terme et ce que peut apporter l'ONG.
Comme pas de rémunération des entretiens, beaucoup de refus et de lapins.

=== Géographie

Juste une modélisation pas très poussée !
Très peu de vérification sur le terrain après -> idée faible de la validité du modèle
Données de qualité faible (?)

=== Écologie

Très faible échantillonage, pas d'indentification à l'espèce : engager des botanistes du Missouri Botanical Garden, de Tannarive ou des étudiants de l'ESSA spécialisés en écologie pour ne travailler que sur ça afin de dresser une liste valide des espèces binominales de la forêt et calculer des indices alpha, beta et gamma sur les espèces botaniques réelles.

Augmenter l'échantillonage pour réduire les incertitudes sur le calcul du stock de carbone.
