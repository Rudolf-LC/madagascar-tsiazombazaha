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

dossierSorties <- "06_ecologie/analyse/sorties"
fichierReconciliation <- file.path(dossierSorties, "liste_especes_vegetales.csv")

if (!file.exists(fichierReconciliation)) {
  stop("liste_especes_vegetales.csv introuvable : lancer listeEspeces.R puis compléter la colonne identite.")
}

reconciliation <- read_csv(fichierReconciliation, show_col_types = FALSE) |>
  filter(!is.na(identite), str_trim(identite) != "")

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
    types = str_c(
      sort(unique(str_trim(str_remove_all(na.omit(identite_type), "^\\s*\\|\\s*$")))),
      collapse = " ; "),
    usages = str_c(
      sort(unique(str_trim(na.omit(c(usagesFlore, usagesGrandsArbres))))),
      collapse = " ; "),
    typesPhenotypiques = str_c(
      sort(unique(str_trim(na.omit(typesFlore)))),
      collapse = " ; "),
    sources = str_c(
      sort(unique(unlist(str_split(sources, "\\.\\.")))), collapse = " | "),
    .groups = "drop"
  ) |>
  arrange(desc(occurrencesTotales), identite) |>
  mutate(
    # nettoyage des NA agrégés par str_c (cellules vides à l'origine)
    across(c(identificationsBotaniques, types, usages,
             typesPhenotypiques, sources),
           ~ str_remove_all(.x, '(NA[[:space:]]*[;|][[:space:]]*)+') |>
             str_remove_all('[[:space:]]*[;|][[:space:]]*NA$') |>
             str_remove_all('^NA$') |>
             str_squish())

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
