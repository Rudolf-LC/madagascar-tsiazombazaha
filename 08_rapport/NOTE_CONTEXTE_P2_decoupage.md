# NOTE — Découpage de la placette P2 en 4 sous-placettes

## Contexte
P2 a été inventoriée comme une placette unique de surface ~4 fois supérieure à la
norme (98 observations, 235 tiges : 52 mesurées + 183 gaulis — contre 73,4 ± 28,1
tiges/placette pour les 24 placettes déjà saisies). Décision de l'auteur : la
découper en 4 placettes standard par tirage aléatoire.

## Méthode
- Listes exhaustives constituées depuis `06_ecologie/releves/P2_propre.ods` :
  52 tiges mesurées (valeurs de circonférence individuelles), 183 gaulis
  (colonne Gaulis développée individu par individu) ;
- Tirage aléatoire **séparé** pour les tiges mesurées et pour les gaulis
  (graine = 20261008, reproductible), répartition quasi-égale en 4 groupes ;
- Sortie : `06_ecologie/analyse/sorties/P2_decoupage_4_placettes.csv`
  (codes P02a–P02d, une ligne par tige mesurée ou par espèce-gaulis, colonne
  « Remarques autres » gardant la traçabilité vers les observations d'origine).

## Résultat du tirage
| Sous-placette | Tiges mesurées | Gaulis | Total | G (m²/ha, 20 m²) | Espèces (noms bruts) |
|---|---|---|---|---|---|
| P02a | 13 | 46 | 59 | 29,1 | 33 |
| P02b | 13 | 46 | 59 | 36,2 | 36 |
| P02c | 13 | 46 | 59 | 28,4 | 35 |
| P02d | 13 | 45 | 58 | 38,5 | 37 |

## Contrôle de « normalité » du tirage
Comparaison aux 24 placettes existantes (N = 73,4 ± 28,1 tiges ; G = 36,3 ± 27,7 m²/ha) :
- **N par sous-placette : 58,8 ± 0,5** — la moyenne des 4 (58,8) est la contrainte
  du découpage (235/4), elle est dans l'étendue des placettes existantes (37–151) et
  à moins de 1 sd de la moyenne du dispositif. L'égalité quasi parfaite entre
  sous-placettes est **mécanique** (découpage d'un total fixe), pas un artefact :
  la variabilité qui compte est celle entre tiges individuelles, redistribuée
  aléatoirement ;
- **G : 28,4 à 38,5 m²/ha** — moyenne 33,1, très proche du G moyen du dispositif
  (36,3), chaque valeur dans l'étendue inter-placettes (9,2–110) et dans l'IC 95 %
  du dispositif. La répartition des gros bois est bien aléatoire (une tige de 62 cm
  de circonférence peut tomber dans n'importe quelle sous-placette) ;
- **Richesse : 33–37 espèces vernaculaires brutes** par sous-placette — cohérent
  avec les placettes existantes (S observée = 29,0 ± 6,1 identités ; en noms bruts
  la richesse est un peu plus élevée) ;
- La corrélation taille/densité du tirage est vérifiée : ni les gros arbres ni
  les gaulis ne sont agrégés dans une même sous-placette (max 1 tige > 30 cm de
  circonférence par sous-placette).

**Conclusion : le tirage ne s'écarte pas de la normalité attendue d'un découpage
aléatoire.** Les 4 sous-placettes sont interchangeables avec les placettes
standard du dispositif au regard de N, G et S.

## Points à arbitrer (signalés, non traités)
1. **Observations 285 (Kitsoky) et 290 (Voamalok'agady)** : dans `P2_propre.ods`,
   aucune circonférence ET Gaulis = 0 — donc comptées nulle part. Dans le fichier
   brut (`P1P2Lucas.xlsx`), elles portaient « Régénération = 1 » (1 tige chacune ?).
   Si ce sont des gaulis oubliés à la mise au propre, le total gaulis passe de 183
   à 185 et un tirage doit être relancé. **À confirmer par l'auteur.**
2. **Codes des sous-placettes** : j'ai utilisé P02a–P02d pour ne pas inventer de
   numéros ; si la convention du dispositif préfère P26–P29 (28 placettes au total),
   renommer dans le CSV (colonne unique, sans ambiguïté).
3. Les colonnes Type / Nb types / Remarques de `P2_propre.ods` ne sont pas
   reportées dans le CSV de sortie (elles sont par observation d'origine, pas par
   sous-placette) ; la traçabilité est conservée via « ex-obs » dans Remarques autres.
