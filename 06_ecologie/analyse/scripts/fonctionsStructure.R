"
Ewen Le Coeur
2026
Objectif : fonctions de calcul des indices de structure forestiere
(densite N, classes de diametre, surface terriere G) — document d'etape §3.2,
Memento du forestier tropical (Mille & Louppe 2015).

Ce script ne contient QUE des fonctions : pas d'effet de bord, pas de
lecture de fichier, pas de sortie. Les analyses et figures sont dans
analyse_structure.R ; l'import des donnees dans importDonnees.R.

Conventions documentees :
  - gaulis = tiges < 1,30 m, non mesures : comptes dans N, exclus de G
  - les indices sont rapportes a la surface horizontale des placettes
  - les classes de diametre ont une largeur de 2,5 cm ; la classe 0-2,5
    regroupe les tiges mesurees de DBH < 2,5 cm ET les gaulis
"

### Preparation ###

# DBH et classe de diametre pour chaque tige meseree
preparer_tiges <- function(d) {
  d$floreTiges |>
    mutate(
      dbh_cm = circ_cm / pi,
      classeDiam = floor(dbh_cm / 2.5) * 2.5
    )
}

# Gaulis comptes par placette
compter_gaulis <- function(d) {
  d$flore |>
    filter(!is.na(gaulis)) |>
    group_by(cdPlacette) |>
    summarise(nbGaulis = sum(gaulis), .groups = "drop")
}

### Densite N ###

# N total du dispositif (tiges mesurees + gaulis)
calculer_N_total <- function(tiges, gaulis) {
  nrow(tiges) + sum(gaulis$nbGaulis)
}

# Indices de densite par placette (brut, /m2, /ha)
calculer_N_par_placette <- function(d, tiges, gaulis) {
  tigesParPlacette <- tiges |>
    count(cdPlacette, name = "nbTiges")
  d$placettes |>
    select(cdPlacette, surfaceHorizontale_m2) |>
    left_join(tigesParPlacette, by = "cdPlacette") |>
    left_join(gaulis, by = "cdPlacette") |>
    mutate(
      nbTiges = replace_na(nbTiges, 0),
      nbGaulis = replace_na(nbGaulis, 0),
      nbTigesBrut = nbTiges + nbGaulis,
      N_m2 = nbTigesBrut / surfaceHorizontale_m2,
      N_ha = N_m2 * 10000
    )
}

# Effectifs par classe de diametre (dispositif), gaulis en 0-2,5
calculer_classes_diametre <- function(tiges, gaulis, surfaceTotale) {
  nbMesurees <- nrow(tiges)
  nbGaulis <- sum(gaulis$nbGaulis)
  tiges |>
    count(classeDiam, name = "effectifTotal") |>
    right_join(
      tibble(classeDiam = seq(0, max(tiges$classeDiam, na.rm = TRUE), by = 2.5)),
      by = "classeDiam"
    ) |>
    mutate(effectifTotal = replace_na(effectifTotal, 0)) |>
    arrange(classeDiam) |>
    mutate(
      effectifTotal = if_else(classeDiam == 0,
                             effectifTotal + nbGaulis, effectifTotal),
      N_ha = effectifTotal / surfaceTotale * 10000,
      borneInf = classeDiam,
      borneSup = classeDiam + 2.5,
      frequence = effectifTotal / (nbMesurees + nbGaulis)
    )
}

# Densite par classe et par placette : moyenne et IC 95 % entre placettes.
# Chaque placette compte 0 dans les classes sans tige (grille complete).
calculer_classes_IC95 <- function(d, tiges, gaulis) {
  surfacesPlacettes <- d$placettes |>
    select(cdPlacette, surfaceHorizontale_m2)
  densiteClassePlacette <- tiges |>
    mutate(classeDiam = if_else(dbh_cm < 2.5, 0, classeDiam)) |>
    count(cdPlacette, classeDiam, name = "effectif") |>
    bind_rows(gaulis |> transmute(cdPlacette, classeDiam = 0, effectif = nbGaulis)) |>
    left_join(surfacesPlacettes, by = "cdPlacette") |>
    mutate(N_ha_placette = effectif / surfaceHorizontale_m2 * 10000) |>
    select(cdPlacette, classeDiam, N_ha_placette)
  toutesClasses <- tidyr::expand_grid(
    cdPlacette = d$placettes$cdPlacette,
    classeDiam = sort(unique(c(tiges$classeDiam, 0)))
  ) |>
    left_join(densiteClassePlacette, by = c("cdPlacette", "classeDiam")) |>
    replace_na(list(N_ha_placette = 0))
  toutesClasses |>
    group_by(classeDiam) |>
    group_modify(~ {
      v <- .x$N_ha_placette
      n <- length(v)
      demi <- qt(0.975, max(n - 1, 1)) * sd(v) / sqrt(n)
      tibble(moyenne_ha = mean(v), ic95_bas = mean(v) - demi,
             ic95_haut = mean(v) + demi)
    }) |>
    ungroup()
}

### Surface terriere G ###

# G par placette et a l'hectare (tiges mesurees uniquement)
calculer_G_par_placette <- function(tiges) {
  tiges |>
    group_by(cdPlacette) |>
    summarise(
      G_m2 = sum(pi / 4 * (dbh_cm / 100)^2),
      nbTiges = n(),
      .groups = "drop"
    )
}

# Moyenne, ecart-type et IC 95 % d'un vecteur (entre placettes)
resumer <- function(valeurs) {
  n <- length(valeurs)
  demiLargeur <- qt(0.975, n - 1) * sd(valeurs) / sqrt(n)
  c(moyenne = mean(valeurs), ecartType = sd(valeurs),
    ic95_bas = mean(valeurs) - demiLargeur, ic95_haut = mean(valeurs) + demiLargeur)
}
