"
Ewen Le Coeur
2026
Objectif : fonctions de calcul de la diversite alpha (§3.4 du document
d'etape) — nombres de Hill et indice de Fisher, par placette.

Fonctions de calcul uniquement ; l'orchestration, les sorties et les
figures sont dans analyse_diversite.R.

Conventions (validees par l'auteur, double controle R/Python) :
  - ABONDANCES = toutes les tiges comptees : tiges mesurees
    (floreTiges, CBH > 8 cm) + gaulis (tiges < 1,30 m) ;
  - ESPECES = identites re conciliees (liste_especes_vegetales.csv) ;
    chaque observation « espece indeterminee » compte pour une espece
    locale distincte (ind_PXX_OOO) ;
  - INDICES DE HILL (Hill 1973 ; interpretations de Jost 2006) :
      0D = richesse specifique S ;
      1D = exp(Shannon H') = nombre effectif d'especes communes ;
      2D = Simpson inverse corrige (estimateur N(N-1)/Σn(n-1))
           = nombre effectif d'especes dominantes ;
  - ALPHA DE FISHER : resolution numerique (dichotomie) de
      S = alpha * ln(1 + N / alpha)
    (Fisher et al. 1943) ; independant du nombre de tiges comptees.
"

### Abondances ###

# Abondances par placette x espece (tibble : cdPlacette, espece, abondance).
#
# Les tiges mesurees proviennent de floreTiges (une ligne = une tige) ;
# les gaulis sont comptes par observation dans d$flore. Une meme espece
# peut apparaitre dans plusieurs observations d'une placette : les gaulis
# sont donc agreges par espece AVANT la jointure, sinon chaque tige
# mesuree serait dupliquee autant de fois (bug corrige et documente ici).
calculer_abondances <- function(d, correspondances) {
  tigesMesurees <- d$floreTiges |>
    mutate(
      espece = dplyr::recode(nomVernaculaire, !!!correspondances,
                             .default = nomVernaculaire),
      espece = if_else(
        str_to_lower(str_trim(espece)) == "espèce indéterminée",
        paste0("ind_", cdPlacette, "_", cdObs),
        espece
      )
    ) |>
    filter(!is.na(espece), str_trim(espece) != "") |>
    count(cdPlacette, espece, name = "nbMesurees")

  gaulis <- d$flore |>
    mutate(
      espece = dplyr::recode(nomVernaculaire, !!!correspondances,
                             .default = nomVernaculaire),
      espece = if_else(
        str_to_lower(str_trim(espece)) == "espèce indéterminée",
        paste0("ind_", cdPlacette, "_", cdObs),
        espece
      ),
      nbGaulis = replace_na(gaulis, 0)
    ) |>
    filter(!is.na(espece), str_trim(espece) != "") |>
    group_by(cdPlacette, espece) |>
    summarise(nbGaulis = sum(nbGaulis), .groups = "drop")

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

### Indices ###

# Nombres de Hill d'un vecteur d'abondances.
# Retourne : S (richesse), H (Shannon), D1, D2, N (total de tiges).
indices_hill <- function(abondances) {
  abondances <- abondances[abondances > 0]
  S <- length(abondances)
  N <- sum(abondances)
  p <- abondances / N
  H <- -sum(p * log(p))          # Shannon H'
  D1 <- exp(H)                   # 1D
  # 2D : Simpson inverse. Indefini si une seule espece (sommeCarres = 0)
  sommeCarres <- sum(abondances * (abondances - 1))
  D2 <- if (sommeCarres > 0) N * (N - 1) / sommeCarres else NA_real_
  c(S = S, H = H, D1 = D1, D2 = D2, N = N)
}

# Alpha de Fisher : resoudre S = alpha * ln(1 + N/alpha) par dichotomie
# (robuste, aucune dependance externe ; la fonction est croissante en
# alpha, un encadrement large [1e-3 ; 1e6] convient toujours).
alpha_fisher <- function(S, N) {
  if (S <= 1 || N <= 1) return(NA_real_)
  f <- function(a) a * log(1 + N / a) - S
  bas <- 1e-3
  haut <- 1e6
  for (i in 1:200) {
    milieu <- (bas + haut) / 2
    if (f(milieu) > 0) haut <- milieu else bas <- milieu
  }
  (bas + haut) / 2
}

### Table par placette ###

# Tous les indices de diversite alpha, une ligne par placette.
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
