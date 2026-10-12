# Ewen Le Coeur
# 2026
# Objectif : diversite beta (§3.4 du document d'etape) — dissimilarites
# entre placettes (Jaccard, Sorensen, Bray-Curtis), beta de Whittaker,
# figure et exports.
#
# Structure du code :
#   - fonctionsDiversite.R   : calculer_abondances (partage avec l'alpha)
#   - fonctionsDiversiteBeta.R : fonctions de calcul (matrices, paires)
#   - analyse_diversite_beta.R : CE SCRIPT — orchestration, figure, sorties
#
# Utilisation :
#   source("06_ecologie/analyse/scripts/07_analyse_diversite_beta.R")

source("06_ecologie/analyse/scripts/fonctions/fonctionsDiversite.R")
source("06_ecologie/analyse/scripts/fonctions/fonctionsDiversiteBeta.R")

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("scales", quietly = TRUE)) install.packages("scales")
if (!requireNamespace("vegan", quietly = TRUE)) install.packages("vegan")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("tibble", quietly = TRUE)) install.packages("tibble")

library(ggplot2)
library(scales)
library(vegan)
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(tibble)

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

# Transects
d_transects <- read_csv(
  file.path(dossierDonnees, "transects.csv"),
  show_col_types = FALSE
) |>
  rename(cdTransect = transect)

