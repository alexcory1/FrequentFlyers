library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(lubridate)
library(rsconnect)
library(plotly)
library(circlize)
library(tibble)


render_plots <- function(input, output,filtered_data) {
  # one call to US flights dataset 
  # use as parameter to the function that manipulates the data for the plots 
  USflight_data <- read.csv("data/raw/US_Airline_Flight.csv", header = TRUE)
  
  
  
  output$price_plot <- renderPlotly({
    plot_price_distribution(price_distribution_data(USflight_data))
  })
  
  output$stacked_yearQuarter_plot <- renderPlotly({
    plot_stacked_yearQuarter(yearQuarter_count_data(USflight_data))
  })
  
  output$distance_fare_plot <- renderPlotly({
    plot_distance_vs_fare(distance_fare_data(USflight_data))
  })
  
  output$yearQuarter_count_plot <- renderPlotly({
    plot_yearQuarter_count(yearQuarter_count_data(USflight_data))
  })
  
  output$price_trend_plot <- renderPlotly({
    plot_price_trend(price_trend_data(USflight_data))
  })
  
  
  output$fare_by_carrier <- renderPlotly({
    plot_fare_by_carrier(price_distribution_data(USflight_data))
  })
  
  output$busiest_airports <- renderPlotly({
    plot_busiest_airports(busiest_airport_data(USflight_data))
  })
  
  output$airline_miles <- renderPlotly({
    plot_airline_miles(USflight_data)
  })
  
  
}

