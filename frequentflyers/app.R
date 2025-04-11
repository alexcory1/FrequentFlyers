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

# Load raw data to get valid city/quarter combinations
flight_raw <- read.csv("./data/raw/US_Airline_Flight.csv", stringsAsFactors = FALSE)
valid_routes <- flight_raw %>%
  select(city1, city2, quarter) %>%
  distinct()

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
                box(width = 6, height = "auto", 
                    h2("Dataset Overview"),
                    tags$ul(
                      tags$li("90262 data points "),
                      tags$li("24 variables"),
                      tags$li("179 US airports ")
                    )),
                box(width = 6, height = "auto", 
                    h2("Summary Statistics"),
                    tags$ul(
                      tags$li("Average ticket price: 237.6845 USD"), 
                      tags$li("Busiest airport: Dallas Fort Worth"),
                      tags$li("Most popular route: Los Angeles to San Francisco")
                    ))
              ),
              fluidRow(
                box(width = 12, height = "auto", plotlyOutput("busiest_airports", width = "100%")),
                
              ),
              fluidRow(
                box(width = 6, height = "auto", 
                    h2("Time"),
                    tags$ul(
                      tags$li("Most Expensive Month: February of 2022 with an average fare of 268 USD"), 
                      tags$li("Busiest Months: July-September in 2016")
                    ))
              ),
              
              
              
          
              
              
              
          ),#end of home tab 
      tabItem(tabName = "plots",
              h2("Flight Data Summary"),
              fluidRow(
                # 3 plots per row for box width = 4
                box(width = 4, height = "auto", plotlyOutput("price_plot", width = "100%")),
                box(width = 4, height = "auto", plotlyOutput("stacked_yearQuarter_plot", width = "100%")),
                box(width = 4, height = "auto", plotlyOutput("airline_miles", width = "100%"))
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
                    sliderInput("top_routes", "Select number of Top Routes to display:", min = 10, max = 50, value = 15, step = 5),
                    plotOutput("chord_plot", height = "600px"))  
              )

              ),
      tabItem(tabName = "pricePrediction",
              h2("Future Flight Prices Analysis"),
              fluidRow(
                box(width = 4,
                    selectInput("city1", "Select Departure City", choices = sort(unique(valid_routes$city1)))
                ),
                box(width = 4,
                    uiOutput("city2_ui")
                ),
                box(width = 4,
                    uiOutput("quarter_ui")
                )
              ),
              fluidRow(
                box(width = 12,
                    actionButton("predict_btn", "Predict Fare", icon = icon("calculator")),
                    verbatimTextOutput("fare_prediction")
                )
              )
      ),

      tabItem(tabName = "about",
              fluidPage(
                h1("🛫 About Frequent Flyers", align = "center"),
                br(),
                
                fluidRow(
                  box(width = 12, height = "auto", title = "📘 Course Context", status = "primary", solidHeader = TRUE,
                      "Frequent Flyers was created for our Data Science capstone course at Iowa State University. 
          The course emphasized using R and Shiny for real-world data visualization, interactive design, 
          and storytelling with a purpose.")
                ),
                
                fluidRow(
                  box(width = 6, height = "auto", title = "✈️ What Is Frequent Flyers?", status = "info", solidHeader = TRUE,
                      "An interactive dashboard that makes sense of over 90,000 U.S. domestic flights from 2013–2024. 
          Users can explore fare trends, airline performance, busy airports, and even predict prices!"),
                  
                  box(width = 6, height = "auto", title = "💡 Our Why", status = "success", solidHeader = TRUE,
                      "Flying is expensive, chaotic, and confusing. Our goal? Use data to bring clarity and confidence to travelers and analysts alike.")
                ),
                
                fluidRow(
                  box(width = 6, height = "auto", title = "👥 Who Can Use This?", status = "warning", solidHeader = TRUE,
                      tags$ul(
                        tags$li("✈️ Travelers comparing price trends"),
                        tags$li("📊 Airline and airport analysts"),
                        tags$li("🧠 Data science students learning Shiny"),
                        tags$li("🤓 Anyone interested in air travel data")
                      )
                  ),
                  
                  box(width = 6, height = "auto", title = "🔍 What You Can Explore (Our 8 Visuals)", status = "danger", solidHeader = TRUE,
                      tags$ul(
                        tags$li("1️⃣ 📈 *Flight Fare Distribution* – Histogram of fares across all flights"),
                        tags$li("2️⃣ 🟦 *Flights by Quarter & Year* – Stacked bar chart over time"),
                        tags$li("3️⃣ 📊 *Fare vs Distance* – Scatter plot showing correlation"),
                        tags$li("4️⃣ 📉 *Flight Price Trend Over Time* – Line chart with quarterly average fares"),
                        tags$li("5️⃣ 🛫 *Flight Route Map* – Interactive Leaflet map by year & airport"),
                        tags$li("6️⃣ 🛬 *Total Flights by Airport* – Bar chart of inbound/outbound flights"),
                        tags$li("7️⃣ 🔄 *Chord Diagram* – Most frequent city-to-city connections"),
                        tags$li("8️⃣ ✈️ *Top Airlines by Miles Flown* – Bar chart showing cumulative distance flown")
                      )
                  )
                ),
                
                fluidRow(
                  box(width = 12, height = "auto", title = "📦 Tech Stack", status = "primary", solidHeader = TRUE,
                      tags$ul(
                        tags$li("🖥 R & Shiny – Core dashboard development"),
                        tags$li("📈 Plotly – Interactive plots and visuals"),
                        tags$li("🌍 Leaflet – Dynamic flight route mapping"),
                        tags$li("🧠 Machine Learning – XGBoost & CatBoost for price prediction")
                      )
                  )
                ),
                
                br(),
                div(style = "text-align: center; font-size: 18px;",
                    "Thanks for flying with us. Clear skies and clean code ahead! 🚀")
              )
      )
      
    )
  )
)


