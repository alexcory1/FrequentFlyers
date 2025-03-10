library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(lubridate)
library(rsconnect)
library(plotly)
library(circlize)
library(tibble)

render_plots <- function(input, output) {
  
  # Render histogram for price distribution
  output$price_plot <- renderPlotly({
    plot_price_distribution(price_distribution_data())
  })
  
  # Render bar chart for total flights per month
  output$flights_per_month_plot <- renderPlotly({
    plot_flights_per_quarter(yearQuarter_count_data())
  })
  
  # Render stacked bar chart for total flights by quarter
  output$stacked_yearQuarter_plot <- renderPlotly({
    plot_stacked_yearQuarter(yearQuarter_count_data())
  })
  
  # Render scatter plot for flight fare by distance
  output$distance_fare_plot <- renderPlotly({
    plot_distance_vs_fare(distance_fare_data())
  })
  
  # Render grouped bar chart for total flights by quarter per year
  output$yearQuarter_count_plot <- renderPlotly({
    plot_yearQuarter_count(yearQuarter_count_data())
  })
}