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
  
  output$price_plot <- renderPlotly({
    plot_price_distribution(price_distribution_data())
  })
  
  output$stacked_yearQuarter_plot <- renderPlotly({
    plot_stacked_yearQuarter(yearQuarter_count_data())
  })
  
  output$distance_fare_plot <- renderPlotly({
    plot_distance_vs_fare(distance_fare_data())
  })
  
  output$yearQuarter_count_plot <- renderPlotly({
    plot_yearQuarter_count(yearQuarter_count_data())
  })
  
  output$price_trend_plot <- renderPlotly({
    plot_price_trend(price_trend_data())
  })
  
  output$chord_plot <- renderPlot({
    circos.clear()
    plot_chord_diagram_routes(price_distribution_data(), input$top_routes)
  })
  
  output$price_heatmap <- renderPlotly({
    plot_flight_price_heatmap(price_distribution_data())
  })
  
  output$fare_by_carrier <- renderPlotly({
    plot_fare_by_carrier(price_distribution_data())
  })
  
}

