# 08_analyse_carbone.R
# Ewen Le Coeur
# 2026
# Objectif : stocks de carbone (§3.3 du rapport d'étape) par compartiment —
# grands arbres (transects 10 m), tiges de placettes (flore), bois mort au
# sol (line intersect, Van Wagner 1968) et bois mort sur pied (chandelles).
# Pour chaque compartiment : volume (m³/ha), biomasse (tMS/ha), carbone
# (tC/ha) et CO2 (tCO2/ha), avec IC95 bootstrap et extrapolation sur la
# forêt totale de Tsiazombazaha.
#
# Methodologie (rapport d'étape §3.3) :
#   AGB      = Chave et al. 2014 (allometrie sans hauteur)
#   BGB      = 0,20 × AGB  (ratio root:shoot, Mokany et al. 2006)
#   CF       = 0,47        (fraction de carbone, Eggleston et al. 2006)
#   CO2/C    = 3,67
#   Vivant   : StockCO2 = (AGB + BGB) × CF × 3,67 = 2,06988 × AGB
#   Bois mort: StockCO2 = V × ρ × CF × 3,67 × f  (f = facteur décomposition)
#
# Sorties :
# - CSV : carbone_stocks.csv — volume, biomasse, C, CO2 par compartiment
#         (ha + total forêt) avec IC95.
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/08_analyse_carbone.R")

# Surface totale de la forêt (ha) pour l'extrapolation des stocks.
# VALEUR PROVISOIRE : 500 ha (ordre de grandeur de la Problématique), en
# attendant le calcul de la surface réelle sous QGIS par l'auteur.
# Modifier cette seule ligne puis relancer le script.
SURFACE_TSIAZOMBAZAHA <- 500

### Modules ###

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")

library(dplyr)
library(tidyr)
library(readr)
library(tibble)

### Import des donnees CSV ###

dossierDonnees <- "06_ecologie/analyse/donnees"
dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

# Flore : tiges mesurees (circonferences)
flore_brut <- read_csv(
  file.path(dossierDonnees, "flore.csv"),
  show_col_types = FALSE
)

cols_circ <- c("Circ1", "Circ2", "Circ3", "Circ4", "Circ5", "Circ6",
               "Cir7", "Circ8", "Circ9", "Cir10")
cols_circ_present <- intersect(cols_circ, names(flore_brut))

d_floreTiges <- flore_brut |>
  select(placette, all_of(cols_circ_present)) |>
  pivot_longer(
    cols = all_of(cols_circ_present),
    names_to = "numTige",
    values_to = "circ_cm"
  ) |>
  filter(!is.na(circ_cm)) |>
  mutate(circ_cm = suppressWarnings(as.numeric(circ_cm))) |>
  filter(!is.na(circ_cm)) |>
  rename(cdPlacette = placette) |>
  select(cdPlacette, circ_cm, numTige)

# Placettes
d_placettes <- read_csv(
  file.path(dossierDonnees, "placettes.csv"),
  show_col_types = FALSE,
  col_types = cols(
    `surface-horizontale` = col_character(),
    `surface-corrigee` = col_character()
  )
) |>
  rename(
    cdPlacette = placette,
    cdTransect = transect,
    surfaceHorizontale_m2 = `surface-horizontale`,
    longueurBM = `longueur-transect-bois-mort`
  ) |>
  mutate(
    surfaceHorizontale_m2 = as.numeric(gsub(",", ".", surfaceHorizontale_m2)),
    longueurBM = suppressWarnings(as.numeric(longueurBM))
  )

# Transects
d_transects <- read_csv(
  file.path(dossierDonnees, "transects.csv"),
  show_col_types = FALSE
) |>
  rename(
    cdTransect = transect,
    longueurGA = `longueur-prospection-grands-arbres`
  ) |>
  mutate(longueurGA = suppressWarnings(as.numeric(longueurGA)))

