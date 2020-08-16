# Data Cleaning of Tucson eButterfly Data
# Kathleen L Prudic
# klprudic@arizona.edu
# created 2020-08-09

# Remove wonton variables 
rm(list = ls())

# Load additional packages
library(tidyverse)
library(lubridate)

# Load data 
arizona_bflies <- read_csv(file = "data/2015-2019-eButt-Arizona.csv")

# Filter to Tucson latitude and longitute
# rectangle 1: 32.351802, 32.209744, -110.962849, -111.046889 
# rectangle 2: 32.260557, 32.209744, -110.841198, -110.962849    
arizona_bflies <- arizona_bflies %>% 
  mutate(rectangle1 = if_else(condition = between(latitude, 32.209744, 32.351802) &
                                between(longitude, -111.046889, -110.962849), 
                              true = TRUE, false = FALSE), 
         rectangle2 = if_else(condition = between(latitude, 32.209744, 32.260557) &
                                between(longitude, -110.962849, -110.841198), 
                              true = TRUE, false = FALSE)) %>%
  mutate(tucson = rectangle1 | rectangle2)

tucson_bflies <- arizona_bflies %>%
  filter(tucson == TRUE) %>%
  select(-rectangle1, -rectangle2, -tucson)

# stamen maps timing out, just use base R
plot(x = tucson_bflies$longitude, 
     y = tucson_bflies$latitude)

# Create table of unique species by families, save to file for later use
# data/ebutt-species-unreconciled.csv

# Reconcile taxonomy (to be done later)

# Create table of reconciled species by families, save to file for later use
# data/ebutt-species-reconciled.csv

# Calculate species richness by year, save to file for later use
# data/inat-species-richness-annual.csv

# Calculate average species accumulation through time 2015-2019

# Plot average species accumualation through time

# # Plot Tucson observations on map
# library(ggplot2)
# library(ggmap)
# 
# map_bounds <- c(floor(min(tucson_bflies$longitude)),
#                 floor(min(tucson_bflies$latitude)),
#                 ceiling(max(tucson_bflies$longitude)),
#                 ceiling(max(tucson_bflies$latitude)))
# names(map_bounds) <- c("left", "bottom", "right", "top")
# 
# tucson_map <- get_map(location = map_bounds, 
#                       source = "stamen", 
#                       maptype = "terrain-lines", # toner-lite
#                       color = "bw")
# obs_map <- ggmap(tucson_map) +
#   geom_point(data = tucson_bflies, mapping = aes(x = longitude, y = latitude), size = 3)
# print(obs_map)

