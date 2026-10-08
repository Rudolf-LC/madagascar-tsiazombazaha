# NOTE DE CONTEXTE — Rédaction §3.4 : diversité (alpha déjà rédigé) + diversité beta

## Pour la session de rédaction Typst

Ce document accompagne l'analyse de diversité beta (branche `vibe/diversite-beta-dbd38e`, PR #10).
Il explique **ce que recouvrent les livrables**, **les valeurs à citer** et **les points de rédaction**.
Données : n = **28 placettes** (P02–P05 = découpage de l'ex-P2, renumérotation P06–P28), **261 espèces** (identités réconciliées), script `07_analyse_diversite_beta.R`.

## 1. Conventions fondamentales (à respecter partout)

- **On ne travaille qu'avec les espèces réconciliées** (colonne `identite` de `liste_especes_vegetales.csv`). Les noms vernaculaires bruts ne servent jamais dans les résultats : ils contiennent des artéfacts (ex. « Ambora »/« Ambory » = même espèce). Les observations « Espèce indéterminée » comptent pour une espèce locale distincte (`ind_PXX_OOO`) — deux placettes ne partagent jamais leurs indéterminées.
- Abondances = tiges mesurées (floreTiges) + gaulis (flore), même convention que la diversité alpha (§3.4 déjà rédigé) — cohérence à préserver entre les deux paragraphes.
- **Figures : niveaux de gris uniquement** (convention d'accessibilité et de lisibilité du mémoire). Pas de couleurs, distinctions par formes/textures/étiquettes.
- **Pas de titres ni de commentaires dans les images** : titre, description, test réalisé, seuils et p-values vont dans la légende Typst de la figure.

## 2. Chiffres clés à citer (tous vérifiés, sorties du 2026-10-09)

- **Whittaker multiplicatif** : β = **7,7** (alpha moyen 30 espèces/placette, gamma 261) — `diversite_beta_whittaker.csv`.
- **Whittaker additif** : β_add = gamma − alpha moyen = **231 espèces**.
- **Bray-Curtis moyen (abondances)** : 0,813 ± 0,086 (378 paires).
- **NMDS Bray-Curtis** : stress = **0,224**, 2 dimensions, solution stable (répétée 2 fois sur 20). Légèrement au-dessus du seuil usuel de 0,2 : citer le stress en légende et noter que l'ordination est indicative, pas une métrique.
- Jaccard moyen (présence-absence) : ~0,88 (calculation dans `diversite_beta_paires.csv`).

## 3. Gradient transect → polisn'ala → commune (le résultat central de la beta)

**Question écologique** : la différenciation entre placettes se joue-t-elle au niveau du transect, du polisn'ala (zone du guide) ou de la commune ? En **listes d'espèces** (Jaccard, sans abondances) — question : « les polisn'ala voient-ils/nomment-ils des espèces différentes ? »

**Moyennes Jaccard par niveau** (`diversite_beta_resume_jaccard` dans `diversite_beta_paires_niveaux.csv`) :

| Niveau | n paires | Jaccard moyen |
|---|---|---|
| Même transect | 37 | le plus bas |
| Même polisn'ala | 16 | intermédiaire |
| Même commune | 70 | élevé |
| Entre communes | 255 | le plus élevé |

**Tests** (Kruskal-Wallis global puis Wilcoxon 2 à 2, correction de Holm ; p-values exactes dans `diversite_beta_tests_niveaux_jaccard.csv`) :
- KW global : p ≈ 4×10⁻²⁷ ;
- polisn'ala vs transect : p = **0,068 (ns)** ;
- commune vs transect : p < 0,001 ; commune vs polisn'ala : p < 0,001 ;
- entre communes vs polisn'ala : p < 0,001 ;
- **entre communes vs commune : p = 0,0006** (significatif en Jaccard, alors que **non significatif en Bray-Curtis**, p = 0,352 — inversion à expliquer, voir §5).

**Figure à insérer** : `diversite_beta_gradient.png` — boxplots gris, 4 niveaux ordonnés, accolades avec étoiles (`***`/`**`/`*`/`ns`) anti-superposées, effectifs (n = …) sous les niveaux.
**Légende Typst à rédiger** (les valeurs ne sont PAS dans l'image) : Dissimilarité de Jaccard entre paires de placettes (espèces réconciliées, présence-absence). Test global : Kruskal-Wallis, p < 0,001. Comparaisons deux à deux : Wilcoxon, correction de Holm ; seuils : `***` p < 0,001, `**` p < 0,01, `*` p < 0,05, `ns` non significatif. Paires non indépendantes (une placette apparaît dans plusieurs paires) : tests indicatifs, à croiser avec les boxplots — à dire en M&M, pas en légende.

**Lecture attendue** : la différenciation en listes d'espèces n'apparaît **pas entre transects voisins d'un même polisn'ala** (p = 0,068), mais **massivement entre zones de guides différentes** (p < 0,001). La forêt fonctionne en mosaïque à petites taches ; la commune n'est pas une frontière floristique nette en abondances.

## 4. NMDS (abondances) — figure d'appui

- `diversite_beta_nmds.png` — points gris, **forme par transect** (8 transects), pas d'étiquettes de placettes, légende « Transect ».
- **Légende Typst** : Position des placettes par NMDS sur dissimilarité de Bray-Curtis (abondances, espèces réconciliées). Deux points proches ont des compositions proches. Stress = 0,224 (2 dimensions, 28 placettes) ; chaque symbole est un transect. Les coordonnées par placette sont dans `diversite_beta_nmds_points.csv` (avec transect, polisn'ala, commune) si besoin d'annexe.
- Lecture : les symboles se mélangent (pas de regroupement net par transect) — cohérent avec le turnover très élevé : l'hétérogénéité domine à toutes les échelles.

## 5. Points de rigueur à mettre en M&M (pas en résultats)

1. **Deux indices, deux questions** : Bray-Curtis pondère par les abondances (structures de peuplement) ; Jaccard les ignore (listes d'espèces, turnover qualitatif). Le gradient est calculé en **Jaccard** car la question porte sur les espèces vues/nommées par zone, pas sur leurs densités. L'NMDS reste en Bray-Curtis pour représenter les peuplements complets.
2. **Inversion Jaccard/Bray-Curtis sur la commune** : en listes d'espèces, un léger effet communal existe (p = 0,0006) ; en abondances, non (p = 0,352). Interprétation : les espèces accompagnatrices diffèrent un peu entre communes, mais les dominantes se retrouvent partout.
3. **Paires non indépendantes** : les tests Wilcoxon/KW sur les paires sont indicatifs (une placette entre dans plusieurs paires). Alternative rigoureuse non mise en œuvre (PERMANOVA) : à mentionner en limite, ou en perspective.
4. **Niveau « Entre communes »** = classe résiduelle (toutes paires ne partageant ni transect, ni polisn'ala, ni commune) — pas un contraste entre deux communes précises.
5. « Même polisn'ala » : n = 16 paires seulement — tendance robuste (p < 0,001 contre commune et entre communes) mais estimation fragile ; le dire.

## 6. Espèces mono-commune (résultat secondaire, une phrase)

`diversite_beta_mono_commune.csv` (espèces réconciliées) : **71,3 %** des espèces sont vues dans une seule commune, contre **53 %** attendu sous permutation aléatoire (999 tirages, p = 0,001) — **la structure spatiale est réelle, pas un artefact du nombre de placettes par commune**. La ligne « noms vernaculaires bruts » du même CSV est un **comparateur de contrôle** (80,6 % mono-commune) : l'écart brut/réconcilié quantifie ce que la réconciliation a fusionné (noms différents pour les mêmes espèces) — citable en discussion des M&M de la réconciliation, pas comme résultat beta.

## 7. À ne pas faire

- Ne pas citer Jaccard/Sørensen **par paire de placettes** dans le texte : le tableau de 378 paires (`diversite_beta_paires.csv`) va en annexe ou en fichier supp.
- Ne pas mélanger la catégorie « Entre communes » avec un test « entre deux communes données ».
- Ne pas présenter le stress NMDS (0,224) comme excellent ; le situer honnêtement (acceptable, limite du seuil usuel).
- Ne pas utiliser les dissimilarités Jaccard/Sørensen brutes pour des conclusions d'abondance (elles n'en contiennent pas).

## 8. Sources des livrables (tous dans `06_ecologie/analyse/sorties/`)

| Fichier | Contenu |
|---|---|
| `diversite_beta_whittaker.csv` | alpha moyen, gamma, beta multiplicatif (7,7), beta additif (231) |
| `diversite_beta_paires.csv` | 378 paires : Jaccard, Sørensen, Bray-Curtis (annexe) |
| `diversite_beta_paires_niveaux.csv` | paires + niveau hiérarchique (niveaux avec accents) |
| `diversite_beta_tests_niveaux_jaccard.csv` | p-values Wilcoxon-Holm (Jaccard) |
| `diversite_beta_tests_niveaux.csv` | idem en Bray-Curtis (contrôle) |
| `diversite_beta_nmds_points.csv` | coordonnées NMDS par placette + transect/polisn'ala/commune |
| `diversite_beta_especes_par_commune.csv` | nb de communes par espèce |
| `diversite_beta_mono_commune.csv` | proportions mono-commune + permutation |
| `diversite_beta_gradient.png` | figure gradient (gris, étoiles) |
| `diversite_beta_nmds.png` | figure NMDS (gris, formes par transect) |
