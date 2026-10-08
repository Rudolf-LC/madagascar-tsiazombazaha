# NOTE DE CONTEXTE — Diversité alpha (§3.4) : livrables et éléments de rédaction

## Pour la session de rédaction Typst

Cette note accompagne le chantier « diversité alpha » du document d'étape (§3.4). Elle donne les chiffres validés, les conventions à respecter et les pistes de rédaction. La référence méthodologique reste le document d'étape (`Documents-etapes/...retroplanning-statistiques.pdf`).

## Livrables (`06_ecologie/analyse/sorties/`)

| Fichier | Contenu |
|---|---|
| `diversite_alpha_placettes.csv` | Indices par placette : S, H', ¹D, ²D, N, Fisher |
| `diversite_alpha_resume.csv` | Moyenne ± écart-type, IC 95 % entre placettes (le tableau à citer) |
| `diversite_abondances.csv` | Table placette × espèce (base du futur NMDS §3.5) |

## Chiffres validés (double contrôle R/Python, données à jour : 743 observations, 1 761 tiges, 24 placettes)

| Indice | Moyenne ± écart-type | IC 95 % |
|---|---|---|
| Richesse S (⁰D) | 29,0 ± 6,1 | [26,5 ; 31,6] |
| Shannon H′ | 3,01 ± 0,23 | [2,92 ; 3,11] |
| ¹D = exp(H′) (espèces communes) | 20,8 ± 4,4 | [19,0 ; 22,7] |
| ²D Simpson inverse (espèces dominantes) | 20,8 ± 6,9 | [17,9 ; 23,7] |
| α de Fisher | 19,6 ± 5,5 | [17,3 ; 21,9] |

## Conventions à respecter dans le texte

1. **Abondances = toutes tiges comptées** : tiges mesurées (CBH > 8 cm) + gaulis (< 1,30 m). Le sous-bois complet est pris en compte — le mentionner en M&M car certains travaux ne comptent que les tiges ≥ 10 cm DBH (les comparer demande cette précision).
2. **Espèces = identités réconciliées** (230 au total). Les espèces indéterminées comptent chacune pour **une espèce locale distincte** (3 « Sp. indéterminée » dans une placette = 3 espèces). Convention à documenter : elle évite de sous-estimer la richesse.
3. **Nombres de Hill** (Hill 1973 ; Jost 2006) : S = ⁰D ; exp(H′) = ¹D (espèces communes effectives) ; ²D Simpson inverse corrigé (espèces dominantes effectives). Citer ces références avec le document d'étape.
4. **Fisher α** : résolution numérique de S = α·ln(1 + N/α) (Fisher et al. 1943) — son intérêt : indépendant du nombre de tiges comptées, comparable entre placettes d'efforts différents.

## Pistes de rédaction pour Résultats et Discussion

- **Peuplement équilibré** : H′ ≈ 3,0 avec ¹D ≈ ²D ≈ 21. L'égalité des nombres effectifs (communes ≈ dominantes) traduit une **équitabilité élevée** : aucune espèce n'écrase la composition locale. C'est un résultat en soi pour une forêt exploitée — l'exploitation sélective ne semble pas avoir homogénéisé le sous-bois.
- **Comparaison littérature** : Fisher α ≈ 19,6 et H′ ≈ 3,0 se situent dans la fourchette des forêts tropicales humides de l'Est malgache (H′ typiquement 2,5-3,5 ; Fisher 10-30). Une phrase de comparaison est possible, à sourcer soigneusement.
- **Contrastes entre placettes** : P15 la plus riche (46 espèces, H′ = 3,42) ; **P23 est un cas particulier** : richesse moyenne (26 espèces) mais H′ = 2,39 et ²D = 6,9 — une espèce y domine très fortement le sous-bois (régénération quasi monospécifique). Ce contraste peut appuyer la discussion sur l'hétérogénéité spatiale (en lien avec le futur NMDS, §3.5).
- **Prudence statistique** : n = 24 placettes, IC 95 % présentés — l'usage veut qu'on présente moyenne ± écart-type ET l'IC, les deux sont dans le CSV.

## En cours / à venir (ne pas rédiger encore)

- **Diversité bêta** (§3.5 : Whittaker, Lande, NMDS Bray-Curtis) — la table `diversite_abondances.csv` est déjà prête pour ça ;
- **IVI** (§3.6), **estimateurs de richesse** (§3.7) ;
- Le calcul « forêt entière » (gamma) et les β associés ont été volontairement mis de côté pour l'instant (à traiter avec le §3.5).

## Rappel

- Toute incohérence entre cette note, le document d'étape et les données : le signaler à l'auteur immédiatement.
- Ne pas figer ces valeurs sans mentionner le n (24 placettes) et la date du jeu de données — la saisie peut encore s'enrichir (le reste du dispositif).
