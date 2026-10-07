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

# Referentiels d'usages (classification Cook/TDWG, adaptée localement)
dossierReferentiels <- "06_ecologie/analyse/referentiels"
mappingMentions <- read_csv(file.path(dossierReferentiels,
                                      "mapping_mentions_usages.csv"),
                            show_col_types = FALSE)
correspondanceUsages <- read_csv(file.path(dossierReferentiels,
                                           "correspondance_usages.csv"),
                                 show_col_types = FALSE)

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

# Nombres de types : entiers conserves (tous si plusieurs valeurs
# distinctes pour une meme identite, ex. "1, 2, 3"). L'annotation "++"
# (beaucoup de types) est conservee ; "na" est ecarte.
normaliser_nb_types <- function(x) {
  x <- str_trim(as.character(x))
  x <- x[!is.na(x) & x != "" & tolower(x) != "na"]
  entiers <- suppressWarnings(as.integer(x))
  nombres <- sort(unique(entiers[!is.na(entiers)]))
  plus <- unique(x[is.na(suppressWarnings(as.integer(x))) & x == "++"])
  c(nombres, plus)
}

# Traduction des mentions brutes en usages normalises (une mention peut
# donner plusieurs usages, ex. "Planches, poutres" -> planche + poutre),
# puis jointure de la classe locale et du mapping Cook.
traduire_usages <- function(mentions) {
  mentions <- nettoyer_texte(mentions)
  usages <- mappingMentions$usage_normalise[
    match(mentions, mappingMentions$mention_brute)]
  usages <- usages[!is.na(usages)]
  sort(unique(usages))
}

resumeDetails <- details |>
  filter(!is.na(identite), str_trim(identite) != "") |>
  group_by(identite) |>
  group_modify(~ {
    usagesNormalises <- traduire_usages(.x$usagesBruts)
    classes <- correspondanceUsages$classe_locale[
      match(usagesNormalises, correspondanceUsages$usage_normalise)]
    tibble(
      usages = paste(usagesNormalises, collapse = " ; "),
      usagesClasses = paste(sort(unique(classes[!is.na(classes)])),
                            collapse = " ; "),
      nbTypes = paste(normaliser_nb_types(.x$nbTypesBrut), collapse = ", "),
      distinctionsTypes = paste(sort(unique(
        nettoyer_texte(.x$distinctionsBrutes))), collapse = " ; ")
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
    sources = str_c(sort(unique(unlist(str_split(sources, fixed(".."))))),
                    collapse = " | "),
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
         identificationsBotaniques, usages, usagesClasses, nbTypes,
         distinctionsTypes, everything())


### Exports ###

write_csv(listeEspecesDefinitive,
          file.path(dossierSorties, "liste_especes_vegetales_definitive.csv"))

### Table d'association espece x usage (n-n) ###

# Une ligne par couple (identite, usage_normalise), avec la classe locale.
# Base des analyses de diversite des usages.
associationUsages <- details |>
  filter(!is.na(identite), str_trim(identite) != "") |>
  mutate(identite = str_trim(identite)) |>
  select(identite, usagesBruts) |>
  filter(!is.na(usagesBruts)) |>
  mutate(mention = str_trim(as.character(usagesBruts))) |>
  left_join(mappingMentions, by = c("mention" = "mention_brute")) |>
  filter(!is.na(usage_normalise), usage_normalise != "aucun") |>
  distinct(identite, usage_normalise) |>
  left_join(correspondanceUsages, by = "usage_normalise") |>
  select(identite, usage_normalise, classe_locale,
         cook_n1, cook_n2, cook_n2_libelle) |>
  arrange(identite, usage_normalise)

write_csv(associationUsages,
          file.path(dossierSorties, "association_espece_usage.csv"))

### Messages ###

message("✅ Liste des espèces végétales (§3.1) :")
message("   ", nrow(listeEspecesDefinitive), " identités (espèces) sur ",
        nrow(reconciliation), " noms vernaculaires")
message("   Identifications botaniques : ",
        sum(str_trim(listeEspecesDefinitive$identificationsBotaniques) != ""),
        " / ", nrow(listeEspecesDefinitive))
message("   Export : liste_especes_vegetales_definitive.csv")
message("   Association espece x usage : ", nrow(associationUsages),
        " couples (", n_distinct(associationUsages$usage_normalise),
        " usages distincts, sans 'aucun')")
message("   Export : association_espece_usage.csv")

listeEspecesDefinitive
