library(dplyr)

compute_flight_counts <- function(flight_data) {
  flights <- flight_data

  departures <- flights %>%
    group_by(airport_1) %>%
    summarise(flight_count = n(), .groups = "drop") %>%
    rename(airport = airport_1)

  arrivals <- flights %>%
    group_by(airport_2) %>%
    summarise(flight_count = n(), .groups = "drop") %>%
    rename(airport = airport_2)

  full_counts <- bind_rows(departures, arrivals) %>%
    group_by(airport) %>%
    summarise(flight_count = sum(flight_count), .groups = "drop")

  flights <- left_join(flights, full_counts, by = c("airport_1" = "airport")) %>%
    rename(start_flight_count = flight_count) %>%
    left_join(full_counts, by = c("airport_2" = "airport")) %>%
    rename(end_flight_count = flight_count)

  return(flights)
}
