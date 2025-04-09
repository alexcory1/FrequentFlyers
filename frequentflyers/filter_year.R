filter_year <- function(flight_year) {

  US_Airline_Flight <- read.csv("data/raw/US_Airline_Flight.csv", header=TRUE)
  geocode_tags <- read.csv("data/raw/airport-codes-geocoded.csv", sep=";")
  geous <- geocode_tags[geocode_tags$Country.Code == "US", ]

  US_Airline_Flight <- US_Airline_Flight %>%
    left_join(geous, by = c("airport_1" = "Airport.Code")) %>%
    rename(start_lat = Latitude, start_long = Longitude)

  US_Airline_Flight <- US_Airline_Flight %>%
    left_join(geous, by = c("airport_2" = "Airport.Code")) %>%
    rename(end_lat = Latitude, end_long = Longitude)


    filtered_years <- US_Airline_Flight[US_Airline_Flight$Year == flight_year, ]


    flight_map_data <- filtered_years %>%
#      select(start_lat, start_long, end_lat, end_long) %>%
      na.omit()


  return(flight_map_data)
}
