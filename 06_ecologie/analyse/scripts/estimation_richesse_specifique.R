# Estimation richesse spécifique totale (§3.7)
# Ewen Le Coeur
# 2026
# Objectif : courbe de raréfaction-extrapolation avec iNEXT, calcul des
# estimateurs asymptotiques (Chao1, Chao2, Jack1, Jack2, ACE, ICE, Bootstrap)
# et intervalles de confiance.
# Sorties :
# - CSV : gamma (richesse totale observée) + estimateurs + IC
# - CSV : valeurs de la courbe de raréfaction-extrapolation (iNEXT)
# - SVG : courbe de raréfaction-extrapolation
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/10_estimation_richesse_specifique.R")

source("06_ecologie/analyse/scripts/fonctions/fonctionsDiversite.R")

if (!requireNamespace("iNEXT", quietly = TRUE)) install.packages("iNEXT")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("svglite", quietly = TRUE)) install.packages("svglite")

library(iNEXT)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(svglite)

### Import des donnees CSV ###

dossierDonnees <- "06_ecologie/analyse/donnees"
dossierReferentiels <- "06_ecologie/analyse/referentiels"

# Reconciliation taxonomique
reconciliation <- read_csv(
  file.path(dossierReferentiels, "reconciliation-taxonomique.csv"),
  show_col_types = FALSE
)

# Correspondances : nom brut → nom reconcilie
correspondances <- reconciliation |>
  distinct(`nom-vernaculaire-brut`, `nom-vernaculaire-reconcilie`)
correspondances <- stats::setNames(
  correspondances$`nom-vernaculaire-reconcilie`,
  correspondances$`nom-vernaculaire-brut`
)

# Flore : observations (gaulis + tiges mesurees en circonference)
flore_brut <- read_csv(
  file.path(dossierDonnees, "flore.csv"),
  show_col_types = FALSE
)

# d$flore : une ligne par observation
d_flore <- flore_brut |>
  rename(
    cdPlacette = placette,
    cdObs = `code-observation-flore`,
    nomVernaculaire = `nom-vernaculaire-brut`,
    gaulis = `nombre-gaulis`
  ) |>
  mutate(gaulis = suppressWarnings(as.numeric(gaulis)))

# d$floreTiges : format long des circonferences mesurees
cols_circ <- c("Circ1", "Circ2", "Circ3", "Circ4", "Circ5", "Circ6",
               "Cir7", "Circ8", "Circ9", "Cir10")
cols_circ_present <- intersect(cols_circ, names(flore_brut))

d_floreTiges <- flore_brut |>
  select(placette, `code-observation-flore`, `nom-vernaculaire-brut`,
         all_of(cols_circ_present)) |>
  pivot_longer(
    cols = all_of(cols_circ_present),
    names_to = "numTige",
    values_to = "circ_cm"
  ) |>
  filter(!is.na(circ_cm)) |>
  mutate(circ_cm = suppressWarnings(as.numeric(circ_cm))) |>
  filter(!is.na(circ_cm)) |>
  rename(
    cdPlacette = placette,
    cdObs = `code-observation-flore`,
    nomVernaculaire = `nom-vernaculaire-brut`
  ) |>
  select(cdPlacette, cdObs, nomVernaculaire, circ_cm, numTige)

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
    surfaceHorizontale_m2 = `surface-horizontale`
  ) |>
  mutate(
    surfaceHorizontale_m2 = as.numeric(gsub(",", ".", surfaceHorizontale_m2))
  )

# Assemblage de l'objet d
d <- list(
  flore = d_flore,
  floreTiges = d_floreTiges,
  placettes = d_placettes
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Theme commun des figures ###

theme_axes <- theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.line = element_line(arrow = grid::arrow(length = grid::unit(0.25, "cm"),
                                                  type = "closed")),
    axis.ticks = element_line(linewidth = 0.4),
    axis.ticks.length = grid::unit(0.15, "cm"),
    axis.text = element_text(size = 9),
    plot.title = element_text(size = 11, face = "bold"),
    plot.subtitle = element_text(size = 9)
  )

### Abondances et matrice d'incidence ###

abondances <- calculer_abondances(d, correspondances)

