# NOTE DE CONTEXTE — Rédaction §3.6 : IVI

## Méthodo (à citer)
- **IVI normalisé** : Curtis, J.T. & McIntosh, R.P. (1951) « An upland forest continuum in the prairie-forest border region of Wisconsin », *Ecology* 32(3) : 476-496 (indice original) ; **Kent, M. (2011)** *Vegetation Description and Data Analysis: A Practical Approach*, 2e éd., Wiley-Blackwell (normalisation, implémentée aussi dans `BiodiversityR::importancevalue`).
- Formule : IVI = (DR + DoR + FR) / 3, base 100. DR = % des tiges, DoR = % de la surface terrière, FR = % des placettes échantillonnées contenant l'espèce.
- **Pourquoi normalisé** : en forêt hyperdiverse à fort turnover (261 espèces), DR et DoR sont dilués (~0,4 %/espèce en moyenne) mais pas la FR (une espèce dans 12/24 placettes = FR 50 même si rare en tiges). L'IVI brut se réduit donc à un classement par FR ; la normalisation équilibre les trois dimensions.

## Références d'application pour la DISCUSSION (à choisir, une des trois)
1. **Gelesha forest, Éthiopie** — *J. Ecology and the Natural Environment* : structure + IVI pour hiérarchiser les priorités de conservation (espèces à IVI faible = conservation, IVI fort = monitoring). Bon parallèle avec vos usages/conservation.
2. **Siberut, Indonésie** — forêt tropicale humide primaire, IVI par classes de dbh — contexte forestier le plus proche du vôtre.
3. **Chhotanagpur plateau, Inde** — *J. Bio. & Env. Sci.* : IVI divisé par 3 (même normalisation que nous), Shorea robusta dominant — exemple d'IVI par espèce dominante unique.

## Livrables (`06_ecologie/analyse/sorties/`)
- `ivi_especes.csv` : rang, espèce (réconciliée), nbTiges, nbPlacettes, g_m2, DR, DoR, FR, IVI normalisé.
- Convention : tiges mesurées uniquement (gaulis exclus, pas de CBH → pas de G) ; indéterminées = espèces locales distinctes.

## Points de rédaction
- Présenter aussi les trois composantes séparément (tableau DR/DoR/FR) : en hyperdiversité, une espèce peut avoir une FR élevée (partout) mais un DoR faible (jamais dominante) — l'IVI seul masque cette nuance.
- Lecture attendue : les espèces à IVI fort sont les « structurantes » (présentes ET denses ET dominantes) ; la longue traîne d'IVI faibles traduit le turnover élevé (cohérent avec §3.4 beta).
