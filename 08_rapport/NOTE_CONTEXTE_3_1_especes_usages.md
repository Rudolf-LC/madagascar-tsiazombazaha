# NOTE DE CONTEXTE — §3.1 : Listes d'espèces et usages (validé)

## ⚠️ MISE À JOUR (après découpage P2)

Les effectifs ont évolué depuis la rédaction de cette note : **376 noms vernaculaires → 261 identités** (le découpage de P2 en 4 sous-placettes P02-P05 a ajouté ~41 noms, réconciliés). Vérifier les chiffres cités dans le §3.1 contre `liste_especes_vegetales_definitive.csv` (261 lignes) avant figement. Les chiffres « 335 noms → 230 identités » de cette note sont l'état antérieur, à mettre à jour dans le texte.

## Pour la session de rédaction Typst

Cette note couvre le chantier §3.1 du document d'étape : listes d'espèces végétales (flore) et classification des usages. Tout est validé et fusionné dans `main`.

## Livrables (`06_ecologie/analyse/sorties/`)

| Fichier | Contenu |
|---|---|
| `liste_especes_vegetales.csv` | Table de réconciliation : 335 noms vernaculaires normalisés → colonne `identite` remplie (réconciliation manuelle de l'auteur) |
| `liste_especes_vegetales_definitive.csv` | **La liste finale §3.1** : une ligne par espèce (identité), avec usages, usages classés (Cook), nb de types, distinctions, identifications botaniques |
| `association_espece_usage.csv` | Table n-n espèce × usage avec codes Cook n1/n2 (pour l'annexe) |
| `usages_especes_par_classe.csv` | Espèces par catégorie Cook n1 (libellés français) |

Référentiels (modifiables à la main, relus par le script) : `06_ecologie/analyse/referentiels/` — `mapping_mentions_usages.csv` (mention brute ODS → usage normalisé) et `correspondance_usages.csv` (usage → classe → Cook n1 → n2).

## Chiffres clés validés

- **335 noms vernaculaires** (normalisés) réconciliés en **261 identités** (≈ espèces perçues localement) ;
- 223/230 identités avec identification botanique ;
- Types par espèce : moyenne **1,59 ± 0,64** [IC 95 % : 1,49 ; 1,68] (n = 181) ; distribution : 1 type = 89 espèces, 2 = 79, 3 = 12, 4 = 1 ; l'annotation « ++ » est conservée (beaucoup de types), « na » écarté ;
- Usages : 69 espèces ont ≥ 1 usage rapporté ; **1,29 ± 0,55 usage** [1,16 ; 1,42] parmi elles ; 39 mentions « aucun » (= usage non rapporté, pas « inutile » — nuance à respecter).

## Répartition des usages (Cook n1, libellés français — codes en annexe uniquement)

| Catégorie | Nb espèces | Usages cités |
|---|---|---|
| Matériaux (0600) | 48 | balai, batan, bois_construction, canaux_irrigation, construction_maison, corde, fixation_toiture, guitare, manche_beche, menuiserie, panier, pilon, pirogue, planche, plancher, poutre, tressage |
| Médicaments (1100) | 11 | aphrodisiaque, douleurs_dentaires, fatigue, gonflements, medicinale |
| Usages sociaux (0800) | 9 | anti_foudre, magie |
| Alimentation (0100) | 3 | ecorce_sucree, fruit_comestible, the |
| Combustibles (0700) | 2 | bois_chauffage |
| Usages environnementaux (1200) | 2 | haie |
| Poisons des non-vertébrés (1000) | 1 | insecticide |

## Conventions à respecter dans le texte

1. **Espèces = identités réconciliées** (pas les noms vernaculaires bruts). Une identité ≈ une espèce perçue localement ; les types phénotypiques (mâle/femelle, grandes/petites feuilles…) d'une même plante peuvent porter des noms vernaculaires complètement différents — la réconciliation est donc un **résultat en soi**, à documenter en M&M (l'auteur l'a faite manuellement, fiche par fiche).
2. **Usages = classification Cook (1995), Economic Botany Data Collection Standard (TDWG)** — référence à citer. Libellés français dans le développement ; codes n1/n2 en annexe (table `association_espece_usage.csv`). Ne pas inventer de grille locale : le standard couvre tout ce qui a été observé.
3. « Espèce indéterminée » (22 occurrences, fusion des « Sp. inconnue ») est un **taxon fourre-tout** : présente dans la liste, à exclure des analyses de diversité (convention appliquée en §3.4).
4. Le nombre de types d'une espèce = **maximum observé** (une espèce vue avec 1 puis 3 types compte 3) ; les « ++ » sont conservés tels quels.
5. La faune (seconde liste du §3.1) : à ce jour, pas de livrable R — les données `animaux` de l'ODS sont brutes (18 lignes). À réclamer à la session R si la rédaction en a besoin (table simple à produire).

## Pistes de rédaction

- La **dominance des Matériaux** (48 espèces, construction/bois d'œuvre : poutres, planches, menuiserie, batan…) est le fait marquant — cohérent avec un village forestier (Manakara/Inter Aide). À relier au volet social (qui coupe, qui construit).
- **La magie et l'anti-foudre (9 espèces)** : pont direct vers le volet sciences sociales — usages rituels à développer dans le corps du texte comme demandé par le document d'étape.
- Les distinctions entre types (colonne `distinctionsTypes`) illustrent la finesse des catégorisations locales (mâle/femelle, forêt/village, couleurs d'écorce) — utilisables en encadré ou exemple.