# Recode des noms pour la matrice d'incidence (présence/absence)
d$flore <- d$flore |>
  mutate(espece = recode(nomVernaculaire, !!!correspondances, .default = nomVernaculaire))

especesParPlacette <- d$flore |>
  filter(!is.na(espece), str_trim(espece) != "") |>
  # Especes indeterminees exclues de la richesse (arbitrage auteur du 31/10/2026)
  filter(str_to_lower(str_trim(espece)) != "espèce indéterminée") |>
  distinct(cdPlacette, espece) |>
  mutate(presence = 1) |>
  pivot_wider(names_from = espece, values_from = presence, values_fill = 0)

# Surface moyenne par placette
surfaceMoyenne <- mean(d$placettes$surfaceHorizontale_m2, na.rm = TRUE)
if (is.na(surfaceMoyenne) || is.nan(surfaceMoyenne)) {
  surfaceMoyenne <- 1  # Valeur par défaut si NA/NaN
}

# Courbe de raréfaction-extrapolation avec iNext (jusqu'à x4 la surface prospectée)
# Surface prospectée totale : 28 placettes * surfaceMoyenne
surfaceProspectee <- 28 * surfaceMoyenne
surfaceMax <- 4 * surfaceProspectee
if (is.na(surfaceMax) || is.nan(surfaceMax)) {
  stop("surfaceMax est NA/NaN: vérifier les données de surface")
}

# Préparation des données pour iNEXT : matrice d'incidence
# On utilise la présence/absence par placette (incidence)
cat("Debug: nrow(especesParPlacette) =", nrow(especesParPlacette), "\n")
cat("Debug: ncol(especesParPlacette) =", ncol(especesParPlacette), "\n")

# Sélectionner uniquement les colonnes espèces (tout sauf cdPlacette)
especesCols <- setdiff(names(especesParPlacette), "cdPlacette")
cat("Debug: nombre d'espèces (colonnes) =", length(especesCols), "\n")

# Extraire la matrice d'incidence
data_iNEXT <- as.matrix(especesParPlacette[, especesCols, drop = FALSE])
rownames(data_iNEXT) <- especesParPlacette$cdPlacette

cat("Debug: dim(data_iNEXT) =", dim(data_iNEXT), "\n")

# Calcul de la courbe
if (ncol(data_iNEXT) == 0) {
  stop("data_iNEXT est vide: aucune espèce détectée dans les placettes")
}

# Vérifier que la matrice contient bien des 0/1 et pas de NA
cat("Debug: valeurs uniques dans data_iNEXT:", unique(as.vector(data_iNEXT)), "\n")
if (any(is.na(data_iNEXT))) {
  stop("data_iNEXT contient des NA: vérifier les données d'entrée")
}

# --- Courbe de raréfaction-extrapolation (iNEXT) ------------------------------
# iNEXT travaille en unités d'échantillonnage (placettes), pas en m².
nPlacettes      <- nrow(data_iNEXT)                    # 28
surfaceProspectee <- nPlacettes * surfaceMoyenne        # m²
endpointUnites  <- 4 * nPlacettes                      # extrapolation x4 => 112 unités

# Format attendu par iNEXT pour "incidence_raw" :
# matrice espèces (lignes) x unités d'échantillonnage (colonnes), 0/1.
matrice_incidence <- t(data_iNEXT)                     # 243 x 28

# Vecteur de fréquences d'incidence : 1er élément = nombre de placettes,
# suivis du nombre de placettes abritant chaque espèce.
freq_incidence <- as.incfreq(matrice_incidence)

sp_inext <- iNEXT(
  x = freq_incidence,
  q = 0,
  datatype = "incidence_freq",
  endpoint = endpointUnites,
  knots = 40
)

# Variante équivalente en fréquences d'incidence :
# freq <- c(nPlacettes, colSums(data_iNEXT))            # 1er élément = nb d'unités
# sp_inext <- iNEXT(freq, q = 0, datatype = "incidence_freq",
#                   endpoint = endpointUnites, knots = 40)

