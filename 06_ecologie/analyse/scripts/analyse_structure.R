"
Ewen Le Coeur
2026
Objectif : analyse de la structure forestiere (§3.2 du document d'etape)
et de la courbe aire-espece — execution et mise en forme des sorties.

Structure du code (standard R en ecologie) :
  - importDonnees.R        : import et nettoyage (socle)
  - fonctionsStructure.R   : fonctions de calcul (N, classes, G)
  - fonctionsAireEspece.R  : fonctions de calcul (aire-espece)
  - analyse_structure.R    : CE SCRIPT — orchestration, figures, exports

Utilisation :
  source(\"06_ecologie/analyse/scripts/analyse_structure.R\")
"

source("06_ecologie/analyse/scripts/importDonnees.R")
source("06_ecologie/analyse/scripts/fonctionsStructure.R")
source("06_ecologie/analyse/scripts/fonctionsAireEspece.R")

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("scales", quietly = TRUE)) install.packages("scales")

d <- importer_donnees()

dossierSorties <- "06_ecologie/analyse/sorties"
if (!dir.exists(dossierSorties)) dir.create(dossierSorties, recursive = TRUE)

### Densite N ###

tiges <- preparer_tiges(d)
gaulis <- compter_gaulis(d)
surfaceTotale <- sum(d$placettes$surfaceHorizontale_m2, na.rm = TRUE)

N_total <- calculer_N_total(tiges, gaulis)
N_par_placette <- calculer_N_par_placette(d, tiges, gaulis)
classesDiametre <- calculer_classes_diametre(tiges, gaulis, surfaceTotale)
classesIC95 <- calculer_classes_IC95(d, tiges, gaulis)

resume_N <- bind_rows(
  tibble(indice = "N total (tiges)",
         moyenne = N_total, ecartType = NA_real_,
         ic95_bas = NA_real_, ic95_haut = NA_real_),
  t(resumer(N_par_placette$nbTigesBrut)) |> as_tibble() |>
    mutate(indice = "N brut par placette (tiges)"),
  t(resumer(N_par_placette$N_m2)) |> as_tibble() |>
    mutate(indice = "N (tiges/m2)"),
  t(resumer(N_par_placette$N_ha)) |> as_tibble() |>
    mutate(indice = "N (tiges/ha)")
) |>
  mutate(nbPlacettes = nrow(N_par_placette)) |>
  select(indice, moyenne, ecartType, ic95_bas, ic95_haut, nbPlacettes) |>
  mutate(across(where(is.numeric), ~ round(.x, 2)))

### Surface terriere G ###

G_par_placette <- calculer_G_par_placette(tiges)
G_total_m2 <- sum(G_par_placette$G_m2)
G_ha <- G_total_m2 / surfaceTotale * 10000

G_par_placette <- G_par_placette |>
  left_join(d$placettes |> select(cdPlacette, surfaceHorizontale_m2),
            by = "cdPlacette") |>
  mutate(G_ha = G_m2 / surfaceHorizontale_m2 * 10000)

resume_G <- t(resumer(G_par_placette$G_ha)) |> as_tibble() |>
  mutate(indice = "G (m2/ha)", nbPlacettes = nrow(G_par_placette)) |>
  select(indice, moyenne, ecartType, ic95_bas, ic95_haut, nbPlacettes) |>
  mutate(across(where(is.numeric), ~ round(.x, 2)))

resume_indices <- bind_rows(resume_N, resume_G)

# G par classe de diametre (5 cm) avec IC 95 % entre placettes
GClasses <- calculer_G_par_classe(
  tiges,
  d$placettes |> select(cdPlacette, surfaceHorizontale_m2),
  largeur = 5, surfaceTotale = surfaceTotale
)

### Regeneration (gaulis vs tiges mesurees) ###

regeneration <- calculer_regeneration(N_par_placette)

figureRegeneration <- ggplot(regeneration$par_placette,
                             aes(x = N_ha_tiges, y = N_ha_gaulis)) +
  geom_point(size = 2.2, alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = "darkred", linewidth = 0.7) +
  labs(x = "Densité des tiges mesurées (tiges/ha)",
       y = "Densité de la régénération (gaulis/ha)",
       title = "Régénération en fonction du peuplement",
       subtitle = paste0("Par placette — Pearson r = ",
                        round(regeneration$pearson_r, 2), " (p = ",
                        format(regeneration$pearson_p, digits = 2),
                        "), Spearman rho = ",
                        round(regeneration$spearman_rho, 2))) +
  theme_minimal()
ggsave(file.path(dossierSorties, "structure_regeneration.png"),
       figureRegeneration, width = 16, height = 12, units = "cm", dpi = 300)

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

### Figures ###

# Echelle symlog : lineaire autour de zero, logarithmique au-dessus,
# pour representer les IC descendant a 0 avec des densites de 20 a 26000/ha
trans_symlog <- scales::trans_new(
  name = "symlog",
  transform = function(y) sign(y) * log10(1 + abs(y) / 10),
  inverse = function(t) sign(t) * 10 * (10^abs(t) - 1)
)

# Figure 1 : tiges/ha par classe, IC 95 % reel (tronque a 0)
classesFigure <- classesIC95 |> filter(moyenne_ha > 0)
etiquettes <- classesFigure |>
  mutate(etiquette = paste0(
    format(moyenne_ha, digits = 3, trim = TRUE),
    " [", format(round(ic95_bas), trim = TRUE), " ; ",
    format(round(ic95_haut), trim = TRUE), "]"
  ))

figureClasses <- ggplot(classesFigure,
                        aes(x = classeDiam + 1.25, y = moyenne_ha)) +
  geom_col(width = 2.5, fill = "grey70", color = "grey30") +
  geom_errorbar(aes(ymin = pmax(ic95_bas, 0), ymax = ic95_haut),
                width = 1.2, linewidth = 0.4) +
  geom_smooth(method = "loess", se = FALSE, color = "darkred", linewidth = 0.8) +
  geom_text(data = etiquettes,
            aes(x = classeDiam + 1.25, y = ic95_haut * 1.10, label = etiquette),
            angle = 90, vjust = 0.5, hjust = 0, size = 2.4) +
  scale_y_continuous(trans = trans_symlog,
                    breaks = c(0, 10, 100, 1000, 10000, 30000),
                    labels = scales::label_comma()) +
  scale_x_continuous(breaks = seq(0, max(classesDiametre$borneSup), by = 2.5)) +
  labs(x = "Classe de diamètre (cm)", y = "Densité (tiges/ha, échelle symlog)",
       title = "Distribution des tiges par classe de diamètre",
       subtitle = "Moyenne par placette, barres : IC 95 % réel (tronqué à 0)") +
  theme_minimal()
ggsave(file.path(dossierSorties, "structure_histogramme_classes.png"),
       figureClasses, width = 20, height = 12, units = "cm", dpi = 300)

# Figure 2 : effectifs bruts par classe (tiges comptees)
figureClassesBrut <- ggplot(classesDiametre,
                            aes(x = classeDiam + 1.25, y = effectifTotal)) +
  geom_col(width = 2.5, fill = "grey70", color = "grey30") +
  geom_text(aes(label = effectifTotal), vjust = -0.3, size = 3) +
  scale_x_continuous(breaks = seq(0, max(classesDiametre$borneSup), by = 2.5)) +
  labs(x = "Classe de diamètre (cm)", y = "Tiges comptées",
       title = "Effectifs par classe de diamètre",
       subtitle = "Nombre de tiges comptées dans le dispositif (gaulis en 0–2,5)") +
  theme_minimal()
ggsave(file.path(dossierSorties, "structure_histogramme_classes_brut.png"),
       figureClassesBrut, width = 20, height = 12, units = "cm", dpi = 300)

# Figure 3 : G/ha par classe de diametre (5 cm), IC 95 % entre placettes
etiquettesG <- GClasses |>
  mutate(etiquette = paste0(
    format(round(moyenne_ha, 1), trim = TRUE),
    " [", format(round(ic95_bas, 1), trim = TRUE), " ; ",
    format(round(ic95_haut, 1), trim = TRUE), "]"
  ))
figureGClasses <- ggplot(GClasses, aes(x = classeG + 2.5, y = moyenne_ha)) +
  geom_col(width = 5, fill = "grey70", color = "grey30") +
  geom_errorbar(aes(ymin = pmax(ic95_bas, 0), ymax = ic95_haut),
                width = 2, linewidth = 0.4) +
  geom_text(data = etiquettesG,
            aes(x = classeG + 2.5, y = ic95_haut * 1.10, label = etiquette),
            angle = 90, vjust = 0.5, hjust = 0, size = 2.6) +
  scale_x_continuous(breaks = seq(0, max(GClasses$borneSup), by = 5)) +
  labs(x = "Classe de diamètre (cm)",
       y = "Surface terrière (m²/ha)",
       title = "Surface terrière par classe de diamètre",
       subtitle = "Moyenne par placette, barres : IC 95 % (tronqué à 0)") +
  theme_minimal()
ggsave(file.path(dossierSorties, "structure_G_classes.png"),
       figureGClasses, width = 20, height = 12, units = "cm", dpi = 300)

# Figure 4 : courbe aire-espece avec bande d'ecart-type
figureAireEspece <- ggplot(courbeAireEspece,
                           aes(x = surface_m2, y = richesse_moyenne)) +
  geom_ribbon(aes(ymin = richesse_moyenne - richesse_ecartType,
                 ymax = richesse_moyenne + richesse_ecartType),
              fill = "grey80", alpha = 0.5) +
  geom_line(color = "darkred", linewidth = 0.9) +
  geom_point(size = 1.8) +
  labs(x = "Surface inventoriée cumulée (m²)",
       y = "Richesse spécifique (espèces)",
       title = "Courbe aire-espèce",
       subtitle = "Richesse moyenne pour 200 permutations aléatoires des placettes") +
  theme_minimal()
ggsave(file.path(dossierSorties, "structure_aire_espece.png"),
       figureAireEspece, width = 16, height = 12, units = "cm", dpi = 300)

### Exports ###

readr::write_csv(resume_indices,
                  file.path(dossierSorties, "structure_resume_indices.csv"))
readr::write_csv(N_par_placette,
                  file.path(dossierSorties, "structure_N_placettes.csv"))
readr::write_csv(classesDiametre,
                  file.path(dossierSorties, "structure_classes_diametre.csv"))
readr::write_csv(classesIC95,
                  file.path(dossierSorties, "structure_classes_ic95.csv"))
readr::write_csv(G_par_placette,
                  file.path(dossierSorties, "structure_G_placettes.csv"))
readr::write_csv(GClasses,
                  file.path(dossierSorties, "structure_G_classes.csv"))
readr::write_csv(courbeAireEspece,
                  file.path(dossierSorties, "structure_aire_espece.csv"))

### Messages ###

message("✅ Structure forestière — résumé (moyenne ± écart-type, IC 95 %) :")
for (i in seq_len(nrow(resume_indices))) {
  r <- resume_indices[i, ]
  message("   ", r$indice, " : ", r$moyenne,
          if (!is.na(r$ecartType)) paste0(" ± ", r$ecartType,
            " [", r$ic95_bas, " ; ", r$ic95_haut, "]"))
}
message("   G (dispositif) = ", round(G_ha, 2), " m2/ha ; G (par placette) = ",
        round(resume_G$moyenne[1], 2), " m2/ha, IC 95 % [",
        round(resume_G$ic95_bas[1], 2), " ; ", round(resume_G$ic95_haut[1], 2), "]")
message("   Surface inventoriée : ", round(surfaceTotale, 1), " m² sur ",
        nrow(d$placettes), " placettes")
message("   Régénération : Pearson r = ", round(regeneration$pearson_r, 2),
        " (p = ", format(regeneration$pearson_p, digits = 2), ") ; ",
        "Spearman rho = ", round(regeneration$spearman_rho, 2),
        " (p = ", format(regeneration$spearman_p, digits = 2), ")")
message("   Richesse totale (identités réconciliées) : ",
        nrow(distinct(especesParPlacette, espece)), " espèces")

list(
  donnees = d,
  tiges = tiges, gaulis = gaulis, surfaceTotale = surfaceTotale,
  N_total = N_total, N_par_placette = N_par_placette,
  classesDiametre = classesDiametre, classesIC95 = classesIC95,
  resume_indices = resume_indices,
  G_par_placette = G_par_placette, G_total_m2 = G_total_m2, G_ha = G_ha,
  GClasses = GClasses,
  courbeAireEspece = courbeAireEspece,
  regeneration = regeneration
)
