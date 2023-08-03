# Script Analyse de donnees meteo 

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(SPEI)

# 1.4. Annual Data

# 1.4.1 Mise en forme

# Read data from CSV file into the data frame 'data.annual'
data.annual <- read.csv2(file = "ClickPickCLER19802020.csv", sep = ",")

# Convert non-numeric columns in 'data.annual' to numeric type
for (col in names(data.annual)) {
  if (!is.numeric(data.annual[[col]])) {
    data.annual[[col]] <- as.numeric(data.annual[[col]])
  }
}

rm(col)

# Calculate the Day of Year (DOY) based on YEAR, MONTH, and JOUR, and rearrange columns
data.annual$DOY <- as.integer(format(as.Date(paste(data.annual$YEAR, data.annual$MONTH, data.annual$JOUR, sep = "-")), "%j"))
data.annual <- data.annual[, c("DOY", setdiff(colnames(data.annual), "DOY"))]

# Remove the first and last rows from 'data.annual'
data.annual <- data.annual[-1,]
data.annual <- data.annual[-nrow(data.annual),]

# 1.4.2. Calcul des moyennes annuelles 

# Calculate the annual means of selected variables using dplyr functions
data.annual <- data.annual %>%
  select(-JOUR, -MONTH, -DOY) %>%
  group_by(YEAR) %>%
  mutate(TX.annual = mean(TX),
         TN.annual = mean(TN),
         UX.annual = mean(UX),
         UN.annual = mean(UN),
         RR.annual = sum(RR)) %>%
  ungroup() %>%
  mutate(mean.RR.annual = mean(RR.annual),
         Year.Wetness = ifelse(RR.annual > mean(RR.annual), "WET", "DRY"))

# Distinct annual means
data.annual <- data.annual %>%
  select(YEAR, TX.annual, TN.annual, UX.annual, UN.annual, RR.annual, Year.Wetness) %>%
  distinct()

# 1.4.3. Computation Indices

# Computing quantiles
quantile <- quantile(data.annual$RR.annual, probs = seq(.0, .9, by = .05))
quantile <- data.frame(quantile = names(quantile), 
                       value = as.numeric(quantile))

data.annual <- data.annual %>%
  mutate(Drougth.Severity.quantile = ifelse(RR.annual <= quantile$value[quantile$quantile == "10%"], "serious", "NA")) %>%
  mutate(Drougth.Severity.quantile = ifelse(RR.annual <= quantile$value[quantile$quantile == "5%"], "severe", "NA"))

# 2. Plotting of Data

# 2.1 T max

# Plot T max over the years with a linear regression line
ggplot(data = data.annual, aes(x = YEAR)) +
  geom_point(aes(y = as.numeric(TX.annual))) +
  geom_smooth(method = "lm", aes(y = as.numeric(TX.annual))) +
  theme_minimal() + 
  scale_x_continuous(name = "YEAR",
                     minor_breaks = seq(1980, 2020),
                     breaks = seq(1980, 2020, by = 5)) +
  scale_y_continuous(name = "T max (°C)", 
                     limits = c(10, 25))

# 2.2 T min

# Plot T min over the years with a linear regression line
ggplot(data = data.annual, aes(x = YEAR)) +
  geom_point(aes(y = as.numeric(TN.annual))) +
  geom_smooth(method = "lm", aes(y = as.numeric(TN.annual))) +
  theme_minimal() + 
  scale_x_continuous(name = "YEAR",
                     minor_breaks = seq(1980, 2020),
                     breaks = seq(1980, 2020, by = 5)) +
  scale_y_continuous(name = "T min (°C)") 

# 2.3 Relative Humid

# Plot Relative Humidity (RH) max over the years with a linear regression line
ggplot(data = data.annual, aes(x = YEAR)) +
  geom_point(aes(y = as.numeric(UX.annual))) +
  geom_smooth(method = "lm", aes(y = as.numeric(UX.annual))) +
  theme_minimal() + 
  scale_x_continuous(name = "YEAR",
                     minor_breaks = seq(1980, 2020),
                     breaks = seq(1980, 2020, by = 5)) +
  scale_y_continuous(name = "RH max %") 

# Plot Relative Humidity (RH) min over the years with a linear regression line
ggplot(data = data.annual, aes(x = YEAR)) +
  geom_point(aes(y = as.numeric(UN.annual))) +
  geom_smooth(method = "lm", aes(y = as.numeric(UN.annual))) +
  theme_minimal() + 
  scale_x_continuous(name = "YEAR",
                     minor_breaks = seq(1980, 2020),
                     breaks = seq(1980, 2020, by = 5)) +
  scale_y_continuous(name = "RH min %") 

# 2.4 Rainfall

# Plot Rainfall over the years with a linear regression line
ggplot(data = data.annual, aes(x = YEAR)) +
  geom_point(aes(y = as.numeric(RR.annual), color = Year.Wetness)) +
  geom_smooth(method = "lm", aes(y = as.numeric(RR.annual))) +
  theme_minimal() + 
  scale_x_continuous(name = "YEAR",
                     minor_breaks = seq(1980, 2020),
                     breaks = seq(1980, 2020, by = 5)) +
  scale_y_continuous(name = "Rainfall (mm)")

