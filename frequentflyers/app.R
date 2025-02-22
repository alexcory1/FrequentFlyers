library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(lubridate)

source("filter_year.R")
source("compute_flight_counts.R")

ui <- dashboardPage(
  dashboardHeader(title = "Frequent Flyers",
                  tags$li(
                    a(
                      href = "https://github.com/alexcory1/FrequentFlyers",
                      target = "_blank",
                      icon("github"),
                      style = "font-size: 30px; padding-top: 10px; padding-right: 10px;"
                    ),
                    class = "dropdown"
                  )
                  ),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Plots", tabName = "plots", icon = icon("plane")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(tabName = "map",
              fluidRow(
                box(width = 3,
                    sliderInput("flight_year", "Select Year Range", min = 2013, max = 2024, value = c(2023, 2024), step = 1, sep = ""),
                    textInput("airport_id", "Enter Airport Code:")
                ),
                box(width = 9, leafletOutput("map", height = "600px"))
              )
      ),
      tabItem(tabName = "home",
              div(tabName = 'header',
                  style = "display: flex;
                  justify-content: center;
                  align-items: center;
                  height: 20vh;
                  font-size: 40px
                  font-weight: bold
                  ",
                  h2("Welcome to Frequent Flyers"),
              ),
              div(tabName = "citation",
                  style = "display: flex; justify-content: center; align-items: center; height: 0vh; font-size: 24px",
                  p(HTML("Created By: <a href='https://www.linkedin.com/in/amcory' target='_blank'>Alex Cory</a>,
                         <a href='https://www.linkedin.com/in/jillian-egland-3302a721a/' target='_blank'>Jillian Egland</a>,
                         <a href='https://www.linkedin.com/in/xuan-wen-loo/' target='_blank'>Michelle Loo</a>,
                         <a href='https://www.linkedin.com/in/snehal-arla-1a1346261/' target='_blank'>Snehal Arla</a>."))
              ),
            ),
      tabItem(tabName = "plots", h2("Flight Data Summary")),
      tabItem(tabName = "about", h2("About This Application"))
    )
  )
)

server <- function(input, output, session) {

  flight_data <- reactive({ filter_year(input$flight_year) })

  filtered_data <- reactive({
    if (input$airport_id == "") {
      flight_data()
    } else {
      flight_data() %>%
        filter(airport_1 == toupper(input$airport_id) | airport_2 == toupper(input$airport_id))
    }
  })

  output$map <- renderLeaflet({
    flight_map_data <- compute_flight_counts(filtered_data()) %>%
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
      addPolylines(data = flight_map_data, lng = ~c(start_long, end_long), lat = ~c(start_lat, end_lat), color = "blue", weight = 1, opacity = 0.2) %>%
      addCircleMarkers(data = unique_airports, lng = ~long, lat = ~lat, color = "#355834", fillColor = "#355834", fillOpacity = 1, opacity = 1, label = ~airport, radius = ~log(total_flight_count)/1.5) %>%
      addLegend("bottomright", colors = c("#355834", "blue"), labels = c("Airport", "Flight Path"), title = "Legend")
  })
}

shinyApp(ui = ui, server = server)