# Assemblage de l'objet d
d <- list(
  flore = d_flore,
  floreTiges = d_floreTiges,
  placettes = d_placettes,
  transects = d_transects
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

### Matrice d'abondances ###

abondances <- calculer_abondances(d, correspondances)
matAbond <- matrice_abondances(abondances)

### Dissimilarites entre paires de placettes ###

paires <- table_paires(matAbond)

### MISE DE COTE (Jaccard, Sorensen, dendrogramme) ###
# Mesures de turnover en presence-absence non retenues dans la
# demonstration : elles restent calculees dans la table
# la table paires mais ni exportees ni affichees.
resumeDissim <- bind_rows(
  tibble(indice = "Bray-Curtis (abondances)",
         moyenne = mean(paires$brayCurtis), ecartType = sd(paires$brayCurtis))
) |>
  dplyr::mutate(across(where(is.numeric), ~ round(.x, 3)))

### Beta de Whittaker ###

whit <- whittaker_beta(matAbond)

### Beta additif (richesse) ###

# beta_add = gamma - alpha_moyen : nombre moyen d'especes
# "supplementaires" gagnees en parcourant les placettes.
betaAdditif <- whit$gamma - whit$alphaMoyen

### NMDS sur Bray-Curtis (ordination des placettes) ###

distBray <- vegan::vegdist(matAbond, method = "bray")
nmdsRes <- vegan::metaMDS(distBray, k = 2, trymax = 100, trace = 0)

correspTransects <- d$placettes |>
  dplyr::select(cdTransect, cdPlacette) |>
  dplyr::left_join(
    d$transects |> dplyr::select(cdTransect, polisnala, commune),
    by = "cdTransect")

pointsNMDS <- tibble::tibble(
  cdPlacette = rownames(nmdsRes$points),
  NMDS1 = nmdsRes$points[, 1],
  NMDS2 = nmdsRes$points[, 2]
) |>
  dplyr::left_join(correspTransects, by = "cdPlacette")

if (!requireNamespace("ggrepel", quietly = TRUE)) install.packages("ggrepel")
library(ggrepel)

nTransects <- length(unique(pointsNMDS$cdTransect))
formes <- c(0:25)[seq_len(nTransects)]

figNMDS <- ggplot(pointsNMDS, aes(x = NMDS1, y = NMDS2,
                                   shape = cdTransect)) +
  geom_point(size = 2.5, colour = "grey20") +
  scale_shape_manual(values = formes, name = "Transect") +
  scale_x_continuous(breaks = scales::breaks_pretty(n = 5),
                     expand = expansion(mult = 0.08)) +
  scale_y_continuous(breaks = scales::breaks_pretty(n = 5),
                     expand = expansion(mult = 0.08)) +
  labs(x = "NMDS 1", y = "NMDS 2") +
  theme_axes

ggsave(file.path(dossierSorties, "diversite_beta_nmds.svg"),
       figNMDS, width = 14, height = 12, units = "cm")

### Bray-Curtis par niveau hierarchique (transect / polisn'ala / commune) ###

# Chaque paire de placettes est classee selon le niveau auquel les deux
# placettes appartiennent a la meme entite : meme transect > meme
# polisn'ala > meme commune > communes differentes.
metaPlacettes <- pointsNMDS |> dplyr::select(cdPlacette, cdTransect,
                                            polisnala, commune)

pairesNiveaux <- paires |>
  dplyr::left_join(metaPlacettes, by = c("placette1" = "cdPlacette")) |>
  dplyr::rename(transect1 = cdTransect, polisnala1 = polisnala,
                commune1 = commune) |>
  dplyr::left_join(metaPlacettes, by = c("placette2" = "cdPlacette")) |>
  dplyr::rename(transect2 = cdTransect, polisnala2 = polisnala,
                commune2 = commune) |>
  dplyr::mutate(
    niveau = dplyr::case_when(
      transect1 == transect2 ~ "Même transect",
      polisnala1 == polisnala2 ~ "Même polisn'ala",
      commune1 == commune2 ~ "Même commune",
      TRUE ~ "Entre communes"
    ),
    niveau = factor(niveau, levels = c(
      "Même transect", "Même polisn'ala", "Même commune",
      "Entre communes"))
  )

resumeNiveaux <- pairesNiveaux |>
  dplyr::group_by(niveau) |>
  dplyr::summarise(
    nbPaires = dplyr::n(),
    moyenne = mean(brayCurtis),
    ecartType = sd(brayCurtis),
    .groups = "drop"
  ) |>
  dplyr::mutate(across(where(is.numeric), ~ round(.x, 3)))

# (figure remplacee par le gradient Jaccard : voir plus bas)

### Tests statistiques entre niveaux ###

# Kruskal-Wallis global puis comparaisons deux a deux (Wilcoxon,
# correction de Holm). Les paires ne sont pas independantes entre
# elles (une placette apparait dans plusieurs paires) : le test est
# indicatif, a croiser avec les boxplots.
testKW <- stats::kruskal.test(brayCurtis ~ niveau, data = pairesNiveaux)
testsPairs <- stats::pairwise.wilcox.test(pairesNiveaux$brayCurtis,
                                         pairesNiveaux$niveau,
                                         p.adjust.method = "holm")
tableTests <- as.data.frame(as.table(testsPairs$p.value))
names(tableTests) <- c("niveau1", "niveau2", "p")
tableTests <- tableTests |>
  dplyr::filter(!is.na(p)) |>
  dplyr::mutate(p = round(p, 4))

### Regroupement Andriana/Mizilo vs Ambahatrazo ###

# Les communes Andriana et Mizilo sont regroupees (cf. arbitrage
# auteur) : le contraste porte sur Ambahatrazo vs le reste.
groupesCommunes <- metaPlacettes |>
  dplyr::mutate(
    groupe = dplyr::if_else(
      commune == "Ambahatrazo", "Ambahatrazo",
      dplyr::if_else(commune %in% c("Andriana", "Mizilo"),
                     "Andriana-Mizilo", NA_character_))
  ) |>
  dplyr::select(cdPlacette, groupe)

pairesGroupe <- pairesNiveaux |>
  dplyr::left_join(groupesCommunes,
                   by = c("placette1" = "cdPlacette")) |>
  dplyr::rename(groupe1 = groupe) |>
  dplyr::left_join(groupesCommunes,
                   by = c("placette2" = "cdPlacette")) |>
  dplyr::rename(groupe2 = groupe) |>
  dplyr::mutate(
    niveauGroupe = dplyr::case_when(
      transect1 == transect2 ~ "Même transect",
      polisnala1 == polisnala2 ~ "Même polisn'ala",
      commune1 == commune2 ~ "Même commune",
      groupe1 == groupe2 ~ "Même groupe (Andriana/Mizilo)",
      TRUE ~ "Ambahatrazo vs autres"
    ),
    niveauGroupe = factor(niveauGroupe, levels = c(
      "Même transect", "Même polisn'ala", "Même commune",
      "Même groupe (Andriana/Mizilo)", "Ambahatrazo vs autres"))
  ) |>
  dplyr::filter(!is.na(niveauGroupe))

resumeGroupe <- pairesGroupe |>
  dplyr::group_by(niveauGroupe) |>
  dplyr::summarise(
    nbPaires = dplyr::n(),
    moyenne = mean(brayCurtis),
    ecartType = sd(brayCurtis),
    .groups = "drop"
  ) |>
  dplyr::mutate(across(where(is.numeric), ~ round(.x, 3)))

testKWGroupe <- stats::kruskal.test(brayCurtis ~ niveauGroupe,
                                    data = pairesGroupe)
testsPairsGroupe <- stats::pairwise.wilcox.test(pairesGroupe$brayCurtis,
                                               pairesGroupe$niveauGroupe,
                                               p.adjust.method = "holm")
tableTestsGroupe <- as.data.frame(as.table(testsPairsGroupe$p.value))
names(tableTestsGroupe) <- c("niveau1", "niveau2", "p")
tableTestsGroupe <- tableTestsGroupe |>
  dplyr::filter(!is.na(p)) |>
  dplyr::mutate(p = round(p, 4))

# (figure remplacee par le gradient Jaccard : voir plus bas)

### Gradient transect -> polisn'ala -> commune (Jaccard, presence-absence) ###

# Objectif : savoir si un polisn'ala (ou une commune) voit/nomme des
# especes differentes des autres, independamment des abondances. La
# dissimilarite de Jaccard compare les listes d'especes (reconciliees)
# sans ponderation d'abondance.
# Tests : Kruskal-Wallis global puis Wilcoxon deux a deux (correction
# de Holm). Les paires ne sont pas independantes (une placette apparait
# dans plusieurs paires) : tests indicatifs, a croiser avec la figure.
testKWJac <- stats::kruskal.test(jaccard ~ niveau, data = pairesNiveaux)
testsPairsJac <- stats::pairwise.wilcox.test(pairesNiveaux$jaccard,
                                            pairesNiveaux$niveau,
                                            p.adjust.method = "holm")
tableTestsJac <- as.data.frame(as.table(testsPairsJac$p.value))
names(tableTestsJac) <- c("niveau1", "niveau2", "p")
tableTestsJac <- tableTestsJac |>
  dplyr::filter(!is.na(p)) |>
  dplyr::mutate(p = round(p, 4))

niveauxOrdres <- levels(pairesNiveaux$niveau)
posNiveau <- stats::setNames(seq_along(niveauxOrdres), niveauxOrdres)
combis <- utils::combn(niveauxOrdres, 2, simplify = FALSE)

# etoiles de significativite (convention usuelle)
etoile <- function(p) {
  dplyr::case_when(
    is.na(p) ~ "",
    p < 0.001 ~ "***",
    p < 0.01 ~ "**",
    p < 0.05 ~ "*",
    TRUE ~ "ns"
  )
}

# p-value exacte d'une paire de niveaux, par reunion robuste (plus de cle texte)
p_de <- function(nA, nB) {
  hit <- tableTestsJac |>
    dplyr::filter((niveau1 == nA & niveau2 == nB) |
                  (niveau1 == nB & niveau2 == nA))
  if (nrow(hit) == 0) return(NA_real_)
  hit$p[1]
}

# Hauteur d'accolade selon la "portee" de la comparaison : les
# comparaisons adjacentes (1-2, 2-3, 3-4) sont basses, les
# comparaisons larges (1-3, 2-4, 1-4) sont plus hautes, sans
# chevauchement possible (une accolade ne croise jamais une autre).
portee <- function(nA, nB) {
  abs(posNiveau[[nB]] - posNiveau[[nA]])
}
# Hauteurs par position exacte (degre de liberte : aucune accolade
# ne partage un point d'ancrage a la meme hauteur) :
#   1-2 : 1,06   2-3 : 1,12   3-4 : 1,06
#   1-3 : 1,18   2-4 : 1,18
#   1-4 : 1,24
hautPosition <- c(
  "1 2" = 1.06, "2 3" = 1.12, "3 4" = 1.06,
  "1 3" = 1.18, "2 4" = 1.18,
  "1 4" = 1.24
)

pairesGrad <- dplyr::bind_rows(lapply(seq_along(combis), function(k) {
  cc <- combis[[k]]
  pv <- p_de(cc[1], cc[2])
  xi <- min(posNiveau[cc[1]], posNiveau[cc[2]])
  xj <- max(posNiveau[cc[1]], posNiveau[cc[2]])
  tibble(
    niveauA = cc[1], niveauB = cc[2],
    x = xi, xend = xj,
    y = hautPosition[[paste(xi, xj)]],
    p = pv,
    etoile = etoile(pv)
  )
}))

# Les p-values exactes et les seuils vont dans la legende de la figure
# (titre/description cote memoire), pas dans l'image : seules les
# etoiles de significativite y figurent.

figGradient <- ggplot(pairesNiveaux,
                      aes(x = niveau, y = jaccard, group = niveau)) +
  geom_boxplot(show.legend = FALSE, linewidth = 0.3, outlier.size = 0.8,
               fill = "grey85", colour = "grey20",
               outlier.colour = "grey20") +
  geom_segment(data = pairesGrad,
               aes(x = x, xend = xend, y = y, yend = y),
               inherit.aes = FALSE, linewidth = 0.3, colour = "grey20") +
  geom_segment(data = pairesGrad,
               aes(x = x, xend = x, y = y, yend = y - 0.02),
               inherit.aes = FALSE, linewidth = 0.3, colour = "grey20") +
  geom_segment(data = pairesGrad,
               aes(x = xend, xend = xend, y = y, yend = y - 0.02),
               inherit.aes = FALSE, linewidth = 0.3, colour = "grey20") +
  geom_text(data = pairesGrad,
            aes(x = (x + xend) / 2, y = y, label = etoile),
            inherit.aes = FALSE, size = 3.8, vjust = -0.1,
            colour = "grey20") +
  coord_cartesian(ylim = c(0, 1.42)) +
  scale_x_discrete(labels = function(l) paste0(l, "\n(n = ",
    as.integer(table(pairesNiveaux$niveau)[l]), ")")) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.2),
                     expand = expansion(mult = c(0.02, 0.02))) +
  labs(x = NULL, y = "Jaccard (présence-absence)") +
  theme_axes +
  theme(axis.text.x = element_text(size = 8))

