library(dplyr)
library(labelled)
library(tidyr)

# 1. IMPORTATION
dir.create("data/data_raw", showWarnings = FALSE)

morphology_data <- read.csv("data/FishPass_Morphology_Database.csv", sep = ",")
behaviour_data  <- read.csv("data/FishPass_Behaviour_Database.csv", sep = ",")

Fish_data <- left_join(morphology_data, behaviour_data,
  by = join_by(Order, Family, Genus, Scientific.Name, Common.Name))

# 2. DESCRIPTION
cat("Nombre d'espèces :", nrow(Fish_data), "\n")
cat("Nombre de variables :", ncol(Fish_data), "\n")
head(Fish_data)

# 3. NETTOYAGE
colnames(Fish_data) <- c(
  "Ordre","Famille","Genre","Nom_scientifique","Nom_commun",
  "Longueur_max","Profondeur_corps","Forme_corps","Rapport_aspect","Etroitesse_pedoncule",
  "Position_nageoire_pectorale","Taille_nageoire_pectorale",
  "Position_oeil_vertical","Taille_oeil",
  "Ref_longueur","Ref_profondeur","Ref_forme","Ref_rapport","Ref_etroitesse",
  "Ref_position_pectorale","Ref_taille_pectorale","Ref_position_oeil","Ref_taille_oeil",
  "Vertical_station","Comportement_banc","Ref_vertical_station","Ref_comportement_banc"
)

Fish_data <- Fish_data %>%
  select(
    Ordre, Longueur_max, Profondeur_corps, Rapport_aspect, Etroitesse_pedoncule,
    Position_nageoire_pectorale, Taille_nageoire_pectorale,
    Position_oeil_vertical, Taille_oeil,
    Vertical_station, Comportement_banc
  ) %>%
  drop_na() 

# 4. LABELS & UNITÉS
Fish_data <- set_variable_labels(
  Fish_data,
  Ordre = "Ordre taxonomique",
  Longueur_max = "Longueur maximale (cm)",
  Profondeur_corps = "Profondeur du corps (% TL)",
  Rapport_aspect = "Rapport d'aspect (sans unité)",
  Etroitesse_pedoncule = "Étroitesse du pédoncule caudal (sans unité)",
  Position_nageoire_pectorale = "Position verticale nageoire pectorale",
  Taille_nageoire_pectorale = "Taille nageoire pectorale (sans unité)",
  Position_oeil_vertical = "Position verticale de l'œil",
  Taille_oeil = "Taille de l'œil (% HL)",
  Vertical_station = "Position verticale dans la colonne d'eau",
  Comportement_banc = "Comportement de banc"
)

# Conversion en facteurs
Fish_data$Ordre <- as.factor(Fish_data$Ordre)
Fish_data$Vertical_station <- as.factor(Fish_data$Vertical_station)
Fish_data$Comportement_banc <- as.factor(Fish_data$Comportement_banc)

# FILTRAGE des ordres les plus grands
ordres_a_garder <- c("Cypriniformes", "Perciformes", "Salmoniformes")
Fish_data <- Fish_data %>%
  filter(Ordre %in% ordres_a_garder)

# Sauvegarde
write.csv(Fish_data, "data/Fish_data.csv", row.names = FALSE)

