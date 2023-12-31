
library(tidyverse)
library(rstudioapi)

# Script Cleaning Dataset from CLIMATIK to a format suitable for meteo data used in Hi-sAFe

rm(list = ls())

setwd(dirname(rstudioapi::getActiveProject()))
setwd(dir = "Climats_Cler_Mtp/A_data/meteo/")

# Read the daily data from CSV
data_daily <- read.csv2("Maugio_1943-2022_METEO_STATION_34154001.csv", header = TRUE, sep = ";", dec = ".")

# Clean the data and create new columns
data_daily_clean <- data_daily %>%
  # Convert columns to Date format and create Julian day and pentad
  mutate(
    DATE = as.Date(paste(AN, MOIS, JOUR, sep = "-")),
    JULIAN_DAY = as.numeric(format(as.Date(paste(AN, MOIS, JOUR, sep = "-")), "%j")),
    PENTAD = ((JULIAN_DAY - 1) %/% 5) + 1
  ) %>%
  # Group by year and month
  group_by(AN, MOIS) %>%
  # Replace missing values with values deemed appropriate to correct
  mutate(
    TX = ifelse(is.na(TX), mean(TX, na.rm = TRUE), TX), 
    TN = ifelse(is.na(TN), mean(TN, na.rm = TRUE), TN),
    #If a value is missing,it is replaced by the Montly avaerage.
    AMP = ifelse(is.na(AMP), abs(TX - TN), AMP),
    TMC = ifelse(is.na(TMC), (TX + TN) / 2, TMC),
    #Arithmetical value. So we calculate them if we have TX and TN
    TM = ifelse(is.na(TM), TMC, TM),
    #Data osed as a raw. We replace missing values with calculated values 
    UX = ifelse(is.na(UX), mean(UX, na.rm = TRUE), UX),
    UN = ifelse(is.na(UN), mean(UN, na.rm = TRUE), UN),
    #If a value is missing,it is replaced by the Montly avaerage.
    UM = ifelse(is.na(UM), (UX + UN) / 2, UM),
    #Arithmetical value. So we calculate them if we have TX and TN
    RR = ifelse(is.na(RR), 0, RR),
    #If a value is missing,it is replaced by 0
    V = ifelse(is.na(V), mean(V, na.rm = TRUE), V),
    #If a value is missing,it is replaced by the Montly avaerage.
    RG = ifelse(is.na(RG), RGC, RG),
    #Data osed as a raw. We replace missing values with calculated values 
    RG = ifelse(is.na(RG), mean(RG, na.rm = TRUE), RG)
    #If a value is missing,it is replaced by the Montly avaerage.
  ) %>%
  ungroup() %>%
  # Group by year and check for missing values
  group_by(AN) %>%
  mutate(TEST = max(
    sum(is.na(TX)),
    sum(is.na(TN)),
    sum(is.na(UX)),
    sum(is.na(UN)),
    sum(is.na(RR)),
    sum(is.na(RG)),
    sum(is.na(V))
  )) %>%
  # Filter rows where TEST is less than or equal to 364 (less than a full year of missing values). Goal is to remove the complete years with missing data 
  filter(TEST <= 364) %>%
  select(-TEST) %>%
  ungroup()

# Extract data for Hi_sAFe
data_daily_Hi_sAFe <- data_daily_clean %>%
  select(JULIAN_DAY, AN, MOIS, JOUR, TX, TN, UX, UN, RG, RR, V)

#Save outputs
setwd(dirname(rstudioapi::getActiveProject()))
setwd("Climats_Cler_Mtp/C_outputs")

if (!file.exists("Cleaning")) {
  dir.create(file.path(getwd(), "Cleaning"), recursive = T)
  
  setwd(dir = paste0(getwd(),"/Cleaning"))
}

# Write data_daily_clean to CSV
write.table(data_daily_clean, file = "output_dataset_cleaned.txt", sep = ";", row.names = FALSE, col.names = TRUE)

# Write data_daily_Hi_sAFe to CSV
write.table(data_daily_Hi_sAFe, file = "output_dataset_Hi-sAFe.txt", sep = "\t", row.names = FALSE, col.names = FALSE)

