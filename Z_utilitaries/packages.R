
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

library(hisafer)
library(tidyverse)
library(precintcon)
library(SPEI)
library(styler)

rm(list = ls())