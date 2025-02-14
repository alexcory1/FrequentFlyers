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

  textInput("airport_id",
            label = "Enter Airport Code: "),


  leafletOutput("map", height="700px"),

)

server <- function(input, output, session) {


  flight_data <- reactive({
    filter_year(input$flight_year)
  })

  filtered_data <- reactive({
    if (input$airport_id == "") {
      flight_data()  #Defaults to displaying all airports when no text in box
    } else {
      flight_data() %>%
        filter(airport_1 == input$airport_id | airport_2 == input$airport_id)
    }
  })


  output$map <- renderLeaflet({
    flight_map_data <- compute_flight_counts(filtered_data())

    #flight_map_data <- filter_year(input$flight_year)
    #View(flight_map_data)

    leaflet() %>%
      addTiles() %>%
      addPolylines(data = flight_map_data,
                   lng = ~c(start_long, end_long),
                   lat = ~c(start_lat, end_lat),
                   color = "blue", weight = 1, opacity = 0.2) %>%
      addCircleMarkers(data = flight_map_data,
                       lng = ~start_long, lat = ~start_lat,
                       color = "green", label = ~airport_1,
                       radius = ~log(start_flight_count)) %>%
      addCircleMarkers(data = flight_map_data,
                       lng = ~end_long, lat = ~end_lat,
                       color = "red", label = ~airport_2,
                       radius = ~log(end_flight_count)) %>%
      addLegend("bottomright", colors = c("green", "red", "blue"),
                labels = c("Start Airport", "End Airport", "Flight Path"), title = "Legend")
  })
}
shinyApp(ui = ui, server = server)
