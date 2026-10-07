"
Ewen Le Coeur
2026
Objectif : calculs des indices écologiques

Ce script traite la STRUCTURE FORESTIÈRE (document d'étape §3.2,
Mémento du forestier tropical, Mille & Louppe 2015) :
  - Densité N (tiges/ha), gaulis inclus
  - Distribution des effectifs par classe de diamètre (largeur 2,5 cm)
  - Surface terrière G (m²/ha)
à l'échelle du dispositif ET par placette (moyenne ± écart-type).

Reste à traiter dans ce script (sections du document d'étape) :
  - chablis/ha et arbres DBH>40 /ha (transects, §3.2)
  - stock de carbone AGB/BGB Chave (§3.3)
  - volume de bois mort (Van Wagner) (§3.3)
  - diversité alpha (Shannon, Simpson, Fisher) (§3.4)
  - IVI (§3.6)

Utilisation :
  source(\"06_ecologie/analyse/scripts/calcIndices.R\")
"

### Modules ###

if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("stringr", quietly = TRUE)) install.packages("stringr")
if (!requireNamespace("readr", quietly = TRUE)) install.packages("readr")

library(dplyr)
library(tidyr)
library(stringr)
library(readr)

source("06_ecologie/analyse/scripts/importDonnees.R")
d <- importer_donnees()

### Préparation des tiges ###

# Tiges mesurées (CBH > 8 cm) : floreTiges.
# Gaulis (tiges < 1,30 m) : non mesurés — comptés dans la densité,
# exclus de la surface terrière (pas de CBH).
# La surface terrière se rapporte à la surface horizontale.
tiges <- d$floreTiges |>
  mutate(
    dbh_cm = circ_cm / pi,
    classeDiam = floor(dbh_cm / 2.5) * 2.5
  )

gaulis <- d$flore |>
  filter(!is.na(gaulis)) |>
  group_by(cdPlacette) |>
  summarise(nbGaulis = sum(gaulis), .groups = "drop")

### Surfaces ###

surfaceTotale <- sum(d$placettes$surfaceHorizontale_m2, na.rm = TRUE)
message("Surface inventoriée (horizontale) : ", round(surfaceTotale, 1),
        " m² sur ", nrow(d$placettes), " placettes")

### Densité N ###

nbTigesMesurees <- nrow(tiges)
nbGaulis <- sum(gaulis$nbGaulis)
densite <- (nbTigesMesurees + nbGaulis) / surfaceTotale * 10000

densite_dispositif <- tibble(
  indicateur = "Densité N (tiges/ha)",
  tigesMesurees = nbTigesMesurees,
  gaulis = nbGaulis,
  valeur = densite
)

### Surface terrière G ###

# G = somme des sections à hauteur de poitrine = pi/4 * DHP²
g_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(G_m2 = sum(pi / 4 * (dbh_cm / 100)^2), nbTiges = n(), .groups = "drop")

surfaceTerriere <- sum(g_par_placette$G_m2)
G_ha <- surfaceTerriere / surfaceTotale * 10000

surfaceTerriere_dispositif <- tibble(
  indicateur = "Surface terrière G (m²/ha)",
  valeur = G_ha
)

### Indices par placette : moyenne et écart-type ###

placettesIndices <- d$placettes |>
  select(cdPlacette, surfaceHorizontale_m2) |>
  left_join(g_par_placette, by = "cdPlacette") |>
  left_join(gaulis, by = "cdPlacette") |>
  mutate(
    nbGaulis = replace_na(nbGaulis, 0),
    nbTiges = replace_na(nbTiges, 0),
    densitePlacette = (nbTiges + nbGaulis) / surfaceHorizontale_m2 * 10000,
    GhaPlacette = replace_na(G_m2, 0) / surfaceHorizontale_m2 * 10000
  )

# resume par placette : moyenne ± ecart-type et IC 95 % de chaque indice
resumer <- function(valeurs) {
  n <- length(valeurs)
  demiLargeur <- qt(0.975, n - 1) * sd(valeurs) / sqrt(n)
  c(moyenne = mean(valeurs), ecartType = sd(valeurs),
    ic95_bas = mean(valeurs) - demiLargeur, ic95_haut = mean(valeurs) + demiLargeur)
}

surfacesPlacettes <- d$placettes |>
  select(cdPlacette, surfaceHorizontale_m2)

indicesParPlacette <- placettesIndices |>
  select(cdPlacette, nbTiges, nbGaulis, densitePlacette, GhaPlacette) |>
  left_join(surfacesPlacettes, by = "cdPlacette") |>
  left_join(agb_par_placette, by = "cdPlacette") |>
  mutate(
    nbTigesBrut = nbTiges + nbGaulis,
    densite_m2 = nbTigesBrut / surfaceHorizontale_m2,
    AGBhaPlacette = replace_na(AGB_kg, 0) / 1000 / surfaceHorizontale_m2 * 10000,
    CO2haPlacette = 2.06988 * AGBhaPlacette
  )

resume_placettes <- bind_rows(
  resumer(indicesParPlacette$nbTigesBrut) |> t() |> as_tibble() |>
    mutate(indice = "N brut par placette (tiges)"),
  resumer(indicesParPlacette$densite_m2) |> t() |> as_tibble() |>
    mutate(indice = "N (tiges/m2)"),
  resumer(indicesParPlacette$densitePlacette) |> t() |> as_tibble() |>
    mutate(indice = "N (tiges/ha)"),
  resumer(indicesParPlacette$GhaPlacette) |> t() |> as_tibble() |>
    mutate(indice = "G (m2/ha)"),
  resumer(indicesParPlacette$AGBhaPlacette) |> t() |> as_tibble() |>
    mutate(indice = "AGB (tMS/ha)"),
  resumer(indicesParPlacette$CO2haPlacette) |> t() |> as_tibble() |>
    mutate(indice = "CO2 vivant (tCO2/ha)")
) |>
  mutate(nbPlacettes = nrow(indicesParPlacette)) |>
  select(indice, moyenne, ecartType, ic95_bas, ic95_haut, nbPlacettes) |>
  mutate(across(where(is.numeric), ~ round(.x, 2)))

### Courbe N par classe de diamètre ###

# Distribution des tiges mesurées par classe de diamètre (largeur 2,5 cm),
# en effectif total du dispositif et en densité à l'hectare (placettes).
# Les classes vides sont incluses pour une courbe régulière.
# N.B. : les gaulis (non mesurés) n'entrent pas dans cette distribution ;
# les grands arbres des transects (DBH > 40 cm) pourront être ajoutés
# dans une seconde courbe une fois les longueurs de prospection saisies.

# N.B. : la classe 0-2,5 cm regroupe les tiges mesurees de DBH < 2,5 cm
# ET les gaulis (tiges non mesurees, par convention DBH < 2,5 cm).
# Total de la courbe = toutes les tiges inventoriees (mesurees + gaulis).
nbTigesMesurees <- nrow(tiges)
nbGaulisTotal <- sum(gaulis$nbGaulis)

courbeClasses <- tiges |>
  count(classeDiam, name = "effectifTotal") |>
  right_join(
    tibble(classeDiam = seq(0, max(tiges$classeDiam, na.rm = TRUE), by = 2.5)),
    by = "classeDiam"
  ) |>
  mutate(effectifTotal = replace_na(effectifTotal, 0)) |>
  arrange(classeDiam) |>
  mutate(
    effectifTotal = if_else(classeDiam == 0,
                           effectifTotal + nbGaulisTotal, effectifTotal),
    densite_ha = effectifTotal / surfaceTotale * 10000,
    borneInf = classeDiam,
    borneSup = classeDiam + 2.5,
    frequence = effectifTotal / (nbTigesMesurees + nbGaulisTotal)
  )

# Densite par classe et par placette : moyenne et IC 95 % entre placettes
densiteClassePlacette <- tiges |>
  mutate(classeDiam = if_else(dbh_cm < 2.5, 0, classeDiam)) |>
  count(cdPlacette, classeDiam, name = "effectif") |>
  bind_rows(
    gaulis |>
      transmute(cdPlacette, classeDiam = 0, effectif = nbGaulis)
  ) |>
  left_join(surfacesPlacettes, by = "cdPlacette") |>
  mutate(densite_ha_placette = effectif / surfaceHorizontale_m2 * 10000) |>
  select(cdPlacette, classeDiam, densite_ha_placette)

# Completer avec des zeros : une placette sans tige dans une classe
# contribue 0 a cette classe (indispensable pour l'IC entre placettes).
# La classe 0 n'a pas d'observation pour les placettes sans gaulis comptes :
# completer avec des zeros pour toutes les placettes.
toutesClasses <- tidyr::expand_grid(
  cdPlacette = d$placettes$cdPlacette,
  classeDiam = sort(unique(c(tiges$classeDiam, 0)))
) |>
  left_join(densiteClassePlacette, by = c("cdPlacette", "classeDiam")) |>
  replace_na(list(densite_ha_placette = 0))

classesIC95 <- toutesClasses |>
  group_by(classeDiam) |>
  group_modify(~ {
    v <- .x$densite_ha_placette
    n <- length(v)
    demi <- qt(0.975, max(n - 1, 1)) * sd(v) / sqrt(n)
    tibble(moyenne_ha = mean(v), ic95_bas = mean(v) - demi,
           ic95_haut = mean(v) + demi)
  }) |>
  ungroup() |>
  mutate(
    borneInf = classeDiam,
    borneSup = classeDiam + 2.5,
    effectifTotalDispositif = courbeClasses$effectifTotal[
      match(classeDiam, courbeClasses$classeDiam)]
  )

### Figure : histogramme des classes de diametre avec IC 95 % ###

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("scales", quietly = TRUE)) install.packages("scales")
library(ggplot2)
library(scales)

