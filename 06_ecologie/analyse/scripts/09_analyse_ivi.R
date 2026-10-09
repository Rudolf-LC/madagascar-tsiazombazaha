"
Ewen Le Coeur
2026
Objectif : IVI — Indice de Valeur d'Importance (§3.6 du document
d'etape), sur especes reconciliees.

IVI normalise (Curtis & McIntosh 1951 ; Kent 2011) : chaque
composante est ramenee a une base 100 en la divisant par sa somme
totale, puis l'IVI est la moyenne des trois (maximum 100) :
  - DR  (densite relative)      : % des tiges de l'espece / total tiges ;
  - DoR (dominance relative)    : % de la surface terriere de l'espece
                                  / surface terriere totale ;
  - FR  (frequence relative)    : % des placettes contenant l'espece /
                                  placettes echantillonnees ;
  - IVI normalise = (DR + DoR + FR) / 3.
La normalisation evite que la FR domine l'indice en foret
hyperdiverse a fort turnover (DR et DoR y sont dilues entre de
nombreuses especes, pas la FR : voir note de contexte).

Conventions :
  - tiges mesurees (floreTiges, CBH > 8 cm) ; gaulis exclus (pas de CBH,
    donc pas de surface terriere) ;
  - especes reconciliees uniquement (identite de
    liste_especes_vegetales.csv) ; indeterminees = especes locales
    distinctes (ind_PXX_OOO), comme pour la diversite ;
  - surface terriere g = circ^2 / (4 pi), rapportee a la placette.

Utilisation :
  source(\"06_ecologie/analyse/scripts/09_analyse_ivi.R\")
"

source("06_ecologie/analyse/scripts/01_importDonnees.R")

d <- importer_donnees()

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Reconciliation ###

reconciliation <- readr::read_csv(
  file.path(dossierSorties, "liste_especes_vegetales.csv"),
  show_col_types = FALSE) |>
  dplyr::filter(!is.na(identite), str_trim(identite) != "")
correspondances <- stats::setNames(reconciliation$identite,
                                   reconciliation$nomNormalise)

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
  message("   ", r$rang, ". ", r$espece, " : IVI = ", r$IVInormalise,
          " (DR ", r$DR, ", DoR ", r$DoR, ", FR ", r$FR, ")")
}

list(tiges = tiges, ivi = ivi)
