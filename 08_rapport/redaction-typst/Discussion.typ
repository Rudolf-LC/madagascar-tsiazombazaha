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
// Renvois aux Résultats ajoutés le 01/11/2026 (critère 67) ; à compléter pour le volet social.
// TODO : remplacer les renvois textuels par @tab-gamma, @fig-rarefaction, @tab-div-alpha, @tab-beta-niveaux, @fig-beta-nmds, @tab-carbone et @fig-carte-localisation quand ces éléments seront décommentés (Résultats, M&M).

=== Inventaire floristique

Les placettes ont été choisies sur place le long des itinéraires suivis avec les guides, et non tirées au hasard. Les résultats valent donc pour les milieux accessibles depuis ces itinéraires~; la recherche d'une diversité de milieux a pu, en outre, surreprésenter des situations particulières. Les estimateurs de richesse doivent être lus comme des bornes inférieures pour les assemblages couverts, et leur extrapolation à la forêt entière reste une généralisation. L'écart entre la richesse observée et la richesse estimée (Résultats, « Richesse spécifique totale »), comme la pente encore forte de la courbe de raréfaction-extrapolation, indique que l'inventaire est loin d'être complet.
// ATTENTION : « pente encore forte » à confirmer à la lecture de la figure (aucune valeur citée).

Les placettes d'un même itinéraire, proches les unes des autres, ne sont pas indépendantes. La variabilité entre placettes est donc probablement sous-estimée, et les intervalles de confiance trop étroits (@tab-structure~; Résultats, « Diversité alpha »). Avec 28 placettes de 20~m², l'effort est faible au regard de la diversité de la forêt~: les grosses tiges, rares à cette échelle, sont mal échantillonnées, ce qui rend la surface terrière et le stock de carbone particulièrement incertains. Le dispositif n'étant pas stratifié selon la distance à la lisière, l'effet de lisière décrit par Hending et al. (2023) ne peut pas être testé.

Le choix de petites placettes s'appuie sur un raisonnement établi pour l'estimation du volume ou de la biomasse (Mille et Louppe, 2015). Il se transpose mal à la richesse spécifique~: une placette de 20~m² ne contient que peu de tiges, si bien que les indices de diversité alpha dépendent fortement de la surface relevée et ne sont comparables qu'à des placettes de même taille. La comparaison avec Armstrong et al. (2011) et Hending et al. (2023) est en outre limitée par la différence de seuil d'inventaire (CBH de 8~cm ici, diamètre de 5~cm chez ces auteurs).
// REF? Mille et Louppe (2015), §6.2, p. 483 (lu) : raisonnement établi pour le volume ou la biomasse — la transposition à la richesse est une lecture de l'auteur, non une affirmation du Mémento.

=== Identification des espèces

Les espèces ont été identifiées par leur nom vernaculaire, donné par les polisin'ala, sans contrôle indépendant ni récolte d'échantillons d'herbier. La réconciliation des noms en identités reste approximative~: un même nom peut regrouper plusieurs espèces, et une même espèce porter plusieurs noms. Les tiges d'espèce indéterminée, exclues des indices, réduisent légèrement la richesse mesurée. Enfin, chaque polisin'ala ayant accompagné des itinéraires différents, l'effet de l'observateur sur la composition se confond avec celui du lieu, et la comparaison des dissimilarités par niveau (Résultats, « Diversité bêta ») ne permet pas de les séparer.
// TODO : point libre — part des noms rattachés à une espèce, au genre ou à la famille (Résultats, « Listes d'espèces et usages »).

=== Transects

Les chablis et les grands arbres ont été recensés le long des chemins existants, à vue depuis le sentier. Ces chemins ne sont pas représentatifs de la forêt~: ils suivent de préférence les crêtes et les terrains faciles, longent parfois les lisières et traversent des zones plus fréquentées, donc plus perturbées. La densité de chablis et de grands arbres qui en est tirée peut ainsi s'écarter de celle de l'intérieur de la forêt, dans un sens difficile à prévoir~; la détection, limitée à quelques dizaines de mètres du sentier, peut en outre manquer des individus.