# Rigueur statistique : l'IC reel est toujours affiche. Si sa borne
# inferieure descend sous 0 (possible : t de Student sur effectifs rares),
# la barre s'arrete a 0 et l'etiquette montre l'IC reel non tronque.
# Echelle : symetrique en log (symlog), lineaire autour de zero puis
# logarithmique au-dessus, pour que les barres descendant a 0 soient
# representables
# tout en gardant la lisibilite log sur les grands effectifs.
# Classes de moyenne nulle : ecartees de la figure (non representables
# en symlog), mais presentes dans les tableaux.

trans_symlog <- scales::trans_new(
  name = "symlog",
  transform = function(y) sign(y) * log10(1 + abs(y) / 10),
  inverse = function(t) sign(t) * 10 * (10^abs(t) - 1)
)
# avec le facteur 10 : y = 10 -> t = log10(2) ; graduations propres via
# breaks manuels ci-dessous

classesFigure <- classesIC95 |>
  filter(moyenne_ha > 0)

etiquettes <- classesFigure |>
  mutate(
    etiquette = paste0(
      format(moyenne_ha, digits = 3, trim = TRUE),
      " [", format(round(ic95_bas), trim = TRUE), " ; ",
      format(round(ic95_haut), trim = TRUE), "]"
    )
  )

