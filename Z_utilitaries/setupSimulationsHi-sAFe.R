
library(rstudioapi)

# Script setup Model

# Check if the current working directory is empty
if (length(list.files(getwd())) == 1) {
  # List of directory names to be created
  directory_names <- c("A_data", "C_outputs", "B_code")

  # Loop to create each directory in the list
  for (dir_name in directory_names) {
    dir.create(dir_name)
  }
} else {
  print("The directory is not empty.")
}

# Navigate to the "A_data" directory and check if "meteo" directory exists
setwd("A_data")

if (length(list.files(getwd())) == 0) {
  dir.create("meteo")
}

# Inside the "meteo" directory, create a README.txt file with specific content
setwd("meteo")

if (length(list.files(getwd())) == 0) {
  text <- ("Données Météos à Avoir pour chaque Site : par jour
- Temp Max
- Temp Min
- Humid Relative Max
- Humid Relative Min
- Vent Moyen
- Somme Radiation
- Somme Précipitation

Pas de temps : Journalier
Date de debut : 31/12/1979
Date de fin : 01/01/2021
Station(s) : 63113001

TN : Temperature minimale (Degres Celsius)
TX : Temperature maximale (Degres Celsius)
UX : Humidite maximale (Pourcentage)
UN : Humidite minimale (Pourcentage)
RG : Rayonnement global (Joules / cm²)
RR : Hauteur des precipitations (Millimetres)
V : Vitesse moyenne du vent (Metres par seconde)")

  complete_file_path <- paste0(getwd(), "/README.txt")

  # Write the text to the .txt file
  writeLines(text, complete_file_path)
}

setwd("C_outputs/")


# Remove all objects from the R environment
rm(list = ls())
