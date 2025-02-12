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
  #br(), br(),

  #textInput("flight_year", label = "Year", value = c(2024:2022), width = NULL, placeholder = NULL)

  leafletOutput("map", height="900px"),

)

server <- function(input, output, session) {
  output$map <- renderLeaflet({

    source("filter_year.R")

    flight_year <- c(2024)
    filtered_years <- filter_year(flight_year)

    flight_map_data <- filtered_years %>%
      select(start_lat, start_long, end_lat, end_long) %>%
      na.omit()

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
