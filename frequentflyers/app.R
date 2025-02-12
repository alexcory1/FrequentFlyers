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
library(maps)
library(leaflet)
library(lubridate)
library(rsconnect)
library(shiny)


US_Airline_Flight <- read.csv("../data/raw/US_Airline_Flight.csv", header=TRUE)
geocode_tags <- read.csv("../data/raw/airport-codes-geocoded.csv", sep=";")
geous <- geocode_tags[geocode_tags$Country.Code == "US", ]

US_Airline_Flight <- US_Airline_Flight %>%
  left_join(geous, by = c("airport_1" = "Airport.Code")) %>%
  rename(start_lat = Latitude, start_long = Longitude)

US_Airline_Flight <- US_Airline_Flight %>%
  left_join(geous, by = c("airport_2" = "Airport.Code")) %>%
  rename(end_lat = Latitude, end_long = Longitude)

flight_year <- c(2024:2022)

filter_year <- function(flight_year) {
  filtered_years <- US_Airline_Flight[US_Airline_Flight$Year == flight_year, ]
  return(filtered_years)
}

filtered_years <- filter_year(flight_year)

flight_map_data <- filtered_years %>%
  select(start_lat, start_long, end_lat, end_long) %>%
  na.omit()



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
  leafletOutput("map", height="900px"),

)

server <- function(input, output, session) {
  output$map <- renderLeaflet({




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
