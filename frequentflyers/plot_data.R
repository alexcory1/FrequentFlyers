library(dplyr)
library(readr)

### Functions to load data from csv files ###
# Function to load US_Airline_Flight.csv
load_USflight_data <- function() {
  USflight_data <- read.csv("../data/raw/US_Airline_Flight.csv", header = TRUE)
  return(USflight_data)
}

## Add more functions to load other data


### Pre-processing data ###

# Preprocess price distribution
price_distribution_data <- function() {
  data <- load_USflight_data()
  price_distribution_data <- data %>% select(fare) %>% na.omit()
  return(price_distribution_data)
}
