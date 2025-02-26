library(ggplot2)
library(dplyr)

# Price distribution of the dataset
plot_price_distribution <- function(data) {
  ggplot(data, aes(x = fare)) +
    geom_histogram(bins = 30, fill = "blue", alpha = 0.7) +
    labs(title = "Flight Fare Distribution", x = "Fare (USD)", y = "Count") +
    theme_minimal()
}
