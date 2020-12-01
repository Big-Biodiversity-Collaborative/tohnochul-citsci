# Data Cleaning of Tucson eButterfly Data
# Kathleen L Prudic
# klprudic@arizona.edu
# created 2020-08-09

# Load additional packages
library(tidyverse)
library(lubridate)

#Load data
ebutt_data <- read_csv(file = "data/ebutt-all.csv")

# Filter data to just Arizona
ebutt_arizona <- ebutt_data %>%
  filter(`Province/State` == "Arizona")

# Change column names and drop unwanted columns
ebutt_arizona <- ebutt_arizona %>%
  rename(latitude = Latitude, longitude = Longitude, state = `Province/State`,
         obs_date = `Date Observed`, family = Family, genus = Genus, 
         country = Country, species = Species, observer = Observer) %>%
  select(family, genus, species, obs_date, latitude, longitude, state, country,
         observer)

# Filter data to 2015 - 2019
ebutt_arizona <- ebutt_arizona %>%
  filter(year(obs_date) %in% c(2015:2019))

# Filter to Tucson latitude and longitude with Tohono Chul data
# rectangle 1: 32.351802, 32.209744, -110.962849, -111.046889 
# rectangle 2: 32.260557, 32.209744, -110.841198, -110.962849    
arizona_bflies <- ebutt_arizona %>% 
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

# Write csv for Tucson data
write_csv(x = tucson_bflies, path = "data/clean-ebutt-tucson.csv")

#Filter to Tohono Chul data
# rectangle 1: 32.337348, 32.341631, -110.982794,  -110.978685
tohono_bflies <- tucson_bflies %>%
  mutate(tohono = if_else(condition = between(latitude, 32.337348, 32.341631) &
                            between(longitude, -110.982794, -110.978685),
                          true = TRUE, false = FALSE))

tohono_bflies <- tohono_bflies %>%
  filter(tohono == TRUE) %>%
  select(-tohono)

# stamen maps timing out, just use base R
plot(x = tohono_bflies$longitude, 
     y = tohono_bflies$latitude)

# Write csv for Tohono data
write_csv(x = tohono_bflies, path = "data/clean-ebutt-tohono.csv")
