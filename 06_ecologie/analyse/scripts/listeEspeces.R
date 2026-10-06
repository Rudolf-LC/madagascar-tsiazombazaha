"Ewen Le Coeur
2026
Objectif : produire la liste des especes vegetales de Tsiazombazaha
a partir des feuilles flore-verifiee, grands-arbres, phenologie et
autres-especes, en vue d'une reconciliation taxonomique manuelle.

Sortie : 06_ecologie/analyse/sorties/liste_especes_vegetales.csv
Une ligne par nom vernaculaire normalise, avec :
  - le nom brut d'origine (variantes d'ecriture conservees)
  - les feuilles sources et le nombre d'occurrences dans chacune
  - les usages et types phenotypiques mentionnes (flore + grands arbres)
  - une colonne \"identite\" vide, a remplir lors de la reconciliation

Utilisation :
  source(\"06_ecologie/analyse/scripts/listeEspeces.R\")
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

### Filtres : exclure les notes de saisie qui ne sont pas des especes ###

est_une_espece <- function(x) {
  !is.na(x) &
    !str_detect(x, "!!!|GPS|RECUP") &
    str_trim(x) != ""
}

### Consolidation des quatre sources ###

# flore-verifiee : occurrences par placette, usages et types
floreOcc <- d$flore |>
  filter(est_une_espece(nomVernaculaire)) |>
  mutate(nomNormalise = normaliser_nom(nomVernaculaire)) |>
  group_by(nomNormalise) |>
  summarise(
    occFlore = n(),
    usagesFlore = str_c(unique(na.omit(remarquesUsages)), collapse = " ; "),
    typesFlore = str_c(unique(na.omit(remarquesTypes)), collapse = " ; "),
    .groups = "drop"
  )

# grands-arbres : occurrences sur les transects, usages et types
grandsArbresOcc <- d$grandsArbres |>
  filter(est_une_espece(nomVernaculaire)) |>
  mutate(nomNormalise = normaliser_nom(nomVernaculaire)) |>
  group_by(nomNormalise) |>
  summarise(
    occGrandsArbres = n(),
    usagesGrandsArbres = str_c(unique(na.omit(usages)), collapse = " ; "),
    typesGrandsArbres = str_c(unique(na.omit(descriptionTypes)), collapse = " ; "),
    .groups = "drop"
  )

# phenologie : especes vues en fleurs/fruits
phenologieOcc <- d$phenologie |>
  filter(est_une_espece(espece)) |>
  mutate(nomNormalise = normaliser_nom(espece)) |>
  group_by(nomNormalise) |>
  summarise(
    occPhenologie = n(),
    phenologieTypes = str_c(unique(na.omit(type)), collapse = " ; "),
    .groups = "drop"
  )

# autres-especes : especes vues hors placettes/transects
autresOcc <- d$autresEspeces |>
  filter(est_une_espece(nomVernaculaire)) |>
  mutate(nomNormalise = normaliser_nom(nomVernaculaire)) |>
  group_by(nomNormalise) |>
  summarise(
    occAutres = n(),
    autresRemarques = str_c(unique(na.omit(remarques)), collapse = " ; "),
    .groups = "drop"
  )

### Table des noms bruts conserves (pour la reconciliation) ###

# Le nom normalise est la cle ; on conserve les graphies d'origine
# rencontrees dans chaque feuille pour eclairer la reconciliation.
nomsBruts <- bind_rows(
  d$flore |>
    transmute(source = "flore-verifiee", nom = nomVernaculaire) |>
    distinct(),
  d$grandsArbres |>
    transmute(source = "grands-arbres", nom = nomVernaculaire) |>
    distinct(),
  d$phenologie |>
    transmute(source = "phenologie", nom = espece) |>
    distinct(),
  d$autresEspeces |>
    transmute(source = "autres-especes", nom = nomVernaculaire) |>
    distinct()
) |>
  filter(est_une_espece(nom)) |>
  mutate(nomNormalise = normaliser_nom(nom)) |>
  group_by(nomNormalise) |>
  summarise(
    variantesNomsBruts = str_c(sort(unique(nom)), collapse = " | "),
    sources = str_c(sort(unique(source)), collapse = " | "),
    .groups = "drop"
  )

### Assemblage de la liste ###

listeEspeces <- nomsBruts |>
  left_join(floreOcc, by = "nomNormalise") |>
  left_join(grandsArbresOcc, by = "nomNormalise") |>
  left_join(phenologieOcc, by = "nomNormalise") |>
  left_join(autresOcc, by = "nomNormalise") |>
  mutate(
    across(starts_with("occ"), ~ replace_na(.x, 0)),
    occurrencesTotales = occFlore + occGrandsArbres + occPhenologie + occAutres,
    identite = NA_character_
  ) |>
  arrange(desc(occurrencesTotales), nomNormalise) |>
  select(
    nomNormalise, variantesNomsBruts, sources, occurrencesTotales,
    occFlore, occGrandsArbres, occPhenologie, occAutres,
    usagesFlore, typesFlore,
    usagesGrandsArbres, typesGrandsArbres,
    phenologieTypes, autresRemarques,
    identite
  )

### Export ###

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)
fichierSortie <- file.path(dossierSorties, "liste_especes_vegetales.csv")
write_csv(listeEspeces, fichierSortie)

message("✅ ", nrow(listeEspeces), " espèces écrites dans ", fichierSortie)
message("   Colonne \"identite\" à compléter lors de la réconciliation taxonomique.")
listeEspeces
