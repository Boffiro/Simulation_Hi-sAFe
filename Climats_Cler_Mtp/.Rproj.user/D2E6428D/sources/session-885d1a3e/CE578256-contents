
library(tidyverse)
library(rstudioapi)

# Script Formating Data For Hi-sAFe Dataset from CLIMATIK to a format suitable for meteo data used in Hi-sAFe

rm(list = ls())

setwd(dirname(rstudioapi::getActiveProject()))
setwd(dir = "Climats_Cler_Mtp/A_data/meteo/")

# Read the daily data
dataset_Hi_sAFe <- read.table("dataset_Hi-sAFe.txt", header = FALSE)

colnames(dataset_Hi_sAFe) <- c("JULIAN_DAY", "AN", "MOIS", "JOUR", "TX", "TN", "UX", "UN", "RR", "RG", "V")

setwd(dirname(rstudioapi::getActiveProject()))
watertable_default <- read.csv2("Climats_Cler_Mtp/A_data/watertable_default.txt", header = F)

dataset_Hi_sAFe$WT <- rep(watertable_default[,1], length.out = nrow(dataset_Hi_sAFe))

dataset_Hi_sAFe$airCO2 <- 330

# Save
setwd(dirname(rstudioapi::getActiveProject()))
setwd("Climats_Cler_Mtp/C_outputs")

if (!file.exists("DataForHi-sAFe")) {
  dir.create(file.path(getwd(), "DataForHi-sAFe"), recursive = T)
  
  setwd(dir = paste0(getwd(),"/DataForHi-sAFe"))
}

# Write data_daily_Hi_sAFe to 
write.table(dataset_Hi_sAFe, file = "output_dataset_Hi_sAFe.wth", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
