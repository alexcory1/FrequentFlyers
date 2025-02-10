#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)


ui <- fluidPage(
  titlePanel("US Flight Map"),
  leafletOutput("map")
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
