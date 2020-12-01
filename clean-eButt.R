# Data Cleaning of Tucson eButterfly Data
# Kathleen L Prudic
# klprudic@arizona.edu
# created 2020-08-09

# Load additional packages
library(tidyverse)

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

# write tucson data to file
write_csv(x = tucson_bflies, path = "data/clean-tucson-eButt.csv")


