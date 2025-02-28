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

# For price distribution
price_distribution_data <- function() {
  data <- load_USflight_data()
  price_distribution_data <- data %>% select(fare) %>% na.omit()
  return(price_distribution_data)
}

# For distance vs fare
distance_fare_data <- function() {
  data <- load_USflight_data()
  distance_fare_data <- data %>% select(nsmiles, fare) %>% na.omit()
  return(distance_fare_data)
}

# For flight count by quarters per year
yearQuarter_count_data <- function() {
  data <- load_USflight_data()
  yearQuarter_count_data <- data %>% group_by(Year, quarter) %>% summarise(flight_count = n(), .groups = "drop")
  
  yearQuarter_count_data$quarter <- factor(yearQuarter_count_data$quarter, levels = c(1,2,3,4))
  
  return(yearQuarter_count_data)
}
