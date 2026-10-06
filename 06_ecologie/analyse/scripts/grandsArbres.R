"
Ewen Le Coeur
21/08/2026
Objectif : analyses basiques sur la feuille grands arbres
"

### Modules ###
library(readODS) # https://cran.r-project.org/package=readODS
library(ggplot2) # 

### Importations ###
fichier <- "donnees/saisie_releves_TZBA.ods"
grandsArbres <- readODS::read_ODS(fichier, sheet = "grands-arbres")
grandsArbres <- grandsArbres[c("Code transect", "Nom simple", "Nom vernaculaire", "Circonférence")]
colnames(grandsArbres) <- c("cdTransect", "nomSimple", "nomComplet", "circ")

transects <- readODS::read_ODS(fichier, sheet = "transects")
transects <- transects[c("Code transect", "Longueur prospection grands arbres")]
colnames(transects) <- c("cdTransect", "longueur")

### Analyses

# Nombre de gros bois à l'hectare, tout confondu
longueurTotal <- sum(transects$longueur)
aireTotal <- longueurTotal * 10
densiteGrosBois <- rows(grandsArbres) / aireTotal / 10000

# Surface terrière des gros bois à l'hectare, tout confondu
grandsArbres$G <- 4/3 * pi * grandsArbres$circ**2
gTotal <- sum(grandsArbres$G)
gGrosBois <- gTotal / aireTotal / 10000

# Surface terrière des gros bois par classe de diamètre
grandsArbres$diam <- circ / pi
grandsArbres$classeDiam <- floor(grandsArbres$diam / 5) # incomplet, réfléchir si classe de 2,5 / 5 / 10
listeClasseDiam <- unique(grandsArbres$classeDiam)
gClasseDiam <- grands_Arbres |> 
  group_by(classeDiam) |> 
  sum(G)

# Calculer les intervalles de confiance à 95 % (méthode X pour agrégation spatiale)
# Faut-il faire cette méthode par transect ou fusionner tous les transects (?)

# Extraire les infos nécessaires pour l'IVI