ggsave(file.path(dossierSorties, "diversite_beta_gradient.svg"),
       figGradient, width = 18, height = 13, units = "cm")

### Especes par commune : structure reelle ou artefact ? ###

# Presence simple (richesse, sans abondances) : pour chaque espece
# reconciliee, dans combien de communes est-elle observee ? Une
# forte proportion d'especes vues dans une seule commune peut venir
# (a) d'une vraie structure spatiale, (b) du fait que peu de
# placettes par commune suffisent a ce que chaque espece n'ait eu
# qu'une chance limitee d'etre vue ailleurs. Le test de permutation
# tranche : on reattribue au hasard les communes aux placettes
# (meme nombre de placettes par commune) et on compare la proportion
# observee a la distribution nulle.
placettesCommunes <- metaPlacettes |>
  dplyr::filter(!is.na(commune)) |>
  dplyr::select(cdPlacette, commune)

communesPlacettes <- stats::setNames(placettesCommunes$commune,
                                     placettesCommunes$cdPlacette)

especesPlacettes <- abondances |>
  dplyr::filter(cdPlacette %in% placettesCommunes$cdPlacette) |>
  dplyr::distinct(cdPlacette, espece)

prop_mono <- function(communesParPlacette) {
  m <- table(especesPlacettes$espece,
             communesParPlacette[especesPlacettes$cdPlacette])
  mean(rowSums(m > 0) == 1)
}

