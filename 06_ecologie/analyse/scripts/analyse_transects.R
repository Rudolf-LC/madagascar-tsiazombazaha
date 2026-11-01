# analyse_transects.R
# Ewen Le Coeur
# 2026
# Objectif : indicateurs releves le long des transects — densite des grands
# arbres (CBH >= 126 cm) a l'hectare avec son erreur-type, et denombrement
# des chablis par classe.
#
# Grands arbres : bande de 10 m (5 m de part et d'autre du chemin) sur les
# transects dont la longueur prospectee est connue (transects.csv). Les
# arbres de CBH < 126 cm (reliquats d'un seuil anterieur) et les lignes
# sans circonference (arbre mort « hors calculs », lignes incompletes) sont
# exclus. La densite est un estimateur par le ratio (effectif total /
# surface totale) ; son erreur-type est celle de l'estimateur par le ratio
# entre transects (Cochran, 1977, chap. 6).
#
# Chablis : PROVISOIRE. Seuls les effectifs par transect et par classe
# (PB < 30, BM 30-60, GB > 60) sont exportes ; les longueurs prospectees
# ne sont pas encore connues, donc aucune densite n'est calculee.
#
# Sorties :
#   - sorties/transects_grands_arbres.csv : effectif, longueur et densite
#     par transect ;
#   - sorties/transects_grands_arbres_resume.csv : densite globale (arbres/ha)
#     et erreur-type ;
#   - sorties/transects_chablis.csv : effectifs par transect et par classe.
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/analyse_transects.R")

### Modules ###

library(dplyr)
library(stringr)
library(readr)

### Import des donnees ###

dossierDonnees <- "06_ecologie/analyse/donnees"
dossierSorties <- "06_ecologie/analyse/sorties"

transects <- read_csv(file.path(dossierDonnees, "transects.csv"),
                      col_types = cols(.default = col_character())) |>
  transmute(cdTransect = transect,
            longueur_m = suppressWarnings(
              as.numeric(`longueur-prospection-grands-arbres`))) |>
  filter(!is.na(longueur_m))

grandsArbres <- read_csv(file.path(dossierDonnees, "grands-arbres.csv"),
                         col_types = cols(.default = col_character())) |>
  transmute(cdTransect = transect,
            circ_cm = suppressWarnings(as.numeric(circonference))) |>
  filter(!is.na(cdTransect), !is.na(circ_cm), circ_cm >= 126)

chablis <- read_csv(file.path(dossierDonnees, "chablis.csv"),
                    col_types = cols(.default = col_character()))

### Grands arbres ###

largeurBande_m <- 10

parTransect <- transects |>
  left_join(grandsArbres |> count(cdTransect, name = "nbArbres"),
            by = "cdTransect") |>
  mutate(nbArbres = coalesce(nbArbres, 0L),
         surface_m2 = longueur_m * largeurBande_m,
         densite_ha = nbArbres / surface_m2 * 10000)

m <- nrow(parTransect)
ratio <- sum(parTransect$nbArbres) / sum(parTransect$surface_m2)
s2 <- sum((parTransect$nbArbres - ratio * parTransect$surface_m2)^2) / (m - 1)
erreurTypeRatio <- sqrt(s2 / m) / mean(parTransect$surface_m2)

resumeGA <- tibble(
  nbTransects = m,
  nbArbres = sum(parTransect$nbArbres),
  longueurTotale_m = sum(parTransect$longueur_m),
  surfaceTotale_m2 = sum(parTransect$surface_m2),
  densite_ha = ratio * 10000,
  erreurType_ha = erreurTypeRatio * 10000
)

### Chablis (provisoire) ###

chablisEffectifs <- chablis |>
  transmute(
    cdTransect = transect,
    nombre = suppressWarnings(as.numeric(`nombre-chablis`)),
    classe = str_trim(str_remove(remarques, "/!\\\\.*$"))
  ) |>
  filter(!is.na(nombre))

### Exports ###

write_csv(parTransect, file.path(dossierSorties, "transects_grands_arbres.csv"))
write_csv(resumeGA, file.path(dossierSorties,
                              "transects_grands_arbres_resume.csv"))
write_csv(chablisEffectifs, file.path(dossierSorties, "transects_chablis.csv"))

message("✅ Grands arbres : ", resumeGA$nbArbres, " arbres sur ",
        resumeGA$longueurTotale_m, " m (", m, " transects) ; densite = ",
        round(resumeGA$densite_ha, 2), " ± ", round(resumeGA$erreurType_ha, 2),
        " arbres/ha (erreur-type)")
message("⚠️ Chablis : effectifs seulement (longueurs prospectees inconnues)")