# Grands arbres
d_grandsArbres <- read_csv(
  file.path(dossierDonnees, "grands-arbres.csv"),
  show_col_types = FALSE
) |>
  rename(cdTransect = transect, circ_cm = circonference) |>
  mutate(circ_cm = suppressWarnings(as.numeric(circ_cm))) |>
  filter(!is.na(circ_cm), !is.na(cdTransect)) |>
  # Seuil des grands arbres : CBH >= 126 cm (DBH ~ 40 cm) ; les arbres plus
  # petits saisis sont des reliquats d'un seuil anterieur
  filter(circ_cm >= 126)

# Bois mort
d_boisMort <- read_csv(
  file.path(dossierDonnees, "bois-mort.csv"),
  show_col_types = FALSE
) |>
  rename(
    cdPlacette = placette,
    circ_cm = circonference,
    etatDecomposition = `niveau-degradation`
  ) |>
  mutate(circ_cm = suppressWarnings(as.numeric(circ_cm))) |>
  filter(!is.na(circ_cm))

### Constantes du rapport d'etape §3.3 ###

# Graine du generateur aleatoire (bootstrap reproductible)
set.seed(2026)

# Indice de stress environnemental E (Chave et al. 2014), lu le 01/11/2026
# dans la grille E diffusee avec le package BIOMASS (E.zip, depot GitHub
# umr-amap/BIOMASS, resolution 2,5') au centre de l'emprise de la foret
# (47,951 E ; 21,904 S). Valeurs aux quatre coins de l'emprise : 0,102 a 0,109.
E_bioclimatique <- 0.1025
# Densite du bois generique (t/m³) : moyenne arithmetique des especes
# d'Afrique tropicale (282 especes), Brown (1997, FAO Forestry Paper 134,
# §3.1.2), d'apres Reyes et al. (1992). Rattachement aux genres et familles
# juge trop incertain pour des densites par espece.
rho_bois <- 0.58
R <- 0.20                   # ratio BGB/AGB (Mokany et al. 2006)
CF <- 0.47                  # fraction de carbone (Eggleston et al. 2006)
M_CO2_C <- 3.67             # rapport molaire CO2/C

# Facteurs de reduction de densite par classe de decomposition (1 sain,
# 2 intermediaire, 3 pourri) : valeurs par defaut de l'outil MDP AR-AM-Tool-12
# v01.1.0 (CCNUCC, EB 58, annexe 14, §21), adaptees de Harmon et Sexton (1996)
facteurs_decomposition <- c("1" = 1.00, "2" = 0.80, "3" = 0.45)
# Facteur de reduction de biomasse des arbres morts sur pied ayant perdu
# feuilles, rameaux et petites branches (meme outil, §11 b) : applique a la
# biomasse de l'arbre entier, faute de hauteur mesuree pour les chandelles
facteur_chandelle <- 0.80

### Fonctions allometriques ###

# AGB Chave et al. 2014 (kg) pour un DHP en cm
agb_chave <- function(dhp_cm, rho = rho_bois, E = E_bioclimatique) {
  lnD <- log(dhp_cm)
  exp(-1.803 - 0.976 * E + 0.976 * log(rho) + 2.673 * lnD - 0.0299 * lnD^2)
}

# Volume (m³) = AGB (kg) / (rho (t/m³) × 1000 kg/t)
volume_chave <- function(dhp_cm, rho = rho_bois, E = E_bioclimatique) {
  agb_chave(dhp_cm, rho, E) / (rho * 1000)
}

facteur_decomposition <- function(etat) {
  dplyr::coalesce(unname(facteurs_decomposition[as.character(etat)]), 1)
}

### 1. Grands arbres (transects, largeur 10 m) — vivant ###

transects_GA <- d_transects |>
  filter(!is.na(longueurGA)) |>
  mutate(surface_m2 = longueurGA * 10)

surfaceGA_m2 <- sum(transects_GA$surface_m2)
message("Grands arbres : ", nrow(transects_GA), " transects, ",
        round(surfaceGA_m2, 0), " m² prospectés (",
        paste(transects_GA$cdTransect, collapse = ", "), ")")

ga <- d_grandsArbres |>
  filter(cdTransect %in% transects_GA$cdTransect) |>
  mutate(
    dbh_cm = circ_cm / pi,
    volume_m3 = volume_chave(dbh_cm)
  )

