
library(tidyverse)
library(SPEI)
library(precintcon)

## 1.2. Weekly Data

### 1.2.1.

## 1.3. Monthly Data

### 1.3.1 Mise en forme 

setwd("/Users/fsoulard/Documents/Simulations_Hi-sAFe/ClimatsClerMtp/Z_meteo/")

data.monthly <- read.csv2(file = "ClickPickCLER19802020.csv", sep = ",")

for (col in names(data.monthly)) {
  if (!is.numeric(data.monthly[[col]])) {
    data.monthly[[col]] <- as.numeric(data.monthly[[col]])
  }
}

rm(col)

data.monthly$DOY <- as.integer(format(as.Date(paste(data.monthly$YEAR, data.monthly$MONTH, data.monthly$JOUR, sep = "-")), "%j"))
data.monthly <- data.monthly[, c("DOY", setdiff(colnames(data.monthly), "DOY"))]

data.monthly$DATE <- as.Date(paste(data.monthly$JOUR, data.monthly$MONTH, data.monthly$YEAR, sep = "-"), format = "%d-%m-%Y")
data.monthly$MONTH.YEAR <- as.Date(paste(data.monthly$YEAR, data.monthly$MONTH, "01", sep = "-"), format = "%Y-%m-%d")

data.monthly <- data.monthly[ -1,]
data.monthly <- data.monthly[ -nrow(data.monthly),]

### 1.3.2. Calcul des moyennes mensuelles 

data.monthly <- data.monthly %>%
  select(-JOUR, -DATE, -DOY) %>%
  group_by(MONTH.YEAR) %>%
  mutate(TX.monthly = mean(TX),
         TN.monthly = mean(TN),
         UX.monthly = mean(UX),
         UN.monthly = mean(UN),
         RR.monthly = sum(RR)) %>%
  select(MONTH.YEAR, MONTH, YEAR, TX.monthly, TN.monthly, UX.monthly, UN.monthly, RR.monthly) %>%
  distinct() %>%
  ungroup()

### 1.3.3. Computaion indices 

# Computation SPI

data.monthly.SPI <- data.monthly %>%
  select(YEAR, MONTH, RR.monthly) %>%
  rename("year" = YEAR, "month" = MONTH, "precipitation" = RR.monthly)

data.monthly.SPI <- as.data.frame(data.monthly.SPI)
data.monthly.SPI <- precintcon::as.precintcon.monthly(data.monthly.SPI)

pni <- precintcon::pn(object = data.monthly.SPI, scale = "m")


data.monthly.SPI <- data.monthly %>%
  select(YEAR, MONTH, JOUR, RR) %>%
  rename("year" = YEAR, "month" = MONTH, "day" = JOUR, "precipitation" = RR)



# Computation PNI

test <- precintcon::monthly
class(test) 

class(test$precipitation) 



















SPI <- spi(data = data.monthly.SPI$RR.monthly, 
           scale = 3)

data.monthly$SPI <- SPI[["fitted"]]

data.monthly$Diag <- ifelse(between(data.monthly$SPI, left = -0.9999, right = 0), yes = "Mild", no = "NA")
data.monthly$Diag <- ifelse(between(data.monthly$SPI, left = -1.4999, right = -1), yes = "Moderate", no = data.monthly$Diag)
data.monthly$Diag <- ifelse(between(data.monthly$SPI, left = -1.9999, right = -1.50), yes = "Severe", no = data.monthly$Diag)
data.monthly$Diag <- ifelse(between(data.monthly$SPI, left = -10000, right = -2), yes = "Extreme", no = data.monthly$Diag)


spi <- precintcon::spi(object = , period = , distribution = )

precintcon::daily

head(precintcon::monthly)
typeof(precintcon::monthly)


temp <- as.list(data.monthly.SPI)

data.monthly.SPI <- data.monthly %>%
  select(YEAR, MONTH, JOUR, RR) %>%
  rename("year" = YEAR, "month" = MONTH, "precipitation" = RR)

data.monthly.SPI <- precintcon::as.precintcon.monthly(data.monthly.SPI)


class(temp$year)
typeof(temp$year)
range(temp$year)

precintcon.spi.analysis(precintcon::monthly)
precintcon::read.data(file = "temp.csv", sep = ",", dec = ".", header = T, na.value = NA)

precintcon::spi(object = test)
precintcon::spi(object = temp)

head(precintcon::daily)











