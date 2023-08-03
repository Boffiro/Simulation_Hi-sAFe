# Script loading packages

package_list <- c(
  "hisafer",
  "tidyverse",
  "precintcon",
  "SPEI",
  "styler"
)

for (i in package_list) {
  # Check if the package is already installed
  if (!requireNamespace(i, quietly = TRUE)) {
    # If not installed, install the package
    install.packages(i)
  }
}

library(tidyverse)
library(precintcon)
library(SPEI)
library(styler)
library(rstudioapi)

if (!requireNamespace(devtools, quietly = TRUE)) {
  install.packages("devtools") # si ça ne marche pas, mettez à jour votre version de R
}

library(devtools)

if (!requireNamespace(hisafer, quietly = TRUE)) {
  devtools::install_github("kevinwolz/hisafer")
}

library(hisafer)

rm(list = ls())
