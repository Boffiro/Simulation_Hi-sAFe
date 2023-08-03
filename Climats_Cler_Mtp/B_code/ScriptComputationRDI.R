library(SPEI)
library(tidyverse)

data(wichita) # test and dev Dataset

wichita$ETP <- SPEI::penman(Tmin = wichita$TMIN, Tmax = wichita$TMAX, wichita$AWND, tsun = wichita$TSUN, lat = 37.6475, z = 402.6, na.rm = T)
# Calcul ETP d'apres penman

data <- wichita

# Script calcul Reconnaiscance Drougth Index (based on Tigkas 2004)

# Inputs needed

# year ; months ; (for reference)
# scale of computation : to know of the indice must be computed for month, season or year
# precipitation : daily data of raining
# potential evapotranspiration : daily data of ETP


# 0. Setup

# Time Scale Choice

time.scale <- 3
# Time scale chosen, in months

# Starting and Ending Years
year.start <- 1990
year.end <- 2000
duration.year <- year.end - year.start

# 1. Somme des P journalieres

data.sum.P <- data %>%
  select(YEAR, MONTH, PRCP)

data.sum.P <- data.sum.P %>%
  group_by(YEAR) %>%
  filter(!(n() < 12)) %>%
  mutate(count = rep(1:(nrow(data.sum.P) %/% time.scale + 1),
    each = time.scale,
    length.out = 12
  )) %>%
  group_by(YEAR, count) %>%
  transmute(sum.PRCP = sum(PRCP)) %>%
  ungroup() %>%
  distinct()

# 2. Somme des PET journalieres

data.sum.PET <- data %>%
  select(YEAR, MONTH, ETP)

data.sum.PET <- data.sum.PET %>%
  group_by(YEAR) %>%
  filter(!(n() < 12)) %>%
  mutate(count = rep(1:(nrow(data.sum.PET) %/% time.scale + 1),
    each = time.scale,
    length.out = 12
  )) %>%
  group_by(YEAR, count) %>%
  transmute(sum.PET = sum(ETP)) %>%
  ungroup() %>%
  distinct()

# 3. Calcul ratio alpha

data.sum <- merge(data.sum.P, data.sum.PET, by = c("YEAR", "count"))

data.sum <- data.sum %>%
  group_by(YEAR) %>%
  mutate(RDI = sum.PRCP / sum.PET) %>%
  mutate(RDI.n = RDI / mean(RDI, na.rm = T)) %>%
  mutate(alpha = log(RDI)) %>%
  mutate(mean.alpha = mean(alpha, na.rm = T)) %>%
  mutate(sd.alpha = sd(alpha)) %>%
  mutate(RDI.st = (alpha - mean.alpha) / sd.alpha) %>%
  ungroup()

data.sum <- data.sum %>%
  mutate(diag.RDI = ifelse(data.sum$RDI > 0, "Non-Drought", NA)) %>%
  mutate(diag.RDI = ifelse(data.sum$RDI <= 0 & data.sum$RDI >= -1, "Near normal", diag.RDI)) %>%
  mutate(diag.RDI = ifelse(data.sum$RDI <= -1 & data.sum$RDI >= -1.5, "Moderate", diag.RDI)) %>%
  mutate(diag.RDI = ifelse(data.sum$RDI <= -1.5 & data.sum$RDI >= -2, "Severe", diag.RDI)) %>%
  mutate(diag.RDI = ifelse(data.sum$RDI <= -2, "Extreme", diag.RDI)) %>%
  filter(is.na(sum.PET) == F) %>%
  filter(is.na(sd.alpha) == F)