Ce biais pèse directement sur le stock de carbone. Les deux dispositifs se complètent par la taille des arbres~: les placettes de 20~m² ne contiennent aucune tige de DBH supérieur à 40~cm (@fig-hist-classes), de sorte que les gros arbres ne sont comptés que par les transects. Le stock porté par les gros arbres, qui concentrent l'essentiel de la biomasse dans une forêt tropicale humide mature, dépend donc entièrement de relevés le long des chemins, sur une surface prospectée encore incomplète. La part du carbone attribuée aux tiges de petit et moyen diamètre est ainsi probablement surestimée, et le stock total sous-estimé (Résultats, « Stock de carbone »). Le compartiment des gros arbres doit être lu comme une borne basse, et la répartition du stock entre classes de diamètre comme un effet du dispositif plutôt que comme un trait de la forêt.
// Vérification du 01/11/2026 (calcul de contrôle, hors sorties R) : DBH maximal de 33,4 cm dans les placettes ; 49 grands arbres (DBH 40 à 72 cm) sur 3,93 ha de transects de longueur connue (T05, T06, T16) ; 29 grands arbres de T19, T20 et T21 non utilisés faute de longueur. Le calcul de l'AGB des grands arbres est correct (15,71 tC/ha retrouvés).
// REF? Répartition de la biomasse par taille dans les forêts tropicales matures : Slik, J. W. F., et al. (2013). Large trees drive forest aboveground biomass variation in moist lowland forests across the tropics. Global Ecology and Biogeography, 22(12), 1261-1271. https://doi.org/10.1111/geb.12092 ; Lutz, J. A., et al. (2018). Global importance of large-diameter trees. Global Ecology and Biogeography, 27(7), 849-864. https://doi.org/10.1111/geb.12747 — non lus, à vérifier avant de citer.
// TODO : point libre — statut final des indicateurs (longueurs des transects à récupérer sur le GPS).

=== Estimation du stock de carbone

Au-delà de l'échantillonnage, l'estimation repose sur des paramètres génériques. Une densité du bois unique ($rho = "0,58"$~g/cm³, moyenne de l'Afrique tropicale selon Brown, 1997) est appliquée à toutes les tiges, faute d'identités assez sûres pour attribuer une densité à chaque espèce~: la variation entre espèces, qui pèse directement sur la biomasse estimée, est ainsi ignorée, et le sens de l'erreur dépend de la composition réelle du peuplement. L'équation de Chave et al. (2014) est par ailleurs appliquée aux tiges de DBH compris entre 2,5 et 5~cm, en deçà de son domaine de calibration. Le ratio racines/parties aériennes et la fraction de carbone sont, eux aussi, des valeurs par défaut. Pour le bois mort au sol, la longueur de ligne varie de 5 à 30~m selon les placettes (290~m au total), et les classes de décomposition, appréciées au couteau, restent sujettes à l'appréciation de l'observateur.
// TODO : un calcul de sensibilité (ρ = 0,50 et 0,70) permettrait d'encadrer le résultat ; à produire dans R si retenu (non recalculé ici).
// TODO : argument noté en M&M (« l'incertitude dominante viendrait de la densité du bois et de la longueur de ligne plutôt que de la finesse de l'échelle ») non repris faute de source. // REF?
// REF? Brown (1997) et Chave et al. (2014) : voir Matériel et méthodes. Domaine de calibration de Chave et al. (2014) (arbres de DBH ≥ 5 cm) à vérifier dans l'article.

=== Évolution du couvert forestier

Faute de temps, l'évolution du couvert n'a pas fait l'objet d'une analyse propre~: elle repose sur des informations existantes, l'analyse de Romiguière (2025) fondée sur les cartes de Vieilledent et al. (2018) et les données de Global Forest Watch. Ces sources, établies à l'échelle nationale ou mondiale, décrivent mal la trajectoire propre d'un fragment de quelques centaines d'hectares.
// TODO : point libre — ...

=== Lien entre la forêt et la ressource en eau

L'eau est la première raison invoquée pour protéger la forêt, et le VOI envisage de taxer les rizières qui en dépendent (Résultats, « L'eau avant le bois » et « Ressources et dépenses »). Ce lien n'a pourtant pas été vérifié~: une modélisation hydrologique des écoulements, envisagée en cours de stage, a été abandonnée faute de temps. Les rizières qui dépendent réellement de l'eau issue de la forêt ne sont donc pas identifiées, et ce qui en est dit repose sur les déclarations des enquêtés. Ces déclarations appellent la prudence~: à Madagascar, le service hydrologique rendu par les forêts est souvent surestimé, par les acteurs locaux comme dans les sphères de décision. Certains effets, comme la protection des sols ou la régulation des petites crues, sont admis sans être quantifiés~; d'autres, comme l'effet de la forêt sur la pluviosité ou sur le débit de saison sèche, sont controversés et dépendent des situations, et le bassin forestier peut être éloigné de celui des usagers, voire séparé de lui par une ligne de partage des eaux (Andriamahefazafy et al., 2012).
// REF? Andriamahefazafy, F., Bidaud, C., Méral, P., Serpantié, G. & Toillier, A. (2012). L'introduction de la notion de service environnemental et écosystémique à Madagascar. VertigO, 12(3). https://id.erudit.org/iderudit/1022681ar — lu : résumé et § 64-66 (perception des services hydrologiques) ; l'article cite Bruijnzeel (2004) et Serpantié et al. (2009) pour ces points.
// Modélisation abandonnée (auteur, 01/11/2026) ; brouillon « Géographie » des Pistes ouvertes (modèle peu poussé, peu de vérification sur le terrain) conservé en fin de fichier.

