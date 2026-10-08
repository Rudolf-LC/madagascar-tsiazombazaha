"
Ewen Le Coeur
2026
Objectif : richesse specifique totale de la foret (§3.7 du document
d'etape) — courbe aire-espece et, ulterieurement, estimateurs
asymptotiques (Chao, jackknife, ICE, bootstrap).

Structure du code :
  - importDonnees.R        : import et nettoyage (socle)
  - fonctionsAireEspece.R  : fonctions de calcul (aire-espece)
  - analyse_richesse.R     : CE SCRIPT — orchestration, figures, exports

Utilisation :
  source(\"06_ecologie/analyse/scripts/analyse_richesse.R\")
"

source("06_ecologie/analyse/scripts/01_importDonnees.R")
source("06_ecologie/analyse/scripts/fonctions/fonctionsAireEspece.R")

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")

d <- importer_donnees()

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Courbe aire-espece ###

correspondances <- charger_correspondances(
  file.path(dossierSorties, "liste_especes_vegetales.csv"))
especesParPlacette <- calculer_especes_par_placette(d, correspondances)
richesseParPlacette <- calculer_richesse_par_placette(especesParPlacette)
courbeAireEspece <- calculer_courbe_aire_espece(
  especesParPlacette,
  d$placettes |> select(cdPlacette, surfaceHorizontale_m2),
  n_permutations = 200
)

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

### Figure ###

figureAireEspece <- ggplot(courbeAireEspece,
                           aes(x = surface_m2, y = richesse_moyenne)) +
  geom_ribbon(aes(ymin = richesse_moyenne - richesse_ecartType,
                 ymax = richesse_moyenne + richesse_ecartType),
              fill = "grey80", alpha = 0.5) +
  geom_line(color = "darkred", linewidth = 0.9) +
  geom_point(size = 1.8) +
  scale_x_continuous(expand = expansion(mult = c(0.02, 0.05))) +
  scale_y_continuous(expand = expansion(mult = c(0.02, 0.08))) +
  labs(x = "Surface inventoriée cumulée (m²)",
       y = "Richesse spécifique (espèces)",
       title = "Courbe aire-espèce",
       subtitle = "Richesse moyenne pour 200 permutations aléatoires des placettes") +
  theme_axes
ggsave(file.path(dossierSorties, "richesse_aire_espece.png"),
       figureAireEspece, width = 16, height = 12, units = "cm", dpi = 300)

### Exports ###

readr::write_csv(courbeAireEspece,
                  file.path(dossierSorties, "richesse_aire_espece.csv"))
readr::write_csv(richesseParPlacette,
                  file.path(dossierSorties, "richesse_par_placette.csv"))

### Messages ###

richesseTotale <- nrow(distinct(especesParPlacette, espece))
message("✅ Richesse spécifique (§3.7) :")
message("   Richesse totale observée (identités réconciliées) : ",
        richesseTotale, " espèces")
message("   Courbe aire-espèce : ", max(courbeAireEspece$nbPlacettes),
        " placettes, ", round(max(courbeAireEspece$surface_m2)), " m² cumulés")

list(
  donnees = d,
  especesParPlacette = especesParPlacette,
  richesseParPlacette = richesseParPlacette,
  richesseTotale = richesseTotale,
  courbeAireEspece = courbeAireEspece
)
