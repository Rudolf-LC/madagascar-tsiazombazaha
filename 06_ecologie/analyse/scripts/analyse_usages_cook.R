# analyse_usages_cook.R
# Ewen Le Coeur
# 2026
# Objectif : nombre d'especes par categorie d'usage de premier niveau de la
# classification de Cook (1995), a partir de la liste des especes
# reconciliees et de la correspondance usages normalises -> codes Cook.
#
# Entrees :
#   - donnees/flore.csv et donnees/grands-arbres.csv (colonne « usages »,
#     usages cites par le polisin'ala, saisie brute) ;
#   - referentiels/reconciliation-taxonomique.csv (nom brut -> espece
#     reconciliee) et referentiels/normalisation-usages.csv (usage brut ->
#     usage(s) normalise(s)) ;
#   - referentiels/liste-especes-usages-types.csv (une ligne par espece
#     reconciliee ; usages normalises separes par « | ») : usages d'autres
#     sources, ajoutes a ceux de flore.csv ;
#   - referentiels/correspondance-usages-cook.csv (encodage ISO-8859-1)
#
# Correction du 01/11/2026 : le referentiel des especes (12/10/2026) ne
# reprenait pas les usages saisis ensuite (placettes P21 a P28 notamment) ;
# les usages sont donc tires directement de flore.csv puis reunis avec
# ceux du referentiel. Les usages des grands arbres, d'abord notes en
# remarque libre, ont ete reportes dans une colonne « usages » de
# grands-arbres.csv (01/11/2026) et sont lus de la meme facon.
#
# Sorties :
#   - sorties/usages_cook_categories.csv : par categorie de premier niveau,
#     nombre d'especes et usages normalises cites ;
#   - sorties/usages_cook_resume.csv : nombre d'especes avec au moins un
#     usage classe, avec la seule mention « aucun », sans mention (NA).
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/analyse_usages_cook.R")

### Modules ###

library(dplyr)
library(tidyr)
library(stringr)
library(readr)

### Import des donnees ###

dossierReferentiels <- "06_ecologie/analyse/referentiels"
dossierSorties <- "06_ecologie/analyse/sorties"

especes <- read_csv(
  file.path(dossierReferentiels, "liste-especes-usages-types.csv"),
  show_col_types = FALSE
) |>
  rename(espece = `nom-vernaculaire-reconcilie`)

reconciliation <- read_csv(
  file.path(dossierReferentiels, "reconciliation-taxonomique.csv"),
  show_col_types = FALSE
) |>
  transmute(nomBrut = str_trim(`nom-vernaculaire-brut`),
            espece = str_trim(`nom-vernaculaire-reconcilie`)) |>
  distinct(nomBrut, .keep_all = TRUE)

normalisation <- read_csv(
  file.path(dossierReferentiels, "normalisation-usages.csv"),
  show_col_types = FALSE
) |>
  transmute(usageBrut = str_trim(`usage-brut`),
            usage = str_trim(`usage-normalise`))

flore <- read_csv(
  file.path("06_ecologie/analyse/donnees", "flore.csv"),
  col_types = cols(.default = col_character())
) |>
  transmute(nomBrut = str_trim(`nom-vernaculaire-brut`),
            usageBrut = str_trim(usages)) |>
  filter(!is.na(usageBrut), usageBrut != "", usageBrut != "NA")

grandsArbres <- read_csv(
  file.path("06_ecologie/analyse/donnees", "grands-arbres.csv"),
  col_types = cols(.default = col_character())
) |>
  transmute(nomBrut = str_trim(`nom-vernaculaire-brut`),
            usageBrut = str_trim(usages)) |>
  filter(!is.na(usageBrut), usageBrut != "", usageBrut != "NA")

# Usages saisis sur le terrain : placettes et grands arbres
flore <- bind_rows(flore, grandsArbres)

