"
Ewen Le Coeur
2026
Objectif : calculs des indices écologiques

Ce script traite la STRUCTURE FORESTIÈRE (document d'étape §3.2,
Mémento du forestier tropical, Mille & Louppe 2015) :
  - Densité N (tiges/ha), gaulis inclus
  - Distribution des effectifs par classe de diamètre (largeur 2,5 cm)
  - Surface terrière G (m²/ha)
à l'échelle du dispositif ET par placette (moyenne ± écart-type).

Reste à traiter dans ce script (sections du document d'étape) :
  - chablis/ha et arbres DBH>40 /ha (transects, §3.2)
  - stock de carbone AGB/BGB Chave (§3.3)
  - volume de bois mort (Van Wagner) (§3.3)
  - diversité alpha (Shannon, Simpson, Fisher) (§3.4)
  - IVI (§3.6)

Utilisation :
  source(\"06_ecologie/analyse/scripts/calcIndices.R\")
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

### Préparation des tiges ###

# Tiges mesurées (CBH > 8 cm) : floreTiges.
# Gaulis (tiges < 1,30 m) : non mesurés — comptés dans la densité,
# exclus de la surface terrière (pas de CBH).
# La surface terrière se rapporte à la surface horizontale.
tiges <- d$floreTiges |>
  mutate(
    dbh_cm = circ_cm / pi,
    classeDiam = floor(dbh_cm / 2.5) * 2.5
  )

gaulis <- d$flore |>
  filter(!is.na(gaulis)) |>
  group_by(cdPlacette) |>
  summarise(nbGaulis = sum(gaulis), .groups = "drop")

### Surfaces ###

surfaceTotale <- sum(d$placettes$surfaceHorizontale_m2, na.rm = TRUE)
message("Surface inventoriée (horizontale) : ", round(surfaceTotale, 1),
        " m² sur ", nrow(d$placettes), " placettes")

### Densité N ###

nbTigesMesurees <- nrow(tiges)
nbGaulis <- sum(gaulis$nbGaulis)
densite <- (nbTigesMesurees + nbGaulis) / surfaceTotale * 10000

densite_dispositif <- tibble(
  indicateur = "Densité N (tiges/ha)",
  tigesMesurees = nbTigesMesurees,
  gaulis = nbGaulis,
  valeur = densite
)

### Surface terrière G ###

# G = somme des sections à hauteur de poitrine = pi/4 * DHP²
g_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(G_m2 = sum(pi / 4 * (dbh_cm / 100)^2), nbTiges = n(), .groups = "drop")

surfaceTerriere <- sum(g_par_placette$G_m2)
G_ha <- surfaceTerriere / surfaceTotale * 10000

surfaceTerriere_dispositif <- tibble(
  indicateur = "Surface terrière G (m²/ha)",
  valeur = G_ha
)

### Indices par placette : moyenne et écart-type ###

placettesIndices <- d$placettes |>
  select(cdPlacette, surfaceHorizontale_m2) |>
  left_join(g_par_placette, by = "cdPlacette") |>
  left_join(gaulis, by = "cdPlacette") |>
  mutate(
    nbGaulis = replace_na(nbGaulis, 0),
    nbTiges = replace_na(nbTiges, 0),
    densitePlacette = (nbTiges + nbGaulis) / surfaceHorizontale_m2 * 10000,
    GhaPlacette = replace_na(G_m2, 0) / surfaceHorizontale_m2 * 10000
  )

resume_placettes <- placettesIndices |>
  summarise(
    nbPlacettes = n(),
    densite_moyenne = mean(densitePlacette),
    densite_ecartType = sd(densitePlacette),
    densite_IC95_bas = qt(0.975, nbPlacettes - 1) * sd(densitePlacette) /
      sqrt(nbPlacettes),
    Gha_moyenne = mean(GhaPlacette),
    Gha_ecartType = sd(GhaPlacette),
    Gha_IC95_bas = qt(0.975, nbPlacettes - 1) * sd(GhaPlacette) /
      sqrt(nbPlacettes),
    .groups = "drop"
  ) |>
  mutate(
    densite_IC95_haut = densite_moyenne + densite_IC95_bas,
    densite_IC95_bas = densite_moyenne - densite_IC95_bas,
    Gha_IC95_haut = Gha_moyenne + Gha_IC95_bas,
    Gha_IC95_bas = Gha_moyenne - Gha_IC95_bas
  )

### Courbe N par classe de diamètre ###

# Distribution des tiges mesurées par classe de diamètre (largeur 2,5 cm),
# en effectif total du dispositif et en densité à l'hectare (placettes).
# Les classes vides sont incluses pour une courbe régulière.
# N.B. : les gaulis (non mesurés) n'entrent pas dans cette distribution ;
# les grands arbres des transects (DBH > 40 cm) pourront être ajoutés
# dans une seconde courbe une fois les longueurs de prospection saisies.

nbTigesMesurees <- nrow(tiges)

courbeClasses <- tiges |>
  count(classeDiam, name = "effectifTotal") |>
  right_join(
    tibble(classeDiam = seq(0, max(tiges$classeDiam, na.rm = TRUE), by = 2.5)),
    by = "classeDiam"
  ) |>
  mutate(effectifTotal = replace_na(effectifTotal, 0)) |>
  arrange(classeDiam) |>
  mutate(
    densite_ha = effectifTotal / surfaceTotale * 10000,
    borneInf = classeDiam,
    borneSup = classeDiam + 2.5,
    frequence = effectifTotal / nbTigesMesurees
  )

### Indicateurs des transects : grands arbres DBH > 40 et chablis ###

# N.B. conventions (document d'étape §3.2) :
#  - largeur de prospection : 10 m -> surface = longueur x 10
#  - la feuille "transects" mélange longueurs (m) et réponses Oui/Non
#    selon que la prospection a eu lieu ; seules les valeurs numériques
#    sont des longueurs exploitables. Les transects sans longueur
#    renseignée sont exclus et signalés.

surfaceTransects_m2 <- longueurTotaleTransects * 10

transectsSansLongueur <- d$transects |>
  filter(is.na(longueurGA)) |>
  pull(cdTransect)
if (length(transectsSansLongueur) > 0) {
  message("⚠️  Transects sans longueur de prospection exploitables : ",
          paste(transectsSansLongueur, collapse = ", "),
          " — exclus des calculs à l'hectare.")
}

# Nombre de grands arbres (DBH > 40 cm) a l'hectare
grandsArbresValides <- d$grandsArbres |>
  filter(cdTransect %in% d$transects$cdTransect[!is.na(d$transects$longueurGA)])

nbGrandsArbres <- nrow(grandsArbresValides)
densiteGrandsArbres <- nbGrandsArbres / surfaceTransects_m2 * 10000

grandsArbresDispositif <- tibble(
  indicateur = "Grands arbres DBH>40 (arbres/ha)",
  valeur = densiteGrandsArbres
)

# Surface terriere des grands arbres a l'hectare
GgrandsArbres <- grandsArbresValides |>
  summarise(G_m2 = sum(pi / 4 * (circ_cm / pi / 100)^2, na.rm = TRUE)) |>
  pull(G_m2)
GgrandsArbres_ha <- GgrandsArbres / surfaceTransects_m2 * 10000

# Chablis a l'hectare
# Convention : seuls les transects avec prospection chablis attestée
# (prospChablis == TRUE) sont comptés ; les longueurs correspondantes
# ne sont pas renseignées dans le fichier -> a completer.
chablisValides <- d$chablis
nbChablis <- sum(chablisValides$nombre, na.rm = TRUE)
transectsChablis <- d$transects |>
  filter(prospChablis == TRUE) |>
  pull(cdTransect)
longueurChablisConnue <- sum(d$transects$longueurGA[d$transects$cdTransect %in% transectsChablis], na.rm = TRUE)

chablisDispositif <- tibble(
  indicateur = "Chablis (/ha)",
  nbChablis = nbChablis,
  transectsProspectes = paste(transectsChablis, collapse = ", "),
  longueurConnue_m = longueurChablisConnue,
  valeur = NA_real_
)
if (longueurChablisConnue > 0) {
  chablisDispositif$valeur <- nbChablis / (longueurChablisConnue * 10) * 10000
}

### Stock de carbone (document d'etape §3.3) ###

# Parametres du site — PROVISOIRES, a confirmer :
#  E : indice bioclimatique de Chave et al. 2014 (foret tropicale humide,
#      facade Est Madagascar ; valeur par defaut -0,080)
#  rho : densite du bois (t/m3) ; moyenne bois tropical humide 0,60
# Constantes du document d'etape :
#  R (BGB/AGB) = 0,20 ; CF = 0,47 ; CO2/MS = 3,67
#     -> StockCO2 vivant = (AGB + 0,20 AGB) x 0,47 x 3,67 = 2,06988 AGB
#  bois mort sur pied : meme allometrie, facteur de decomposition
#     par etat (1 : 0,9 ; 2 : 0,6 ; 3 : 0,4 ; NA : 1,0)
#  bois mort au sol : Van Wagner (1968), L_bm = 290 m
#     V = pi2/8L x somme(d2) x 10000 (m3/ha), CO2 = V x rho x CF x 3,67

E_bioclimatique <- -0.080   # PROVISOIRE
rho_bois <- 0.60            # PROVISOIRE
facteurs_decomposition <- c("1" = 0.9, "2" = 0.6, "3" = 0.4)

agb_chave <- function(dhp_cm, rho = rho_bois, E = E_bioclimatique) {
  lnD <- log(dhp_cm)
  exp(-1.803 - 0.976 * E + 0.976 * log(rho) + 2.673 * lnD - 0.0299 * lnD^2)
}

# N.B. domaine de validite de Chave 2014 : DHP >= 5 cm. Les tiges plus
# petites (2,2 a 5 cm) sont incluses mais contribuent marginalement
# (< 8 % de l'AGB total) ; recalcul sans elles possible via floreTiges.

tiges <- tiges |>
  mutate(agb_kg = agb_chave(dbh_cm))

agb_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(AGB_kg = sum(agb_kg, na.rm = TRUE), .groups = "drop")

AGB_ha <- sum(agb_par_placette$AGB_kg) / surfaceTotale / 1000 * 10000
stockCO2_vivant <- 2.06988 * AGB_ha

# Bois mort sur pied (chandelles)
facteur_decomposition <- function(etat) {
  dplyr::coalesce(unname(facteurs_decomposition[as.character(etat)]), 1)
}

chandelles <- d$boisMort |>
  filter(type == "Chandelle") |>
  mutate(
    dbh_cm = circ_cm / pi,
    facteur = facteur_decomposition(etatDecomposition),
    agb_kg = agb_chave(dbh_cm)
  )

CO2_pied_ha <- sum(chandelles$agb_kg * chandelles$facteur, na.rm = TRUE) *
  0.47 * 3.67 / surfaceTotale / 1000 * 10000

# Bois mort au sol (Van Wagner)
longueur_transect_bm <- 290   # L_bm (m)

boisSol <- d$boisMort |>
  filter(type == "Sol") |>
  mutate(
    diametre_m = circ_cm / pi / 100,
    facteur = facteur_decomposition(etatDecomposition)
  )

V_sol_ha <- pi^2 / (8 * longueur_transect_bm) *
  sum(boisSol$diametre_m^2 * boisSol$facteur, na.rm = TRUE) * 10000
CO2_sol_ha <- V_sol_ha * rho_bois * 0.47 * 3.67

stockCO2_boisMort <- CO2_pied_ha + CO2_sol_ha

stockCarbone_dispositif <- tibble(
  indicateur = c(
    "AGB vivant (tMS/ha)",
    "Stock CO2 vivant (tCO2/ha)",
    "CO2 bois mort sur pied (tCO2/ha)",
    "CO2 bois mort au sol (tCO2/ha)",
    "CO2 bois mort total (tCO2/ha)"
  ),
  valeur = c(AGB_ha, stockCO2_vivant, CO2_pied_ha, CO2_sol_ha, stockCO2_boisMort)
)

### Sorties ###


resultat <- list(
  surface_m2 = surfaceTotale,
  densite_dispositif = densite_dispositif,
  classesDiametre = courbeClasses,
  surfaceTerriere_m2 = surfaceTerriere,
  surfaceTerriere_ha = surfaceTerriere_dispositif,
  placettesIndices = placettesIndices,
  resume_placettes = resume_placettes,
  surfaceTransects_m2 = surfaceTransects_m2,
  grandsArbresDispositif = grandsArbresDispositif,
  GgrandsArbres_ha = GgrandsArbres_ha,
  chablisDispositif = chablisDispositif,
  stockCarbone = stockCarbone_dispositif
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)
write_csv(courbeClasses, file.path(dossierSorties, "structure_classes_diametre.csv"))
write_csv(placettesIndices, file.path(dossierSorties, "structure_indices_placettes.csv"))

message("✅ Structure forestière :")
message("   Densité par placette : ", round(resume_placettes$densite_moyenne),
        " ± ", round(resume_placettes$densite_ecartType),
        " tiges/ha (IC 95 % : ", round(resume_placettes$densite_IC95_bas), "–",
        round(resume_placettes$densite_IC95_haut), ")")
message("   Densité N = ", round(densite), " tiges/ha (",
        nbTigesMesurees, " tiges mesurées + ", nbGaulis, " gaulis, ",
        round(surfaceTotale, 1), " m²)")
message("   Surface terrière G = ", round(G_ha, 2), " m²/ha")
resultat
