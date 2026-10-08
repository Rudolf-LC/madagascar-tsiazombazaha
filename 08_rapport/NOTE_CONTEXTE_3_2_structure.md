# NOTE DE CONTEXTE — §3.2 : Structure forestière (validé)

## Pour la session de rédaction Typst

Cette note couvre le chantier §3.2 du document d'étape : densité N, distribution par classes de diamètre, surface terrière G (Mémento du forestier tropical, Mille & Louppe 2015). Tout est validé et fusionné dans `main`.

## Livrables (`06_ecologie/analyse/sorties/`)

| Fichier | Contenu |
|---|---|
| `structure_resume_indices.csv` | **Le tableau récapitulatif à citer** : N (total, brut/placette, /m², /ha) et G (/ha) avec moyenne ± écart-type, IC 95 % |
| `structure_histogramme_classes.png` | Tiges/ha par classe de diamètre (2,5 cm), barres IC 95 %, échelle symlog |
| `structure_histogramme_classes_brut.png` | Effectifs comptés par classe (dénombrement exhaustif, pas d'IC) |
| `structure_G_classes.png` | Surface terrière par classe (5 cm, bornes décalées depuis 2,5 : [2,5-7,5], [7,5-12,5]…) avec IC 95 % |
| `structure_regeneration.png` | Gaulis vs tiges DBH ≥ 12,5 cm (corrélation) |
| `structure_classes_diametre.csv` / `structure_classes_ic95.csv` | Tables des classes (effectifs, densités, IC) |
| `structure_N_placettes.csv` / `structure_G_placettes.csv` | Indices par placette |
| `structure_indices_placettes.csv` | Ancien format (obsolète — utiliser les précédents) |

## Chiffres clés validés (25 placettes, 549,4 m² horizontaux — attention : les effectifs d'observations ont évolué depuis, la saisie continue)

| Indice | Moyenne ± sd | IC 95 % |
|---|---|---|
| N total (tiges comptées) | 1 761 | — |
| N brut par placette | 70,4 ± 31,2 | [57,6 ; 83,3] |
| N (tiges/m²) | 3,59 ± 1,59 | [2,93 ; 4,25] |
| N (tiges/ha) | 35 901 ± 15 885 | [29 344 ; 42 458] |
| G (m²/ha) | 36,3 ± 27,7 | [24,6 ; 48,0] |

⚠️ Ces chiffres datent de la dernière exécution ; les valeurs font foi dans les CSV, pas dans cette note. Vérifier la date de mise à jour avant de figer dans le texte.

## Conventions à respecter dans le texte

1. **Gaulis** (tiges < 1,30 m) : comptés dans N (classe 0-2,5 des effectifs), **exclus de G** (pas de circonférence mesurée) ;
2. Indices rapportés à la **surface horizontale** (549,4 m²) — la surface réelle (569 m², corrigée de pente) est disponible mais non utilisée ; préciser en M&M ;
3. **Deux visions à ne jamais mélanger** : *dispositif* (total/surface cumulée) vs *par placette* (moyenne de ratios, IC entre placettes) — les chiffres diffèrent légèrement ; citer l'une ou l'autre selon la question ;
4. Classes de diamètre : **2,5 cm** pour les effectifs ; **5 cm** pour G, bornes décalées (première borne 2,5 = seuil de mesure effectif du protocole CBH > 8 cm) ;
5. IC 95 % par t de Student entre placettes ; les classes rares peuvent avoir une borne inférieure négative (petits effectifs) : barres tronquées à 0, étiquettes avec l'IC réel — **à signaler en légende de figure** ;
6. Échelle des figures : **symlog** (linéaire près de 0, log au-dessus) — une phrase de légende s'impose, l'axe n'est ni linéaire ni log pur.

## Pistes de rédaction

- **Distribution en J inversé** : régénération massive (~24 000 tiges/ha en 0-2,5 cm), décroissance régulière — signe d'un peuplement qui se renouvelle ;
- **Contraste effectifs/G** : les petites classes dominent les effectifs mais la surface terrière se maintient jusqu'aux grandes classes (la classe 20-25 cm est la plus forte ~7-8 m²/ha) — les petites tiges sont innombrables mais pèsent peu (g ∝ d²) ; quelques tiges moyennes portent l'essentiel du bois ;
- **Régénération** : corrélation **négative** gaulis vs tiges DBH ≥ 12,5 cm (Pearson r = -0,39, p = 0,058, n = 17 placettes avec grosses tiges) — effet d'ombrage du couvert, à la limite de la significativité. **Point de rigueur pour le M&M** : la corrélation positive naïve (gaulis vs classes 2,5-5 cm adjacentes) est un artefact mécanique — ce contraste vaut une phrase méthodologique ;
- G ≈ 36 m²/ha : cohérent avec une forêt tropicale humide mature (25-35 typiques), N très élevé = essentiellement des gaulis ;
- **Attention** : les indicateurs transects (chablis/ha, grands arbres DBH > 40/ha) du §3.2 **ne sont pas calculables à ce jour** — les longueurs de prospection manquent dans le fichier de saisie (3 945 m saisis sur ~6 000 annoncés ; à compléter depuis le GPS). Ne pas rédiger ces valeurs ; la session R les produira dès la saisie complétée.
