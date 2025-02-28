library(ggplot2)
library(dplyr)
library(plotly)
library(circlize)
library(tibble)

# Price distribution of the dataset
plot_price_distribution <- function(data) {
  p <- ggplot(data, aes(x = fare)) +
    geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
    labs(title = "Flight Fare Distribution", x = "Fare (USD)", y = "Count") +
    theme_minimal()
  
  ggplotly(p)
}

# Bar chart of total flights by quarters
plot_flights_per_quarter <- function(data) {
  req(data$quarter)  # Ensures the 'quarter' column exists
  
  data %>%
    count(quarter) %>%
    mutate(quarter = factor(quarter, levels = 1:4, labels = c("Q1", "Q2", "Q3", "Q4"))) %>%
    plot_ly(x = ~quarter, y = ~n, type = "bar", marker = list(color = "#FF6666")) %>%
    layout(title = "Total Flights Per Quarter", xaxis = list(title = "Quarter"), 
           yaxis = list(title = "Total Flights (Log Scale)", type = "log"))
}

# Scatter plot of flight price by flight distance
plot_distance_vs_fare <- function(data) {
  # Fit a linear model
  fit <- lm(fare ~ nsmiles, data = data)
  
  # Generate predicted values
  trend_line <- data.frame(
    nsmiles = seq(min(data$nsmiles, na.rm = TRUE), max(data$nsmiles, na.rm = TRUE), length.out = 100)
  )
  trend_line$fare <- predict(fit, newdata = trend_line)
  
  # Create the scatter plot with trend line
  plot_ly(data, x = ~nsmiles, y = ~fare, type = "scatter", mode = "markers",
          marker = list(color = "green", size = 5, opacity = 0.6), name = "Data",
          showlegend = FALSE) %>%
    add_trace(data = trend_line, x = ~nsmiles, y = ~fare, type = "scatter", mode = "lines",
              line = list(color = "red", width = 3), name = "Trend Line", showlegend = FALSE) %>%
    layout(title = "Fare vs Distance",
           xaxis = list(title = "Distance (nsmiles)"),
           yaxis = list(title = "Fare (USD)"))
}


# Group bar chart of flight count by quarters per year
plot_yearQuarter_count <- function(data) {
  plot_ly(data, x = ~Year, y = ~flight_count, color = ~quarter, type = "bar") %>% 
    layout(title = "Total Flights Per Year & Quarter",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Total Flights"), 
           legend = list(title = list(text = "Quarter")))
}



