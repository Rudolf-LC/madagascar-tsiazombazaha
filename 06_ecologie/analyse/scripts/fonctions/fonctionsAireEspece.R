"
Ewen Le Coeur
2026
Objectif : courbe aire-espece (accumulation de la richesse specifique
en fonction de la surface inventoriee).

Fonctions de calcul uniquement ; la figure et les exports sont dans
analyse_structure.R.
"

# Correspondances taxonomiques : nomNormalise -> identite
# (source : liste_especes_vegetales.csv, reconciliation manuelle)
charger_correspondances <- function(chemin_csv) {
  correspondances <- readr::read_csv(chemin_csv, show_col_types = FALSE) |>
    dplyr::select(nomNormalise, identite) |>
    dplyr::filter(!is.na(identite), str_trim(identite) != "")
  stats::setNames(correspondances$identite, correspondances$nomNormalise)
}

# Applique les correspondances a un vecteur de noms vernaculaires
traduire_especes <- function(noms, correspondances) {
  dplyr::recode(noms, !!!correspondances, .default = noms)
}

# Especes presentes dans chaque placette (une ligne par placette x espece)
calculer_especes_par_placette <- function(d, correspondances) {
  d$flore |>
    mutate(espece = traduire_especes(nomVernaculaire, correspondances)) |>
    filter(!is.na(espece), str_trim(espece) != "") |>
    distinct(cdPlacette, espece)
}

# Richesse specifique par placette
calculer_richesse_par_placette <- function(especesParPlacette) {
  especesParPlacette |>
    group_by(cdPlacette) |>
    summarise(richesse = n_distinct(espece), .groups = "drop")
}

# Courbe aire-espece par permutations aleatoires.
# Pour chaque k de 1 a n placettes : richesse de l'union des especes de
# k placettes tirees au hasard, moyennee sur n_permutations. La surface
# cumulee est la moyenne des surfaces des k placettes tirees.
calculer_courbe_aire_espece <- function(especesParPlacette, surfaces,
                                        n_permutations = 200, graine = 42) {
  jeu <- especesParPlacette |>
    left_join(surfaces, by = "cdPlacette") |>
    filter(!is.na(surfaceHorizontale_m2))
  placettes <- sort(unique(jeu$cdPlacette))
  n <- length(placettes)
  surfaceMoyenne <- mean(surfaces$surfaceHorizontale_m2[surfaces$cdPlacette %in% placettes],
                          na.rm = TRUE)

  set.seed(graine)
  bind_rows(lapply(seq_len(n), function(k) {
    richesses <- replicate(n_permutations, {
      echant <- sample(placettes, k)
      length(unique(jeu$espece[jeu$cdPlacette %in% echant]))
    })
    tibble(
      nbPlacettes = k,
      surface_m2 = surfaceMoyenne * k,
      richesse_moyenne = mean(richesses),
      richesse_ecartType = sd(richesses)
    )
  }))
}