ga_par_transect <- ga |>
  group_by(cdTransect) |>
  summarise(volume_m3 = sum(volume_m3, na.rm = TRUE), .groups = "drop") |>
  left_join(transects_GA, by = "cdTransect")

V_GA_ha <- sum(ga_par_transect$volume_m3) / surfaceGA_m2 * 10000

boot_GA <- replicate(1000, {
  idx <- sample(nrow(ga_par_transect), replace = TRUE)
  bs <- ga_par_transect[idx, ]
  sum(bs$volume_m3) / sum(bs$surface_m2) * 10000
})
ic_GA <- quantile(boot_GA, c(0.025, 0.975), names = FALSE)

### 2. Tiges des placettes (flore) — vivant ###

surfacePlacettes_m2 <- sum(d_placettes$surfaceHorizontale_m2, na.rm = TRUE)
message("Placettes : ", nrow(d_placettes), " placettes, ",
        round(surfacePlacettes_m2, 1), " m², ",
        nrow(d_floreTiges), " tiges mesurées")

tiges <- d_floreTiges |>
  mutate(
    dbh_cm = circ_cm / pi,
    volume_m3 = volume_chave(dbh_cm)
  )

tiges_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(volume_m3 = sum(volume_m3, na.rm = TRUE), .groups = "drop") |>
  right_join(
    d_placettes |> select(cdPlacette, surfaceHorizontale_m2),
    by = "cdPlacette"
  ) |>
  mutate(volume_m3 = replace_na(volume_m3, 0))

V_tiges_ha <- sum(tiges_par_placette$volume_m3) / surfacePlacettes_m2 * 10000

boot_tiges <- replicate(1000, {
  idx <- sample(nrow(tiges_par_placette), replace = TRUE)
  bs <- tiges_par_placette[idx, ]
  sum(bs$volume_m3) / sum(bs$surfaceHorizontale_m2) * 10000
})
ic_tiges <- quantile(boot_tiges, c(0.025, 0.975), names = FALSE)

### 3. Bois mort au sol (line intersect, Van Wagner 1968) — mort ###

L_total <- sum(d_placettes$longueurBM, na.rm = TRUE)
message("Bois mort au sol : L_total = ", L_total, " m")

boisSol <- d_boisMort |>
  filter(type == "Sol") |>
  mutate(
    diametre_m = circ_cm / pi / 100,
    facteur = facteur_decomposition(etatDecomposition),
    d2_f = diametre_m^2 * facteur
  )

boisSol_par_placette <- d_placettes |>
  select(cdPlacette, longueurBM) |>
  left_join(
    boisSol |>
      group_by(cdPlacette) |>
      summarise(somme_d2f = sum(d2_f, na.rm = TRUE), .groups = "drop"),
    by = "cdPlacette"
  ) |>
  mutate(somme_d2f = replace_na(somme_d2f, 0))

# V/ha = π²/(8×L) × Σ(d²×f) × 10000  (f déjà appliqué par pièce)
V_sol_ha <- pi^2 / (8 * L_total) * sum(boisSol_par_placette$somme_d2f) * 10000

boot_sol <- replicate(1000, {
  idx <- sample(nrow(boisSol_par_placette), replace = TRUE)
  bs <- boisSol_par_placette[idx, ]
  L_boot <- sum(bs$longueurBM)
  if (L_boot == 0) return(NA_real_)
  pi^2 / (8 * L_boot) * sum(bs$somme_d2f) * 10000
})
ic_sol <- quantile(boot_sol, c(0.025, 0.975), na.rm = TRUE, names = FALSE)

### 4. Bois mort sur pied (chandelles) — mort ###

chandelles <- d_boisMort |>
  filter(type == "Chandelle") |>
  mutate(
    dbh_cm = circ_cm / pi,
    volume_m3 = volume_chave(dbh_cm) * facteur_chandelle
  )

message("Chandelles : ", nrow(chandelles), " bois morts sur pied")

chandelles_par_placette <- chandelles |>
  group_by(cdPlacette) |>
  summarise(volume_m3 = sum(volume_m3, na.rm = TRUE), .groups = "drop") |>
  right_join(
    d_placettes |> select(cdPlacette, surfaceHorizontale_m2),
    by = "cdPlacette"
  ) |>
  mutate(volume_m3 = replace_na(volume_m3, 0))