especesParCommune <- presences_tmp <- especesPlacettes |>
  dplyr::mutate(commune = communesPlacettes[cdPlacette]) |>
  dplyr::distinct(espece, commune)

especesParCommune <- especesParCommune |>
  dplyr::count(espece, name = "nbCommunes") |>
  dplyr::arrange(dplyr::desc(nbCommunes), espece) |>
  dplyr::mutate(monoCommune = nbCommunes == 1)

propMonoObs <- mean(especesParCommune$monoCommune)

set.seed(2026)
nPerm <- 999
permMono <- replicate(nPerm, prop_mono(
  stats::setNames(sample(communesPlacettes), names(communesPlacettes))))
pMono <- (1 + sum(permMono >= propMonoObs)) / (nPerm + 1)

### Noms vernaculaires bruts vs especes reconciliees ###

# Meme mesure sur les noms vernaculaires bruts (sans reconciliation) :
# si la proportion de noms mono-commune est nettement plus elevee que
# celle des especes reconciliees, c'est que la reconciliation a fusionne
# des noms differents entre communes (les polisn'ala nomment
# differemment les memes especes).
nomsBruts <- d$floreTiges |>
  dplyr::distinct(cdPlacette, nomVernaculaire) |>
  dplyr::bind_rows(
    d$flore |> dplyr::distinct(cdPlacette, nomVernaculaire)) |>
  dplyr::distinct() |>
  dplyr::filter(!is.na(nomVernaculaire),
                str_trim(nomVernaculaire) != "",
                !str_detect(str_to_lower(nomVernaculaire),
                            "ind.termin")) |>
  dplyr::filter(cdPlacette %in% placettesCommunes$cdPlacette)

