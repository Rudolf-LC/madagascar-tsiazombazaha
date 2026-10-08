"
Ewen Le Coeur
2026
Objectif : fonctions de calcul de la diversite alpha (§3.4 du document
d'etape) — nombres de Hill, indice de Fisher, par placette.

Fonctions de calcul uniquement ; l'orchestration est dans
analyse_diversite.R.

Conventions :
  - les abondances comptent les tiges mesurees ET les gaulis
    (une observation de flore = l'espece + son nombre de tiges) ;
  - l'identite reconciliationnee fait foi (exclusion de l'espece
    indeterminee, taxon fourre-tout) ;
  - indices de Hill : 0D = richesse S ; 1D = exp(Shannon) ;
    2D = Simpson inverse corrige (forme unveighted) ;
  - alpha de Fisher : resolution numerique de
    S = alpha * ln(1 + N / alpha).
"

# Abondances par placette x espece (identites re conciliees).
# Chaque observation de flore represente une espece dans une placette ;
# son abondance = nombre de tiges mesurees (floreTiges, CBH > 8 cm)
#               + nombre de gaulis (colonnes Gaulis).
# Les especes sans tige comptee (presence notee uniquement) comptent 1.
# Exclusion : espece indeterminee (taxon fourre-tout).
calculer_abondances <- function(d, correspondances) {
  tigesMesurees <- d$floreTiges |>
    mutate(espece = dplyr::recode(nomVernaculaire, !!!correspondances,
                                  .default = nomVernaculaire)) |>
    filter(!is.na(espece), str_trim(espece) != "",
           str_to_lower(str_trim(espece)) != "espèce indéterminée") |>
    count(cdPlacette, espece, name = "nbMesurees")

  gaulis <- d$flore |>
    mutate(espece = dplyr::recode(nomVernaculaire, !!!correspondances,
                                  .default = nomVernaculaire)) |>
    filter(!is.na(espece), str_trim(espece) != "",
           str_to_lower(str_trim(espece)) != "espèce indéterminée") |>
    mutate(nbGaulis = replace_na(gaulis, 0)) |>
    select(cdPlacette, espece, nbGaulis)

  full_join(tigesMesurees, gaulis,
            by = c("cdPlacette", "espece")) |>
    mutate(
      nbMesurees = replace_na(nbMesurees, 0),
      nbGaulis = replace_na(nbGaulis, 0),
      abondance = nbMesurees + nbGaulis
    ) |>
    filter(abondance > 0) |>
    select(cdPlacette, espece, abondance)
}

# Indices d'une placette a partir du vecteur d'abondances
indices_hill <- function(abondances) {
  abondances <- abondances[abondances > 0]
  S <- length(abondances)
  N <- sum(abondances)
  p <- abondances / N
  H <- -sum(p * log(p))
  D1 <- exp(H)
  # Simpson inverse, forme corrigee (estimateur unveil)
  sommeCarres <- sum(abondances * (abondances - 1))
  D2 <- if (sommeCarres > 0) N * (N - 1) / sommeCarres else NA_real_
  c(S = S, H = H, D1 = D1, D2 = D2, N = N)
}

# Alpha de Fisher : resoudre S = alpha * ln(1 + N/alpha)
alpha_fisher <- function(S, N) {
  if (S <= 1 || N <= 1) return(NA_real_)
  f <- function(a) a * log(1 + N / a) - S
  # encadrement : alpha dans [1e-3, 1e6]
  bas <- 1e-3
  haut <- 1e6
  # dichotomie (robuste, sans dependance)
  for (i in 1:200) {
    milieu <- (bas + haut) / 2
    if (f(milieu) > 0) haut <- milieu else bas <- milieu
  }
  (bas + haut) / 2
}

# Tous les indices par placette
calculer_diversite_alpha <- function(abondances) {
  abondances |>
    group_by(cdPlacette) |>
    group_modify(~ {
      idx <- indices_hill(.x$abondance)
      tibble(
        S = idx["S"], H = idx["H"], D1 = idx["D1"], D2 = idx["D2"],
        N = idx["N"],
        fisher = alpha_fisher(idx["S"], idx["N"])
      )
    }) |>
    ungroup() |>
    mutate(across(everything(), unname))
}
