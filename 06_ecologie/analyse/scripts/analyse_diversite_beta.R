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
library(ggplot2)
library(scales)

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

resumeDissim <- bind_rows(
  tibble(indice = "Jaccard (presences)",
         moyenne = mean(paires$jaccard), ecartType = sd(paires$jaccard)),
  tibble(indice = "Sorensen (presences)",
         moyenne = mean(paires$sorensen), ecartType = sd(paires$sorensen)),
  tibble(indice = "Bray-Curtis (abondances)",
         moyenne = mean(paires$brayCurtis), ecartType = sd(paires$brayCurtis))
) |>
  dplyr::mutate(across(where(is.numeric), ~ round(.x, 3)))

### Beta de Whittaker ###

whit <- whittaker_beta(matAbond)

### Figure : histogramme des dissimilarites Jaccard ###

if (!exists("theme_axes")) {
  theme_axes <- ggplot2::theme_minimal() +
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
}

figDissim <- ggplot(paires, aes(x = jaccard)) +
  geom_histogram(binwidth = 0.05, boundary = 0,
                fill = "grey40", color = "white") +
  scale_x_continuous(breaks = seq(0, 1, by = 0.1),
                     labels = scales::number_format(accuracy = 0.1)) +
  labs(
    title = "Dissimilarit\u00e9 de Jaccard entre paires de placettes",
    subtitle = paste0(nrow(paires), " paires \u2014 moyenne ",
                      round(mean(paires$jaccard), 3)),
    x = "Jaccard (0 = placettes identiques, 1 = aucune esp\u00e8ce commune)",
    y = "Nombre de paires"
  ) +
  theme_axes

ggsave(file.path(dossierSorties, "diversite_beta_jaccard_histogramme.png"),
       figDissim, width = 14, height = 10, units = "cm", dpi = 300)

### Figure : clustering des placettes (Jaccard, lien moyen) ###

distJaccard <- stats::as.dist(matrice_dissimilarite(matAbond, jaccard))
arbre <- stats::hclust(distJaccard, method = "average")

# Dendrogramme redessine en ggplot depuis l'arbre de hclust
# (aucune dependance externe supplementaire).
coords_fusion <- function(arbre) {
  n <- length(arbre$height)
  labelsOrdonnes <- arbre$labels[arbre$order]
  positions <- stats::setNames(seq_along(labelsOrdonnes), labelsOrdonnes)
  membres <- stats::setNames(seq_along(arbre$labels), arbre$labels)
  segments <- vector("list", 2 * n)
  for (k in seq_len(n)) {
    fusion <- arbre$merge[k, ]
    pts <- lapply(fusion, function(f) {
      if (f < 0) {
        lbl <- arbre$labels[-f]
        list(x = positions[[lbl]], bas = 0)
      } else {
        list(x = membres[[as.character(f)]], bas = arbre$height[f])
      }
    })
    haut <- arbre$height[k]
    segments[[2 * k - 1]] <- data.frame(
      x = pts[[1]]$x, y = c(pts[[1]]$bas, haut), groupe = k)
    segments[[2 * k]] <- data.frame(
      x = pts[[2]]$x, y = c(pts[[2]]$bas, haut), groupe = k)
    membres[[as.character(k)]] <- mean(c(pts[[1]]$x, pts[[2]]$x))
  }
  dplyr::bind_rows(segments)
}

# Lignes horizontales de chaque fusion (hauteur k) entre les deux
# sous-arbres : (x1, h) -> (x2, h).
fusions_h <- function(arbre) {
  n <- length(arbre$height)
  labelsOrdonnes <- arbre$labels[arbre$order]
  positions <- stats::setNames(seq_along(labelsOrdonnes), labelsOrdonnes)
  membres <- stats::setNames(seq_along(arbre$labels), arbre$labels)
  res <- vector("list", n)
  for (k in seq_len(n)) {
    fusion <- arbre$merge[k, ]
    xs <- vapply(fusion, function(f) {
      if (f < 0) positions[[arbre$labels[-f]]] else membres[[as.character(f)]]
    }, numeric(1))
    res[[k]] <- data.frame(
      x = min(xs), xend = max(xs), y = arbre$height[k], groupe = k)
    membres[[as.character(k)]] <- mean(xs)
  }
  dplyr::bind_rows(res)
}

segVert <- coords_fusion(arbre)
segHori <- fusions_h(arbre)

figDendrogramme <- ggplot() +
  geom_segment(data = segVert,
               aes(x = x, xend = x, y = y, yend = 0, group = groupe)) +
  geom_segment(data = segHori,
               aes(x = x, xend = xend, y = y, yend = y, group = groupe)) +
  scale_x_continuous(breaks = seq_along(arbre$labels[arbre$order]),
                     labels = arbre$labels[arbre$order],
                     expand = expansion(add = 0.6)) +
  labs(
    title = "Regroupement des placettes (Jaccard, lien moyen)",
    subtitle = "Deux placettes sont d'autant plus proches qu'elles partagent d'especes",
    x = NULL, y = "Dissimilarite de Jaccard"
  ) +
  theme_axes

ggsave(file.path(dossierSorties, "diversite_beta_dendrogramme.png"),
       figDendrogramme, width = 14, height = 12, units = "cm", dpi = 300)

### Exports ###

readr::write_csv(paires,
                 file.path(dossierSorties, "diversite_beta_paires.csv"))
readr::write_csv(resumeDissim,
                 file.path(dossierSorties, "diversite_beta_resume.csv"))
readr::write_csv(tibble::tibble(
  alphaMoyen = whit$alphaMoyen,
  gamma = whit$gamma,
  betaWhittaker = whit$beta
) |> dplyr::mutate(across(where(is.numeric), ~ round(.x, 2))),
file.path(dossierSorties, "diversite_beta_whittaker.csv"))

### Messages ###

message("\u2705 Diversit\u00e9 beta (\u00a73.4) \u2014 ", nrow(matAbond),
        " placettes, ", ncol(matAbond), " esp\u00e8ces :")
for (i in seq_len(nrow(resumeDissim))) {
  r <- resumeDissim[i, ]
  message("   ", r$indice, " : ", r$moyenne, " \u00b1 ", r$ecartType)
}
message("   Beta de Whittaker : ", round(whit$beta, 2),
        " (alpha moyen ", round(whit$alphaMoyen, 1),
        ", gamma ", whit$gamma, ")")

list(
  donnees = d,
  abondances = abondances,
  matAbond = matAbond,
  paires = paires,
  resumeDissim = resumeDissim,
  whittaker = whit
)
