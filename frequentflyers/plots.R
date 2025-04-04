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
  quarter_info <- c("Q1: Jan-Mar" = "#d55e00", 
                    "Q2: Apr-Jun" = "#009e73", 
                    "Q3: Jul-Sep" = "#e69f00", 
                    "Q4: Oct-Dec" = "#56b4e9")
  plot_ly(data, x = ~Year, y = ~flight_count, 
          color = ~quarter, colors = quarter_info, 
          type = "scatter", mode = "lines+markers") %>% 
    layout(title = "Total Flights Per Year & Quarter",
           xaxis = list(title = "Year",
                        tickmode = "array",
                        tickvals = unique(data$Year), 
                        showgrid = FALSE,
                        tickangle = -45),
           yaxis = list(title = "Total Flights"), 
           legend = list(title = list(text = "Quarter")))
}

# Line chart of price trend over time
plot_price_trend <- function(data) {
  plot_ly(data, x = ~paste(Year, quarter, sep = "-"), y = ~avg_fare, 
          type = "scatter", mode = "lines+markers", 
          line = list(shape = "spline", width = 2, color = "#1f77b4")) %>%
    layout(title = "Flight Price Trends Over Time",
           xaxis = list(title = "Year-Quarter", tickangle = 45),
           yaxis = list(title = "Average Fare (USD)", type = "log"), # Use log scale for better distribution
           hovermode = "x")
}

#Chord diagram for popular votes
plot_chord_diagram_routes <- function(data, top_n = 15) {
  library(circlize)
  circos.clear()
  
  
  route_data <- data %>%
    group_by(city1, city2) %>%
    summarise(total_passengers = sum(passengers, na.rm = TRUE)) %>%
    ungroup()
  
  
  top_routes <- route_data %>%
    arrange(desc(total_passengers)) %>%
    head(top_n)
  
  
  cities <- unique(c(top_routes$city1, top_routes$city2))
  matrix_data <- matrix(0, nrow = length(cities), ncol = length(cities),
                        dimnames = list(cities, cities))
  
  for (i in 1:nrow(top_routes)) {
    city_a <- top_routes$city1[i]
    city_b <- top_routes$city2[i]
    matrix_data[city_a, city_b] <- top_routes$total_passengers[i]
  }
  
  city_colors <- rand_color(length(cities), transparency = 0.3)
  names(city_colors) <- cities
  
 
  chordDiagram(matrix_data, grid.col = city_colors, transparency = 0.4,
               directional = TRUE, direction.type = "arrows",
               annotationTrack = "grid", preAllocateTracks = list(track.height = 0.1))
  
  
  circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
    sector.name <- get.cell.meta.data("sector.index")
    cleaned.name <- gsub("\\s*\\(.*\\)", "", sector.name)
    
    x_pos <- mean(get.cell.meta.data("xlim"))
    y_pos <- get.cell.meta.data("ylim")[1]
    
    circos.text(x = x_pos, 
                y = y_pos,  
                labels = cleaned.name, 
                facing = "clockwise",
                niceFacing = TRUE, 
                adj = c(0, 0.5), 
                cex = 0.7)
  }, bg.border = NA)
  
  gg <- ggplot() + theme_void()
  ggplotly(gg)
}

#heatmap 
plot_flight_price_heatmap <- function(data, top_n = 20) {
 
  heatmap_data <- data %>%
    group_by(city1, city2) %>%
    summarise(avg_fare = mean(fare, na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(avg_fare)) %>%
    head(top_n)  # Select top N
  
 
  p <- ggplot(heatmap_data, aes(x = city1, y = city2, fill = avg_fare)) +
    geom_tile(color = "white") +
    scale_fill_viridis_c(option = "plasma") +
    labs(title = "Heatmap of Flight Prices by Routes",
         x = "Departure City",
         y = "Arrival City",
         fill = "Avg Fare (USD)") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggplotly(p) 
}

plot_fare_by_carrier <- function(data) {
  plot_ly(data, x = ~carrier_lg, y = ~fare, 
          type = "box", boxpoints = "outliers", jitter = 0.3, 
          pointpos = -1.8, marker = list(opacity = 0.5)) %>%
    layout(title = "Fare Distribution by Airline",
           xaxis = list(title = "Airline", automargin = TRUE),
           yaxis = list(title = "Fare (USD)", tickmode = "linear", tick0 = 0, dtick = 50))
}

plot_busiest_airports <- function(data){
  ggplot(data) +
    geom_bar(aes(x = airport_1, y = flights_total, fill = "Flights In"), stat = "identity") +
    geom_bar(aes(x = airport_1, y = flights_out, fill = "Flights Out"), stat = "identity") +
    scale_fill_manual(values = c("Flights In" = "#22aaa1", "Flights Out" = "#3e505b")) +
    labs(title = "Total Flights per Airport",
         x = "Airport",
         y = "Number of Flights",
         fill = "Flight Type") +
    theme_minimal() 
}