V_pied_ha <- sum(chandelles_par_placette$volume_m3) /
  surfacePlacettes_m2 * 10000

boot_pied <- replicate(1000, {
  idx <- sample(nrow(chandelles_par_placette), replace = TRUE)
  bs <- chandelles_par_placette[idx, ]
  sum(bs$volume_m3) / sum(bs$surfaceHorizontale_m2) * 10000
})
ic_pied <- quantile(boot_pied, c(0.025, 0.975), names = FALSE)

### Conversion volume → biomasse → carbone → CO2 ###
# Biomasse (tMS) = Volume (m³) × ρ
# Vivant  : C = Biomasse × (1+R) × CF ;  CO2 = C × 3,67
# Mort    : C = Biomasse × CF          ;  CO2 = C × 3,67
# Les IC se déduisent linéairement des IC volume.

# Coefficients de conversion (par m³ de bois à l'hectare)
conv_vivant <- c(
  biomasse = rho_bois,                          # tMS / m³
  carbone  = rho_bois * (1 + R) * CF,           # tC  / m³
  co2      = rho_bois * (1 + R) * CF * M_CO2_C  # tCO2/ m³ = 2,06988 × ρ
)
conv_mort <- c(
  biomasse = rho_bois,                 # tMS / m³
  carbone  = rho_bois * CF,            # tC  / m³
  co2      = rho_bois * CF * M_CO2_C   # tCO2/ m³
)

### Assemblage compartiment par compartiment ###

# Vecteurs nommés : volume/ha + IC pour chaque compartiment
compartiments <- c(
  "Grands arbres (transects 10 m)",
  "Tiges placettes (flore)",
  "Bois mort au sol (line intersect)",
  "Bois mort sur pied (chandelles)"
)
V_ha   <- c(V_GA_ha, V_tiges_ha, V_sol_ha, V_pied_ha)
ic_lo  <- c(ic_GA[1], ic_tiges[1], ic_sol[1], ic_pied[1])
ic_hi  <- c(ic_GA[2], ic_tiges[2], ic_sol[2], ic_pied[2])
vivant <- c(TRUE, TRUE, FALSE, FALSE)  # compartiments vivants

# Fonction : convertir un volume/ha + IC en biomasse/carbone/CO2
convertir <- function(v, ic_l, ic_h, vivant) {
  conv <- if (vivant) conv_vivant else conv_mort
  tibble(
    volume_m3_ha  = v,
    volume_ic95_bas = ic_l,
    volume_ic95_haut = ic_h,
    biomasse_tMS_ha = v * conv[["biomasse"]],
    biomasse_ic95_bas = ic_l * conv[["biomasse"]],
    biomasse_ic95_haut = ic_h * conv[["biomasse"]],
    carbone_tC_ha = v * conv[["carbone"]],
    carbone_ic95_bas = ic_l * conv[["carbone"]],
    carbone_ic95_haut = ic_h * conv[["carbone"]],
    co2_tCO2_ha = v * conv[["co2"]],
    co2_ic95_bas = ic_l * conv[["co2"]],
    co2_ic95_haut = ic_h * conv[["co2"]]
  )
}

liste_compartiments <- lapply(seq_along(compartiments), function(i) {
  convertir(V_ha[i], ic_lo[i], ic_hi[i], vivant[i]) |>
    mutate(compartiment = compartiments[i], .before = 1)
})

