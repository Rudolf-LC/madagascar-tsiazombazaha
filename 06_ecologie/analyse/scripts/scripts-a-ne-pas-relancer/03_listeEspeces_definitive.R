# Ewen Le Coeur
# 2026
# Objectif : Liste définitive des espèces végétales de Tsiazombazaha (§3.1 du document
# d'étape) — consolidation par identité révélée par la réconciliation taxonomique manuelle.
#
# À partir de referentiels/reconciliation-taxonomique.csv et des données brutes
# (donnees/autres-observations-flore.csv, donnees/flore.csv, donnees/grands-arbres.csv,
# donnees/phenologie.csv), ce script produit la liste finale :
#   - une ligne par NOMReconcilie (espèce révélée)
#   - colonnes : NOMReconcilie / nomBinominal / usages-normalisé / nbTypes /
#     desc des types+typesReconcilie / remarques autres
#   - avec | pour séparer les valeurs multiples
#   - sans doublon, en fusionnant les lignes avec le même NOMReconcilie
#
# Sortie : 06_ecologie/analyse/sorties/liste_especes_par_identite.csv
#
# Utilisation : source('scripts/03_listeEspeces_definitive.R')
#
# ---

### Modules ###

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")

library(dplyr)
library(tidyr)
library(stringr)
library(readr)

### Chargement des données ###

# Référentiels (chemins depuis la racine du dépôt)
reconciliation <- read_csv("06_ecologie/analyse/referentiels/reconciliation-taxonomique.csv", show_col_types = FALSE)
normalisation_usages <- read_csv("06_ecologie/analyse/referentiels/normalisation-usages.csv", show_col_types = FALSE)

# Données brutes (depuis la racine du dépôt)
autresEspeces <- read_csv("06_ecologie/analyse/donnees/autres-observations-flore.csv", show_col_types = FALSE)
flore <- read_csv("06_ecologie/analyse/donnees/flore.csv", show_col_types = FALSE)
grandsArbres <- read_csv("06_ecologie/analyse/donnees/grands-arbres.csv", show_col_types = FALSE)
phenologie <- read_csv("06_ecologie/analyse/donnees/phenologie.csv", show_col_types = FALSE)

### Fonctions utilitaires ###

# Normalisation des noms
normaliser_nom <- function(x) {
  x <- str_to_lower(str_squish(as.character(x)))
  dplyr::if_else(is.na(x), x,
                 paste0(str_sub(x, 1, 1) |> str_to_upper(), str_sub(x, 2)))
}

# Nettoyage des textes
nettoyer_texte <- function(x) {
  x <- str_squish(str_trim(as.character(x)))
  x[!is.na(x) & x != "" & x != "NA"]
}

# Agrégation des valeurs avec | comme séparateur
aggreger_avec_pipe <- function(x) {
  x <- nettoyer_texte(x)
  x <- x[!is.na(x)]
  if (length(x) == 0) return(NA_character_)
  paste(sort(unique(x)), collapse = " | ")
}

# Flore : usages, types, remarques
extraire_usages_types_flore <- function() {
  flore |>
    mutate(
      nomNormalise = normaliser_nom(`nom-vernaculaire-brut`),
    ) |>
    left_join(normalisation_usages, by = c(usages = "usage-brut")) |>
    filter(!is.na(nomNormalise)) |>
    group_by(nomNormalise) |>
    summarise(
      usages = aggreger_avec_pipe(`usage-normalise`),
      nbTypes = aggreger_avec_pipe(`nombre-types`),
      distinctionsTypes = aggreger_avec_pipe(`definition-types`),
      remarques = aggreger_avec_pipe(`remarques-autres`)
    )
}

# Grands arbres : usages, types, remarques
extraire_usages_types_grandsArbres <- function() {
  grandsArbres |>
    mutate(
      nomNormalise = normaliser_nom(`nom-vernaculaire-brut`)
    ) |>
    filter(!is.na(nomNormalise)) |>
    group_by(nomNormalise) |>
    summarise(
      usages = NA_character_,
      `usages-normalises` = NA_character_,
      nbTypes = NA_character_,
      distinctionsTypes = NA_character_,
      remarques = aggreger_avec_pipe(remarques)
    )
}

# Autres observations flore : usages, types, remarques
extraire_usages_types_autres <- function() {
  autresEspeces |>
    mutate(nomNormalise = normaliser_nom(`nom-vernaculaire-brut`)) |>
    filter(!is.na(nomNormalise)) |>
    group_by(nomNormalise) |>
    summarise(
      usages = NA_character_,
      nbTypes = NA_character_,
      distinctionsTypes = NA_character_,
      remarques = aggreger_avec_pipe(`remarques`)
    )
}

