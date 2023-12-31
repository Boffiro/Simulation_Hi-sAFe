library(hisafer)
library(tidyverse)
library(rstudioapi)

# Script

## Setup

rm(list = ls())

setwd(dirname(rstudioapi::getActiveProject()))
setwd(dir = "Climats_Cler_Mtp/")

path_to_simulation <- paste0(getwd(), "/C_outputs/Simulation/")

profiles <- c("all")

## Setup des runs

inputs_runs <- read.csv2(file = "A_data/input_runs.csv", sep = ",")

## Creation des runs

ensemble_run <- vector(mode = "list", length = nrow(inputs_runs))

for (i in 1:nrow(inputs_runs)) {
  ensemble_run[[i]] <- define_hisafe(
    path = path_to_simulation,
    template = inputs_runs$AgriculturalSystem[i],
    exp.name = "TestEffetClimat",
    SimulationName = inputs_runs$RunID[i],
    profiles = profiles,
    # weatherFile = "A_data/meteo/TEST.wth",
    weatherFile = paste0("A_data/meteo/", inputs_runs$Climate[i], ".wth"),
    simulationYearStart = inputs_runs$YearStart[i],
    nbSimulations = inputs_runs$YearEnd[i] - inputs_runs$YearStart[i],
    mainCropSpecies = paste0(inputs_runs$CropSpecies[i], ".plt"),
    mainCropItk = paste0(inputs_runs$CropSpecies[i], ".tec"),
    treeSpecies = "poplar.tree"
  )
  names(ensemble_run)[[i]] <- inputs_runs$RunID[i]
  build_hisafe(hip = ensemble_run[[i]])
}

## Change export parameters

output_folders <- list.files(path = "C_outputs/Simulation/")

for (i in 1:length(output_folders)) {
  unlink(paste0("C_outputs/Simulation/", output_folders[i], "/exportParameters/"), recursive = TRUE)

  file.copy(
    from = "A_data/exportParameters/",
    to = paste0("C_outputs/Simulation/", output_folders[i]),
    overwrite = T, recursive = T
  )
}

## Lancement des runs

for (i in 1:nrow(inputs_runs)) {
  timestamp()
  run_hisafe(hip = ensemble_run[[i]], capsis.path = "C:/Users/fsoulard/Documents/CAPSIS/")
  timestamp()
}
