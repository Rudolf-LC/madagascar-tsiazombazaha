# HANDOFF — État du dépôt (mémoire écologie, Tsiazombazaha)

## État actuel
- Branche active : `vibe/ivi-dbd38e` (base : `main`, commits IVI + notes de rédaction).
- PR ouvertes : #6 (introduction), #9 (M&M + résultats §3.1/3.2/3.4), #11 (découpage P2). PR #10 (diversité beta) fusionnée.
- Données : `saisie_releves_TZBA.ods` — **28 placettes** (ex-P2 → P02–P05, renumérotation P06–P28), 261 espèces réconciliées (376 noms), bois-mort renuméroté. P06BIS = transect BM au sol de 20 m, pas une placette.
- Scripts (`06_ecologie/analyse/scripts/`) : 01 import → 02 liste brute → 03 liste définitive → 04 structure → 05 aire-espèce → 06 diversité alpha → 07 diversité beta → 08 carbone → 09 IVI. `fonctions/` (sourcées, jamais seules), `archives/` (obsolètes). README.md documente l'ordre.

## Résultats validés
- Structure (§3.2) : N total 1 998, N/ha 36 365 ± 13 461, G 35,95 ± 26,79 m²/ha (28 placettes).
- Alpha (§3.4) : S = 30 ± 6,19, Shannon 3,06, Fisher 22,5.
- Beta (§3.4) : Whittaker 7,7, additif 231, NMDS stress 0,224, gradient Jaccard transect→polisn'ala→commune significatif (KW p ≈ 4e-27) ; commune vs entre communes significatif en Jaccard (p = 0,0006) mais pas en Bray-Curtis (p = 0,352).
- Mono-commune : 71,3 % vs 53 % attendu (permutation, p = 0,001) — structure réelle.
- IVI (§3.6) : normalisé (Kent 2011), Babogna en tête (6,5), 129 espèces mesurées.
- Carbone (§3.5) : **PRÉLIMINAIRE** — E = −0,080 et ρ = 0,60 provisoires, ne pas figer.

## Décisions prises (ne pas rouvrir)
- Espèces réconciliées uniquement ; noms bruts = artéfacts (ex. Ambora/Ambory).
- Figures : **niveaux de gris uniquement**, pas de titres ni p-values dans l'image (tout en légende Typst).
- Tests beta en Jaccard (listes d'espèces) ; Bray-Curtis limité au NMDS.
- Gradient sans partition Legendre/De Cáceres (mention en perspective suffit).
- « P02 » restant dans `autres-especes` : reste sur P02, sans retour.
- IVI normalisé (÷3, base 100), citations Curtis & McIntosh (1951) + Kent (2011).
- Merge de PR : uniquement par l'auteur.

## En suspens
- Figure gradient beta : superposition étoiles/barres à ajuster visuellement (reporté).
- Figures scripts 04/05 : encore en couleurs, à passer en gris (convention).
- Paramètres carbone E et ρ : à confirmer (façade Est Madagascar) avant figement §3.5.
- §3.3 (bois mort détaillé) et §3.7-3.8 : non traités.
- Transects sans commune renseignée (T02, T06, T19, T20, T21) : paires exclues des analyses par commune — à compléter dans l'ODS si possible.

## Prochaines étapes
1. Lancer `09_analyse_ivi.R` (fait), vérifier `ivi_especes.csv` (fait).
2. L'acolyte rédige : §3.4 (notes beta + alpha existantes), §3.6 (note IVI), §3.1/3.2 (notes mises à jour post-P2).
3. Confirmer E/ρ puis finaliser §3.5 carbone.
4. Passer les figures 04/05 en gris avant intégration Typst.
5. Merge des PR par l'auteur uniquement.
