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
price_distribution_data <- function(data) {
  #data <- load_USflight_data()
  data <- data %>% na.omit()
  
  # Handle outliers
  Q1 <- quantile(data$fare, 0.25)
  Q3 <- quantile(data$fare, 0.75)
  IQR_value <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR_value
  upper_bound <- Q3 + 1.5 * IQR_value
  
  price_distribution_data <- data %>% filter(fare >= lower_bound & fare <= upper_bound)
  return(price_distribution_data)
}

# For distance vs fare
distance_fare_data <- function(data) {
  #data <- load_USflight_data()
  distance_fare_data <- data %>% select(nsmiles, fare) %>% na.omit()
  return(distance_fare_data)
}

# For flight count by quarters per year
yearQuarter_count_data <- function(data) {
  #data <- load_USflight_data()
  quarter_info <- c("Q1: Jan-Mar" = "#d55e00", 
                    "Q2: Apr-Jun" = "#009e73", 
                    "Q3: Jul-Sep" = "#e69f00", 
                    "Q4: Oct-Dec" = "#56b4e9")
  
  yearQuarter_count_data <- data %>% group_by(Year, quarter) %>% summarise(flight_count = n(), .groups = "drop")
  
  yearQuarter_count_data$quarter <- factor(yearQuarter_count_data$quarter, levels = c(1,2,3,4), labels = names(quarter_info))
  
  return(yearQuarter_count_data)
}

# For flight price trend
price_trend_data <- function(data) {
  #data <- load_USflight_data()
  price_trend <- data %>%
    group_by(Year, quarter) %>%
    summarise(avg_fare = mean(fare, na.rm = TRUE), .groups = "drop")
  
  return(price_trend)
}

busiest_airport_data <- function(data){
  #data <- load_USflight_data() 
  airport_counts1 = data %>% group_by(airport_1) %>% summarize(flights_out = n())
  airport_counts1 = airport_counts1[order(airport_counts1$flights_out, decreasing=TRUE), ]
  
  airport_counts2 = data %>% group_by(airport_2) %>% summarize(flights_in = n())
  airport_counts2 = airport_counts2[order(airport_counts2$flights_in, decreasing=TRUE), ]
  
  airport_counts = merge(airport_counts1, airport_counts2, by.x="airport_1", by.y="airport_2")
  airport_counts$flights_total = airport_counts$flights_in + airport_counts$flights_out
  airport_counts = airport_counts[order(airport_counts$flights_total, decreasing=TRUE), ]
  airport_counts$airport_1 <- factor(airport_counts$airport_1, levels = airport_counts$airport_1)
  
  return (head(airport_counts, 15))
}
