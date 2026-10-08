"
Ewen Le Coeur
2026
Objectif : fonctions de calcul de la diversite beta (\u00a73.4 du document
d'etape) \u2014 dissimilarites entre placettes et turnover.

Fonctions de calcul uniquement ; l'orchestration, les sorties et les
figures sont dans analyse_diversite_beta.R.

Conventions (coh\u00e9rentes avec fonctionsDiversite.R, diversite alpha) :
  - ABONDANCES = m\u00eame table que la diversite alpha
    (calculer_abondances : tiges mesurees + gaulis) ;
  - ESPECES = identites reconciliees ; chaque observation
    \u00ab espece indeterminee \u00bb compte pour une espece locale distincte
    (ind_PXX_OOO), donc deux placettes ne partagent jamais leurs
    indeterminees ;
  - DISSIMILARITES (Legendre & Legendre 2012) :
      Jaccard  : b / (a + b + c)  (presence-absence) ;
      Sorensen : b / (2a + b)     (presence-absence) ;
      Bray-Curtis : somme |y1i - y2i| / somme (y1i + y2i) (abondances) ;
    avec a = especes communes, b = especes propres a la placette 1,
    c = especes propres a la placette 2 (b et c symetrises pour Jaccard).
  - BETA DE WHITTAKER (1960) : beta = gamma / alpha_moyen - 1,
    calcule sur les presences-absences (multiplicatif).
"

### Table especes x placettes ###

# Matrice d'abondances (placettes en lignes, especes en colonnes)
# a partir de la table longue de calculer_abondances.
matrice_abondances <- function(abondances) {
  abondances |>
    tidyr::pivot_wider(
      names_from = espece,
      values_from = abondance,
      values_fill = 0
    ) |>
    tibble::column_to_rownames("cdPlacette") |>
    as.matrix()
}

### Dissimilarites entre deux placettes ###

# Statistiques de base entre deux vecteurs d'abondances :
# a = especes communes, b = especes presentes seulement dans x,
# c = especes presentes seulement dans y, N1/N2 = totaux de tiges.
stats_paires <- function(x, y) {
  px <- x > 0
  py <- y > 0
  c(
    a = sum(px & py),
    b = sum(px & !py),
    c = sum(!px & py),
    N1 = sum(x),
    N2 = sum(y)
  )
}

# Jaccard (presence-absence) : (b + c) / (a + b + c).
jaccard <- function(x, y) {
  s <- stats_paires(x, y)
  denom <- s["a"] + s["b"] + s["c"]
  if (denom == 0) return(NA_real_)
  (s["b"] + s["c"]) / denom
}

# Sorensen (presence-absence) : (b + c) / (2a + b + c).
sorensen <- function(x, y) {
  s <- stats_paires(x, y)
  denom <- 2 * s["a"] + s["b"] + s["c"]
  if (denom == 0) return(NA_real_)
  (s["b"] + s["c"]) / denom
}

# Bray-Curtis (abondances) : somme |x - y| / somme (x + y).
bray_curtis <- function(x, y) {
  denom <- sum(x) + sum(y)
  if (denom == 0) return(NA_real_)
  sum(abs(x - y)) / denom
}

### Matrices de dissimilarite ###

# Matrice carree placettes x placettes pour une mesure donnee
# (jaccard, sorensen ou bray_curtis).
matrice_dissimilarite <- function(matAbond, mesure = jaccard) {
  n <- nrow(matAbond)
  M <- matrix(NA_real_, nrow = n, ncol = n,
              dimnames = list(rownames(matAbond), rownames(matAbond)))
  for (i in seq_len(n)) {
    for (j in seq_len(n)) {
      if (i == j) {
        M[i, j] <- 0
      } else if (j > i) {
        M[i, j] <- M[j, i] <- mesure(matAbond[i, ], matAbond[j, ])
      }
    }
  }
  M
}

### Table longue des paires ###

# Une ligne par paire de placettes (i < j) : statistiques a, b, c
# et les trois dissimilarites.
table_paires <- function(matAbond) {
  n <- nrow(matAbond)
  noms <- rownames(matAbond)
  res <- NULL
  for (i in seq_len(n - 1)) {
    for (j in (i + 1):n) {
      s <- stats_paires(matAbond[i, ], matAbond[j, ])
      res <- rbind(res, data.frame(
        placette1 = noms[i],
        placette2 = noms[j],
        especesCommunes = s["a"],
        uniquesP1 = s["b"],
        uniquesP2 = s["c"],
        tigesP1 = s["N1"],
        tigesP2 = s["N2"],
        jaccard = jaccard(matAbond[i, ], matAbond[j, ]),
        sorensen = sorensen(matAbond[i, ], matAbond[j, ]),
        brayCurtis = bray_curtis(matAbond[i, ], matAbond[j, ])
      ))
    }
  }
  tibble::as_tibble(res)
}

### Beta de Whittaker (multiplicatif, presence-absence) ###

# beta = gamma / alpha_moyen - 1, avec alpha_moyen = richesse moyenne
# des placettes et gamma = richesse totale du jeu de donnees.
whittaker_beta <- function(matAbond) {
  alphaMoyen <- mean(rowSums(matAbond > 0))
  gamma <- sum(colSums(matAbond > 0) > 0)
  list(
    alphaMoyen = alphaMoyen,
    gamma = gamma,
    beta = gamma / alphaMoyen - 1
  )
}
