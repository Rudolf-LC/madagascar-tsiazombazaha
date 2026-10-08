"
Ewen Le Coeur
2026
Objectif : diversite beta (\u00a73.4 du document d'etape) \u2014 dissimilarites
entre placettes (Jaccard, Sorensen, Bray-Curtis), beta de Whittaker,
figure et exports.

Structure du code :
  - importDonnees.R        : import et nettoyage (socle)
  - fonctionsDiversite.R   : calculer_abondances (partage avec l'alpha)
  - fonctionsDiversiteBeta.R : fonctions de calcul (matrices, paires)
  - analyse_diversite_beta.R : CE SCRIPT \u2014 orchestration, figure, sorties

Utilisation :
  source(\"06_ecologie/analyse/scripts/analyse_diversite_beta.R\")
"

source("06_ecologie/analyse/scripts/importDonnees.R")
source("06_ecologie/analyse/scripts/fonctionsDiversite.R")
source("06_ecologie/analyse/scripts/fonctionsDiversiteBeta.R")

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("scales", quietly = TRUE)) install.packages("scales")
if (!requireNamespace("vegan", quietly = TRUE)) install.packages("vegan")
library(ggplot2)
library(scales)
library(vegan)

d <- importer_donnees()

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

# Correspondances taxonomiques (reconciliation manuelle)
reconciliation <- readr::read_csv(
  file.path(dossierSorties, "liste_especes_vegetales.csv"),
  show_col_types = FALSE) |>
  dplyr::filter(!is.na(identite), str_trim(identite) != "")
correspondances <- stats::setNames(reconciliation$identite,
                                   reconciliation$nomNormalise)

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
                                   shape = cdTransect,
                                   colour = cdTransect)) +
  geom_point(size = 2.5) +
  scale_shape_manual(values = formes) +
  geom_text_repel(aes(label = cdPlacette), size = 2.5,
                  min.segment.length = 0, show.legend = FALSE) +
  labs(
    title = "NMDS des placettes (dissimilarite de Bray-Curtis)",
    subtitle = paste0("Stress : ", round(nmdsRes$stress, 3),
                      " (k = 2, ", nrow(matAbond), " placettes)"),
    x = "NMDS 1", y = "NMDS 2"
  ) +
  theme_axes

ggsave(file.path(dossierSorties, "diversite_beta_nmds.png"),
       figNMDS, width = 14, height = 12, units = "cm", dpi = 300)

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
      transect1 == transect2 ~ "Meme transect",
      polisnala1 == polisnala2 ~ "Meme polisn'ala",
      commune1 == commune2 ~ "Meme commune",
      TRUE ~ "Communes differentes"
    ),
    niveau = factor(niveau, levels = c(
      "Meme transect", "Meme polisn'ala", "Meme commune",
      "Communes differentes"))
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

figNiveaux <- ggplot(pairesNiveaux,
                     aes(x = niveau, y = brayCurtis, fill = niveau)) +
  geom_boxplot(show.legend = FALSE, linewidth = 0.3) +
  labs(
    title = "Dissimilarite de Bray-Curtis selon le niveau geographique",
    subtitle = "Paires de placettes : meme transect, meme polisn'ala, meme commune ou communes differentes",
    x = NULL,
    y = "Bray-Curtis"
  ) +
  theme_axes +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

ggsave(file.path(dossierSorties, "diversite_beta_bray_niveaux.png"),
       figNiveaux, width = 16, height = 12, units = "cm", dpi = 300)

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
      transect1 == transect2 ~ "Meme transect",
      polisnala1 == polisnala2 ~ "Meme polisn'ala",
      commune1 == commune2 ~ "Meme commune",
      groupe1 == groupe2 ~ "Meme groupe (Andriana/Mizilo)",
      TRUE ~ "Ambahatrazo vs autres"
    ),
    niveauGroupe = factor(niveauGroupe, levels = c(
      "Meme transect", "Meme polisn'ala", "Meme commune",
      "Meme groupe (Andriana/Mizilo)", "Ambahatrazo vs autres"))
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

figGroupe <- ggplot(pairesGroupe,
                    aes(x = niveauGroupe, y = brayCurtis,
                        fill = niveauGroupe)) +
  geom_boxplot(show.legend = FALSE, linewidth = 0.3) +
  labs(
    title = "Bray-Curtis selon le niveau (Andriana/Mizilo regroupes)",
    subtitle = paste0("Kruskal-Wallis p = ",
                      signif(testKWGroupe$p.value, 3)),
    x = NULL, y = "Bray-Curtis"
  ) +
  theme_axes +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

ggsave(file.path(dossierSorties, "diversite_beta_bray_groupes.png"),
       figGroupe, width = 16, height = 12, units = "cm", dpi = 300)

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

### Messages ###

message("\u2705 Diversit\u00e9 beta (\u00a73.4) \u2014 ", nrow(matAbond),
        " placettes, ", ncol(matAbond), " esp\u00e8ces :")
for (i in seq_len(nrow(resumeDissim))) {
  r <- resumeDissim[i, ]
  message("   ", r$indice, " : ", r$moyenne, " \u00b1 ", r$ecartType)
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
  especesParCommune = especesParCommune
)
