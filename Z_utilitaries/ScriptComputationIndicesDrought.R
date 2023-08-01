library(tidyverse)
library(precintcon)
library(SPEI)

# Script computation drought indices

# Formating daily data of rainfall to be used by package precintcon

setwd("/Users/fsoulard/Documents/Simulations_Hi-sAFe/ClimatsClerMtp/Z_meteo/")

data <- read.csv2(file = "ClickPickCLER19802020.csv", sep = ",")

for (col in names(data)) {
  if (!is.numeric(data[[col]])) {
    data[[col]] <- as.numeric(data[[col]])
  }
}

rm(col)

####

data.precintcon <- data %>%
  select(YEAR, MONTH, JOUR, RR) %>%
  rename("year" = YEAR, "month" = MONTH, "day" = JOUR, "precipitation" = RR)

data.precintcon.formated <- data.precintcon %>%
  select(year, month) %>%
  distinct()

exemple <- precintcon::daily

matrix <- matrix(nrow = nrow(data.precintcon.formated), ncol = 31)
colnames(matrix) <- list("d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8", "d9", "d10", "d11", "d12", "d13", "d14", "d15", "d16", "d17", "d18", "d19", "d20", "d21", "d22", "d23", "d24", "d25", "d26", "d27", "d28", "d29", "d30", "d31")

data.precintcon.formated <- cbind(data.precintcon.formated, as.data.frame(matrix))

for (i in 1:nrow(data.precintcon)) {
  for (j in 1:31) {
    if (length(data.precintcon[data.precintcon$year == data.precintcon$year[i] & data.precintcon$month == data.precintcon$month[i] & data.precintcon$day == j, "precipitation"]) == 0) {
      data.precintcon.formated[data.precintcon.formated$year == data.precintcon$year[i] & data.precintcon.formated$month == data.precintcon$month[i], j + 2] <- NA
    } else {
      data.precintcon.formated[data.precintcon.formated$year == data.precintcon$year[i] & data.precintcon.formated$month == data.precintcon$month[i], j + 2] <- data.precintcon[data.precintcon$year == data.precintcon$year[i] & data.precintcon$month == data.precintcon$month[i] & data.precintcon$day == j, "precipitation"]
    }
  }
}

rm(list = c("i", "j", "matrix"))

# Computation of drought indices

# precintcon::

data.precintcon.formated.daily <- precintcon::as.daily(data.precintcon.formated)

# Computation normal
precintcon.pn.results <- precintcon::pn(object = data.precintcon.formated.daily)
precintcon.pn.results.season <- precintcon::pn(object = data.precintcon.formated.daily, scale = "s")

# Computation SPI
precintcon.SPI.monthly <- precintcon::spi(data.precintcon.formated.daily)

precintcon.SPI.monthly <- data.frame(precintcon.SPI.monthly)

precintcon.SPI.monthly <- precintcon.SPI.monthly %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.monthly$spi > 0, "Non-Drought", NA)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.monthly$spi <= 0 & precintcon.SPI.monthly$spi >= -1, "Near normal", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.monthly$spi <= -1 & precintcon.SPI.monthly$spi >= -1.5, "Moderate", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.monthly$spi <= -1.5 & precintcon.SPI.monthly$spi >= -2, "Severe", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.monthly$spi <= -2, "Extreme", diag.SPI))

precintcon.SPI.yearly <- precintcon::spi.per.year(data.precintcon.formated.daily)

precintcon.SPI.yearly <- data.frame(precintcon.SPI.yearly)

precintcon.SPI.yearly <- precintcon.SPI.yearly %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.yearly$spi > 0, "Non-Drought", NA)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.yearly$spi <= 0 & precintcon.SPI.yearly$spi >= -1, "Near normal", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.yearly$spi <= -1 & precintcon.SPI.yearly$spi >= -1.5, "Moderate", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.yearly$spi <= -1.5 & precintcon.SPI.yearly$spi >= -2, "Severe", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(precintcon.SPI.yearly$spi <= -2, "Extreme", diag.SPI))

# Computation RAI
precintcon.RAI <- precintcon::rai(data.precintcon.formated.daily)
# precintcon.RAI <- precintcon::

#####

# Computation SPEI

data.SPEI <- data %>%
  select(YEAR, MONTH, JOUR, RR) %>%
  rename("year" = YEAR, "month" = MONTH, "day" = JOUR, "precipitation" = RR)

SPEI.SPI.daily <- SPEI::spi(
  data = data.SPEI$precipitation,
  scale = 3,
  # kernel = ,
  keep.x = T,
  verbose = T
)

SPEI.SPI.daily <- data.frame(data.SPEI,
  SPEI.SPI = SPEI.SPI.daily[["fitted"]]
)

SPEI.SPI.daily <- SPEI.SPI.daily %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.daily$SPEI.SPI > 0, "Non-Drought", NA)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.daily$SPEI.SPI <= 0 & SPEI.SPI.daily$SPEI.SPI >= -1, "Near normal", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.daily$SPEI.SPI <= -1 & SPEI.SPI.daily$SPEI.SPI >= -1.5, "Moderate", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.daily$SPEI.SPI <= -1.5 & SPEI.SPI.daily$SPEI.SPI >= -2, "Severe", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.daily$SPEI.SPI <= -2, "Extreme", diag.SPI))

####

data.SPEI.monthly <- data.SPEI %>%
  group_by(year, month) %>%
  transmute(precipitation.monthly = mean(precipitation)) %>%
  ungroup() %>%
  distinct()

SPEI.SPI.monthly <- SPEI::spi(
  data = data.SPEI.monthly$precipitation.monthly,
  scale = 3,
  # kernel = ,
  keep.x = T,
  verbose = T
)

SPEI.SPI.monthly <- data.frame(data.SPEI.monthly,
  SPEI.SPI = SPEI.SPI.monthly[["fitted"]]
)

SPEI.SPI.monthly <- SPEI.SPI.monthly %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.monthly$SPEI.SPI > 0, "Non-Drought", NA)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.monthly$SPEI.SPI <= 0 & SPEI.SPI.monthly$SPEI.SPI >= -1, "Near normal", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.monthly$SPEI.SPI <= -1 & SPEI.SPI.monthly$SPEI.SPI >= -1.5, "Moderate", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.monthly$SPEI.SPI <= -1.5 & SPEI.SPI.monthly$SPEI.SPI >= -2, "Severe", diag.SPI)) %>%
  mutate(diag.SPI = ifelse(SPEI.SPI.monthly$SPEI.SPI <= -2, "Extreme", diag.SPI))
