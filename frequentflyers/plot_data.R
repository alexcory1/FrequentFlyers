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
  quarter_info <- c("Q1: Jan-Mar" = "#fd7f6f", 
                    "Q2: Apr-Jun" = "#b2e061", 
                    "Q3: Jul-Sep" = "#ffb55a", 
                    "Q4: Oct-Dec" = "#8bd3c7")
  
  yearQuarter_count_data <- data %>% group_by(Year, quarter) %>% summarise(flight_count = n(), .groups = "drop")
  
  yearQuarter_count_data$quarter <- factor(yearQuarter_count_data$quarter, levels = c(1,2,3,4), labels = names(quarter_info))
  
  return(yearQuarter_count_data)
}
