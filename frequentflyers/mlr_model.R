###
# Problem to solve:
# Randomly splitting train and test may cause one of them having airport codes that the other does not have.
#
# The current code could only predict routes with exact quarter, departure and arrival airports combination in the dataset.
# Consider calculating miles for new unseen combinations?
###

library(tidyverse)
library(caret)

us_data <- read.csv("./data/raw/US_Airline_flight.csv")

# Features that I think should take into considerate
us_data <- us_data %>%
  select(quarter, airport_1, airport_2, nsmiles, passengers, large_ms, fare_lg, lf_ms, fare_low, fare) %>%
  drop_na()

us_data$airport_1 <- as.factor(us_data$airport_1)
us_data$airport_2 <- as.factor(us_data$airport_2)

# Split 80% training and 20% testing
set.seed(123)
trainIndex <- createDataPartition(us_data$fare, p = 0.8, list = FALSE)
trainData <- us_data[trainIndex, ]
testData <- us_data[-trainIndex, ]

# Find missing airport codes in testData
missing_airports_1 <- setdiff(levels(df$airport_1), levels(testData$airport_1))
missing_airports_2 <- setdiff(levels(df$airport_2), levels(testData$airport_2))

# Train model
mlr_model <- lm(fare ~ ., data = trainData)

# Test model
## TODO

# Function to take user input and predict price
predict_flight_price <- function(quarter, departure_airport, arrival_airport) {
  # Check if the entered airport codes exist in the dataset
  if (!(departure_airport %in% us_data$airport_1) | !(arrival_airport %in% us_data$airport_2)) {
    return("Airport codes not found in the dataset.")
  }
  
  # Get average values 
  # TODO#1: change to range, maybe display using a graph?
  avg_values <- us_data %>%
    filter(airport_1 == departure_airport & airport_2 == arrival_airport & quarter == quarter) %>%
    summarise(across(c(nsmiles, passengers, large_ms, fare_lg, lf_ms, fare_low), ~ mean(.x, na.rm = TRUE)))
  
  # Check if the input combination exists in the dataset
  if (nrow(avg_values) == 0 || any(is.na(avg_values))) {
    return("No historical data available for this route and quarter.")
  }
  
  input_data <- data.frame(
    quarter = as.integer(quarter),
    airport_1 = factor(departure_airport, levels = levels(us_data$airport_1)),
    airport_2 = factor(arrival_airport, levels = levels(us_data$airport_2)),
    nsmiles = avg_values$nsmiles,
    passengers = avg_values$passengers,
    large_ms = avg_values$large_ms,
    fare_lg = avg_values$fare_lg,
    lf_ms = avg_values$lf_ms,
    fare_low = avg_values$fare_low
  )
  predicted_price <- predict(mlr_model, input_data)
  
  # Just in case something went wrong and outputs NaN
  if (is.na(predicted_price)) {
    return("Prediction failed. Insufficient data for this route.")
  }
  
  # TODO: show range with graph (refer to TODO#1)
  return(paste("Predicted Price: $", round(predicted_price, 2)))
}

# Prompt user inputs
# TODO#2: consider other input variables
quarter_input <- as.integer(readline(prompt = "Enter quarter (1-4): "))
departure_airport_input <- readline(prompt = "Enter departure airport code: ")
arrival_airport_input <- readline(prompt = "Enter arrival airport code: ")

predicted_price <- predict_flight_price(quarter_input, departure_airport_input, arrival_airport_input)
print(predicted_price)
