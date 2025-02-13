#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(ggplot2)
library(dplyr)
library(leaflet)
library(lubridate)
library(rsconnect)
library(shiny)
source("filter_year.R")


ui <- fluidPage(
  tags$style(HTML("
    body {
      background-color: #AAD3DF;
    }
  ")),
  div(style = "background-color: #2C3E50; padding: 10px; color: white; text-align: center;",
      h1("Frequent Flyers", style = "margin: 0;"),
      h2("US Flight Map")
  ),

  sliderInput("flight_year",
              label = "Select Year Range",
              min = 2013,
              max = 2024,
              value = c(2023, 2024),
              step = 1,
              sep = ""),
  leafletOutput("map", height="700px"),

)

server <- function(input, output, session) {
  output$map <- renderLeaflet({

    flight_map_data <- filter_year(input$flight_year)

    leaflet() %>%
      addTiles() %>%
      addPolylines(data = flight_map_data,
                   lng = ~c(start_long, end_long),
                   lat = ~c(start_lat, end_lat),
                   color = "blue", weight = 1, opacity = 0.5) %>%
      addCircleMarkers(data = flight_map_data,
                       lng = ~start_long, lat = ~start_lat,
                       color = "red", radius = 3, label = ~paste("Start: (", start_lat, ",", start_long, ")")) %>%
      addCircleMarkers(data = flight_map_data,
                       lng = ~end_long, lat = ~end_lat,
                       color = "green", radius = 3, label = ~paste("End: (", end_lat, ",", end_long, ")")) %>%
      addLegend("bottomright", colors = c("red", "green", "blue"),
                labels = c("Start Airport", "End Airport", "Flight Path"), title = "Legend")
  })
}
shinyApp(ui = ui, server = server)