=== Volet social

Les personnes interrogées ont été identifiées principalement par le bureau du VOI et les chefs de fokontany. Ce recrutement expose à un biais de sélection, au profit de personnes proches du VOI ou des autorités locales. L'échantillon est en outre majoritairement masculin (43 hommes et 10 femmes), ce qui limite la portée des résultats sur les usages et les perceptions des femmes. Ce déséquilibre reflète en partie leur place dans la gestion de la forêt~: aucune des femmes rencontrées n'exerce de fonction au sein du VOI, et l'assemblée générale observée réunissait environ une femme pour dix hommes. Certaines femmes sont membres du VOI de leur propre initiative, mais la plupart n'entretiennent pas de lien direct avec la forêt, où ce sont les hommes qui allaient chercher le bois. Or, à Madagascar, les femmes sont particulièrement concernées par l'approvisionnement en énergie et en compléments alimentaires tirés de la forêt, et l'organisation des communautés de base leur a ouvert peu à peu l'accès aux décisions locales (Randriamamonjy, 2007). Dans les communes riveraines de Tsiazombazaha, la plupart des femmes n'avaient en outre, au milieu des années 2000, ni accès à la propriété foncière coutumière ni droit d'hériter de la terre, la coutume antemoro réservant la terre des ancêtres au groupe de parenté (Müller et Evers, s. d.). Leurs usages et leurs attentes restent donc mal connus, alors qu'ils conditionnent en partie la réussite des reboisements et de la gestion.
// Source : observation de l'auteur (auteur, 01/11/2026) ; « aucune fonction au sein du VOI » : ResultatsSocio.typ, commentaire l. 91 (métadonnées).
// ATTENTION : le ratio d'environ 1 femme pour 10 hommes à l'AG n'est pas rapporté dans les Résultats (critère 68) : date de l'AG et source (OBS, carnet) à préciser, et à reporter en Résultats si conservé.
// ATTENTION : « ce sont les hommes qui allaient chercher le bois » vaut pour la forêt ; les Résultats indiquent que le bois de feu autour des maisons est ramassé par les hommes, les femmes ou les enfants selon les ménages (E9, E14, S4), et que les plantes médicinales de lisière le sont aussi par les femmes (E9, E26). Formulation à garder limitée à la forêt.
// REF? Müller, D. F. & Evers, S. J. T. M. (s. d.). Case studies of land access practices in Fianarantsoa province, Madagascar. VU University Amsterdam. — lu (p. 1-3, 9-12) ; terrain de 2006 à Ambila, Ambahatrazo et Mizilo (« communes de Tsiazombazaha »). Support de publication (chapitre d'ouvrage ?) et année à identifier. Exceptions mentionnées par les auteurs ; les femmes mariées ont accès à la terre de leurs parents sans la posséder.
// ATTENTION : donnée vieille de vingt ans ; ne pas la présenter comme la situation actuelle sans confirmation par les entretiens.
// TODO : « de leur propre initiative » reformule « pas par le choix du mari » (auteur) — à confirmer.
// REF? Randriamamonjy, M. (2007). Intégrer les questions de genre dans le secteur forestier en Afrique : Madagascar. FAO, Rome. — lu : résumé (p. iv) et p. 43 (COBA) ; rapport national et normatif, à citer avec prudence. // TODO : URL FAO.

