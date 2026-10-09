# NOTE DE CONTEXTE — Rédaction §3.6 : IVI (synthèse finale)

## Ce qui a été fait
Script `09_analyse_ivi.R` (branche `vibe/ivi-dbd38e`), exécuté et validé. Sortie : `ivi_especes.csv` — 129 espèces, 24 placettes échantillonnées (28 au total, 4 sans tige mesurée), 488 tiges.

## Méthode (citations)
- **IVI normalisé** base 100 : IVI = (DR + DoR + FR) / 3.
  - DR = 100 × nbTiges/Σ tiges ; DoR = 100 × G espèce/Σ G ; FR = 100 × nbPlacettes de l'espèce/Σ placettes par espèce (vérifier le dénominateur exact dans le script : FR sur les placettes échantillonnées).
- Citations : **Curtis & McIntosh (1951)**, *Ecology* 32(3) : 476-496 (indice original) ; **Kent (2011)**, *Vegetation Description and Data Analysis*, 2e éd., Wiley-Blackwell (normalisation).
- Pourquoi normalisé : en forêt hyperdiverse (129 espèces mesurées), l'IVI brut (somme sur 300) est dominé à >80 % par la FR — DR et DoR sont dilués entre les espèces, pas la FR. La normalisation équilibre les trois dimensions.

## Résultats à citer (ivi_especes.csv, trié par IVI décroissant)
- **Babogna** domine nettement : IVI = 6,5 (DR 5,1 ; DoR 9,9 ; FR 4,5) — à la fois la plus dense, la plus dominante (G) et l'une des plus fréquentes. Espèce structurante de la forêt.
- Suivent : Ambora (5,0), Hazomainty (4,9), Menafatagna (4,4), Voapaka (3,8).
- La décroissance est rapide : 5 espèces > 3,5 ; au-delà du rang 15, IVI < 1,5. Longue traîne d'IVI faibles = traduction directe du turnover élevé (cohérent avec §3.4 beta, Whittaker 7,7).
- Cas intéressants à commenter : Ramiavogna et Sary — 2 tiges chacune mais DoR ~4,5-5,0 (grosses tiges isolées) : rares mais localement dominantes. Hasina — FR 3,9 (12 placettes) mais DoR 1,3 : partout mais jamais dominante. Ces contrastes DR/DoR/FR sont la richesse de l'indice : les présenter par composantes, pas seulement l'IVI agrégé.

## Conventions
- Espèces réconciliées uniquement ; indéterminées = espèces locales distinctes.
- Tiges mesurées (CBH > 8 cm) ; gaulis exclus (pas de CBH → pas de G).
- Échelle : dispositif entier (pas de ventilation par placette — la FR n'aurait pas de sens).

## Figure éventuelle (optionnelle)
Si figure : barres horizontales top 15 + longue traîne en mention textuelle. Niveaux de gris uniquement, pas de titre dans l'image (légende Typst). Sinon, un tableau top 10-15 suffit largement pour un point secondaire du mémoire.

## Références d'application pour la DISCUSSION (en choisir une)
1. Gelesha forest, Éthiopie — IVI pour hiérarchiser priorités de conservation.
2. Siberut, Indonésie — forêt tropicale humide primaire, contexte le plus proche.
3. Chhotanagpur plateau, Inde — IVI normalisé comme nous (÷3), espèce dominante unique.
