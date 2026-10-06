"
Ewen Le Coeur
21/08/2026
Objectif : réaliser les figures sur les métadonnées en sociologie
Disclaimer : merci d'importer les données en utilisant un autre script
"

### Import des modules ###

library(readODS)
library(ggplot2)

### Import des données ###

# metadonnees_enquete-de-terrain.ods
# feuille 1 "entretiens" : Durée, Fokontany, Nombre d'enquêtés
# feuille 3 "enquetes" : Genre, Âge, Professions, Lien au VOI 

### Nettoyage et mise en forme des données ###

# ne garder que les données d'interet dans les deux feuilles dans une nv table

### Figures ###

## Figure : Boxplot du temps par entretien

## Figure : Barre/camembert sur le nombre d'enquetes par entretien

## Figure : Nombre d'entretiens et d'enquetes par FKT (type de figure ?)

## Figure : Tableau à double entrée sur la démographie des enquêtés (H/F + classe d'Age)

## Figure : Camemberts/barres sur la Professions et liens au VOI (?)