Les entretiens, traduits en direct et consignés par des notes plutôt qu'enregistrés, passent par un double filtre, celui de l'interprète et celui de la prise de notes~; les citations restent des propos traduits. L'étendue des thèmes abordés, sur un territoire vaste, a limité l'approfondissement de chacun, d'autant que la traduction allonge chaque échange. Les documents de transfert de gestion, rédigés en malgache, n'ont été exploités que ponctuellement, ce qui limite l'analyse des règles formelles de gestion, et l'administration forestière n'a pas pu être rencontrée.

Plusieurs entretiens n'ont pas eu lieu ou ont été interrompus. Les raisons avancées par les personnes sollicitées tiennent à l'absence de rémunération de l'entretien, au manque de temps, à une distribution alimentaire ou à une réunion organisée au même moment par un autre organisme, à la maladie ou au décès d'un proche~; certaines n'en ont donné aucune. Des personnes ne se sont pas présentées ou sont parties en cours d'entretien. Ces absences ne sont probablement pas aléatoires~: les personnes les plus éloignées du VOI, ou les plus méfiantes envers des enquêteurs extérieurs, sont sans doute sous-représentées.

Enfin, les propos recueillis dépendent de la position de l'enquêteur, étranger et associé à une ONG. Les enquêtés ont pu adapter leur discours à cet interlocuteur, en mettant en avant les attentes d'appui et en évoquant moins les conflits ou l'histoire coloniale~; ce biais de désirabilité sociale tend à lisser les désaccords et à surreprésenter les demandes adressées à Inter Aide.
// Brouillon d'origine reformulé ci-dessus : « peur du blanc héritée de la colonisation », « peur générale de l'étranger », « mentalité Antemoro ». La généralisation à un groupe (« mentalité Antemoro ») est retirée : non sourcée, elle serait difficile à défendre en soutenance.
// TODO : étymologie de « Tsiazombazaha » et lien avec la méfiance envers les étrangers — à sourcer avant de l'évoquer. // REF?
// TODO : nombre d'entretiens refusés ou interrompus, si consigné (carnet).

== Recommandations stratégiques


VIs à vis de :
- VOI
- Reboisements tranobe
- Reboisements VOI
- Etudes à mener : écologie, hydrographie
- Diagnostic agraires et actions

L'arrêt des plantations d'_Acacia_ paraît prioritaire. L'espèce est décrite comme envahissante en lisière, dans les clairières et jusque dans des trouées de la forêt (Résultats, « Espèces exotiques envahissantes »), et elle colonise des parcelles agricoles et des pâturages (Mialy, XX, cité par Mettetal, 2026). Après la coupe, ses sauvageons recolonisent la parcelle et imposent de lourdes éclaircies pour obtenir de nouveau de grands fûts~; sous un peuplement de sept ans, des plants d'espèces natives restaient vivants mais sans croissance deux ans après leur plantation (Mettetal, 2026). Inter Aide a remplacé _Acacia mangium_ par _Acacia leptocarpa_, dont le risque d'envahissement reste à évaluer avant toute diffusion massive (Mettetal, 2026). Le guide national de reboisement range pourtant encore _Acacia_ sp. et _Grevillea banksii_ parmi les essences de bois-énergie conseillées pour l'écorégion humide (MEDD, 2020)~; une recommandation d'arrêt devrait donc s'appuyer sur les observations locales et être portée auprès de l'administration forestière. Les _Eucalyptus_, jugés sans danger par les enquêtés et préférés par plusieurs d'entre eux pour les poutres (Résultats, « Le bois de construction, usage le plus cité »), ne se propagent pas spontanément~; ils interdisent toutefois la culture du manioc après eux (Mettetal, 2026).
// Paragraphe réécrit le 01/11/2026 à partir du brouillon : « besoin urgent d'arrêter les reboisements en acacia car sa capacité de propagation a déjà condamné des terrains agricoles [...] L'eucalyptus est un bois de meilleure qualité [...] il ne se propage pas naturellement. »
// TODO : code de l'entretien qui mentionne des terrains agricoles envahis par l'Acacia (sources du volet social : E8, E10, E20, E23, S4, S8, S17).
// TODO : référence complète du mémoire de Mialy (auteur, année, titre, établissement) — « XX » à compléter. // REF?
// REF? Mettetal, S. (2026). Rapport d'étonnement, programme Agro Manakara : « Concilier préservation des écosystèmes, restauration des paysages, et satisfaction des besoins croissants en bois ». Mission du 7 au 10 septembre 2026. Inter Aide, document interne. Lu le 01/11/2026 ; entrée absente de References.typ.
// ATTENTION : les Résultats rapportent aussi des avantages prêtés à l'Acacia (sol meilleur pour le manioc, S17) ; Mettetal (2026) note la même perception après Acacia et Grevillea. Nuance à garder si la recommandation est maintenue.

