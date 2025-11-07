# Importation et remaniement des données Morphology --------------------------------

# Étape 1 : Importation des données brutes
dir.create("data/data_raw", showWarnings = FALSE)


morphology_data <- read.csv(
  "data/FishPass_Morphology_Database.csv",
  header = TRUE,
  sep = ","
)
behaviour_data <- read.csv(
  "data/FishPass_Behaviour_Database.csv",
  header = TRUE,
  sep = ","
)



#combiner les deux tableaux 

Fish_data <- full_join(morphology_data, behaviour_data, by =  join_by("Order", "Family", "Genus", "Scientific.Name", "Common.Name"))
Fish_data <- left_join(morphology_data, behaviour_data)
DT::datatable(Fish_data)

# Renommer les colonnes en français
# Renommage des colonnes
colnames(Fish_data) <- c(
  "Ordre",
  "Famille",
  "Genre",
  "Nom_scientifique",
  "Nom_commun",
  "Longueur_max",
  "Profondeur_corps",
  "Forme_corps",
  "Rapport_aspect",
  "Etroitesse_pedoncule",
  "Position_nageoire_pectorale",
  "Taille_nageoire_pectorale",
  "Position_oeil_vertical",
  "Taille_oeil",
  "Ref_longueur",
  "Ref_profondeur",
  "Ref_forme",
  "Ref_rapport",
  "Ref_etroitesse",
  "Ref_position_pectorale",
  "Ref_taille_pectorale",
  "Ref_position_oeil",
  "Ref_taille_oeil",
  "Vertical_station",
  "Comportement_banc",
  "Ref_vertical_station",
  "Ref_comportement_banc"
)


#Vérification rapide 

head(Fish_data) 
str(Fish_data) 

#suppression des variables non nécessaires pour notre travail
Fish_data <- Fish_data %>% 
  select(-starts_with("Ref_"))

#sélection des variables d’intérêt
Fish_data <- Fish_data %>%
  select(
    Ordre, Longueur_max, Profondeur_corps, Rapport_aspect, Etroitesse_pedoncule,
    Position_nageoire_pectorale, Taille_nageoire_pectorale,
    Position_oeil_vertical, Taille_oeil,
    Vertical_station, Comportement_banc
  )
#convertir en variables facteur
Fish_data$Ordre <- as.factor(Fish_data$Ordre)
Fish_data$Forme_corps <- as.factor(Fish_data$Forme_corps)
Fish_data$Vertical_station <- as.factor(Fish_data$Vertical_station)
Fish_data$Comportement_banc <- as.factor(Fish_data$Comportement_banc)

#suppression des valeurs manquantes
Fish_data <- na.omit(Fish_data)

#2. Descrciption des données 

# -- Dimensions du jeu de données --
cat("Nombre d'espèces :", nrow(Fish_data), "\n")
cat("Nombre de variables :", ncol(Fish_data), "\n")

# -- Résumé des variables numériques --
vars_num <- c("Longueur_max", "Profondeur_corps", "Rapport_aspect", 
  "Etroitesse_pedoncule", "Position_nageoire_pectorale",
  "Taille_nageoire_pectorale", "Position_oeil_vertical", "Taille_oeil")

summary(Fish_data[, vars_num])

# -- Distribution des variables qualitatives --
cat("\nRépartition des formes du corps :\n")
table(Fish_data$Forme_corps)

cat("\nRépartition des ordres :\n")
table(Fish_data$Ordre)

cat("\nPosition verticale dans la colonne d'eau :\n")
table(Fish_data$Vertical_station)

cat("\nComportement de banc :\n")
table(Fish_data$Comportement_banc)




# Résumé statistique des variables numériques
cols_num <- c(
  "Longueur_max", "Profondeur_corps", "Rapport_aspects",
  "Etroitesse_pedoncule", "Position_natation_pectorale",
  "Taille_natation_pectorale", "Position_oeil_vertical", "Taille_oeil"
)
summary(morphology_data[, cols_num])

# Nombre de modalités pour les variables qualitatives
sapply(morphology_data[c("Forme_corps", "Ordre")], function(x) length(unique(x)))

# Comptage des valeurs manquantes
colSums(is.na(morphology_data))

# Étape 3 : Nettoyage des données
# Conversion des colonnes numériques
for (col in cols_num) {
  morphology_data[[col]] <- as.numeric(morphology_data[[col]])
}

# Conversion des variables qualitatives en facteur
morphology_data$Forme_corps <- as.factor(morphology_data$Forme_corps)
morphology_data$Ordre <- as.factor(morphology_data$Ordre)

# Suppression des lignes avec valeurs manquantes pour les variables d'intérêt
vars_of_interest <- c(
  "Ordre", "Forme_corps",
  cols_num
)
morpho <- na.omit(morphology_data[, vars_of_interest])

# Vérification finale
cat("Dimensions après nettoyage :\n")
dim(morpho)
head(morpho)
tail(morpho)

# Sélection des ordres les plus représentés
ordres_gardés <- c("Cypriniformes", "Perciformes", "Salmoniformes", "Siluriformes")
morpho <- subset(morpho, Ordre %in% ordres_gardés)

# Vérification du nombre d'individus par ordre
table(morpho$Ordre)

# Étape 4 : Ajout des labels et unités
library(labelled)

morpho <- set_variable_labels(
  morpho,
  Ordre = "Ordre taxonomique",
  Forme_corps = "Forme du corps",
  Longueur_max = "Longueur maximale",
  Profondeur_corps = "Profondeur du corps (% TL)",
  Rapport_aspects = "Rapport d'aspect",
  Etroitesse_pedoncule = "Étroitesse du pédoncule caudal",
  Position_natation_pectorale = "Position verticale nageoire pectorale",
  Taille_natation_pectorale = "Taille nageoire pectorale",
  Position_oeil_vertical = "Position verticale de l'œil",
  Taille_oeil = "Taille de l'œil (% HL)"
)

# Étape 5 : Sauvegarde locale des données retravaillées
write.csv(morpho, "data/data_morpho.csv", row.names = FALSE)

# Affichage final du tableau complet
head(morpho)

