# NOTE — Découpage de la placette P2 en 4 sous-placettes (v2, intégrée)

## Contexte
P2 a été inventoriée comme une placette unique de surface quadruple (78,54 m²
horizontaux, 98 observations, 237 tiges : 52 mesurées + 185 gaulis — les obs 285
Kitsoky et 290 Voamalok'agady étant des gaulis régé=1, décision auteur). Décision :
la découper en 4 placettes standard par tirage aléatoire et intégrer le tout dans
`saisie_releves_TZBA.ods`.

## Ce qui a été fait (v2, decisions auteur du 08/10 appliquées)
1. **Tirage relancé avec les 2 gaulis manquants** (graine 20261009, reproductible) :
   listes exhaustives = 52 tiges mesurées + 185 gaulis = 237 ;
2. **Renumérotation du dispositif** dans `saisie_releves_TZBA.ods` :
   - ancien P02 (la grande P2) → remplacée par P02–P05 (4 sous-placettes) ;
   - anciens P03–P25 → **P06–P28** (décalage +3) — codes placette **et** codes
     d'observation (03xx→06xx…25xx→28xx) ;
   - feuilles touchées : `flore-verifiee` (renumérotation + 174 lignes insérées),
     `placettes` (P02 → 4 lignes, surfaces 78,54/4 = 19,63 m² horizontaux,
     82,96/4 = 20,74 m² réels, pente conservée, remarque « Sous-placette i/4 de
     l'ancienne P2 »), `phenologie` (P04→P07, P11→P14, P13→P16, P15→P18, P17→P20,
     P23→P26, P24→P27), `autres-especes` (P07→P10, P25→P28 ; l'ancienne référence
     « P02 » de la grande placette laissée telle quelle — à arbitrer) ;
3. **Intégration** des 174 lignes P02–P05 dans `flore-verifiee` (format identique :
   tiges mesurées en Circ1, gaulis par espèce en colonne Gaulis, traçabilité
   « ex-P2 obs » en Remarques autres).

## Résultat du tirage (v2, graine 20261009)
| Sous-placette | Tiges mesurées | Gaulis | Total | G (m²/ha) | Espèces (noms bruts) |
|---|---|---|---|---|---|
| P02 | 13 | 47 | 60 | 30,8 | 39 |
| P03 | 13 | 46 | 59 | 67,8 | 34 |
| P04 | 13 | 46 | 59 | 17,7 | 33 |
| P05 | 13 | 46 | 59 | 18,4 | 39 |

## Contrôle de normalité du tirage
- N total intégré : 1 761 + 237 = **1 998 tiges, 28 placettes** — cohérent ;
- **Test Monte-Carlo (10 000 tirages aléatoires)** : le rapport G max/moyenne
  observé (2,01 — P03 concentre les trois plus grosses tiges : Ramiavogna 83 cm,
  Sakatavilogna 63 cm, Kabokala 60 cm) a une **p = 0,114 sous tirage aléatoire
  pur** : le tirage n'est pas anormal, P03 est simplement la sous-placette qui a
  « hérité » des gros bois. La moyenne des 4 (33,7 m²/ha) colle au G moyen du
  dispositif (36,3 ± 27,7) ;
- G de chaque sous-placette (17,7–67,8) dans l'étendue des placettes existantes
  (9,2–110) ; S = 33–39, cohérent avec S = 29,0 ± 6,1 en identités.

## Livrables
- `06_ecologie/analyse/sorties/P2_decoupage_4_placettes.csv` — le détail du
  découpage (mise à jour v2), en lecture seule de traçabilité ;
- `saisie_releves_TZBA.ods` — la source de vérité intégrée (les scripts R
  reliront directement ce fichier).

## Reste à arbitrer
1. `autres-especes` : l'ancienne référence « P02 » (régénération observée sur la
   grande P2) n'a pas été renumérotée — faut-il la rattachée à une sous-placette
   précise (laquelle ?) ou la laisser en « P02 » ?
2. La convention de nommage définitive (P02–P05 « sous-placettes de l'ancienne
   P2 ») est actée ; si renommage ultérieur, il suffira de renuméroter.
3. La session R doit relancer ses scripts : tous les indicateurs (§3.2–3.7)
   changent avec n = 28 placettes (et la richesse du dispositif augmente : les
   39 noms vernaculaires de P2 dont Hafitra rejoignent la liste d'espèces).