Évaluer les espèces héliophiles auprès des tranobe. Les essences sont plutôt choisies pour la qualité du bois final que pour leur caractère pionnier dans beaucoup de cas. Vérifier les taux de reprises.
// Voir « Espèces pionnières natives » ci-dessous (Baguette et al., 2025).

Une concertation dans les méthodes avec les ONG XXX et XXX semble importante pour assurer une meilleure efficacité des actions.

Projets d'agroforesterie : très pertinent. Demandes de culture de rente. Nécessité de réfléchir en filière. S'informer sur l'usine de stockage/transformation qui s'ouvre au carrefour d'Ambila.

=== Conditions de réussite des reboisements

Les expériences de restauration participative menées dans six pays tropicaux éclairent plusieurs difficultés relevées à Tsiazombazaha (Gómez et Brasser, 2025). Les initiatives qui ont duré partaient des problèmes locaux, l'eau en particulier, plutôt que d'objectifs de plantation, et laissaient décider localement le choix des espèces, la densité et l'organisation du travail. Des bénéfices rapides y ont rendu l'entretien des arbres possible~; ici, la participation aux chantiers est inégale et la prime est jugée faible ou annoncée trop tard (Résultats, « Chantiers et participation »). Au Ghana, l'incertitude sur la propriété des arbres décourage la plantation~; à Tsiazombazaha, le statut des arbres plantés dans le périmètre est ambigu, et leur coupe peut être payante pour le planteur (Résultats, « Règles d'usage »~; Mettetal, 2026). Le même mécanisme est décrit pour la régénération naturelle assistée~: sans droit reconnu d'utiliser ou de vendre les arbres, les usagers n'ont aucun intérêt économique à investir dans leur régénération (Rinaudo et al., 2020). Le cadre national offre pourtant un outil pour lever cette ambiguïté~: sur les terres transférées, le cahier des charges fixe les droits et obligations des membres du reboisement jusqu'à l'exploitation des produits (MEDD, 2020). Y préciser le statut des arbres plantés ou régénérés dans le périmètre, et le sort de leur bois, donnerait aux planteurs l'assurance de profiter de leur travail. La question rejoint celle de l'accès à la terre~: là où planter revient à revendiquer une terre, celles et ceux que la coutume en exclut, femmes et migrants notamment (Müller et Evers, s. d.), ont peu de raisons de planter. Enfin, les femmes y tenaient souvent les pépinières, et l'accompagnement était adapté à leurs contraintes~; ici, la prime à l'arbre vivant défavorise celles et ceux qui transportent moins de plants, en particulier les femmes (E2).
// REF? Gómez, H. & Brasser, A. (dir.) (2025). Restoring tropical forests: Lessons in participatory productive restoration from six countries. Tropenbos International, Ede. https://doi.org/10.55515/MVHM6835 — lu : synthèse (p. 53-56) et chapitre Ghana (propriété des arbres) ; littérature grise d'ONG, aucun cas malgache.
// ATTENTION : la prime défavorable aux femmes (E2) n'apparaît que dans la section de travail de ResultatsSocio.typ (« Autres sujets de réflexion ») : à rapporter en Résultats (critère 68).
// TODO : renvoyer à @tab-socio-regles quand ResultatsSocio.typ sera inclus dans main.typ.
// REF? Rinaudo, T., Muller, A. & Morris, M. (2020). Manuel : la régénération naturelle assistée (RNA). World Vision Australia, FMNR Hub. — lu : chap. 1 (définition, p. 1-3) et chap. 5, « Propriété et utilisation des arbres » (p. 106-107) ; littérature grise, expérience surtout sahélienne.
// REF? Ministère de l'Environnement et du Développement durable (MEDD) (2020). Guide de reboisement et de reforestation : 04 écorégions de Madagascar. Antananarivo. — lu : §3.4.2.1 « Reboisement communautaire » (p. 25) et tableau des essences de l'écorégion humide (p. 16-17).
// ATTENTION : « planter revient à revendiquer une terre » n'est rapporté que dans la section de travail de ResultatsSocio.typ (E1, E6, E7, E23 ; Charpentier, 2026) : à reporter en Résultats (critère 68).
// TODO : vérifier si le cahier des charges du VOI Maharitra traite déjà des arbres plantés (document consulté ponctuellement).