resultats <- bind_rows(liste_compartiments) |>
  mutate(
    type = ifelse(vivant, "vivant", "mort"),
    # Extrapolation forêt totale
    volume_total_m3 = volume_m3_ha * SURFACE_TSIAZOMBAZAHA,
    volume_total_ic95_bas = volume_ic95_bas * SURFACE_TSIAZOMBAZAHA,
    volume_total_ic95_haut = volume_ic95_haut * SURFACE_TSIAZOMBAZAHA,
    biomasse_total_tMS = biomasse_tMS_ha * SURFACE_TSIAZOMBAZAHA,
    biomasse_total_ic95_bas = biomasse_ic95_bas * SURFACE_TSIAZOMBAZAHA,
    biomasse_total_ic95_haut = biomasse_ic95_haut * SURFACE_TSIAZOMBAZAHA,
    carbone_total_tC = carbone_tC_ha * SURFACE_TSIAZOMBAZAHA,
    carbone_total_ic95_bas = carbone_ic95_bas * SURFACE_TSIAZOMBAZAHA,
    carbone_total_ic95_haut = carbone_ic95_haut * SURFACE_TSIAZOMBAZAHA,
    co2_total_tCO2 = co2_tCO2_ha * SURFACE_TSIAZOMBAZAHA,
    co2_total_ic95_bas = co2_ic95_bas * SURFACE_TSIAZOMBAZAHA,
    co2_total_ic95_haut = co2_ic95_haut * SURFACE_TSIAZOMBAZAHA
  ) |>
  select(compartiment, type,
         volume_m3_ha, volume_ic95_bas, volume_ic95_haut,
         biomasse_tMS_ha, biomasse_ic95_bas, biomasse_ic95_haut,
         carbone_tC_ha, carbone_ic95_bas, carbone_ic95_haut,
         co2_tCO2_ha, co2_ic95_bas, co2_ic95_haut,
         volume_total_m3, volume_total_ic95_bas, volume_total_ic95_haut,
         biomasse_total_tMS, biomasse_total_ic95_bas, biomasse_total_ic95_haut,
         carbone_total_tC, carbone_total_ic95_bas, carbone_total_ic95_haut,
         co2_total_tCO2, co2_total_ic95_bas, co2_total_ic95_haut)

### Sortie CSV ###

readr::write_csv(resultats, file.path(dossierSorties, "carbone_stocks.csv"))

### Messages ###

message("\n=== Stocks par compartiment (ha + total ",
        SURFACE_TSIAZOMBAZAHA, " ha) ===")
for (i in seq_len(nrow(resultats))) {
  r <- resultats[i, ]
  message(sprintf(
    "\n%s [%s]",
    r$compartiment, r$type
  ))
  message(sprintf(
    "  Volume   : %8.1f m³/ha  [%8.1f ; %8.1f]  →  %10.0f m³  [%10.0f ; %10.0f]",
    r$volume_m3_ha, r$volume_ic95_bas, r$volume_ic95_haut,
    r$volume_total_m3, r$volume_total_ic95_bas, r$volume_total_ic95_haut
  ))
  message(sprintf(
    "  Biomasse : %8.1f tMS/ha [%8.1f ; %8.1f]  →  %10.0f tMS [%10.0f ; %10.0f]",
    r$biomasse_tMS_ha, r$biomasse_ic95_bas, r$biomasse_ic95_haut,
    r$biomasse_total_tMS, r$biomasse_total_ic95_bas, r$biomasse_total_ic95_haut
  ))
  message(sprintf(
    "  Carbone  : %8.1f tC/ha  [%8.1f ; %8.1f]  →  %10.0f tC  [%10.0f ; %10.0f]",
    r$carbone_tC_ha, r$carbone_ic95_bas, r$carbone_ic95_haut,
    r$carbone_total_tC, r$carbone_total_ic95_bas, r$carbone_total_ic95_haut
  ))
  message(sprintf(
    "  CO2      : %8.1f tCO2/ha[%8.1f ; %8.1f]  →  %10.0f tCO2[%10.0f ; %10.0f]",
    r$co2_tCO2_ha, r$co2_ic95_bas, r$co2_ic95_haut,
    r$co2_total_tCO2, r$co2_total_ic95_bas, r$co2_total_ic95_haut
  ))
}

# Totaux forêt
total_carbone <- sum(resultats$carbone_tC_ha) * SURFACE_TSIAZOMBAZAHA
total_co2 <- sum(resultats$co2_tCO2_ha) * SURFACE_TSIAZOMBAZAHA
message(sprintf(
  "\n=== Total forêt (%.0f ha) ===\n  Carbone : %.0f tC\n  CO2     : %.0f tCO2",
  SURFACE_TSIAZOMBAZAHA, total_carbone, total_co2
))

resultats
