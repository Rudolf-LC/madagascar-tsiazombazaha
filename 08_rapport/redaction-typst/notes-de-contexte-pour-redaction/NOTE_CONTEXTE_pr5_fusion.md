# NOTE DE CONTEXTE — Rédaction : ce qui vient d'être fusionné (PR #5)

## Pour la session de rédaction Typst

Ce document accompagne le merge de la PR #5 dans `main`. Il explique **ce que recouvrent les livrables** et **comment les présenter dans le mémoire**. La référence méthodologique reste le document d'étape (`Documents-etapes/...retroplanning-statistiques.pdf`), sections 3.2, 3.3 et 3.1.

## 1. Structure forestière (§3.2) — validée

**Livrables** (`06_ecologie/analyse/sorties/`) :
- `structure_resume_indices.csv` — le tableau récapitulatif à citer : N total, N brut/placette, N/m², N/ha, G/ha — chacun avec moyenne ± écart-type et IC 95 % (t de Student entre placettes) ;
- `structure_histogramme_classes.png` — tiges/ha par classe de diamètre (2,5 cm), barres IC 95 %, échelle **symlog** (linéaire près de 0, log au-dessus : les IC descendant à 0 sont représentables) ;
- `structure_histogramme_classes_brut.png` — effectifs comptés (dénombrement exhaustif, pas d'IC) ;
- `structure_G_classes.png` — surface terrière par classe de **5 cm à partir de 2,5** (bornes : [2,5-7,5], [7,5-12,5]…) ;
- `structure_regeneration.png` — gaulis vs tiges DBH ≥ 12,5 cm.

**Points de rédaction importants** :
- Deux visions coexistent : *dispositif* (total/surface cumulée) et *par placette* (moyenne de ratios, IC entre placettes). Les chiffres diffèrent légèrement — citer les deux selon la question, ne jamais les mélanger.
- La distribution des diamètres est un **J inversé** (régénération massive) : ~26 000 tiges/ha en 0-2,5 cm (gaulis inclus par convention), décroissance régulière ensuite.
- Le profil G est contrasté : les effectifs dominent en petites classes, mais la **surface terrière se maintient jusqu'aux grandes classes** (classe 20-25 la plus forte) — les petites tiges sont innombrables mais pèsent peu (g ∝ d²).
- Régénération : corrélation **négative** gaulis vs grosses tiges (Pearson r = -0,39, p = 0,058, seuil 12,5 cm) — effet d'ombrage du couvert, à la limite de la significativité (n = 17 placettes avec grosses tiges). **Important méthodologiquement** : la corrélation positive naïve (classes adjacentes) était un artefact mécanique — ce point de rigueur mérite une phrase en M&M.
- Les IC des classes rares peuvent avoir une borne inférieure négative (t de Student sur petits effectifs) : les barres sont tronquées à 0, les étiquettes montrent l'IC réel. À signaler en légende de figure.
- Conventions à respecter : gaulis = tiges < 1,30 m, comptés dans N mais **pas dans G** ; indices rapportés à la **surface horizontale** ; classe 0-2,5 des effectifs inclut les gaulis.

## 2. Stock de carbone (§3.3) — calculé, paramètres provisoires

**Statut : PRÉLIMINAIRE.** Les formules du document d'étape sont implémentées (AGB Chave 2014 sans hauteur, BGB = 0,20·AGB, CO₂ = 2,06988·AGB ; bois mort sur pied avec facteurs de décomposition 1→0,9, 2→0,6, 3→0,4 ; bois mort au sol Van Wagner L_bm = 290 m). Les résultats (dans `calcIndices.R`, ancien script — seront restructurés) : AGB ≈ 206 tMS/ha, CO₂ vivant ≈ 427 t/ha, bois mort ≈ 34 t/ha.

**DEUX PARAMÈTRES SONT PROVISOIRES et signalés dans le code** : E (indice bioclimatique Chave) = -0,080 et ρ (densité du bois) = 0,60. **Ne pas citer ces chiffres comme définitifs dans le mémoire** — en attente de confirmation des valeurs pour la façade Est Madagascar. Marquer la section `// TODO: valeurs définitives après confirmation E et ρ`.

## 3. Liste d'espèces et usages (§3.1) — validée

**Livrables** :
- `liste_especes_vegetales_definitive.csv` — **230 identités** (espèces réconciliées manuellement à partir de 335 noms vernaculaires), avec usages normalisés, nb de types (multiples conservés, `++` conservé), distinctions entre types, identifications botaniques (223/230) ;
- `association_espece_usage.csv` — table n-n espèce × usage avec classification **Cook (1995) / TDWG** ;
- `usages_especes_par_classe.csv` — espèces par catégorie Cook n1 (libellés français).

**Points de rédaction** :
- La réconciliation des noms vernaculaires (variantes mâle/femelle, types morphologiques portant des noms différents) est un **résultat en soi** : une phrase en M&M la documente (une identité ≈ une espèce perçue localement ; les types phénotypiques restent tracés en colonnes) ;
- Classification des usages : **Cook (1995), Economic Botany Data Collection Standard (TDWG)** — à citer comme référentiel ; libellés français dans le texte (Matériaux, Médicaments, Usages sociaux, Alimentation, Combustibles, Usages environnementaux, Poisons des non-vertébrés), codes n1/n2 **en annexe** uniquement ;
- Chiffres clés validés : 335 noms vernaculaires → 230 identités ; types/espèce = 1,59 ± 0,64 [IC 95 % : 1,49-1,68] ; usages/espèce (celles ayant ≥ 1 usage) = 1,29 ± 0,55 [1,16-1,42], n = 69/230 ; **Matériaux domine** (~49 espèces, construction/bois d'œuvre), puis Médicaments (11), Usages sociaux (9 — dont la magie, à relier au volet social du mémoire) ;
- « Espèce indéterminée » (22 occurrences) est un taxon poubelle : présent dans la liste, **à exclure des analyses de diversité** ;
- L'« aucun usage » (39 mentions) signifie « usage non rapporté », pas « inutile » — nuance à respecter dans le texte.

## 4. En cours / à venir (ne pas rédiger encore)

- **Diversité alpha** (§3.4 : Shannon, Simpson, Fisher par placette) — en cours ;
- **Diversité bêta** (§3.5 : Whittaker, Lande, NMDS Bray-Curtis) ;
- **IVI** (§3.6) et **estimateurs de richesse** (§3.7 : Chao2, jackknife, iNEXT — la courbe aire-espèce `richesse_aire_espece.png` est déjà là et montre une courbe **non saturée**, argument en faveur des estimateurs) ;
- Indicateurs transects (chablis/ha, grands arbres/ha) bloqués : **les longueurs de prospection manquent dans le fichier ODS** (3 945 m saisis sur ~6 000 annoncés) — à réclamer à l'auteur (GPS).

## Rappel des conventions générales

- Toutes les figures partagent le même style : axes fléchés, pas de quadrillage, IC réels affichés (tronqués à 0 seulement dans la barre) ;
- Les fichiers sorties font foi — les valeurs citées ici sont celles de la dernière exécution validée ;
- Toute incohérence entre cette note, le document d'étape et les données : le signaler à l'auteur immédiatement.