bornesY <- sort(unique(c(0,
  classesFigure$ic95_haut[classesFigure$ic95_haut > 0],
  classesFigure$ic95_bas[classesFigure$ic95_bas > 0])))

figureClasses <- ggplot(classesFigure, aes(x = classeDiam + 1.25, y = moyenne_ha)) +
  geom_col(width = 2.5, fill = "grey70", color = "grey30") +
  geom_errorbar(aes(ymin = pmax(ic95_bas, 0),
                    ymax = ic95_haut),
                width = 1.2, linewidth = 0.4) +
  geom_smooth(method = "loess", se = FALSE, color = "darkred", linewidth = 0.8) +
  geom_text(data = etiquettes,
            aes(x = classeDiam + 1.25,
                y = ic95_haut * 1.10,
                label = etiquette),
            angle = 90, vjust = 0.5, hjust = 0, size = 2.4) +
  scale_y_continuous(
    trans = trans_symlog,
    breaks = c(0, 10, 100, 1000, 10000, 30000),
    labels = scales::label_comma()
  ) +
  scale_x_continuous(breaks = seq(0, max(classesFigure$borneSup), by = 2.5)) +
  labs(
    x = "Classe de diametre (cm, bornes)",
    y = "Densite moyenne (tiges/ha, echelle symlog)",
    title = "Distribution des tiges par classe de diametre",
    subtitle = "Moyenne par placette, barres : IC 95 % reel (tronque a 0), courbe : loess"
  ) +
  theme_minimal()

ggsave(file.path(dossierSorties, "structure_histogramme_classes.png"),
       figureClasses, width = 20, height = 12, units = "cm", dpi = 300)
message("   Figure : structure_histogramme_classes.png")

# Figure en effectifs bruts : nombre de tiges comptées par classe (tiges/cd)
# (meme presentation, echelle lineaire — les effectifs bruts restent lisibles)
figureClassesBrut <- ggplot(courbeClasses, aes(x = classeDiam + 1.25, y = effectifTotal)) +
  geom_col(width = 2.5, fill = "grey70", color = "grey30") +
  geom_text(aes(label = effectifTotal), vjust = -0.3, size = 3) +
  scale_x_continuous(breaks = seq(0, max(courbeClasses$borneSup), by = 2.5)) +
  labs(
    x = "Classe de diamètre (cm, bornes)",
    y = "Tiges comptées (effectif)",
    title = "Effectifs par classe de diamètre",
    subtitle = "Nombre de tiges comptées dans le dispositif (gaulis en 0–2,5)"
  ) +
  theme_minimal()

