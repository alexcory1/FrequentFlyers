library(ggplot2)
library(dplyr)
library(plotly)
library(circlize)
library(tibble)
library(viridis)

# Price distribution of the dataset
plot_price_distribution <- function(data) {
  p <- ggplot(data, aes(x = fare)) +
    geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
    labs(title = "Flight Fare Distribution", x = "Fare (USD)", y = "Count") +
    theme_minimal()
  
  ggplotly(p)
}

# Stacked bar chart of total flights by quarters, stacked years
plot_stacked_yearQuarter <- function(data) {
  year_colors <- viridis_pal(option = "plasma")(13)
  names(year_colors) <- unique(data$Year)
  
  plot_ly(data, x = ~quarter, y = ~flight_count, 
          color = ~factor(Year), colors = year_colors, 
          type = "bar") %>%
    layout(title = "Total Flights Per Quarter",
           xaxis = list(title = "Quarter"),
           yaxis = list(title = "Total Flights"),
           barmode = "stack",
           legend = list(title = list(text = "Year")))
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
  quarter_info <- c("Q1: Jan-Mar" = "#fd7f6f", 
                    "Q2: Apr-Jun" = "#b2e061", 
                    "Q3: Jul-Sep" = "#ffb55a", 
                    "Q4: Oct-Dec" = "#8bd3c7")
  plot_ly(data, x = ~Year, y = ~flight_count, 
          color = ~quarter, colors = quarter_info, 
          type = "scatter", mode = "lines+markers") %>% 
    layout(title = "Total Flights Per Year & Quarter",
           xaxis = list(title = "Year"),
           yaxis = list(title = "Total Flights"), 
           legend = list(title = list(text = "Quarter")))
}