#This is the backend code.
#It takes the parameters from the UI
server <- function(input, output) {
  # Stuff for map:
  render_plots(input = input, output = output, filtered_data = filtered_data)
  
  #output$chord_plot <- renderPlot({
    #circos.clear()
    #plot_chord_diagram_routes(filtered_data())
  #})
  
  
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
  
  # Stuff for prediction:
  output$city2_ui <- renderUI({
    req(input$city1)
    available_city2 <- valid_routes %>%
      filter(city1 == input$city1) %>%
      pull(city2) %>%
      unique() %>%
      sort()
    
    selectInput("city2", "Select Arrival City", choices = available_city2)
  })
  
  output$quarter_ui <- renderUI({
    req(input$city1, input$city2)
    available_quarters <- valid_routes %>%
      filter(city1 == input$city1, city2 == input$city2) %>%
      pull(quarter) %>%
      unique() %>%
      sort()
    
    selectInput("quarter", "Select Quarter", choices = available_quarters)
  })
  
  observeEvent(input$predict_btn, {
    req(input$city1, input$city2, input$quarter)
    
    model <- readRDS("final_flight_price_model.rds")
    metadata <- readRDS("final_model_metadata.rds")
    
    input_df <- as.data.frame(matrix(0, nrow = 1, ncol = length(metadata$feature_names)))
    colnames(input_df) <- metadata$feature_names
    
    tryCatch({
      input_df$city1 <- as.numeric(factor(input$city1, levels = metadata$factor_mappings$city1))
      input_df$city2 <- as.numeric(factor(input$city2, levels = metadata$factor_mappings$city2))
      input_df$quarter <- as.integer(input$quarter)
      
      input_matrix <- as.matrix(input_df[, metadata$feature_names])
      
      # Debugging
     # print("Prediction input matrix:")
     # print(head(input_matrix))
      ##
      
      pred_fare <- predict(model, input_matrix)
      output$fare_prediction <- renderText({
        paste0("Predicted Price: $", round(pred_fare, 2))
      })
    }, error = function(e) {
      output$fare_prediction <- renderText({
        paste("Prediction error:", e$message)
      })
    })
  })
  
}

shinyApp(ui = ui, server = server)
