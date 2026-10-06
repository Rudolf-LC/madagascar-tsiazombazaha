"Ewen Le Coeur
2026
Objectif : import, renommage et nettoyage des donnees terrain

Utilisation dans un autre script :
  source(\"06_ecologie/analyse/scripts/importDonnees.R\")
  donnees <- importer_donnees()

Le chemin du fichier ODS est resolu automatiquement depuis la racine du projet
(le dossier contenant 06_ecologie/), quel que soit le repertoire de travail.
"

### Modules ###

if (!requireNamespace("readODS", quietly = TRUE)) install.packages("readODS")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")

library(readODS)
library(dplyr)
library(tidyr)
library(stringr)

### Localisation du fichier de donnees ###

trouver_fichier <- function() {
  candidats <- c(
    file.path("06_ecologie", "releves", "saisie_releves_TZBA.ods"),
    file.path("..", "..", "releves", "saisie_releves_TZBA.ods"),
    file.path("..", "releves", "saisie_releves_TZBA.ods")
  )
  for (c in candidats) {
    if (file.exists(c)) return(normalizePath(c))
  }
  stop("Fichier saisie_releves_TZBA.ods introuvable : lancer le script depuis la racine du projet ou depuis 06_ecologie/analyse/scripts/.")
}

### Fonctions utilitaires de nettoyage ###

# Convertit en nombre : \"~ 205\" -> 205, \"?\" -> NA, \"Oui\"/\"Non\" -> NA
en_numerique <- function(x) {
  x |>
    as.character() |>
    str_replace("~", "") |>
    str_trim() |>
    suppressWarnings(as.numeric())
}

en_booleen <- function(x, vrai = "Oui", faux = "Non") {
  x <- str_trim(as.character(x))
  dplyr::if_else(x %in% vrai, TRUE, dplyr::if_else(x %in% faux, FALSE, NA))
}

# Uniformise un nom vernaculaire (espaces multiples, casse)
normaliser_nom <- function(x) {
  x |>
    as.character() |>
    str_squish() |>
    str_to_title()
}

### Import et nettoyage de chaque feuille ###

importer_donnees <- function(fichier = trouver_fichier()) {

  ### transects ###
  transects <- read_ods(fichier, sheet = "transects") |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      date = as.character(`Date`),
      polisnala = `Polisn’ala`,
      objectifs = `Objectifs`,
      longueurGA = en_numerique(`Longueur prospection grands arbres`),
      prospGA = en_booleen(`Longueur prospection grands arbres`),
      prospChablis = en_booleen(`Longueur prospection chablis`)
    )

  ### grands-arbres (transects, DBH > 40 cm) ###
  grandsArbres <- read_ods(fichier, sheet = "grands-arbres") |>
    select(`Code transect`:`Usages`) |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      cdObs = as.character(`Code observation`),
      nomVernaculaire = normaliser_nom(`Nom vernaculaire`),
      circ_cm = en_numerique(`Circonférence`),
      gps = `GPS`,
      remarque = `Remarque`,
      type = `Type`,
      nomSimple = `Nom simple`,
      nbTypes = en_numerique(`Nb types`),
      descriptionTypes = `Description types`,
      usages = `Usages`
    ) |>
    filter(!is.na(cdTransect))

  ### placettes (en-tes sur la deuxieme ligne) ###
  placettes <- read_ods(fichier, sheet = "placettes", skip = 1) |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      cdPlacette = str_trim(`Code placette`),
      situationTopo = `Situation topographique`,
      surfaceHorizontale_m2 = en_numerique(`Surface horizontale`),
      pente_pct = en_numerique(`Pente %`),
      surfaceReelle_m2 = en_numerique(`Surface réelle`),
      canopeeN = `%N`, canopeeS = `%S`, canopeeE = `%E`, canopeeO = `%O`,
      strateHerbacee = `Herbacée`,
      strateSousEtage = `Sous-étage`,
      strateCanopeeInf = `Canopée inf`,
      strateCanopeeSup = `Canopée sup`,
      typeHumus = `Type d’humus`,
      certitudeHumus = `Certitude humus`,
      humiditeSol = `Humidité du sol`,
      epiphytes = `Epiphytes`, mousses = `Mousses`, lichens = `Lichens`,
      lianes = `Lianes`, champignons = `Champignons`,
      regeneration_inf30cm = `<30 cm`,
      regeneration_30_130cm = `30 – 130 cm`,
      remarques = `Remarques`
    )

  ### bois-mort ###
  boisMortBrut <- read_ods(fichier, sheet = "bois-mort")

  # Table de gauche : bois morts (chandelles = sur pied, sol = au sol)
  boisMort <- boisMortBrut |>
    select(Placette, Type, `Circonférence`, `État`) |>
    transmute(
      cdPlacette = str_trim(Placette),
      type = str_trim(Type),
      circ_cm = en_numerique(`Circonférence`),
      etatDecomposition = en_numerique(`État`)
    ) |>
    filter(!is.na(cdPlacette))

  # Table de droite : longueur des pieces de bois mort au sol (methode Van Wagner)
  boisMortLongueurs <- boisMortBrut |>
    select(`Placette.1`, `Longueur`) |>
    transmute(
      cdPlacette = str_trim(`Placette.1`),
      longueur_m = en_numerique(`Longueur`)
    ) |>
    filter(!is.na(longueur_m))

  ### chablis (transects) ###
  chablis <- read_ods(fichier, sheet = "chablis") |>
    transmute(
      cdTransect = str_trim(`Transect`),
      nombre = en_numerique(`Nombre de chablis`),
      categorie = str_extract(`Remarques`, "BM|PB|GB"),
      remarques = `Remarques`
    ) |>
    filter(!is.na(cdTransect), !is.na(nombre))

  ### flore-verifiee (placettes) ###
  floreBrut <- read_ods(fichier, sheet = "flore-verifiee") |>
    transmute(
      cdPlacette = str_trim(`Code placette`),
      cdObs = as.character(`Code observation`),
      nomVernaculaire = normaliser_nom(`Nom vernaculaire`),
      type = `Type`,
      gaulis = en_numerique(`Gaulis`),
      nbTypes = en_numerique(`Nb types`),
      remarquesTypes = `Remarques (types)`,
      remarquesUsages = `Remarques (usages)`,
      remarquesAutres = `Remarques autres`
    )

  # Circonference a hauteur de poitrine : recuperation des colonnes Circ1..Circ10
  circBrut <- read_ods(fichier, sheet = "flore-verifiee")
  colonnesCirc <- grep("^Cir[c]?[0-9]+$", names(circBrut), value = TRUE)

  floreTiges <- circBrut |>
    select(`Code placette`, `Code observation`, all_of(colonnesCirc)) |>
    mutate(
      cdPlacette = str_trim(`Code placette`),
      cdObs = as.character(`Code observation`)
    ) |>
    select(-`Code placette`, -`Code observation`) |>
    pivot_longer(
      cols = all_of(colonnesCirc),
      names_to = "noTige",
      values_to = "circ_cm"
    ) |>
    mutate(noTige = as.integer(str_extract(noTige, "[0-9]+"))) |>
    filter(!is.na(circ_cm)) |>
    left_join(
      floreBrut |> select(cdPlacette, cdObs, nomVernaculaire, type, gaulis, nbTypes,
                          remarquesTypes, remarquesUsages, remarquesAutres),
      by = c("cdPlacette", "cdObs")
    ) |>
    select(cdPlacette, cdObs, nomVernaculaire, noTige, circ_cm,
           type, gaulis, nbTypes, remarquesTypes, remarquesUsages, remarquesAutres) |>
    arrange(cdPlacette, cdObs, noTige)

  flore <- floreBrut |> filter(!is.na(cdPlacette))

  ### feuilles descriptives ###
  activitesHumaines <- read_ods(fichier, sheet = "activites-humaines") |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      type = `Type`,
      codePhoto = `Code photo`,
      remarques = `Remarques`
    ) |>
    filter(!is.na(cdTransect))

  animaux <- read_ods(fichier, sheet = "animaux") |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      nomGasy = `Nom gasy sp`,
      typeObservation = `Type d’observation`,
      photo = `Photo`,
      remarques = `Remarques`
    ) |>
    filter(!is.na(cdTransect))

  phenologie <- read_ods(fichier, sheet = "phenologie") |>
    transmute(
      cdPlacette = str_trim(`Placette`),
      type = `Type`,
      espece = `Espèce`,
      nombre = `Nombre`,
      remarque = `Remarque`
    ) |>
    filter(!is.na(cdPlacette))

  autresEspeces <- read_ods(fichier, sheet = "autres-especes") |>
    transmute(
      cdZone = str_trim(`Code placette ou  transect`),
      nomVernaculaire = normaliser_nom(`Nom vernaculaire`),
      remarques = `Remarques`,
      remarquesLieu = `Remarques lieu d’observation`
    ) |>
    filter(!is.na(cdZone))

  ### Assemblage ###
  list(
    fichier = fichier,
    transects = transects,
    grandsArbres = grandsArbres,
    placettes = placettes,
    boisMort = boisMort,
    boisMortLongueurs = boisMortLongueurs,
    chablis = chablis,
    flore = flore,
    floreTiges = floreTiges,
    activitesHumaines = activitesHumaines,
    animaux = animaux,
    phenologie = phenologie,
    autresEspeces = autresEspeces
  )
}
