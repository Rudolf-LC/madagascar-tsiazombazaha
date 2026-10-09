"
Ewen Le Coeur
21/08/2026
Objectif : calculs des indices écologiques
"

### Import des modules ###

library(readODS)
library(ggplot2)

### Import des données ###

# saisie_releves_TZBA.ods
# indices par placettes du script calcIndices

### Nettoyage et mise en forme des données ###

# ne garder que les données d'interet dans les deux feuilles dans une nv table
# renommer les colonnes

### Analyses ###

### CAH/arbre de proximité des placettes sur la flore (?)

### tests de significativité de la composition floristique/G pour chaque variable de placette
## pour ce faire, grouper sec/humide/saturé et tester les uns contre les autres
## tester chaque placette l'une contre l'autre également

### glm
## P ~ variables (?)
## flore ~ variables
## ~ flore (une ligne pour chaque espèce)

### ACP entre espèces pour identifier groupes d'espèces / variables explicatives de chaque groupe
## hmmm...

### Tableaux pour comparaison avec les valeurs de la littérature (alpha, G...)