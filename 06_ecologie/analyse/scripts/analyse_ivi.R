# Ewen Le Coeur
# 2026
# Objectif : IVI — Indice de Valeur d'Importance (§3.6 du document
# d'etape), sur especes reconciliees.
#
# IVI normalise (Curtis & McIntosh 1951 ; Kent 2011) : chaque
# composante est ramenee a une base 100 en la divisant par sa somme
# totale, puis l'IVI est la moyenne des trois (maximum 100) :
#   - DR  (densite relative)      : % des tiges de l'espece / total tiges ;
#   - DoR (dominance relative)    : % de la surface terriere de l'espece
#                                   / surface terriere totale ;
#   - FR  (frequence relative)    : % des placettes contenant l'espece /
#                                   placettes echantillonnees ;
#   - IVI normalise = (DR + DoR + FR) / 3.
# La normalisation evite que la FR domine l'indice en foret
# hyperdiverse a fort turnover (DR et DoR y sont dilues entre de
# nombreuses especes, pas la FR : voir note de contexte).
#
# Conventions :
#   - tiges mesurees (floreTiges, CBH > 8 cm) ; gaulis exclus (pas de CBH,
#     donc pas de surface terriere) ;
#   - especes reconciliees uniquement (reconciliation-taxonomique.csv) ;
#     indeterminees = especes locales distinctes (ind_PXX_OOO) ;
#   - surface terriere g = circ^2 / (4 pi), rapportee a la placette.
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/09_analyse_ivi.R")

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")

library(dplyr)
library(tidyr)
library(readr)
library(stringr)

### Import des donnees CSV ###

dossierDonnees <- "06_ecologie/analyse/donnees"
dossierReferentiels <- "06_ecologie/analyse/referentiels"

# Reconciliation taxonomique
reconciliation <- read_csv(
  file.path(dossierReferentiels, "reconciliation-taxonomique.csv"),
  show_col_types = FALSE
)

# Correspondances : nom brut → nom reconcilie
correspondances <- reconciliation |>
  distinct(`nom-vernaculaire-brut`, `nom-vernaculaire-reconcilie`)
correspondances <- stats::setNames(
  correspondances$`nom-vernaculaire-reconcilie`,
  correspondances$`nom-vernaculaire-brut`
)

# Flore : tiges mesurees en circonference
flore_brut <- read_csv(
  file.path(dossierDonnees, "flore.csv"),
  show_col_types = FALSE
)

# d$floreTiges : format long des circonferences mesurees
cols_circ <- c("Circ1", "Circ2", "Circ3", "Circ4", "Circ5", "Circ6",
               "Cir7", "Circ8", "Circ9", "Cir10")
cols_circ_present <- intersect(cols_circ, names(flore_brut))

d_floreTiges <- flore_brut |>
  select(placette, `code-observation-flore`, `nom-vernaculaire-brut`,
         all_of(cols_circ_present)) |>
  pivot_longer(
    cols = all_of(cols_circ_present),
    names_to = "numTige",
    values_to = "circ_cm"
  ) |>
  filter(!is.na(circ_cm)) |>
  mutate(circ_cm = suppressWarnings(as.numeric(circ_cm))) |>
  filter(!is.na(circ_cm)) |>
  rename(
    cdPlacette = placette,
    cdObs = `code-observation-flore`,
    nomVernaculaire = `nom-vernaculaire-brut`
  ) |>
  select(cdPlacette, cdObs, nomVernaculaire, circ_cm, numTige)

# Placettes
d_placettes <- read_csv(
  file.path(dossierDonnees, "placettes.csv"),
  show_col_types = FALSE,
  col_types = cols(
    `surface-horizontale` = col_character(),
    `surface-corrigee` = col_character()
  )
) |>
  rename(
    cdPlacette = placette,
    cdTransect = transect,
    surfaceHorizontale_m2 = `surface-horizontale`
  ) |>
  mutate(
    surfaceHorizontale_m2 = as.numeric(gsub(",", ".", surfaceHorizontale_m2))
  )

# Assemblage de l'objet d
d <- list(
  floreTiges = d_floreTiges,
  placettes = d_placettes
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Tiges mesurees avec espece reconciliee et surface terriere ###

tiges <- d$floreTiges |>
  dplyr::mutate(
    espece = dplyr::recode(nomVernaculaire, !!!correspondances,
                           .default = nomVernaculaire),
    espece = dplyr::if_else(
      str_to_lower(str_trim(espece)) == "espèce indéterminée",
      paste0("ind_", cdPlacette, "_", cdObs),
      espece
    ),
    g_m2 = (circ_cm / 100)^2 / (4 * pi)
  ) |>
  dplyr::filter(!is.na(espece), str_trim(espece) != "",
                !is.na(circ_cm))

nbPlacettesTotal <- d$placettes$cdPlacette |> unique() |> length()
nbPlacettesEchantillonnees <- tiges$cdPlacette |> unique() |> length()
totalTiges <- nrow(tiges)

### IVI a l'echelle du dispositif ###

ivi <- tiges |>
  dplyr::group_by(espece) |>
  dplyr::summarise(
    nbTiges = dplyr::n(),
    g_m2 = sum(g_m2),
    nbPlacettes = dplyr::n_distinct(cdPlacette),
    .groups = "drop"
  ) |>
  dplyr::mutate(
    DR = 100 * nbTiges / sum(nbTiges),
    DoR = 100 * g_m2 / sum(g_m2),
    FR = 100 * nbPlacettes / sum(nbPlacettes),
    IVInormalise = (DR + DoR + FR) / 3
  ) |>
  dplyr::arrange(dplyr::desc(IVInormalise)) |>
  dplyr::mutate(rang = dplyr::row_number()) |>
  dplyr::select(rang, espece, nbTiges, nbPlacettes, g_m2,
                DR, DoR, FR, IVInormalise)

### Exports ###

readr::write_csv(ivi, file.path(dossierSorties, "ivi_especes.csv"))

### Messages ###

message("✅ IVI (§3.6) — ", nrow(ivi), " espèces, ",
        nbPlacettesEchantillonnees, " placettes échantillonnées (",
        nbPlacettesTotal, " au total), ", totalTiges, " tiges :")
for (i in seq_len(min(10, nrow(ivi)))) {
  r <- ivi[i, ]
  message("   ", r$rang, ". ", r$espece, " : IVI = ", round(r$IVInormalise, 2),
          " (DR ", round(r$DR, 2), ", DoR ", round(r$DoR, 2),
          ", FR ", round(r$FR, 2), ")")
}

list(tiges = tiges, ivi = ivi)