prop_mono_noms <- function(communesParPlacette) {
  m <- table(nomsBruts$nomVernaculaire,
             communesParPlacette[nomsBruts$cdPlacette])
  mean(rowSums(m > 0) == 1)
}

nomsParCommune <- nomsBruts |>
  dplyr::mutate(commune = communesPlacettes[cdPlacette]) |>
  dplyr::distinct(nomVernaculaire, commune) |>
  dplyr::count(nomVernaculaire, name = "nbCommunes")

propMonoNomsObs <- mean(nomsParCommune$nbCommunes == 1)
permMonoNoms <- replicate(nPerm, prop_mono_noms(
  stats::setNames(sample(communesPlacettes), names(communesPlacettes))))
pMonoNoms <- (1 + sum(permMonoNoms >= propMonoNomsObs)) / (nPerm + 1)

### Exports ###

readr::write_csv(paires,
                 file.path(dossierSorties, "diversite_beta_paires.csv"))
readr::write_csv(resumeDissim,
                 file.path(dossierSorties, "diversite_beta_resume.csv"))
readr::write_csv(tibble::tibble(
  alphaMoyen = whit$alphaMoyen,
  gamma = whit$gamma,
  betaMultiplicatif = whit$beta,
  betaAdditif = betaAdditif
) |> dplyr::mutate(across(where(is.numeric), ~ round(.x, 2))),
file.path(dossierSorties, "diversite_beta_whittaker.csv"))
readr::write_csv(pointsNMDS,
                 file.path(dossierSorties, "diversite_beta_nmds_points.csv"))
readr::write_csv(pairesNiveaux |>
                   dplyr::select(placette1, placette2, niveau, brayCurtis),
                 file.path(dossierSorties, "diversite_beta_paires_niveaux.csv"))
readr::write_csv(resumeNiveaux,
                 file.path(dossierSorties, "diversite_beta_bray_niveaux.csv"))
readr::write_csv(tableTests,
                 file.path(dossierSorties, "diversite_beta_tests_niveaux.csv"))
readr::write_csv(tableTestsJac,
                 file.path(dossierSorties, "diversite_beta_tests_niveaux_jaccard.csv"))
readr::write_csv(resumeGroupe,
                 file.path(dossierSorties, "diversite_beta_bray_groupes.csv"))
readr::write_csv(tableTestsGroupe,
                 file.path(dossierSorties, "diversite_beta_tests_groupes.csv"))
readr::write_csv(especesParCommune,
                 file.path(dossierSorties, "diversite_beta_especes_par_commune.csv"))
readr::write_csv(dplyr::bind_rows(
  tibble(indice = "Especes reconciliees",
         proportionMonoCommune = round(propMonoObs, 3),
         permutationMoyenne = round(mean(permMono), 3),
         pValue = signif(pMono, 3)),
  tibble(indice = "Noms vernaculaires bruts",
         proportionMonoCommune = round(propMonoNomsObs, 3),
         permutationMoyenne = round(mean(permMonoNoms), 3),
         pValue = signif(pMonoNoms, 3))
),
file.path(dossierSorties, "diversite_beta_mono_commune.csv"))

