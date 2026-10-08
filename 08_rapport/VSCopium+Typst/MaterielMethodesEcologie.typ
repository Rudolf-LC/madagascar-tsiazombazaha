// Matériel et méthodes — volet écologie.
// Style : Typst simple. Conventions typographiques françaises (espaces insécables, « »).
// Marqueurs : // TODO = à compléter ; // REF? = référence à confirmer ;
//             // ATTENTION = incohérence ou point à arbitrer avec l'auteur.
// Valeurs : celles des livrables R (06_ecologie/analyse/sorties/), jamais figées sans
//           vérification du CSV à la date de rédaction.

= Matériels et méthodes // TODO : arbitrer « Matériel et méthodes » (guide GEEFT) vs « Matériels et méthodes » (squelette existant). Harmoniser tout le mémoire.

== Site d'étude
// TODO : carte de localisation (coordonnées du projet de stage : 47,933–47,969°E, 21,884–21,924°S, WGS84).
// TODO : climat, géologie, pédologie, contexte socio-économique — voir squelette « Site d'étude »
//        dans Foresterie et projet de stage. La section n'est pas une monographie (guide, critère 31).

== Acquisition des données

=== Dispositif d'échantillonnage

// Face au temps limité, au manque de moyens et à la faible accessibilité de la forêt
// (densité des tiges, temps d'approche depuis les villages), un échantillonnage
// systématique a été écarté, de même qu'un échantillonnage stratifié. Les placettes
// ont été implantées au hasard en cours de journée le long des chemins de ronde des
// patrouilleurs communautaires, qui ne sont pas encore cartographiés.

// Arbitrage auteur (2026-10-08) : 28 placettes au total ; 24 saisies à ce jour
// (4 restent à saisir) — les n des livrables actuels (24-25) augmenteront donc.
// Les indices rapportés à la surface utilisent la surface HORIZONTALE (549,4 m2
// pour 25 placettes saisies ; à mettre à jour avec la saisie complète), pas la
// surface réelle corrigée de pente — convention à préciser ici (note §3.2).
// Les CSV évoluant avec la saisie : NE JAMAIS figer les effectifs/surfaces/densités
// sans relecture des livrables à jour.

// TODO : rédiger la description du dispositif une fois la forme des placettes
// confirmée (circulaires d10 m ? rectangulaires 4×10 m ? cf. protocole ODT et
// Romiguière 2025) :
//   - forme des placettes (circulaires d10 m ? rectangulaires 4×10 m ? cf. protocole
//     ODT et Romiguière 2025) ;
//   - les huit placettes de Romiguière (2025) : 40 m2, précomptage 2,5 cm, sous-placettes
//     de 4 m2 en comptage plein — intégrées quand l'indice n'exige ni comptage en plein
//     ni homogénéité des données ;
//   - les transects : ~6 000 m linéaires, 10 m de large, ~6 ha prospectés pour les
//     chablis et les grands arbres (DBH > 40 cm).
//     ATTENTION (note §3.2) : 3 945 m saisis sur ~6 000 annoncés — les indicateurs
//     transects (chablis/ha, grands arbres/ha) ne sont pas calculables à ce jour.

=== Relevés de placette

// TODO : variables relevées par placette (document d'étape §2.1 et protocole ODT) :
// pente (clinomètre), recouvrement de la canopée par quadrants (0-25/25-50/50-75/75-100),
// strates présentes, type d'humus (clé Jabiol et al. 2016 // REF?), humidité du sol,
// présence de mousses, lichens, lianes, épiphytes, champignons, fleurs/fruits,
// nombre de tiges < 1,30 m (gaulis).
// TODO : mentionner que le comptage des semis n'a été réalisé que sur sept placettes
// (document d'étape §2.1) — en contradiction apparente avec le quadrat 1×1 m du
// protocole : à clarifier avec l'auteur.

Pour chaque tige, le nom vernaculaire est relevé par le *polisin'ala* (personne désignée par la communauté comme connaisseuse de la forêt), et la circonférence à hauteur de poitrine (CBH, à 1,30 m) est mesurée au ruban métrique si elle dépasse 8 cm — soit un seuil de mesure effectif de 2,5 cm de diamètre (DBH). Les tiges de CBH inférieur ou égal à 8 cm (gaulis) sont comptées sans mesure. Les bois morts sur pied sont mesurés et notés à part.

// Arbitrage auteur : le seuil de mesure effectif est CBH >= 8 cm (DBH 2,5 cm).
// Le protocole ODT initial prévoyait un précomptage de 5 cm (CBH 15,5 cm) : mentionner
// l'écart avec le protocole initial uniquement si utile (limite/discussion), sinon
// garder la version terrain.

L'équipe de terrain était constituée de trois membres : un *polisin'ala* garant de l'identification vernaculaire, un traducteur-interprète faisant office de scribe (notation des noms malgaches), et un forestier chef d'équipe guidant le cheminement et réalisant les mesures. Par manque de temps, de moyens et de pertinence, aucun contrôle croisé de l'inventaire n'a été réalisé. La saisie a été effectuée sous LibreOffice Calc, avec vérification aléatoire portant sur 20 % des placettes.

=== Usages et types vernaculaires

Pour chaque nom vernaculaire, le *polisin'ala* a été interrogé sur les formes éventuelles de l'espèce (types phénotypiques), sur les distinctions correspondantes et sur les usages et symboliques de la plante.

=== Faune

// TODO : les indices d'animaux relevés lors des cheminements (nom vernaculaire, type de
// trace, nombre) — l'analyse par indice kilométrique d'abondance initialement prévue a
// été abandonnée (faible surface inventoriée, relevé non rigoureux) ; remplacée par une
// liste des espèces rencontrées et évoquées. Pas de livrable R à ce jour (données
// brutes : 18 lignes) — à réclamer à la session R si besoin.

