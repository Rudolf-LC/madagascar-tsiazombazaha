"Ewen Le Coeur
2026
Objectif : import, renommage et nettoyage des donnees terrain

Utilisation dans un autre script :
  source(\"06_ecologie/analyse/scripts/importDonnees.R\")
  donnees <- importer_donnees()

Le chemin du fichier ODS est resolu automatiquement depuis la racine du projet
(le dossier contenant 06_ecologie/), quel que soit le repertoire de travail.

Avertissements : les lignes ecartees par le nettoyage (valeurs non numeriques
notamment) sont signalees a l'ecran (source, nombre, raison, numeros de ligne
du fichier ODS) et conservees dans l'attribut \"avertissements\" du resultat :
  attr(donnees, \"avertissements\")
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
  x <- str_trim(str_replace(as.character(x), "~", ""))
  suppressWarnings(as.numeric(x))
}

# Cellules remplies mais non convertibles en nombre (ex. \"?\", \"beaucoup\").
# Les cellules vides ne sont pas des anomalies.
non_numerique <- function(x) {
  x <- as.character(x)
  !is.na(x) & str_trim(x) != "" & is.na(en_numerique(x))
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

# Normalise les noms de colonnes d'une feuille : espaces inseables,
# espaces en debut/fin. Rend l'acces par backticks robuste aux
# variations invisibles du fichier ODS.
normaliser_colonnes <- function(df) {
  noms <- names(df)
  noms <- stringr::str_replace_all(noms, "[   ]", " ")
  noms <- stringr::str_squish(noms)
  names(df) <- noms
  df
}

### Import et nettoyage de chaque feuille ###

importer_donnees <- function(fichier = trouver_fichier()) {

  avertissements <- character(0)

  # Signale les lignes ecartees : source (feuille), colonne, raison,
  # numeros de ligne du fichier ODS.
  avertir <- function(feuille, colonne, raison, lignes) {
    if (length(lignes) == 0) return(invisible(NULL))
    msg <- sprintf(
      "[%s / %s] %d ligne(s) ignoree(s) — %s — ligne(s) %s du fichier ODS",
      feuille, colonne, length(lignes), raison,
      paste(lignes, collapse = ", ")
    )
    avertissements <<- c(avertissements, msg)
    message("⚠️  ", msg)
  }

  ### transects ###
  transectsBrut <- normaliser_colonnes(read_ods(fichier, sheet = "transects")) |>
    mutate(.ligne = row_number() + 1)   # ligne 1 = en-tete du fichier ODS

  transectsTmp <- transectsBrut |>
    transmute(
      .ligne,
      cdTransect = str_trim(`Code transect`),
      date = as.character(`Date`),
      polisnala = `Polisn’ala`,
      objectifs = `Objectifs`,
      longueurGABrute = as.character(`Longueur prospection grands arbres`),
      longueurGA = en_numerique(`Longueur prospection grands arbres`),
      prospGA = en_booleen(`Longueur prospection grands arbres`),
      prospChablis = en_booleen(`Longueur prospection chablis`)
    )

  avertir("transects", "Longueur prospection grands arbres",
          "valeur remplie mais non numerique",
          transectsTmp$.ligne[non_numerique(transectsTmp$longueurGABrute)])

  transects <- transectsTmp |>
    select(-.ligne, -longueurGABrute)

  ### grands-arbres (transects, DBH > 40 cm) ###
  # N.B. : la ligne d'en-tete contient deux colonnes \"Remarque\" (bloc gauche
  # et bloc droit du tableau ODS) ; on reference donc les colonnes par position.
  # On lit sans en-tete (col_names = FALSE) et on nomme explicitement les 11
  # premieres colonnes du bloc gauche. Avec col_names = FALSE, la ligne 1 lue
  # est la ligne 1 du fichier ODS : .ligne = row_number() avant slice(-1).
  grandsArbresBrut <- read_ods(fichier, sheet = "grands-arbres", col_names = FALSE) |>
    mutate(.ligne = row_number()) |>
    slice(-1) |>
    select(.ligne, 1:11) |>
    setNames(c(".ligne", "cdTransectBrut", "cdObs", "nomVernaculaireBrut", "circBrute",
               "gps", "remarque", "type", "nomSimple", "nbTypesBrut",
               "descriptionTypes", "usages"))

  grandsArbresTmp <- grandsArbresBrut |>
    transmute(
      .ligne,
      cdTransect = str_trim(cdTransectBrut),
      cdObs = as.character(cdObs),
      nomVernaculaire = normaliser_nom(nomVernaculaireBrut),
      circ_cm = en_numerique(circBrute),
      gps = gps,
      remarque = remarque,
      type = type,
      nomSimple = nomSimple,
      nbTypes = en_numerique(nbTypesBrut),
      descriptionTypes = descriptionTypes,
      usages = usages
    )

  lignesGA <- grandsArbresBrut$.ligne[!is.na(grandsArbresBrut$cdTransectBrut) &
                                        non_numerique(grandsArbresBrut$circBrute)]
  avertir("grands-arbres", "Circonférence",
          "valeur remplie mais non numerique", lignesGA)

  grandsArbres <- grandsArbresTmp |>
    filter(!is.na(cdTransect)) |>
    select(-.ligne)

  ### placettes (en-tes sur la deuxieme ligne) ###
  placettesBrut <- normaliser_colonnes(read_ods(fichier, sheet = "placettes", skip = 1)) |>
    mutate(.ligne = row_number() + 2)   # lignes 1-2 = en-tetes du fichier ODS

  placettesTmp <- placettesBrut |>
    transmute(
      .ligne,
      cdTransect = str_trim(`Code transect`),
      cdPlacette = str_trim(`Code placette`),
      situationTopo = `Situation topographique`,
      surfaceHorizontaleBrute = as.character(`Surface horizontale`),
      surfaceHorizontale_m2 = en_numerique(`Surface horizontale`),
      penteBrute = as.character(`Pente %`),
      pente_pct = en_numerique(`Pente %`),
      surfaceReelleBrute = as.character(`Surface réelle`),
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

  avertir("placettes", "Surface horizontale",
          "valeur remplie mais non numerique",
          placettesTmp$.ligne[non_numerique(placettesTmp$surfaceHorizontaleBrute)])
  avertir("placettes", "Pente %",
          "valeur remplie mais non numerique",
          placettesTmp$.ligne[non_numerique(placettesTmp$penteBrute)])
  avertir("placettes", "Surface réelle",
          "valeur remplie mais non numerique",
          placettesTmp$.ligne[non_numerique(placettesTmp$surfaceReelleBrute)])

  placettes <- placettesTmp |>
    select(-.ligne, -surfaceHorizontaleBrute, -penteBrute, -surfaceReelleBrute)

  ### bois-mort ###
  # N.B. : deux colonnes \"Placette\" (bloc gauche et bloc droit) ; on lit sans
  # en-tete (col_names = FALSE) et on nomme explicitement. Colonnes 1-4 :
  # mesures des bois morts (chandelle = sur pied, sol = au sol) ; colonnes 7-8 :
  # longueurs des pieces au sol (methode Van Wagner).
  boisMortBrut <- read_ods(fichier, sheet = "bois-mort", col_names = FALSE) |>
    mutate(.ligne = row_number()) |>
    slice(-1)

  boisMortTmp <- boisMortBrut |>
    select(.ligne, 1:4) |>
    setNames(c(".ligne", "cdPlacetteBrut", "typeBrut", "circBrute", "etatBrut")) |>
    transmute(
      .ligne,
      cdPlacette = str_trim(cdPlacetteBrut),
      type = str_trim(typeBrut),
      circBrute = as.character(circBrute),
      circ_cm = en_numerique(circBrute),
      etatBrut = as.character(etatBrut),
      etatDecomposition = en_numerique(etatBrut)
    )

  avertir("bois-mort", "Circonférence",
          "valeur remplie mais non numerique",
          boisMortTmp$.ligne[!is.na(boisMortTmp$cdPlacette) &
                              non_numerique(boisMortTmp$circBrute)])
  avertir("bois-mort", "État",
          "valeur remplie mais non numerique",
          boisMortTmp$.ligne[!is.na(boisMortTmp$cdPlacette) &
                              non_numerique(boisMortTmp$etatBrut)])

  boisMort <- boisMortTmp |>
    filter(!is.na(cdPlacette)) |>
    select(-.ligne, -circBrute, -etatBrut)

  boisMortLongueursTmp <- boisMortBrut |>
    select(.ligne, 7:8) |>
    setNames(c(".ligne", "cdPlacetteBrut", "longueurBrute")) |>
    transmute(
      .ligne,
      cdPlacette = str_trim(cdPlacetteBrut),
      longueurBrute = as.character(longueurBrute),
      longueur_m = en_numerique(longueurBrute)
    )

  avertir("bois-mort", "Longueur",
          "valeur remplie mais non numerique",
          boisMortLongueursTmp$.ligne[non_numerique(boisMortLongueursTmp$longueurBrute)])

  boisMortLongueurs <- boisMortLongueursTmp |>
    filter(!is.na(longueur_m)) |>
    select(-.ligne, -longueurBrute)

  ### chablis (transects) ###
  chablisBrut <- normaliser_colonnes(read_ods(fichier, sheet = "chablis")) |>
    mutate(.ligne = row_number() + 1)

  chablisTmp <- chablisBrut |>
    transmute(
      .ligne,
      cdTransect = str_trim(`Transect`),
      nombreBrut = as.character(`Nombre de chablis`),
      nombre = en_numerique(`Nombre de chablis`),
      categorie = str_extract(`Remarques`, "BM|PB|GB"),
      remarques = `Remarques`
    )

  avertir("chablis", "Nombre de chablis",
          "valeur remplie mais non numerique (ligne ecartee)",
          chablisTmp$.ligne[!is.na(chablisTmp$cdTransect) &
                            non_numerique(chablisTmp$nombreBrut)])

  chablis <- chablisTmp |>
    filter(!is.na(cdTransect), !is.na(nombre)) |>
    select(-.ligne, -nombreBrut)

  ### flore-verifiee (placettes) ###
  floreBrut <- normaliser_colonnes(read_ods(fichier, sheet = "flore-verifiee")) |>
    mutate(.ligne = row_number() + 1)

  floreTmp <- floreBrut |>
    transmute(
      .ligne,
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

  flore <- floreTmp |> filter(!is.na(cdPlacette))

  # Circonference a hauteur de poitrine : recuperation des colonnes Circ1..Circ10
  colonnesCirc <- grep("^Cir[c]?[0-9]+$", names(floreBrut), value = TRUE)

  floreTigesBrut <- floreBrut |>
    select(.ligne, `Code placette`, `Code observation`, all_of(colonnesCirc)) |>
    mutate(
      cdPlacette = str_trim(`Code placette`),
      cdObs = as.character(`Code observation`)
    ) |>
    select(-`Code placette`, -`Code observation`) |>
    pivot_longer(
      cols = all_of(colonnesCirc),
      names_to = "noTige",
      values_to = "circBrute"
    ) |>
    mutate(noTige = as.integer(str_extract(noTige, "[0-9]+")))

  avertir("flore-verifiee", "Circonférences des tiges (Circ1..Circ10)",
          "valeur remplie mais non numerique",
          floreTigesBrut$.ligne[non_numerique(floreTigesBrut$circBrute)])

  floreTiges <- floreTigesBrut |>
    transmute(
      .ligne,
      cdPlacette, cdObs, noTige,
      circBrute = as.character(circBrute),
      circ_cm = en_numerique(circBrute)
    ) |>
    filter(!is.na(circ_cm)) |>
    left_join(
      floreTmp |> select(cdPlacette, cdObs, nomVernaculaire, type, gaulis, nbTypes,
                         remarquesTypes, remarquesUsages, remarquesAutres),
      by = c("cdPlacette", "cdObs")
    ) |>
    select(cdPlacette, cdObs, nomVernaculaire, noTige, circ_cm,
           type, gaulis, nbTypes, remarquesTypes, remarquesUsages, remarquesAutres) |>
    arrange(cdPlacette, cdObs, noTige)

  ### feuilles descriptives ###
  activitesHumaines <- normaliser_colonnes(read_ods(fichier, sheet = "activites-humaines")) |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      type = `Type`,
      codePhoto = `Code photo`,
      remarques = `Remarques`
    ) |>
    filter(!is.na(cdTransect))

  animaux <- normaliser_colonnes(read_ods(fichier, sheet = "animaux")) |>
    transmute(
      cdTransect = str_trim(`Code transect`),
      nomGasy = `Nom gasy sp`,
      typeObservation = `Type d’observation`,
      photo = `Photo`,
      remarques = `Remarques`
    ) |>
    filter(!is.na(cdTransect))

  phenologie <- normaliser_colonnes(read_ods(fichier, sheet = "phenologie")) |>
    transmute(
      cdPlacette = str_trim(`Placette`),
      type = `Type`,
      espece = `Espèce`,
      nombre = `Nombre`,
      remarque = `Remarque`
    ) |>
    filter(!is.na(cdPlacette))

  autresEspeces <- normaliser_colonnes(read_ods(fichier, sheet = "autres-especes")) |>
    transmute(
      cdZone = str_trim(`Code placette ou transect`),
      nomVernaculaire = normaliser_nom(`Nom vernaculaire`),
      remarques = `Remarques`,
      remarquesLieu = `Remarques lieu d’observation`
    ) |>
    filter(!is.na(cdZone))

  ### Assemblage ###
  if (length(avertissements) > 0) {
    message("ℹ️  Récapitulatif : ", length(avertissements),
            " avertissement(s) de nettoyage. Détail : attr(donnees, \"avertissements\")")
  }

  resultat <- list(
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
  attr(resultat, "avertissements") <- avertissements
  resultat
}