=== Espèces pionnières natives

Les reboisements du VOI utilisent des sauvageons prélevés en forêt, dont certains supportent mal le plein soleil, tandis que les espèces exotiques plantées dans la zone, _Acacia_ sp. au premier chef, sont décrites comme envahissantes en lisière et dans les clairières (Résultats, « Reboisements » et « Espèces exotiques envahissantes »). Les espèces pionnières natives offrent une voie intermédiaire. La revue de portée de Baguette et al. (2025), fondée sur 398 publications, prend pour modèle _Harungana madagascariensis_ Lam. (Hypericaceae), arbre pionnier héliophile natif d'Afrique tropicale, de Madagascar et des Mascareignes, relevé dans les placettes de Tsiazombazaha et cité en entretien. À Madagascar, le guide des essences pour la restauration des paysages forestiers la place en tête des espèces de l'écorégion Est pour la restauration des forêts naturelles dégradées (Razanaka et al., 2019). Il la décrit comme une héliophile pionnière, très abondante dans les formations secondaires récentes, à croissance rapide et à faible niveau d'envahissement, dont les graines sont disséminées par les oiseaux~; elle peut être installée par semis direct, en sachets, en stumps ou à partir de rejets de souche, et fournit du bois de chauffe, du bois de menuiserie légère, une teinture, du miel et de nombreux remèdes.
// REF? Razanaka, S. J., Ramanankirija, A. H., Andrianirinarimanana, M., Randriambololona, R. M., Rakotovao, J. A. & Ratovoson, A. A. N. (2019). Guide des essences pour la restauration des paysages forestiers à Madagascar. PAGE/GIZ, Antananarivo. — lu : liste de l'écorégion Est (p. 11) et fiche _H. madagascariensis_ (p. 279-280) ; semences disponibles au SNGF (Antananarivo, Alaotra Mangoro).
// Présence : placettes et entretiens (auteur, 01/11/2026).
// TODO : l'espèce n'apparaît dans aucune table copiée dans analyse-tables ; vérifier son rattachement dans le référentiel de réconciliation (06_ecologie) et lever le TODO de ResultatsSocio.typ (« harongana »).

Selon cette revue, l'espèce colonise rapidement les milieux perturbés (forêts dégradées, lisières et trouées, savanes, terres abandonnées) et peut former un couvert fermé en quatre à six ans~; elle domine les forêts secondaires jeunes, puis est progressivement remplacée par des espèces post-pionnières et ne reste pas dominante au-delà de dix à vingt ans. Sur les 39 publications qui traitent de son intérêt pour la restauration, 38 la jugent favorable, pour sa croissance rapide, son rôle d'arbre nourricier, sa capacité à améliorer le sol et à concurrencer d'autres espèces héliophiles, souvent exotiques et envahissantes. L'espèce nourrit de nombreux animaux, dont 36 espèces d'oiseaux et 12 de primates, parmi lesquels quatre lémuriens~; ses petits fruits charnus attirent des frugivores qui en dispersent les graines. Les auteurs soulignent toutefois que la plupart de ces avantages n'ont pas été quantifiés, que sa tolérance au feu reste à tester et que son acceptation par les communautés n'a pas été étudiée, alors que l'espèce fournit du miel, du bois de feu, du charbon et des perches.