# Phénologie : types (fleurs/fruits)
extraire_types_phenologie <- function() {
  phenologie |>
    mutate(nomNormalise = normaliser_nom(`nom-vernaculaire-brut`)) |>
    filter(!is.na(nomNormalise)) |>
    group_by(nomNormalise) |>
    summarise(
      usages = NA_character_,
      nbTypes = NA_character_,
      distinctionsTypes = NA_character_,
      remarques = aggreger_avec_pipe(remarque)
    )
}

# Fusion de toutes les sources
details <- bind_rows(
  extraire_usages_types_flore(),
  extraire_usages_types_grandsArbres(),
  extraire_usages_types_autres(),
  extraire_types_phenologie()
) |>
  distinct(nomNormalise, .keep_all = TRUE)

### Assemblage final par NOMReconcilie ###

listeEspecesDefinitive <- reconciliation |>
  mutate(nomNormalise = normaliser_nom(`nom-vernaculaire-brut`)) |>
  left_join(details, by = "nomNormalise") |>
  mutate(
    nb_types = coalesce(distinctionsTypes, NA_character_),
    distinctions_types = coalesce(distinctionsTypes, NA_character_),
    remarques_autres = coalesce(remarques, NA_character_)
  ) |>
  group_by(`nom-vernaculaire-reconcilie`) |>
  summarise(
    `nom-binomial` = aggreger_avec_pipe(`nom-binominal`),
    `usages` = ifelse(all(is.na(`usages`) | `usages` == ""), NA_character_, `usages`),
    `nb-types` = aggreger_avec_pipe(nbTypes),
    `distinctions-types` = aggreger_avec_pipe(distinctionsTypes),
    `remarques-autres` = aggreger_avec_pipe(remarques_autres)
  ) |>
  arrange(`nom-vernaculaire-reconcilie`)

### Export ###

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)
write_csv(listeEspecesDefinitive, file.path(dossierSorties, "liste-especes-par-identite.csv"))

message("✅ Liste des espèces végétales (§3.1) :")
message("   ", nrow(listeEspecesDefinitive), " identités (espèces) produites.")
message("   Export : liste-especes-par-identite.csv")

# ### Messages ###
# 
# message("✅ Liste des espèces végétales (§3.1) :")
# message("   ", nrow(listeEspecesDefinitive), " identités (espèces) sur ",
#         nrow(reconciliation), " noms vernaculaires")
# message("   Identifications botaniques : ",
#         sum(str_trim(listeEspecesDefinitive$identificationsBotaniques) != ""),
#         " / ", nrow(listeEspecesDefinitive))
# message("   Export : liste_especes_vegetales_definitive.csv")
# message("   Association espece x usage : ", nrow(associationUsages),
#         " couples (", n_distinct(associationUsages$usage_normalise),
#         " usages distincts, sans 'aucun')")
# message("   Export : association_espece_usage.csv")
# message("   Espèces vernaculaires (noms normalisés) : ", nbEspecesVernaculaires)
# message("   Types par espèce : ", round(statsTypes["moyenne"], 2),
#         " ± ", round(statsTypes["ecartType"], 2),
#         " [IC 95 % : ", round(statsTypes["ic95_bas"], 2), " ; ",
#         round(statsTypes["ic95_haut"], 2), "] (n = ", statsTypes["n"], ")")
# message("   Usages par espèce (toutes) : ", round(statsUsagesToutes["moyenne"], 2),
#         " ± ", round(statsUsagesToutes["ecartType"], 2),
#         " [IC 95 % : ", round(statsUsagesToutes["ic95_bas"], 2), " ; ",
#         round(statsUsagesToutes["ic95_haut"], 2), "]")
# message("   Usages par espèce (ayant ≥ 1 usage) : ",
#         round(statsUsagesAvec["moyenne"], 2), " ± ",
#         round(statsUsagesAvec["ecartType"], 2),
#         " [IC 95 % : ", round(statsUsagesAvec["ic95_bas"], 2), " ; ",
#         round(statsUsagesAvec["ic95_haut"], 2), "] (n = ", statsUsagesAvec["n"], ")")
# for (i in seq_len(nrow(especesParClasse))) {
#   r <- especesParClasse[i, ]
#   message("   ", r$libelle, " : ", r$nbEspeces,
#           " espèces — usages: ", r$usagesDetailles)
# }

listeEspecesDefinitive