# --- Extraction de la courbe --------------------------------------------------
courbe_data <- sp_inext$iNextEst
# iNEXT >= 3.0.0 : $iNextEst est une liste ($size_based, $coverage_based)
if (is.list(courbe_data) && !is.data.frame(courbe_data)) {
  courbe_data <- courbe_data$size_based
}
courbe_data <- as.data.frame(courbe_data)
# Noms de colonnes selon la version d'iNEXT :
# >= 3.0.0 (incidence) : t, qD, qD.LCL, qD.UCL — versions antérieures : m, D, LCL, UCL
colTaille <- if ("m" %in% names(courbe_data)) "m" else "t"
colD      <- if ("D" %in% names(courbe_data)) "D" else "qD"
colLCL    <- if ("LCL" %in% names(courbe_data)) "LCL" else "qD.LCL"
colUCL    <- if ("UCL" %in% names(courbe_data)) "UCL" else "qD.UCL"

courbe_data$surface_m2 <- courbe_data[[colTaille]] * surfaceMoyenne   # conversion en m²

# --- Estimateurs asymptotiques ------------------------------------------------
gamma <- ncol(data_iNEXT)

# Chao2 (estimateur de Chao pour données d'incidence) + IC
chao2 <- ChaoRichness(freq_incidence, datatype = "incidence_freq", conf = 0.95)

# Jack1 et Jack2 : sites en lignes, espèces en colonnes
if (!requireNamespace("vegan", quietly = TRUE)) install.packages("vegan")
sp <- vegan::specpool(data_iNEXT)

# --- Panel d'estimateurs d'incidence (ICE, bootstrap, jackknife2) -------------
if (!requireNamespace("SpadeR", quietly = TRUE)) install.packages("SpadeR")

panel_incidence <- SpadeR::ChaoSpecies(freq_incidence,
                                       datatype = "incidence_freq",
                                       k = 10, conf = 0.95)
print(panel_incidence)          # tableau complet avec erreurs standards et IC
sp_tab <- as.data.frame(panel_incidence$Species_table)

# Extraction d'une ligne par motif, en excluant les variantes "-1" (ICE-1)
ext <- function(motif, tab = sp_tab) {
  hit <- rownames(tab)[grepl(motif, rownames(tab), fixed = TRUE)]
  if (length(hit) == 0) stop("Ligne non trouvee dans la table SpadeR : ", motif)
  tab[hit[1], , drop = FALSE]
}

ice        <- ext("ICE (Lee")
jack2      <- ext("2nd order jackknife")
chao2_inci <- ext("Chao2 (Chao, 1987)")

print(sp_tab)     # repérer les lignes : Bootstrap, ICE, Jackknife2, Chao2

# --- Estimateurs d'abondance : Chao1, ACE -------------------------------------
# Somme des tiges par espèce à l'échelle de l'étude (gamma)
abondances_totales <- abondances |>
  dplyr::filter(!is.na(espece), trimws(espece) != "") |>
  dplyr::group_by(espece) |>
  dplyr::summarise(abondance = sum(as.integer(abondance), na.rm = TRUE), .groups = "drop") |>
  dplyr::filter(abondance > 0)

abondances_vec <- stats::setNames(as.numeric(abondances_totales$abondance),
                                  abondances_totales$espece)

if (length(abondances_vec) != gamma) {
  warning("Le nombre d'espèces dans la table des abondances (", length(abondances_vec),
          ") diffère du gamma de la matrice d'incidence (", gamma, ") : vérifier les correspondances.")
}

# Chao1 + IC exact à 95% (iNEXT)
chao1 <- ChaoRichness(abondances_vec, datatype = "abundance", conf = 0.95)
print(chao1)
chao1_ic_inf <- unlist(chao1[grep("Lower", names(chao1))])
chao1_ic_sup <- unlist(chao1[grep("Upper", names(chao1))])

# ACE + erreur standard (vegan) ; IC par approximation normale
est_ab   <- vegan::estimateR(abondances_vec)
ace_est  <- as.numeric(est_ab["S.ACE"])
ace_se   <- as.numeric(est_ab["se.ACE"])
ace_ic_inf <- ace_est - 1.96 * ace_se
ace_ic_sup <- ace_est + 1.96 * ace_se

# Bornes de l'IC de Chao2 : colonnes "95% Lower" / "95% Upper" (iNEXT 3.x)
chao2_ic_inf <- unlist(chao2[grep("Lower", names(chao2))])
chao2_ic_sup <- unlist(chao2[grep("Upper", names(chao2))])