correspondance <- read_csv(
  file.path(dossierReferentiels, "correspondance-usages-cook.csv"),
  locale = locale(encoding = "ISO-8859-1"),
  show_col_types = FALSE
) |>
  rename(usage = `usage-normalise`, cookN1 = `cook-n1`,
         cookN1Libelle = `cook-n1-libelle`)

### Usages par espece ###

# Usages de flore.csv : nom brut -> espece reconciliee, usage brut ->
# usage(s) normalise(s)
nomsNonReconcilies <- flore |>
  anti_join(reconciliation, by = "nomBrut") |>
  distinct(nomBrut)
if (nrow(nomsNonReconcilies) > 0) {
  message("⚠️ Noms bruts absents de la reconciliation (ignores) : ",
          paste(nomsNonReconcilies$nomBrut, collapse = ", "))
}
usagesNonNormalises <- flore |>
  anti_join(normalisation, by = "usageBrut") |>
  distinct(usageBrut)
if (nrow(usagesNonNormalises) > 0) {
  message("⚠️ Usages bruts absents de la normalisation (ignores) : ",
          paste(usagesNonNormalises$usageBrut, collapse = ", "))
}
usagesFlore <- flore |>
  inner_join(reconciliation, by = "nomBrut") |>
  inner_join(normalisation, by = "usageBrut",
             relationship = "many-to-many") |>
  select(espece, usage)

# Usages du referentiel des especes
usagesReferentiel <- especes |>
  select(espece, usages) |>
  separate_rows(usages, sep = "\\|") |>
  mutate(usage = str_trim(usages)) |>
  select(-usages)

# Une ligne par espece x usage normalise (toutes sources)
# (especes indeterminees exclues, comme dans les autres analyses)
usagesEspeces <- bind_rows(usagesReferentiel, usagesFlore) |>
  mutate(usage = na_if(usage, "NA")) |>
  filter(str_to_lower(str_trim(espece)) != "espèce indéterminée") |>
  distinct()

usagesClasses <- usagesEspeces |>
  inner_join(correspondance |> filter(!is.na(cookN1)), by = "usage")

# Usages normalises absents de la correspondance (controle)
nonClasses <- usagesEspeces |>
  filter(!is.na(usage), usage != "aucun", usage != "NA") |>
  anti_join(correspondance, by = "usage") |>
  distinct(usage)
if (nrow(nonClasses) > 0) {
  message("⚠️ Usages sans correspondance Cook : ",
          paste(nonClasses$usage, collapse = ", "))
}

### Comptages ###

categories <- usagesClasses |>
  group_by(cookN1, cookN1Libelle) |>
  summarise(
    nbEspeces = n_distinct(espece),
    usagesCites = paste(sort(unique(usage)), collapse = " | "),
    .groups = "drop"
  ) |>
  arrange(desc(nbEspeces), cookN1)

especesAvecUsage <- n_distinct(usagesClasses$espece)
especesAucun <- usagesEspeces |>
  group_by(espece) |>
  summarise(
    aucun = any(usage %in% "aucun"),
    classe = any(usage %in% correspondance$usage[!is.na(correspondance$cookN1)]),
    .groups = "drop"
  ) |>
  filter(aucun, !classe) |>
  nrow()
especesNA <- usagesEspeces |>
  group_by(espece) |>
  summarise(sansMention = all(is.na(usage)), .groups = "drop") |>
  filter(sansMention) |>
  nrow()

resume <- tibble(
  nbEspecesListe = n_distinct(usagesEspeces$espece),
  nbEspecesUsageClasse = especesAvecUsage,
  nbEspecesSeulementAucun = especesAucun,
  nbEspecesSansMention = especesNA
)

### Exports ###

write_csv(categories, file.path(dossierSorties, "usages_cook_categories.csv"))
write_csv(resume, file.path(dossierSorties, "usages_cook_resume.csv"))

message("✅ Usages (Cook, 1995) : ", especesAvecUsage,
        " especes avec au moins un usage classe sur ",
        resume$nbEspecesListe, " especes")