ggsave(file.path(dossierSorties, "structure_histogramme_classes_brut.png"),
       figureClassesBrut, width = 20, height = 12, units = "cm", dpi = 300)
message("   Figure : structure_histogramme_classes_brut.png")

# Tableau recapitulatif des indices : export CSV
write_csv(resume_placettes, file.path(dossierSorties, "structure_resume_indices.csv"))

### Indicateurs des transects : grands arbres DBH > 40 et chablis ###

# N.B. conventions (document d'étape §3.2) :
#  - largeur de prospection : 10 m -> surface = longueur x 10
#  - la feuille "transects" mélange longueurs (m) et réponses Oui/Non
#    selon que la prospection a eu lieu ; seules les valeurs numériques
#    sont des longueurs exploitables. Les transects sans longueur
#    renseignée sont exclus et signalés.

longueurTotaleTransects <- sum(d$transects$longueurGA, na.rm = TRUE)
surfaceTransects_m2 <- longueurTotaleTransects * 10

transectsSansLongueur <- d$transects |>
  filter(is.na(longueurGA)) |>
  pull(cdTransect)
if (length(transectsSansLongueur) > 0) {
  message("⚠️  Transects sans longueur de prospection exploitables : ",
          paste(transectsSansLongueur, collapse = ", "),
          " — exclus des calculs à l'hectare.")
}

# Nombre de grands arbres (DBH > 40 cm) a l'hectare
grandsArbresValides <- d$grandsArbres |>
  filter(cdTransect %in% d$transects$cdTransect[!is.na(d$transects$longueurGA)])

nbGrandsArbres <- nrow(grandsArbresValides)
densiteGrandsArbres <- nbGrandsArbres / surfaceTransects_m2 * 10000

grandsArbresDispositif <- tibble(
  indicateur = "Grands arbres DBH>40 (arbres/ha)",
  valeur = densiteGrandsArbres
)

# Surface terriere des grands arbres a l'hectare
GgrandsArbres <- grandsArbresValides |>
  summarise(G_m2 = sum(pi / 4 * (circ_cm / pi / 100)^2, na.rm = TRUE)) |>
  pull(G_m2)
GgrandsArbres_ha <- GgrandsArbres / surfaceTransects_m2 * 10000

# Chablis a l'hectare
# Convention : seuls les transects avec prospection chablis attestée
# (prospChablis == TRUE) sont comptés ; les longueurs correspondantes
# ne sont pas renseignées dans le fichier -> a completer.
chablisValides <- d$chablis
nbChablis <- sum(chablisValides$nombre, na.rm = TRUE)
transectsChablis <- d$transects |>
  filter(prospChablis == TRUE) |>
  pull(cdTransect)
longueurChablisConnue <- sum(d$transects$longueurGA[d$transects$cdTransect %in% transectsChablis], na.rm = TRUE)

chablisDispositif <- tibble(
  indicateur = "Chablis (/ha)",
  nbChablis = nbChablis,
  transectsProspectes = paste(transectsChablis, collapse = ", "),
  longueurConnue_m = longueurChablisConnue,
  valeur = NA_real_
)
if (longueurChablisConnue > 0) {
  chablisDispositif$valeur <- nbChablis / (longueurChablisConnue * 10) * 10000
}

### Stock de carbone (document d'etape §3.3) ###

# Parametres du site — PROVISOIRES, a confirmer :
#  E : indice bioclimatique de Chave et al. 2014 (foret tropicale humide,
#      facade Est Madagascar ; valeur par defaut -0,080)
#  rho : densite du bois (t/m3) ; moyenne bois tropical humide 0,60
# Constantes du document d'etape :
#  R (BGB/AGB) = 0,20 ; CF = 0,47 ; CO2/MS = 3,67
#     -> StockCO2 vivant = (AGB + 0,20 AGB) x 0,47 x 3,67 = 2,06988 AGB
#  bois mort sur pied : meme allometrie, facteur de decomposition
#     par etat (1 : 0,9 ; 2 : 0,6 ; 3 : 0,4 ; NA : 1,0)
#  bois mort au sol : Van Wagner (1968), L_bm = 290 m
#     V = pi2/8L x somme(d2) x 10000 (m3/ha), CO2 = V x rho x CF x 3,67

E_bioclimatique <- -0.080   # PROVISOIRE
rho_bois <- 0.60            # PROVISOIRE
facteurs_decomposition <- c("1" = 0.9, "2" = 0.6, "3" = 0.4)

