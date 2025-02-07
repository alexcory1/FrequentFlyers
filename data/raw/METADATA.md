# Datasets about Flight Prices

## Clean_Dataset.csv
This dataset was made by combining business.csv and economy.csv and cleaning up the features 
Data Features: 

    1) Airline: The name of the airline company is stored in the airline column. It is a categorical feature having 6 different airlines.
    2) Flight: Flight stores information regarding the plane's flight code. It is a categorical feature.
    3) Source City: City from which the flight takes off. It is a categorical feature having 6 unique cities.
    4) Departure Time: This is a derived categorical feature obtained created by grouping time periods into bins. It stores information about the departure time and have 6 unique time labels.
    5) Stops: A categorical feature with 3 distinct values that stores the number of stops between the source and destination cities.
    6) Arrival Time: This is a derived categorical feature created by grouping time intervals into bins. It has six distinct time labels and keeps information about the arrival time.
    7) Destination City: City where the flight will land. It is a categorical feature having 6 unique cities.
    8) Class: A categorical feature that contains information on seat class; it has two distinct values: Business and Economy.
    9) Duration: A continuous feature that displays the overall amount of time it takes to travel between cities in hours.
    10)Days Left: This is a derived characteristic that is calculated by subtracting the trip date by the booking date.
    11) Price: Target variable stores information of the ticket price


## business.csv
Data Features: 

    1) date: Date of Travel. It is a DateTime feature from February 11 - March 31, 2022 
    2) Airline: The name of the airline company is stored in the airline column. It is a categorical feature having 6 different airlines.
    3) ch_code: Flight Character Code. It is a categorical feature with 2 unique values: UK, AI 
    4) num_code: Flight Numerical Code. Stores information regarding the plane's flight code. It is a categorical feature. 
    5) dep_time: Departure Time. This is a DateTime feature with a timestamp. 
    6) from: Source City. City from which the flight takes off. It is a categorical feature having 6 unique cities.
    7) time_taken: Duration of Flight. A continuous feature that displays the overall amount of time it takes to travel between cities in hours. Stored as a string. 
    8) stop: Stops. A categorical feature with 5 distinct values that stores the number of stops between the source and destination cities.
    9) arr_time: Arrival Time. This is a DateTime feature with a timestamp. 
    10) Destination City: City where the flight will land. It is a categorical feature having 5 unique cities.
    12) price: Ticket Price. Target variable stores information of the ticket price


## economy.csv
Data Features: 

    1) date: Date of Travel. It is a DateTime feature from February 11 - March 31, 2022 
    2) Airline: The name of the airline company is stored in the airline column. It is a categorical feature having 6 different airlines.
    3) ch_code: Flight Character Code. It is a categorical feature with 2 unique values: UK, AI 
    4) num_code: Flight Numerical Code. Stores information regarding the plane's flight code. It is a categorical feature. 
    5) dep_time: Departure Time. This is a DateTime feature with a timestamp. 
    6) from: Source City. City from which the flight takes off. It is a categorical feature having 6 unique cities.
    7) time_taken: Duration of Flight. A continuous feature that displays the overall amount of time it takes to travel between cities in hours. Stored as a string. 
    8) stop: Stops. A categorical feature with 5 distinct values that stores the number of stops between the source and destination cities.
    9) arr_time: Arrival Time. This is a DateTime feature with a timestamp. 
    10) Destination City: City where the flight will land. It is a categorical feature having 5 unique cities.
    12) price: Ticket Price. Target variable stores information of the ticket price


## US_Airline_flight.csv
Data Features:

    tbl: Table identifier
    Year: Year of the data record (2013-2024)
    quarter: Quarter of the year (1-4)
    citymarketid_1: Origin city market ID
    citymarketid_2: Destination city market ID
    city1: Origin city name
    city2: Destination city name
    airportid_1: Origin airport ID
    airportid_2: Destination airport ID
    airport_1: Origin airport code
    airport_2: Destination airport code
    nsmiles: Distance between airports in miles
    passengers: Number of passengers
    fare: Average fare
    carrier_lg: Code for the largest carrier by passengers
    large_ms: Market share of the largest carrier
    fare_lg: Average fare of the largest carrier
    carrier_low: Code for the lowest fare carrier
    lf_ms: Market share of the lowest fare carrier
    fare_low: Lowest fare
    Geocoded_City1: Geocoded coordinates for the origin city
    Geocoded_City2: Geocoded coordinates for the destination city
    tbl1apk: Unique identifier for the route

# Datasets about Flight Routes

## faa_routes_db.csv

## routes.csv
Data Features:

    airline: 2-letter (IATA) or 3-letter (ICAO) code of the airline.
    airline ID: Unique OpenFlights identifier for airline (see Airline).
    source airport: 3-letter (IATA) or 4-letter (ICAO) code of the source airport.
    source airport ID: Unique OpenFlights identifier for source airport (see Airport)
    destination airport: 3-letter (IATA) or 4-letter (ICAO) code of the destination airport.
    destination airport ID: Unique OpenFlights identifier for destination airport (see Airport)
    codeshare: "Y" if this flight is a codeshare (that is, not operated by Airline, but another carrier), empty otherwise.
    stops: Number of stops on this flight ("0" for direct)
    equipment: 3-letter codes for plane type(s) generally used on this flight, separated by spaces
    [The special value \N is used for "NULL" to indicate that no value is available.]
