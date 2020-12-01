# Data Cleaning of Tucson iNaturalist Data
# Kathleen L Prudic
# klprudic@arizona.edu
# created 2020-08-09

# Load additional packages
library(tidyverse)
library(lubridate)

# Load data 
arizona_bflies <- read_csv(file = "data/inat-arizona.csv")

# Filter to 2015-2019
arizona_bflies <- arizona_bflies %>%
  filter(year(observed_on) %in% c(2015:2019))

# Filter to Tucson latitude and longitute
# rectangle 1: 32.351802, 32.209744, -110.962849, -111.046889 
# rectangle 2: 32.260557, 32.209744, -110.841198, -110.962849    
tucson_bflies <- arizona_bflies %>% 
  mutate(rectangle1 = if_else(condition = between(latitude, 32.209744, 32.351802) &
                                between(longitude, -111.046889, -110.962849), 
                              true = TRUE, false = FALSE), 
         rectangle2 = if_else(condition = between(latitude, 32.209744, 32.260557) &
                                between(longitude, -110.962849, -110.841198), 
                              true = TRUE, false = FALSE)) %>%
  mutate(tucson = rectangle1 | rectangle2)

tucson_bflies <- tucson_bflies %>%
  filter(tucson == TRUE) %>%
  select(-rectangle1, -rectangle2, -tucson)

# stamen maps timing out, just use base R
plot(x = tucson_bflies$longitude, 
     y = tucson_bflies$latitude)

# write tucson data to file
write_csv(x = tucson_bflies, path = "data/clean-inat-tucson.csv")

#Filter to Tohono Chul data
# rectangle 1:32.337348, 32.341631, -110.982794,  -110.978685
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
write_csv(x = tohono_bflies, path = "data/clean-inat-tohono.csv")


