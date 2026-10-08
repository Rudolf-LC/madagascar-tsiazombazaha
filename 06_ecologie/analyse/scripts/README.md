# Analyse écologie — scripts R

Ordre de lancement (chaque script se source depuis la racine du projet,
il importe lui-même ses dépendances) :

| # | Script | Rôle | Sorties principales |
|---|--------|------|---------------------|
| 01 | `01_importDonnees.R` | Socle : import et nettoyage du fichier ODS. Ne s'utilise pas seul (les scripts suivants le source) — mais peut être source pour explorer les données. | — |
| 02 | `02_listeEspeces_brute.R` | Produit la liste brute des noms vernaculaires, **à lancer après chaque mise à jour du fichier ODS** pour régénérer `liste_especes_vegetales.csv`. | `sorties/liste_especes_vegetales.csv` |
| 03 | `03_listeEspeces_definitive.R` | Consolide la liste par identité réconciliée (après arbitrage taxonomique manuel du CSV). | `sorties/liste_especes_vegetales_definitive.csv`, usages par espèce |
| 04 | `04_analyse_structure.R` | §3.2 : densité, classes de diamètre, surface terrière. | `sorties/structure_*.csv`, figures |
| 05 | `05_analyse_richesse_aire_espece.R` | §3.7 : courbe aire-espèce. | `sorties/richesse_*.csv`, figure |
| 06 | `06_analyse_diversite_alpha.R` | §3.4 alpha : richesse, Shannon, Simpson inverse, Fisher par placette. | `sorties/diversite_alpha_*.csv` |
| 07 | `07_analyse_diversite_beta.R` | §3.4 beta : Whittaker multiplicatif/additif, NMDS Bray-Curtis, tests par niveau (transect/polisn'ala/commune). | `sorties/diversite_beta_*.csv`, figures |
| 08 | `08_analyse_carbone.R` | §3.5 (préliminaire) : AGB Chave 2014, bois mort, CO₂. | `sorties/` (carbone) |

Sous-dossiers :

- `fonctions/` — bibliothèques de fonctions, sourcées par les scripts
  04–07, **jamais lancées seules** ;
- `archives/` — anciens scripts autonomes (diffPlacettes, figSocio,
  grandsArbres), conservés pour référence, non utilisés par les
  analyses actuelles.

## Workflow type après une mise à jour du fichier ODS

```r
source("06_ecologie/analyse/scripts/02_listeEspeces_brute.R")      # regenere la liste brute
# -> arbitrage taxonomique manuel dans sorties/liste_especes_vegetales.csv (colonne identite)
source("06_ecologie/analyse/scripts/03_listeEspeces_definitive.R")  # consolide
source("06_ecologie/analyse/scripts/04_analyse_structure.R")
source("06_ecologie/analyse/scripts/06_analyse_diversite_alpha.R")
source("06_ecologie/analyse/scripts/07_analyse_diversite_beta.R")
```

⚠️ `02_listeEspeces_brute.R` régénère le CSV brut : il **écrase** la
colonne `identite` si elle est remplie après coup dans le fichier
régénéré — vérifier le diff Git avant d'accepter la nouvelle version,
ou reporter les identités depuis la version précédente.