### Resume synthetique pour le rapport ###

resumeRapport <- dplyr::bind_rows(
  # Beta multiplicatif (Whittaker)
  tibble(
    section = "Beta multiplicatif (Whittaker)",
    indice = "Beta = gamma / alpha - 1",
    valeur = round(whit$beta, 2),
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = NA_real_, n = NA_integer_,
    details = paste0("alpha moyen = ", round(whit$alphaMoyen, 1),
                     ", gamma = ", whit$gamma)
  ),
  # Beta additif
  tibble(
    section = "Beta additif",
    indice = "Beta additif = gamma - alpha moyen",
    valeur = round(betaAdditif, 1),
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = NA_real_, n = NA_integer_,
    details = paste0("alpha moyen = ", round(whit$alphaMoyen, 1),
                     ", gamma = ", whit$gamma)
  ),
  # NMDS
  tibble(
    section = "NMDS (Bray-Curtis)",
    indice = "Stress",
    valeur = round(nmdsRes$stress, 3),
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = NA_real_, n = nrow(matAbond),
    details = "k = 2, methode Bray-Curtis"
  ),
  # Boxplot Jaccard : KW global
  tibble(
    section = "Boxplot Jaccard (presence-absence)",
    indice = "Kruskal-Wallis (4 niveaux)",
    valeur = NA_real_,
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = signif(testKWJac$p.value, 3),
    n = nrow(pairesNiveaux),
    details = "Niveaux : meme transect / polisn'ala / commune / entre communes"
  ),
  # Boxplot Jaccard : comparaisons deux a deux
  tableTestsJac |>
    dplyr::transmute(
      section = "Boxplot Jaccard (presence-absence)",
      indice = paste0("Wilcoxon : ", niveau1, " vs ", niveau2),
      valeur = NA_real_,
      ic95_bas = NA_real_, ic95_haut = NA_real_,
      p_value = p,
      n = NA_integer_,
      details = "Correction Holm"
    ),
  # Bray-Curtis par niveau : moyennes
  resumeNiveaux |>
    dplyr::transmute(
      section = "Bray-Curtis par niveau",
      indice = as.character(niveau),
      valeur = moyenne,
      ic95_bas = NA_real_, ic95_haut = NA_real_,
      p_value = NA_real_,
      n = nbPaires,
      details = paste0("moyenne ± ecart-type = ", moyenne, " ± ", ecartType)
    ),
  # Bray-Curtis : KW global
  tibble(
    section = "Bray-Curtis par niveau",
    indice = "Kruskal-Wallis (4 niveaux)",
    valeur = NA_real_,
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = signif(testKW$p.value, 3),
    n = nrow(pairesNiveaux),
    details = ""
  ),
  # Bray-Curtis : comparaisons deux a deux
  tableTests |>
    dplyr::transmute(
      section = "Bray-Curtis par niveau",
      indice = paste0("Wilcoxon : ", niveau1, " vs ", niveau2),
      valeur = NA_real_,
      ic95_bas = NA_real_, ic95_haut = NA_real_,
      p_value = p,
      n = NA_integer_,
      details = "Correction Holm"
    ),
  # Groupes (Andriana/Mizilo vs Ambahatrazo) : moyennes
  resumeGroupe |>
    dplyr::transmute(
      section = "Bray-Curtis par groupe",
      indice = as.character(niveauGroupe),
      valeur = moyenne,
      ic95_bas = NA_real_, ic95_haut = NA_real_,
      p_value = NA_real_,
      n = nbPaires,
      details = paste0("moyenne ± ecart-type = ", moyenne, " ± ", ecartType)
    ),
  # Groupes : KW
  tibble(
    section = "Bray-Curtis par groupe",
    indice = "Kruskal-Wallis (5 niveaux)",
    valeur = NA_real_,
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = signif(testKWGroupe$p.value, 3),
    n = nrow(pairesGroupe),
    details = "Andriana/Mizilo regroupes vs Ambahatrazo"
  ),
  # Groupes : comparaisons deux a deux
  tableTestsGroupe |>
    dplyr::transmute(
      section = "Bray-Curtis par groupe",
      indice = paste0("Wilcoxon : ", niveau1, " vs ", niveau2),
      valeur = NA_real_,
      ic95_bas = NA_real_, ic95_haut = NA_real_,
      p_value = p,
      n = NA_integer_,
      details = "Correction Holm"
    ),
  # Especes mono-commune
  tibble(
    section = "Especes mono-commune",
    indice = "Especes reconciliees",
    valeur = round(propMonoObs, 3),
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = signif(pMono, 3),
    n = nrow(especesParCommune),
    details = paste0("attendu sous permutation = ", round(mean(permMono), 3))
  ),
  tibble(
    section = "Especes mono-commune",
    indice = "Noms vernaculaires bruts",
    valeur = round(propMonoNomsObs, 3),
    ic95_bas = NA_real_, ic95_haut = NA_real_,
    p_value = signif(pMonoNoms, 3),
    n = nrow(nomsParCommune),
    details = paste0("attendu sous permutation = ", round(mean(permMonoNoms), 3))
  )
)

