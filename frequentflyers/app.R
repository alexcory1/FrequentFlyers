library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(lubridate)
library(rsconnect)
library(plotly)
library(circlize)
library(tibble)

#This loads in the other functions to be used down the line
#Split into multiple R scripts for readability and collaboration 
source("filter_year.R")
source("compute_flight_counts.R")
source("plots.R")
source("plot_data.R")
source("render_plots.R")

#This is the main UI code These are often split into ui.r and app.r
#This section is responsible for all UI elements
ui <- dashboardPage(
  #This is the header that has the name and github link at the top
  dashboardHeader(title = "Frequent Flyers",
                  tags$li(
                    a(
                      href = "https://github.com/alexcory1/FrequentFlyers",
                      target = "_blank",
                      icon("github"),
                      style = "font-size: 30px; padding-top: 5px; padding-right: 10px;"
                    ),
                    class = "dropdown"
                  )
                  ),

  #Sidebar - menuItems are the tabs
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Map", tabName = "map", icon = icon("map")),
      menuItem("Plots", tabName = "plots", icon = icon("plane")),
      menuItem("Price Prediction", tabName = "pricePrediction", icon = icon("dollar-sign")),
      menuItem("About", tabName = "about", icon = icon("info-circle"))
    )
  ),

  #This is the UI for the map page
  #tabItem takes in the tabName from the menuItem above
  #tabItem takes in all of the standard shiny code for the page 
  #To make a new page, simply add a new tabItem that contains the UI elements for said page
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
                  height: 15vh; 
                  font-size: 40px;
                  font-weight: bold
                  ",
                  h2("Welcome to Frequent Flyers"),
              ),
              div(tabName = "citation", 
                  style = "display: flex; justify-content: center; align-items: center; height: auto; font-size: 20px",
                  p(HTML("Created By: <a href='https://www.linkedin.com/in/amcory' target='_blank'>Alex Cory</a>,
                         <a href='https://www.linkedin.com/in/jillian-egland-3302a721a/' target='_blank'>Jillian Egland</a>,
                         <a href='https://www.linkedin.com/in/xuan-wen-loo/' target='_blank'>Michelle Loo</a>,
                         <a href='https://www.linkedin.com/in/snehal-arla-1a1346261/' target='_blank'>Snehal Arla</a>."))
              ),
              fluidRow(
                box(width = 4, height = "auto", 
                    h2("Dataset Overview"),
                      tags$ul(
                        tags$li("90262 data points "),
                        tags$li("24 variables"),
                        tags$li("xx airports ")
                      ))
              ),
              
              
          
              
              
              
          ),#end of home tab 
      tabItem(tabName = "plots",
              h2("Flight Data Summary"),
              fluidRow(
                # 3 plots per row for box width = 4
                box(width = 4, height = "auto", plotlyOutput("price_plot", width = "100%")),
                box(width = 4, height = "auto", plotlyOutput("stacked_yearQuarter_plot", width = "100%")),
              ),
              fluidRow(
                box(width = 12, height = "auto", plotlyOutput("fare_by_carrier", width = "100%"))
              ),
              fluidRow(
                # 2 plots per row for box width = 6
                box(height = "auto", plotlyOutput("distance_fare_plot", width = "100%")),
                box(height = "auto", plotlyOutput("yearQuarter_count_plot", width = "100%"))
              ),
              fluidRow(
                box(width = 12, height = "auto", plotlyOutput("price_trend_plot", width = "100%"))
              ),
              fluidRow(
                box(width = 12, height = "auto", 
                    h4("Chord Diagram: Popular Routes"),
                    plotOutput("chord_plot", height = "600px"))  
              ),
              fluidRow(
                box(width = 12, height = "auto",
                    h4("Heatmap of Flight Prices by Routes"),
                    plotlyOutput("price_heatmap", width = "100%"))
              )

              ),
      tabItem(tabName = "pricePrediction",
              h2("Future Flight Prices Analysis"),
              
      ),

      tabItem(tabName = "about",
              h2("About Frequent Flyers"),
              br(),
              
              h4("📘 Summary of the Class"),
              p("This dashboard was built for our Data Science capstone course at Iowa State University. The class emphasized real-world applications of data wrangling, visualization, interactive dashboards, and storytelling using R and Shiny."),
              
              h4("✈️ Project Overview"),
              p("Frequent Flyers is an interactive Shiny dashboard that visualizes domestic U.S. flight data from 2013 to 2024. The platform features a dynamic flight map showing routes across airports, along with visual tools such as:"),
              tags$ul(
                tags$li("📍 Flight route map filtered by year and airport code"),
                tags$li("📊 Histogram of fare distribution across all flights"),
                tags$li("📈 Line chart of average flight fares over time"),
                tags$li("🟦 Stacked bar charts of total flights by quarter and year"),
                tags$li("📉 Scatter plot showing relationship between fare and distance"),
                tags$li("🔄 Chord diagram showing most frequent routes"),
                tags$li("🔥 Heatmap of flight prices between departure and arrival cities")
              ),
              p("All components are built in R using Shiny, Plotly, and Leaflet libraries to enable smooth interactivity and visual exploration."),
              
              h4("💡 Why We Chose This Project"),
              p("With airfare constantly fluctuating and thousands of routes across the country, we wanted to build something that makes flying data more accessible. Travel is personal and widespread — so this dashboard helps both casual and frequent travelers make informed decisions using data."),
              
              h4("👥 Who Could Use This"),
              tags$ul(
                tags$li("• Travelers comparing price trends across routes"),
                tags$li("• Airline analysts and transportation researchers"),
                tags$li("• Data science students learning interactive dashboards"),
                tags$li("• Anyone interested in trends within domestic air travel")
              )
      )
      
    )
  )
)


#This is the backend code.
#It takes the parameters from the UI
server <- function(input, output) {
  
  render_plots(input = input, output = output, filtered_data = filtered_data)
  
  output$chord_plot <- renderPlot({
    circos.clear()
    plot_chord_diagram_routes(filtered_data())
  })
  
  
  #This reactively filters the year based on the slider
  #The reactive keyword means this function is called whenever the UI element is interacted with
  flight_data <- reactive({ filter_year(input$flight_year) })

  #This re-defines the variable when the UI is updated  
  filtered_data <- reactive({
  flight_data <- flight_data()

    
    #This removes the airport that is encoded to the wrong latlong making it appear in Kazakhstan
    flight_data <- flight_data %>%
      filter(airport_1 != "PBG" & airport_2 != "PBG")

    #This is the airport id filtering. If the box has fewer than 3 characters it shows all airports, 
    #Otherwise it only shows flights in and out of the input airport
    #uses toupper function to allow lowercase airport entries
    if (nchar(input$airport_id) < 3) {
      flight_data
    } else {
      flight_data %>%
        filter(airport_1 == toupper(input$airport_id) | airport_2 == toupper(input$airport_id))
    }
  })

  render_plots(input = input, output = output, filtered_data = filtered_data)
  
  
  output$map <- renderLeaflet({
    #This computes the number of flights for the radius of the circle markers
    flight_map_data <- compute_flight_counts(filtered_data()) %>%
      mutate(total_flight_count = start_flight_count + end_flight_count)

    #This gets all of the unique airports so we do not duplicate the circle marker
    #For every occurrence of each airport in the csv
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

    #Actually renders the map
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
      addLegend("bottomright", colors = c("#355834", "blue"), labels = c("Airport", "Flight Path"), title = "Legend")
  })
}

shinyApp(ui = ui, server = server)
