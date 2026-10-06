"
Ewen Le Coeur
2026
Objectif : calculs des indices écologiques

Ce script traite la STRUCTURE FORESTIÈRE (document d'étape §3.2,
Mémento du forestier tropical, Mille & Louppe 2015) :
  - Densité N (tiges/ha), gaulis inclus
  - Distribution des effectifs par classe de diamètre (largeur 2,5 cm)
  - Surface terrière G (m²/ha)
à l'échelle du dispositif ET par placette (moyenne ± écart-type).

Reste à traiter dans ce script (sections du document d'étape) :
  - chablis/ha et arbres DBH>40 /ha (transects, §3.2)
  - stock de carbone AGB/BGB Chave (§3.3)
  - volume de bois mort (Van Wagner) (§3.3)
  - diversité alpha (Shannon, Simpson, Fisher) (§3.4)
  - IVI (§3.6)

Utilisation :
  source(\"06_ecologie/analyse/scripts/calcIndices.R\")
"

### Modules ###

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")

library(dplyr)
library(tidyr)
library(stringr)
library(readr)

source("06_ecologie/analyse/scripts/importDonnees.R")
d <- importer_donnees()

### Préparation des tiges ###

# Tiges mesurées (CBH > 8 cm) : floreTiges.
# Gaulis (tiges < 1,30 m) : non mesurés — comptés dans la densité,
# exclus de la surface terrière (pas de CBH).
# La surface terrière se rapporte à la surface horizontale.
tiges <- d$floreTiges |>
  mutate(
    dbh_cm = circ_cm / pi,
    classeDiam = floor(dbh_cm / 2.5) * 2.5
  )

gaulis <- d$flore |>
  filter(!is.na(gaulis)) |>
  group_by(cdPlacette) |>
  summarise(nbGaulis = sum(gaulis), .groups = "drop")

### Surfaces ###

surfaceTotale <- sum(d$placettes$surfaceHorizontale_m2, na.rm = TRUE)
message("Surface inventoriée (horizontale) : ", round(surfaceTotale, 1),
        " m² sur ", nrow(d$placettes), " placettes")

### Densité N ###

nbTigesMesurees <- nrow(tiges)
nbGaulis <- sum(gaulis$nbGaulis)
densite <- (nbTigesMesurees + nbGaulis) / surfaceTotale * 10000

densite_dispositif <- tibble(
  indicateur = "Densité N (tiges/ha)",
  tigesMesurees = nbTigesMesurees,
  gaulis = nbGaulis,
  valeur = densite
)

### Distribution par classe de diamètre (largeur 2,5 cm) ###

classesDiametre <- tiges |>
  count(classeDiam, name = "effectif") |>
  arrange(classeDiam) |>
  mutate(
    densite_ha = effectif / surfaceTotale * 10000,
    frequence = effectif / nbTigesMesurees
  )

### Surface terrière G ###

# G = somme des sections à hauteur de poitrine = pi/4 * DHP²
g_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(G_m2 = sum(pi / 4 * (dbh_cm / 100)^2), nbTiges = n(), .groups = "drop")

surfaceTerriere <- sum(g_par_placette$G_m2)
G_ha <- surfaceTerriere / surfaceTotale * 10000

surfaceTerriere_dispositif <- tibble(
  indicateur = "Surface terrière G (m²/ha)",
  valeur = G_ha
)

### Indices par placette : moyenne et écart-type ###

placettesIndices <- d$placettes |>
  select(cdPlacette, surfaceHorizontale_m2) |>
  left_join(g_par_placette, by = "cdPlacette") |>
  left_join(gaulis, by = "cdPlacette") |>
  mutate(
    nbGaulis = replace_na(nbGaulis, 0),
    nbTiges = replace_na(nbTiges, 0),
    densitePlacette = (nbTiges + nbGaulis) / surfaceHorizontale_m2 * 10000,
    GhaPlacette = replace_na(G_m2, 0) / surfaceHorizontale_m2 * 10000
  )

resume_placettes <- placettesIndices |>
  summarise(
    densite_moyenne = mean(densitePlacette),
    densite_ecartType = sd(densitePlacette),
    Gha_moyenne = mean(GhaPlacette),
    Gha_ecartType = sd(GhaPlacette)
  )

### Indicateurs des transects : grands arbres DBH > 40 et chablis ###

# N.B. conventions (document d'étape §3.2) :
#  - largeur de prospection : 10 m -> surface = longueur x 10
#  - la feuille "transects" mélange longueurs (m) et réponses Oui/Non
#    selon que la prospection a eu lieu ; seules les valeurs numériques
#    sont des longueurs exploitables. Les transects sans longueur
#    renseignée sont exclus et signalés.

surfaceTransects_m2 <- longueurTotaleTransects * 10

transectsSansLongueur <- d$transects |>
  filter(is.na(longueurGA)) |>
  pull(cdTransect)
if (length(transectsSansLongueur) > 0) {
  message("⚠️  Transects sans longueur de prospection exploitables : ",
          paste(transectsSansLongueur, collapse = ", "),
          " — exclus des calculs à l'hectare.")
}

# Nombre de grands arbres (DBH > 40 cm) a l'hectare
grandsArbresValides <- d$grandsArbres |>
  filter(cdTransect %in% d$transects$cdTransect[!is.na(d$transects$longueurGA)])

nbGrandsArbres <- nrow(grandsArbresValides)
densiteGrandsArbres <- nbGrandsArbres / surfaceTransects_m2 * 10000

grandsArbresDispositif <- tibble(
  indicateur = "Grands arbres DBH>40 (arbres/ha)",
  valeur = densiteGrandsArbres
)

# Surface terriere des grands arbres a l'hectare
GgrandsArbres <- grandsArbresValides |>
  summarise(G_m2 = sum(pi / 4 * (circ_cm / pi / 100)^2, na.rm = TRUE)) |>
  pull(G_m2)
GgrandsArbres_ha <- GgrandsArbres / surfaceTransects_m2 * 10000

# Chablis a l'hectare
# Convention : seuls les transects avec prospection chablis attestée
# (prospChablis == TRUE) sont comptés ; les longueurs correspondantes
# ne sont pas renseignées dans le fichier -> a completer.
chablisValides <- d$chablis
nbChablis <- sum(chablisValides$nombre, na.rm = TRUE)
transectsChablis <- d$transects |>
  filter(prospChablis == TRUE) |>
  pull(cdTransect)
longueurChablisConnue <- sum(d$transects$longueurGA[d$transects$cdTransect %in% transectsChablis], na.rm = TRUE)

chablisDispositif <- tibble(
  indicateur = "Chablis (/ha)",
  nbChablis = nbChablis,
  transectsProspectes = paste(transectsChablis, collapse = ", "),
  longueurConnue_m = longueurChablisConnue,
  valeur = NA_real_
)
if (longueurChablisConnue > 0) {
  chablisDispositif$valeur <- nbChablis / (longueurChablisConnue * 10) * 10000
}

### Sorties ###

resultat <- list(
  surface_m2 = surfaceTotale,
  densite_dispositif = densite_dispositif,
  classesDiametre = classesDiametre,
  surfaceTerriere_m2 = surfaceTerriere,
  surfaceTerriere_ha = surfaceTerriere_dispositif,
  placettesIndices = placettesIndices,
  resume_placettes = resume_placettes
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)
write_csv(classesDiametre, file.path(dossierSorties, "structure_classes_diametre.csv"))
write_csv(placettesIndices, file.path(dossierSorties, "structure_indices_placettes.csv"))

message("✅ Structure forestière :")
message("   Densité N = ", round(densite), " tiges/ha (",
        nbTigesMesurees, " tiges mesurées + ", nbGaulis, " gaulis, ",
        round(surfaceTotale, 1), " m²)")
message("   Surface terrière G = ", round(G_ha, 2), " m²/ha")
resultat