Pour Tsiazombazaha, ces éléments suggèrent un essai d'_H. madagascariensis_, et plus largement d'espèces pionnières natives, sur les zones brûlées ou défrichées du périmètre, en complément des espèces de forêt mature mal adaptées au plein soleil. Un tel essai comparerait la reprise et la croissance des plants, la recolonisation spontanée d'autres espèces natives sous leur couvert et leur résistance au feu, principale cause de recul citée par les enquêtés. Comme dans les expériences de restauration participative, la technique pourrait varier selon l'état du site~: plantation sur les zones nues, régénération naturelle assistée là où un couvert subsiste (Gómez et Brasser, 2025). Cette dernière consiste à sélectionner, tailler et entretenir les rejets de souches et les semis spontanés~; surtout pratiquée en milieu sec, elle reste possible en milieu humide, avec des pratiques adaptées (Rinaudo et al., 2020). L'essai pourrait s'appuyer sur le repiquage de sauvageons d'espèces pionnières, prélevés en bordure de forêt, que Mettetal (2026) juge pertinent sous réserve d'une collecte raisonnée, et sur la régénération naturelle assistée envisagée par Inter Aide (Mettetal, 2026). Il devrait associer le VOI et les pépiniéristes, et recueillir l'avis des habitants sur les usages de l'espèce~; les auteurs rappellent enfin de ne la planter que là où elle pousse naturellement.
// REF? Baguette, F. M. M. P., Baider, C. & Florens, F. B. V. (2025). A scoping review of tropical pioneer trees' roles for restoration and conservation management: Harungana madagascariensis (Hypericaceae) a widespread African species as a model. PeerJ, 13, e19458. https://doi.org/10.7717/peerj.19458 — lu (résultats et discussion, p. 7-18) le 01/11/2026 ; entrée absente de References.typ.
// Chiffres tirés de l'article : 398 publications ; 39 publications sur la restauration, dont 38 favorables ; couvert fermé en 4 à 6 ans (d'après Ndam et Healey, 2001) ; dominance non maintenue au-delà de 10 à 20 ans ; 36 espèces d'oiseaux et 12 de primates (dont quatre lémuriens) s'en nourrissent, sans précision de la partie consommée pour toutes.
// TODO : place à arbitrer — ici (recommandation opérationnelle) ou en « Pistes de recherche » (essai à concevoir).

=== Études complémentaires

La priorité est de fiabiliser l'identification des espèces. Les relevés reposent sur des noms vernaculaires, sans contrôle botanique. Une récolte d'échantillons d'herbier sur les placettes, suivie d'une identification par des botanistes, par exemple ceux du Missouri Botanical Garden à Antananarivo ou des étudiants de l'ESSA spécialisés en écologie, permettrait de rattacher les identités locales à des noms scientifiques, de séparer les espèces regroupées sous un même nom et de confirmer la présence d'espèces endémiques ou menacées en rattachant chaque espèce identifiée à son statut sur la Liste rouge de l'UICN. Ce travail rendrait les indices de diversité comparables à ceux d'autres forêts et donnerait une base solide à tout suivi ultérieur.
// TODO : coût et durée indicatifs ; partenaires effectivement envisageables (à confirmer avec Inter Aide).

L'estimation du stock de carbone gagnerait ensuite à être consolidée. La principale source d'incertitude étant le compartiment des gros arbres, relevé seulement le long des chemins, des transects de longueur mesurée au GPS, ouverts aussi hors des sentiers, réduiraient le biais et l'incertitude de ce compartiment. L'identification des espèces permettrait en outre d'attribuer à chaque tige une densité du bois propre à son espèce ou à son genre.
// ATTENTION : le brouillon des « Pistes ouvertes » propose d'« augmenter l'échantillonnage », alors que les placettes permanentes ou plus grandes figurent parmi les propositions non retenues (31/10/2026). La formulation ci-dessus se limite aux transects : à arbitrer.

L'évolution du couvert forestier mériterait aussi une analyse propre. Une classification supervisée ou non supervisée d'images satellites permettrait de suivre finement la déforestation~: chaque année à partir des images Sentinel-2, disponibles depuis 2015 à 10~m de résolution, et sur le long terme à partir d'images plus anciennes, pour retracer la trajectoire du fragment depuis la fin des années 1960. Elle repérerait les zones dégradées ou défrichées et suivrait leur évolution dans le temps. Elle fournirait aussi un indicateur de suivi simple à renouveler pour Inter Aide et pour le VOI.
// TODO : sources d'images anciennes envisagées (photographies aériennes, Landsat ?) et compétences ou prestataires nécessaires. // REF? (Sentinel-2 : date et résolution à sourcer, ESA.)

