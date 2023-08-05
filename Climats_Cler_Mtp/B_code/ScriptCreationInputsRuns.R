# Load libraries
library(tidyverse)    # Load tidyverse to use data manipulation functions
library(rstudioapi)   # Load rstudioapi to access RStudio project information

# Clear the workspace
rm(list = ls())

# Set the working directory to the root of the RStudio project
setwd(dirname(rstudioapi::getActiveProject()))

# Define script parameters
param_list <- list(
  AgriculturalSystem = c("monocrop", "agroforestry"),
  AgriculturalSystemDesign = c("Default"),
  YearStart = c(1980),
  YearEnd = c(2020),
  TreeSpecies = c("poplar"),
  TreeStartAge = c(20),
  TreeIntervention = c("Default"),
  CropSpecies = c("durum-wheat"),
  CropItk = c("Default"),
  Soil = c("Default"),
  Climate = c("Mediterranean", "Continental")
)

# Create all possible combinations of parameters
input_runs <- expand.grid(param_list, stringsAsFactors = FALSE)

# Create the RunID column by concatenating the values of other columns

RunID <- data.frame(matrix(nrow = 4,ncol = 1))

for (i in 1:length(row_number(input_runs))) {
  RunID[i,] <- paste(input_runs[i,], collapse = "_")
  RunID[i,] <- gsub("Default_", "", RunID[i,])
}

input_runs$RunID <- RunID[,1] 

# Add a RunNumber column to number each row
input_runs <- input_runs %>%
  mutate(RunNumber = row_number())

# Move the RunID column to the first position
input_runs <- input_runs %>%
  select(RunID, RunNumber, everything())

# Save the result to a CSV file
setwd(dir = "Climats_Cler_Mtp/C_outputs/Inputs_runs/")

write.table(input_runs, file = "input_runs.csv", sep = ",", row.names = FALSE, quote = FALSE)

#This code performs the following operations:
  
# 1. Load the tidyverse and rstudioapi libraries.
# 2. Clear the workspace to remove existing objects.
# 3. Set the working directory to the root of the RStudio project.
# 4. Define the script parameters using the param_list list.
# 5. Create a table input_runs containing all possible combinations of parameters.
# 6. Create a new column RunID by concatenating the values of other columns.
# 7. Add a RunNumber column to number each row in the table.
# 8. Move the RunID column to the first position in the table.
# 9. Save the result to a CSV file named "input_runs.csv" in the "Climats_Cler_Mtp/C_outputs/Inputs_runs/" directory.



