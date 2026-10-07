"
Ewen Le Coeur
2026
Objectif : liste des especes vegetales de Tsiazombazaha (§3.1 du document
d'etape) — consolidation par identite revelee par la reconciliation
taxonomique manuelle.

A partir de liste_especes_vegetales.csv (une ligne par nom vernaculaire
normalise, avec la colonne identite remplie par la reconciliation), ce
script produit la liste finale :
  - une ligne par IDENTITE (espece reveleee)
  - occurrences consolidees (toutes sources confondues)
  - noms vernaculaires normalises regroupes sous l'identite
  - identification botanique, types et usages mentionnes

Sorties :
  06_ecologie/analyse/sorties/liste_especes_par_identite.csv
  06_ecologie/analyse/sorties/liste_especes_vegetales_definitive.csv

Utilisation :
  source(\"06_ecologie/analyse/scripts/listeEspecesDefinitive.R\")
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

dossierSorties <- "06_ecologie/analyse/sorties"
fichierReconciliation <- file.path(dossierSorties, "liste_especes_vegetales.csv")

if (!file.exists(fichierReconciliation)) {
  stop("liste_especes_vegetales.csv introuvable : lancer listeEspeces.R puis compléter la colonne identite.")
}

reconciliation <- read_csv(fichierReconciliation, show_col_types = FALSE) |>
  filter(!is.na(identite), str_trim(identite) != "")

### Recuperation des donnees brutes de types et usages (flore + grands arbres) ###

# Le CSV de reconciliation resume trop ces champs : on puise dans l'ODS
# pour recuperer tous les usages, tous les nombres de types et toutes les
# distinctions entre types renseignes pour chaque identite.
d <- importer_donnees()

correspondances <- setNames(reconciliation$identite, reconciliation$nomNormalise)

floreDetails <- d$flore |>
  mutate(identite = dplyr::recode(nomVernaculaire, !!!correspondances,
                                  .default = nomVernaculaire)) |>
  mutate(identite = str_trim(identite)) |>
  select(identite,
         usagesBruts = remarquesUsages,
         nbTypesBrut = nbTypes,
         distinctionsBrutes = remarquesTypes)

grandsArbresDetails <- d$grandsArbres |>
  mutate(identite = dplyr::recode(nomVernaculaire, !!!correspondances,
                                  .default = nomVernaculaire)) |>
  mutate(identite = str_trim(identite)) |>
  select(identite,
         usagesBruts = usages,
         nbTypesBrut = nbTypes,
         distinctionsBrutes = descriptionTypes)

details <- bind_rows(floreDetails, grandsArbresDetails)

nettoyer_texte <- function(x) {
  x <- str_squish(str_trim(as.character(x)))
  x[!is.na(x) & x != "" & x != "NA"]
}

# Nombres de types valides : entiers uniquement. Les annotations non
# numeriques (++, na) sont ecartees. Si plusieurs nombres distincts
# existent pour une meme identite, tous sont conserves (ex. "1, 2, 3").
normaliser_nb_types <- function(x) {
  v <- suppressWarnings(as.integer(str_trim(as.character(x))))
  sort(unique(v[!is.na(v)]))
}

resumeDetails <- details |>
  filter(!is.na(identite), str_trim(identite) != "") |>
  group_by(identite) |>
  group_modify(~ {
    usages <- nettoyer_texte(.x$usagesBruts)
    nbTypes <- normaliser_nb_types(.x$nbTypesBrut)
    distinctions <- nettoyer_texte(.x$distinctionsBrutes)
    tibble(
      usages = paste(sort(unique(usages)), collapse = " ; "),
      nbTypes = paste(nbTypes, collapse = ", "),
      distinctionsTypes = paste(sort(unique(distinctions)), collapse = " ; ")
    )
  }) |>
  ungroup()

### Consolidation par identite ###

listeEspecesDefinitive <- reconciliation |>
  mutate(identite = str_trim(identite)) |>
  group_by(identite) |>
  summarise(
    nomsVernaculaires = str_c(sort(unique(str_trim(nomNormalise))),
                              collapse = " | "),
    nbNomsVernaculaires = n_distinct(str_trim(nomNormalise)),
    occurrencesTotales = sum(occurrencesTotales),
    occFlore = sum(occFlore),
    occGrandsArbres = sum(occGrandsArbres),
    occPhenologie = sum(occPhenologie),
    occAutres = sum(occAutres),
    identificationsBotaniques = str_c(
      sort(unique(str_trim(na.omit(identification_botanique)))),
      collapse = " | "),
    sources = str_c(
      sort(unique(unlist(str_split(sources, fixed("..")))), collapse = " | "),
    .groups = "drop"
  ) |>
  left_join(resumeDetails, by = "identite") |>
  arrange(desc(occurrencesTotales), identite) |>
  mutate(
    across(c(identificationsBotaniques, sources),
           ~ str_remove_all(.x, '(NA[[:space:]]*[;|][[:space:]]*)+') |>
             str_remove_all('[[:space:]]*[;|][[:space:]]*NA$') |>
             str_remove_all('^NA$') |>
             str_squish())
  ) |>
  select(identite, nomsVernaculaires, occurrencesTotales,
         identificationsBotaniques, usages, nbTypes, distinctionsTypes,
         everything())


### Exports ###

write_csv(listeEspecesDefinitive,
          file.path(dossierSorties, "liste_especes_vegetales_definitive.csv"))

### Messages ###

message("✅ Liste des espèces végétales (§3.1) :")
message("   ", nrow(listeEspecesDefinitive), " identités (espèces) sur ",
        nrow(reconciliation), " noms vernaculaires")
message("   Identifications botaniques : ",
        sum(str_trim(listeEspecesDefinitive$identificationsBotaniques) != ""),
        " / ", nrow(listeEspecesDefinitive))
message("   Export : liste_especes_vegetales_definitive.csv")

listeEspecesDefinitive
