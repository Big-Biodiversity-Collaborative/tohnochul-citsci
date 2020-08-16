# Data Cleaning of Tucson TohonoChul Data
# Kathleen L Prudic
# klprudic@arizona.edu
# created 2020-08-16

# Remove wonton variables 
rm(list = ls())

# Load additional packages
library(tidyverse)
library(lubridate)

# Load data 
tohonochul_bflies <- read_csv(file = "data/2015-2019-eButt-Tohonochul.csv")

# Filter Andrew Hogan
tohonochul_bflies <- tohonochul_bflies %>%
  filter(observer == "Andrew Hogan")

# Filter to Tohonochul latitude and longitute 
# tohonochul: 32.338352, 32.340682, -110.982803, -110.979788
tohonochul_bflies <- tohonochul_bflies %>% 
  mutate(tohonochul = if_else(condition = between(latitude, 32.338352, 32.340682) &
                                between(longitude, -110.982803, -110.979788), 
                              true = TRUE, false = FALSE))

tohonochul_bflies <- tohonochul_bflies %>%
  filter(tohonochul == TRUE) %>%
  select(-tohonochul)

# stamen maps timing out, just use base R
plot(x = tohonochul_bflies$longitude, 
     y = tohonochul_bflies$latitude)

# Create table of unique species by families, save to file for later use
# data/tohonochul-species-unreconciled.csv

# Reconcile taxonomy (to be done later)

# Create table of reconciled species by families, save to file for later use
# data/tohonochul-species-reconciled.csv

# Calculate species richness by year, save to file for later use
# data/inat-species-richness-annual.csv

# Calculate average species accumulation through time 2015-2019

# Plot average species accumualation through time