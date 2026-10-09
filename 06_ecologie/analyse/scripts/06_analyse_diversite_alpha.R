"
Ewen Le Coeur
2026
Objectif : diversite alpha (§3.4 du document d'etape) — richesse,
Shannon, Simpson inverse, alpha de Fisher, par placette puis
moyenne ± ecart-type et IC 95 % entre placettes.

Structure du code :
  - importDonnees.R   : import et nettoyage (socle)
  - fonctionsDiversite.R : fonctions de calcul (abondances, Hill, Fisher)
  - analyse_diversite.R  : CE SCRIPT — orchestration, sorties

Utilisation :
  source(\"06_ecologie/analyse/scripts/analyse_diversite.R\")
"

source("06_ecologie/analyse/scripts/01_importDonnees.R")
source("06_ecologie/analyse/scripts/fonctions/fonctionsStructure.R")
source("06_ecologie/analyse/scripts/fonctions/fonctionsDiversite.R")

d <- importer_donnees()

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

# Correspondances taxonomiques (reconciliation manuelle)
reconciliation <- readr::read_csv(
  file.path(dossierSorties, "liste_especes_vegetales.csv"),
  show_col_types = FALSE) |>
  dplyr::filter(!is.na(identite), str_trim(identite) != "")
correspondances <- stats::setNames(reconciliation$identite,
                                   reconciliation$nomNormalise)

### Abondances et indices par placette ###

abondances <- calculer_abondances(d, correspondances)
diversiteAlpha <- calculer_diversite_alpha(abondances)

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

### Messages ###

message("✅ Diversité alpha (§3.4) — ", nrow(diversiteAlpha),
        " placettes, indéterminées comptées comme espèces distinctes :")
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