== Analyse des données

Les données ont été nettoyées puis traitées avec le langage R (// REF? : version et
citation R à préciser ; packages : dplyr, ggplot2 // TODO : compléter la liste effective)
sous l'environnement RStudio.

Sauf mention contraire, les indicateurs sont présentés sous la forme moyenne ± écart-type, accompagnés d'un intervalle de confiance à 95 % calculé par le t de Student entre placettes. Le nombre de placettes (n) est systématiquement précisé. // TODO : convention de notation des seuils de significativité (* p(H₀) < 0,05 ; ** p(H₀) < 0,01 ; *** p(H₀) < 0,001) à énoncer ici si des tests sont présentés en Résultats (guide, critère 45).

// Deux visions coexistent pour les indicateurs à l'échelle du dispositif :
//   - vision « dispositif » : total rapporté à la surface cumulée ;
//   - vision « par placette » : moyenne des ratios par placette, IC entre placettes.
// Les chiffres diffèrent légèrement — ne jamais les mélanger, citer l'un ou l'autre
// selon la question (convention note §3.2).

=== Listes d'espèces et usages (§3.1)

Les noms vernaculaires relevés ont été normalisés puis réconciliés manuellement, fiche par fiche, en « identités » : une identité correspond à une espèce perçue localement, plusieurs noms vernaculaires pouvant désigner une même plante (types phénotypiques distincts, tels que formes mâle/femelle ou grandes/petites feuilles) et un même nom pouvant recouvrir plusieurs plantes. Cette réconciliation constitue un résultat en soi. Le nombre de types d'une espèce est le maximum observé sur l'ensemble des relevés.

Les usages rapportés ont été classés selon le standard *Economic Botany Data Collection Standard* (Cook, 1995) de la TDWG : les libellés français sont utilisés dans le développement et les codes de premier et second niveau sont renvoyés en annexe (table `association_espece_usage.csv`).

// Convention « espèce indéterminée » (arbitrage auteur) : au sein d'une placette,
// chaque « Sp. indéterminée » compte comme une espèce locale distincte dans les
// calculs de diversité (évite de sous-estimer la richesse locale) ; entre placettes,
// les individus indéterminés sont exclus des comparaisons (on ne sait pas s'il s'agit
// d'une même espèce ou d'une erreur du polisin'ala). Les analyses de structure
// (N, G) les conservent, étant indépendantes de l'espèce.

=== Structure forestière (§3.2)

La densité (N) et la surface terrière (G) suivent les définitions du *Mémento du forestier tropical* (Mille & Louppe, 2015). N est le nombre de tiges par hectare ; G est la somme des sections des troncs à hauteur de poitrine. Les gaulis (tiges < 1,30 m) sont comptés dans N mais exclus de G, leur circonférence n'étant pas mesurée. Les indices sont rapportés à la surface horizontale du dispositif.

La distribution des effectifs par classe de diamètre utilise des classes de 2,5 cm. Pour la surface terrière, des classes de 5 cm sont utilisées, avec bornes décalées depuis le seuil de mesure effectif : [2,5–7,5], [7,5–12,5], etc.

// TODO : indicateurs transects (chablis, grands arbres DBH > 40 cm) : non calculables
// à ce jour (saisie GPS incomplète). Ne pas rédiger de valeurs.

=== Diversité alpha (§3.4)

La diversité alpha est quantifiée par quatre indices s'inscrivant dans le cadre des nombres de Hill $q D$ (Hill, 1973 ; Jost, 2006) : la richesse spécifique $S = ^0D$ ; l'indice de Shannon $H'$ (Shannon & Weaver, 1949), dont l'exponentielle $exp(H') = ^1D$ s'interprète comme le nombre effectif d'espèces communes (Jost, 2006) ; l'inverse de l'indice de Simpson corrigé, $^2D$, nombre effectif d'espèces dominantes (Simpson, 1949) ; et l'indice $alpha$ de Fisher (Fisher et al., 1943), résolu numériquement depuis $S = alpha ln(1 + N/alpha)$, dont la valeur est indépendante du nombre de tiges comptées.

Les abondances prennent en compte toutes les tiges comptées : tiges mesurées (CBH > 8 cm) et gaulis. Cette convention doit être gardée à l'esprit lors des comparaisons, certains travaux ne comptant que les tiges de DBH ≥ 10 cm. Les espèces sont les identités réconciliées ; les individus indéterminés d'une même placette comptent pour des espèces locales distinctes (convention qui évite de sous-estimer la richesse).

// La convention « espèce indéterminée » est explicitée en §3.1 ci-dessus : comptées
// localement dans les indices, exclues des comparaisons entre placettes, conservées
// dans la structure.

=== Analyses en attente (à rédiger après validation)

// §3.3 Stock de carbone : allométrie sans hauteur (Chave et al. 2014), BGB ratio R = 0,20,
// CF = 0,47 ; bois mort sur pied et au sol (Van Wagner 1968).
// §3.5 Diversité bêta : Whittaker multiplicatif, Lande additif, NMDS Bray-Curtis.
// §3.6 IVI : Curtis & McIntosh (1951).
// §3.7 Estimateurs de richesse : Chao2 (principal), jackknife2, ICE, bootstrap, Chao1 ;
// courbe de raréfaction-extrapolation (Chao & Jost 2012 ; Hsieh et al. 2016).
// §3.8 Compléments : corrélation, ACP, CAH si le temps le permet.
// TODO : rédiger chaque sous-section quand la session R livre et valide les livrables.
