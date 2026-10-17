// Annexes — table des annexes et liste des annexes.
// Transféré du brouillon « redaction-foresterie-brouillon » (liste intégrale conservée,
// coquilles telles quelles).
// TODO : composer chaque annexe ; les gros tableaux (liste des espèces, association
// espèce×usage) sont à importer dynamiquement depuis les CSV (cf. convention de gestion
// des tableaux en Résultats §3.1).

#show figure.where(kind: "annexe"): set figure.caption(position: top)
#set figure(numbering: "1")

= Annexes

#figure(
  [ ... contenu de l'annexe ... ],
  kind: "annexe",
  supplement: [Annexe],
  caption: [Titre de l'annexe],
)

- Carte d'intervention du projet EcoBois (?)
- Canevas d'entretien
- Liste des enquetes / sorties
- Protocole des relevés de terrain (si besoin) / Matériel utilisé
- Feuille de relevé
- Liste des plantes établie (nom vernaculaire) avec IVI
- Autres espèces de plantes observées/mentionnées en dehors des placettes
- Liste des animaux
- Table des logiciels et programmes utilisés
- Métadonnées des fichiers complémentaires du rapport (données écologiques, transcription des entretiens)