resultats <- tibble(
  Metrique   = c("Gamma (observé)", "Chao2", "Jack2", "ICE", "Bootstrap",
                 "Chao1", "Jack1", "ACE"),
  Modele     = c("-", "incidence", "incidence", "incidence", "incidence",
                 "abondance", "incidence", "abondance"),
  Estimation = c(gamma,
                 chao2_inci[["Estimate"]], jack2[["Estimate"]],
                 ice[["Estimate"]],
                 sp$boot,
                 chao1$Estimator,
                 sp$jack1,
                 ace_est),
  IC_inf = c(NA,
             chao2_inci[["95%Lower"]], jack2[["95%Lower"]],
             ice[["95%Lower"]],
             sp$boot - 1.96 * sp$boot.se,
             chao1_ic_inf,
             sp$jack1 - 1.96 * sp$jack1.se,
             ace_ic_inf),
  IC_sup = c(NA,
             chao2_inci[["95%Upper"]], jack2[["95%Upper"]],
             ice[["95%Upper"]],
             sp$boot + 1.96 * sp$boot.se,
             chao1_ic_sup,
             sp$jack1 + 1.96 * sp$jack1.se,
             ace_ic_sup)
)

# ICE (optionnel, package SpadeR) :
# freq <- c(nPlacettes, colSums(data_iNEXT))
# SpadeR::Spade(freq, datatype = "incidence_freq")   # fournit ICE + IC

# --- Figure (colonnes iNEXT : m, D, LCL, UCL) ----------------------------------
figureRarefaction <- ggplot(courbe_data, aes(x = surface_m2, y = .data[[colD]])) +
  geom_ribbon(aes(ymin = .data[[colLCL]], ymax = .data[[colUCL]]),
              alpha = 0.5, fill = "grey60") +
  geom_line(linewidth = 0.9) +
  geom_vline(xintercept = surfaceProspectee, linetype = "dashed", color = "grey40") +
  labs(x = "Surface cumulée (m²)",
       y = "Richesse spécifique (espèces)",
       title = "Courbe de raréfaction-extrapolation",
       subtitle = paste("Données :", nPlacettes, "placettes, gamma =", gamma, "espèces")) +
  theme_axes

# Sauvegarde en SVG (vectoriel)
ggsave(file.path(dossierSorties, "courbe_raréfaction_extrapolation.svg"),
       figureRarefaction, width = 16, height = 12, units = "cm")

# Export CSV
readr::write_csv(resultats, file.path(dossierSorties, "estimateurs_richesse_gamma.csv"))
readr::write_csv(courbe_data, file.path(dossierSorties, "courbe_raréfaction_extrapolation.csv"))

# Messages
message("✅ Estimation richesse spécifique (§3.7) :")
message("   Gamma (richesse totale observée) : ", gamma, " espèces")
message("   Chao2 : ", round(chao2_inci[["Estimate"]], 1),
        " [", round(chao2_inci[["95%Lower"]], 1), "; ",
        round(chao2_inci[["95%Upper"]], 1), "]")
message("   Jack2 : ", round(jack2[["Estimate"]], 1),
        " [", round(jack2[["95%Lower"]], 1), "; ",
        round(jack2[["95%Upper"]], 1), "]")
message("   ICE : ", round(ice[["Estimate"]], 1),
        " [", round(ice[["95%Lower"]], 1), "; ",
        round(ice[["95%Upper"]], 1), "]")
message("   Bootstrap : ", round(sp$boot, 1),
        " [", round(sp$boot - 1.96 * sp$boot.se, 1), "; ",
        round(sp$boot + 1.96 * sp$boot.se, 1), "]")
message("   Chao1 : ", round(chao1$Estimator, 1),
        " [", round(chao1_ic_inf, 1), "; ", round(chao1_ic_sup, 1), "]")
message("   Jack1 : ", round(sp$jack1, 1),
        " [", round(sp$jack1 - 1.96 * sp$jack1.se, 1), "; ",
        round(sp$jack1 + 1.96 * sp$jack1.se, 1), "]")
message("   ACE : ", round(ace_est, 1),
        " [", round(ace_ic_inf, 1), "; ", round(ace_ic_sup, 1), "]")