readr::write_csv(resumeRapport,
                 file.path(dossierSorties, "diversite_beta_resume_rapport.csv"))

### Messages ###

message("✅ Diversité beta (§3.4) — ", nrow(matAbond),
        " placettes, ", ncol(matAbond), " espèces :")
for (i in seq_len(nrow(resumeDissim))) {
  r <- resumeDissim[i, ]
  message("   ", r$indice, " : ", r$moyenne, " ± ", r$ecartType)
}
message("   Beta multiplicatif (Whittaker) : ", round(whit$beta, 2),
        " (alpha moyen ", round(whit$alphaMoyen, 1),
        ", gamma ", whit$gamma, ")")
message("   Beta additif : ", round(betaAdditif, 1),
        " especes (gamma - alpha moyen)")
message("   NMDS Bray-Curtis : stress = ", round(nmdsRes$stress, 3))
message("   Bray-Curtis par niveau :")
for (i in seq_len(nrow(resumeNiveaux))) {
  r <- resumeNiveaux[i, ]
  message("     ", r$niveau, " : ", r$moyenne,
          " (n = ", r$nbPaires, " paires)")
}
message("   Kruskal-Wallis (4 niveaux) : p = ",
        signif(testKW$p.value, 3))
for (i in seq_len(nrow(tableTests))) {
  r <- tableTests[i, ]
  message("     ", r$niveau1, " vs ", r$niveau2, " : p = ", r$p)
}
message("   Niveaux avec Andriana/Mizilo regroupes :")
for (i in seq_len(nrow(resumeGroupe))) {
  r <- resumeGroupe[i, ]
  message("     ", r$niveauGroupe, " : ", r$moyenne,
          " (n = ", r$nbPaires, " paires)")
}
message("   Kruskal-Wallis (groupes) : p = ",
        signif(testKWGroupe$p.value, 3))
message("   Gradient Jaccard (presence-absence) : KW p = ",
        signif(testKWJac$p.value, 3))
for (i in seq_len(nrow(tableTestsJac))) {
  r <- tableTestsJac[i, ]
  message("     ", r$niveau1, " vs ", r$niveau2, " : p = ", r$p)
}
message("   Especes vues dans une seule commune : ",
        round(propMonoObs, 3), " (attendu sous permutation : ",
        round(mean(permMono), 3), ", p = ", signif(pMono, 3), ")")
message("   Noms vernaculaires bruts mono-commune : ",
        round(propMonoNomsObs, 3), " (attendu : ",
        round(mean(permMonoNoms), 3), ", p = ", signif(pMonoNoms, 3),
        ")")

list(
  donnees = d,
  abondances = abondances,
  matAbond = matAbond,
  paires = paires,
  resumeDissim = resumeDissim,
  whittaker = whit,
  betaAdditif = betaAdditif,
  nmds = nmdsRes,
  pointsNMDS = pointsNMDS,
  pairesNiveaux = pairesNiveaux,
  resumeNiveaux = resumeNiveaux,
  pairesGroupe = pairesGroupe,
  resumeGroupe = resumeGroupe,
  tableTests = tableTests,
  tableTestsGroupe = tableTestsGroupe,
  tableTestsJac = tableTestsJac,
  especesParCommune = especesParCommune
)
