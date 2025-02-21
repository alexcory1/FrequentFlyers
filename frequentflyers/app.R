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
source("compute_flight_counts.R")


ui <- fluidPage(
  tags$style(HTML("
    body {
      background-color: #AAD3DF;
    }
  ")),
  div(style = "background-color: #003249; padding: 10px; color: white; text-align: center;",
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

  textInput("airport_id",
            label = "Enter Airport Code: "),


  leafletOutput("map", height="600px"),

)

server <- function(input, output) {


  flight_data <- reactive({
    filter_year(input$flight_year)
  })

  filtered_data <- reactive({
    if (input$airport_id == "") {
      flight_data()  #Defaults to displaying all airports when no text in box
    } else {
      flight_data() %>%
        filter(airport_1 == toupper(input$airport_id) | airport_2 == toupper(input$airport_id))
    }
  })


  output$map <- renderLeaflet({
    flight_map_data <- compute_flight_counts(filtered_data())

    flight_map_data <- flight_map_data %>%
      mutate(total_flight_count = start_flight_count + end_flight_count)

    unique_airports <- flight_map_data %>%
      select(airport_1, start_long, start_lat, total_flight_count) %>%
      rename(airport = airport_1, long = start_long, lat = start_lat) %>%
      bind_rows(
        flight_map_data %>%
          select(airport_2, end_long, end_lat, total_flight_count) %>%
          rename(airport = airport_2, long = end_long, lat = end_lat)
      ) %>%
      group_by(airport, long, lat) %>%
      summarise(total_flight_count = sum(total_flight_count), .groups = "drop")

    leaflet() %>%
      addTiles() %>%
      addPolylines(data = flight_map_data,
                   lng = ~c(start_long, end_long),
                   lat = ~c(start_lat, end_lat),
                   color = "blue", weight = 1, opacity = 0.2) %>%
      addCircleMarkers(data = unique_airports,
                       lng = ~long, lat = ~lat,
                       color = "#355834",
                       fillColor = "#355834",
                       fillOpacity = 1,
                       opacity = 1,
                       label = ~airport,
                       radius = ~log(total_flight_count)/1.5) %>%
      addLegend("bottomright", colors = c("#355834", "blue"),
                labels = c("Airport", "Flight Path"), title = "Legend")

  })
}
shinyApp(ui = ui, server = server)
