# Importation et remaniement des données Morphology --------------------------------

# Étape 1 : Importation des données brutes
dir.create("data/data_raw", showWarnings = FALSE)

morphology_data <- read.csv(
  "data/FishPass_Morphology_Database.csv",
  header = TRUE,
  sep = ","
)

# Renommer les colonnes en français
colnames(morphology_data) <- c(
  "Ordre",                     
  "Famille",                   
  "Genre",                     
  "Nom_scientifique",          
  "Nom_commun",                
  "Longueur_max",              
  "Profondeur_corps",          
  "Forme_corps",               
  "Rapport_aspects",           
  "Etroitesse_pedoncule",      
  "Position_natation_pectorale",
  "Taille_natation_pectorale", 
  "Position_oeil_vertical",    
  "Taille_oeil",               
  "Ref_longueur",              
  "Ref_profondeur"             
)

# Vérification rapide
head(morphology_data)
str(morphology_data)

# Étape 2 : Description brève des données
# Dimensions du jeu de données
cat("Nombre de lignes et colonnes :\n")
dim(morphology_data)

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
morpho_data <- na.omit(morphology_data[, vars_of_interest])

# Vérification finale
cat("Dimensions après nettoyage :\n")
dim(morpho_data)
head(morpho_data)
tail(morpho_data)

# Étape 4 : Ajout des labels et unités
library(labelled)

morpho_data <- set_variable_labels(
  morpho_data,
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
write.csv(morpho_data, "data/data_morpho.csv", row.names = FALSE)

# Affichage final du tableau complet
head(morpho_data)

