"
Ewen Le Coeur
21/08/2026
Objectif : import des donneés terrains
"

### Modules ###
library(readODS) # https://cran.r-project.org/package=readODS

### Importations ###
fichier <- "donnees/saisie_releves_TZBA.ods"
transects <- read_ODS(fichier, sheet = "transects")
grandsArbres <- read_ODS(fichier, sheet = "grands-arbres")
placettes <- read_ODS(fichier, sheet = "placettes", skip = 1)
boisMort <- read_ODS(fichier, sheet = "bois-mort")
flore <- read_ODS(fichier, sheet = "flore")
autresEspeces <- read_ODS(fichier, sheet = "autres-especes")