Une modélisation hydrologique des écoulements permettrait de déterminer quelles rizières dépendent réellement de la forêt. À partir d'un modèle numérique de terrain, l'extraction du réseau de drainage et la délimitation des bassins versants en amont des points de sortie de l'eau connus des habitants indiqueraient l'aire d'alimentation de chaque rizière~; un indice d'humidité topographique (Beven et Kirkby, 1979) signalerait les zones d'accumulation de l'eau. Ces résultats, à vérifier sur le terrain, donneraient une base objective à la taxe sur les rizières envisagée par le VOI. Cette taxe rapproche la gestion d'un paiement pour service environnemental, instrument promu à Madagascar depuis le milieu des années 2000, d'abord pour le carbone puis pour l'eau (Andriamahefazafy et al., 2012)~; elle ne serait légitime qu'auprès des rizières effectivement alimentées par la forêt. La modélisation pourrait aussi orienter les plantations d'espèces natives vers les périmètres de protection des sources, comme le suggère Mettetal (2026).
// Source de la démarche : note méthodologique de l'auteur (09_Poubelle/07_Hydrologie/methodo_hydrologie.pdf), non citable telle quelle ; ses recommandations (SRTM 30 m, seuils d'extraction, plugin Hydra) ne sont pas reprises faute de vérification.
// ATTENTION : la note indique qu'un MNT de 30 m capte mal des cours d'eau de 1 à 2 m de large et surestime le réseau ; limite à mentionner si le paragraphe est développé.
// REF? Beven, K. J. & Kirkby, M. J. (1979). A physically based, variable contributing area model of basin hydrology. Hydrological Sciences Bulletin, 24(1), 43-69. https://doi.org/10.1080/02626667909491834 — non lu, à vérifier.

Enfin, un suivi de la faune par indices kilométriques d'abondance, relevés le long des chemins de ronde par des polisin'ala formés à la notation des observations et des indices de présence, compléterait la liste d'espèces établie ici.
// TODO : point libre — fréquence des relevés, espèces cibles.

// Propositions non retenues pour l'instant (auteur, 31/10/2026) :
// - suivi écologique par placettes permanentes, plan systématique ou stratifié, placettes plus grandes ;
// - cartographie GPS des chemins de ronde et des transects.

== Pistes de recherche

=== Connectivité écologique

La forêt de Tsiazombazaha a été étudiée comme un fragment isolé. Sa place dans la trame écologique régionale n'a pas été analysée, alors que les petits fragments de forêt naturelle situés à 5, 10 et 15~km peuvent servir de relais pour la dispersion des espèces. Une analyse de la connectivité entre ces fragments, appuyée sur la cartographie du couvert et sur les espèces dont la dispersion dépend des animaux, permettrait de situer l'enjeu de conservation de Tsiazombazaha à l'échelle du paysage.
// TODO : noms et distances des fragments à vérifier (M&M : Lakia, Vorovoka, Vatovavy). // REF? méthode de connectivité à proposer.

=== Fokontany non adhérents au VOI

Deux fokontany voisins n'ont pas été enquêtés, faute de temps et pour des raisons logistiques. Le fokontany de Tsararano, dans la commune de Vohimasina Sud, n'est pas membre du VOI, mais semble à l'origine de nombreux feux pouvant atteindre la forêt (Charpentier, 2026)~; une partie de sa population vit à faible distance de la forêt. Le fokontany d'Ambahatrazo, lui non plus adhérent, englobe une partie de la forêt de Tsiazombazaha. Certains ménages de ces fokontany interagissent probablement avec la forêt, ou l'ont fait par le passé. Comprendre leurs usages et les raisons de leur non-adhésion au VOI éclairerait les limites du dispositif de gestion actuel.
// ATTENTION : « Tsararano » (Discussion) contre « Tsarano » (projet de stage) — voir MaterielMethodes.typ:71.
// REF? Charpentier (2026) : entrée à vérifier dans References.typ.

=== Acteurs non rencontrés

Plusieurs acteurs n'ont pas pu être rencontrés, en raison de leurs propres contraintes ou du temps disponible. Les rencontrer compléterait la vision de la gestion, en particulier sur la mise en place du VOI, les coupes et leur sanction, les reboisements en cours ou en projet et l'écotourisme.
// TODO : tableau à finaliser (acteur, lieu, sujet) ; vérifier que chaque acteur n'est pas identifiable s'il s'agit d'une personne privée.
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

// Brouillon d'origine des « Pistes ouvertes », repris dans « Limites méthodologiques > Volet social » et ci-dessus :
// Géographie : « Juste une modélisation pas très poussée ! Très peu de vérification sur le terrain après -> idée faible de la validité du modèle. Données de qualité faible (?) »
// Écologie : « Très faible échantillonnage, pas d'identification à l'espèce [...] Augmenter l'échantillonnage pour réduire les incertitudes sur le calcul du stock de carbone. »
