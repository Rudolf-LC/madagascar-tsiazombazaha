# Ewen Le Coeur
# 2026
# Objectif : diversite alpha (§3.4 du document d'etape) — richesse,
# Shannon, Simpson inverse, alpha de Fisher, par placette puis
# moyenne ± ecart-type et IC 95 % entre placettes.
#
# Structure du code :
#   - fonctionsDiversite.R : fonctions de calcul (abondances, Hill, Fisher)
#   - analyse_diversite_alpha.R  : CE SCRIPT — orchestration, sorties
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/06_analyse_diversite_alpha.R")

source("06_ecologie/analyse/scripts/fonctions/fonctionsDiversite.R")

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

# Flore : observations (gaulis + tiges mesurees en circonference)
flore_brut <- read_csv(
  file.path(dossierDonnees, "flore.csv"),
  show_col_types = FALSE
)

# d$flore : une ligne par observation
d_flore <- flore_brut |>
  rename(
    cdPlacette = placette,
    cdObs = `code-observation-flore`,
    nomVernaculaire = `nom-vernaculaire-brut`,
    gaulis = `nombre-gaulis`
  ) |>
  mutate(gaulis = suppressWarnings(as.numeric(gaulis)))

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
  flore = d_flore,
  floreTiges = d_floreTiges,
  placettes = d_placettes
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Abondances et indices par placette ###

abondances <- calculer_abondances(d, correspondances)
diversiteAlpha <- calculer_diversite_alpha(abondances)

### Tiges d'espece indeterminee (exclues des indices) ###

est_indeterminee <- function(nom) {
  espece <- dplyr::recode(nom, !!!correspondances, .default = nom)
  !is.na(espece) & str_to_lower(str_trim(espece)) == "espèce indéterminée"
}
indetTiges <- d$floreTiges |> filter(est_indeterminee(nomVernaculaire))
indetGaulis <- d$flore |>
  filter(est_indeterminee(nomVernaculaire)) |>
  mutate(gaulis = replace_na(gaulis, 0))
indeterminees <- tibble(
  nbTigesMesurees = nrow(indetTiges),
  nbGaulis = sum(indetGaulis$gaulis),
  nbTotal = nbTigesMesurees + nbGaulis,
  nbPlacettes = n_distinct(c(indetTiges$cdPlacette,
                             indetGaulis$cdPlacette[indetGaulis$gaulis > 0])),
  nbTigesRetenues = sum(abondances$abondance)
)

### Resume entre placettes ###

resumer_ic <- function(valeurs) {
  n <- length(valeurs)
  demi <- qt(0.975, n - 1) * sd(valeurs) / sqrt(n)
  c(n = n, moyenne = mean(valeurs), ecartType = sd(valeurs),
    ic95_bas = mean(valeurs) - demi, ic95_haut = mean(valeurs) + demi)
}

resumeAlpha <- bind_rows(
  t(resumer_ic(diversiteAlpha$S)) |> as_tibble() |>
    mutate(indice = "Richesse S (⁰D)"),
  t(resumer_ic(diversiteAlpha$H)) |> as_tibble() |>
    mutate(indice = "Shannon H'"),
  t(resumer_ic(diversiteAlpha$D1)) |> as_tibble() |>
    mutate(indice = "exp(H') = ¹D (espèces communes)"),
  t(resumer_ic(diversiteAlpha$D2)) |> as_tibble() |>
    mutate(indice = "Simpson inverse ²D (espèces dominantes)"),
  t(resumer_ic(diversiteAlpha$fisher)) |> as_tibble() |>
    mutate(indice = "Alpha de Fisher")
) |>
  dplyr::select(indice, n, moyenne, ecartType, ic95_bas, ic95_haut) |>
  mutate(across(where(is.numeric), ~ round(.x, 2)))

### Exports ###

readr::write_csv(diversiteAlpha,
                  file.path(dossierSorties, "diversite_alpha_placettes.csv"))
readr::write_csv(abondances,
                  file.path(dossierSorties, "diversite_abondances.csv"))
readr::write_csv(resumeAlpha,
                  file.path(dossierSorties, "diversite_alpha_resume.csv"))
readr::write_csv(indeterminees,
                  file.path(dossierSorties, "diversite_indeterminees.csv"))

### Messages ###

message("✅ Diversité alpha (§3.4) — ", nrow(diversiteAlpha),
        " placettes, espèces indéterminées exclues :")
for (i in seq_len(nrow(resumeAlpha))) {
  r <- resumeAlpha[i, ]
  message("   ", r$indice, " : ", r$moyenne, " ± ", r$ecartType,
          " [IC 95 % : ", r$ic95_bas, " ; ", r$ic95_haut, "]")
}

list(
  donnees = d,
  abondances = abondances,
  diversiteAlpha = diversiteAlpha,
  resumeAlpha = resumeAlpha
)