agb_chave <- function(dhp_cm, rho = rho_bois, E = E_bioclimatique) {
  lnD <- log(dhp_cm)
  exp(-1.803 - 0.976 * E + 0.976 * log(rho) + 2.673 * lnD - 0.0299 * lnD^2)
}

# N.B. domaine de validite de Chave 2014 : DHP >= 5 cm. Les tiges plus
# petites (2,2 a 5 cm) sont incluses mais contribuent marginalement
# (< 8 % de l'AGB total) ; recalcul sans elles possible via floreTiges.

tiges <- tiges |>
  mutate(agb_kg = agb_chave(dbh_cm))

agb_par_placette <- tiges |>
  group_by(cdPlacette) |>
  summarise(AGB_kg = sum(agb_kg, na.rm = TRUE), .groups = "drop")

AGB_ha <- sum(agb_par_placette$AGB_kg) / surfaceTotale / 1000 * 10000
stockCO2_vivant <- 2.06988 * AGB_ha

# Bois mort sur pied (chandelles)
facteur_decomposition <- function(etat) {
  dplyr::coalesce(unname(facteurs_decomposition[as.character(etat)]), 1)
}

chandelles <- d$boisMort |>
  filter(type == "Chandelle") |>
  mutate(
    dbh_cm = circ_cm / pi,
    facteur = facteur_decomposition(etatDecomposition),
    agb_kg = agb_chave(dbh_cm)
  )

CO2_pied_ha <- sum(chandelles$agb_kg * chandelles$facteur, na.rm = TRUE) *
  0.47 * 3.67 / surfaceTotale / 1000 * 10000

# Bois mort au sol (Van Wagner)
longueur_transect_bm <- 290   # L_bm (m)

boisSol <- d$boisMort |>
  filter(type == "Sol") |>
  mutate(
    diametre_m = circ_cm / pi / 100,
    facteur = facteur_decomposition(etatDecomposition)
  )

V_sol_ha <- pi^2 / (8 * longueur_transect_bm) *
  sum(boisSol$diametre_m^2 * boisSol$facteur, na.rm = TRUE) * 10000
CO2_sol_ha <- V_sol_ha * rho_bois * 0.47 * 3.67

stockCO2_boisMort <- CO2_pied_ha + CO2_sol_ha

stockCarbone_dispositif <- tibble(
  indicateur = c(
    "AGB vivant (tMS/ha)",
    "Stock CO2 vivant (tCO2/ha)",
    "CO2 bois mort sur pied (tCO2/ha)",
    "CO2 bois mort au sol (tCO2/ha)",
    "CO2 bois mort total (tCO2/ha)"
  ),
  valeur = c(AGB_ha, stockCO2_vivant, CO2_pied_ha, CO2_sol_ha, stockCO2_boisMort)
)

### Sorties ###


resultat <- list(
  surface_m2 = surfaceTotale,
  densite_dispositif = densite_dispositif,
  classesDiametre = courbeClasses,
  surfaceTerriere_m2 = surfaceTerriere,
  surfaceTerriere_ha = surfaceTerriere_dispositif,
  placettesIndices = placettesIndices,
  resume_placettes = resume_placettes,
  surfaceTransects_m2 = surfaceTransects_m2,
  grandsArbresDispositif = grandsArbresDispositif,
  GgrandsArbres_ha = GgrandsArbres_ha,
  chablisDispositif = chablisDispositif,
  stockCarbone = stockCarbone_dispositif
)

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)
write_csv(courbeClasses, file.path(dossierSorties, "structure_classes_diametre.csv"))
write_csv(placettesIndices, file.path(dossierSorties, "structure_indices_placettes.csv"))

message("✅ Structure forestière :")
message("✅ Récapitulatif des indices (moyenne ± écart-type entre placettes, IC 95 %) :")
for (i in seq_len(nrow(resume_placettes))) {
  r <- resume_placettes[i, ]
  message("   ", r$indice, " : ", round(r$moyenne, 1), " ± ", round(r$ecartType, 1),
          " [IC 95 % : ", round(r$ic95_bas, 1), " ; ", round(r$ic95_haut, 1), "]")
}
message("   Densité N (dispositif) = ", round(densite), " tiges/ha (",
        nbTigesMesurees, " tiges mesurées + ", nbGaulis, " gaulis, ",
        round(surfaceTotale, 1), " m²)")
message("   N total du dispositif = ", nbTigesMesurees + nbGaulis,
        " tiges (", nbTigesMesurees, " mesurées + ", nbGaulis, " gaulis)")
message("   Surface terrière G (dispositif) = ", round(G_ha, 2), " m²/ha")
resultat
