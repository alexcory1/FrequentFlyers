# Datasets about Flight Prices

## itineraries.csv
Data Features: 

    legId: An identifier for the flight.
    searchDate: The date (YYYY-MM-DD) on which this entry was taken from Expedia.
    flightDate: The date (YYYY-MM-DD) of the flight.
    startingAirport: Three-character IATA airport code for the initial location.
    destinationAirport: Three-character IATA airport code for the arrival location.
    fareBasisCode: The fare basis code.
    travelDuration: The travel duration in hours and minutes.
    elapsedDays: The number of elapsed days (usually 0).
    isBasicEconomy: Boolean for whether the ticket is for basic economy.
    isRefundable: Boolean for whether the ticket is refundable.
    isNonStop: Boolean for whether the flight is non-stop.
    baseFare: The price of the ticket (in USD).
    totalFare: The price of the ticket (in USD) including taxes and other fees.
    seatsRemaining: Integer for the number of seats remaining.
    totalTravelDistance: The total travel distance in miles. This data is sometimes missing.
    segmentsDepartureTimeEpochSeconds: String containing the departure time (Unix time) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsDepartureTimeRaw: String containing the departure time (ISO 8601 format: YYYY-MM-DDThh:mm:ss.000±[hh]:00) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsArrivalTimeEpochSeconds: String containing the arrival time (Unix time) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsArrivalTimeRaw: String containing the arrival time (ISO 8601 format: YYYY-MM-DDThh:mm:ss.000±[hh]:00) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsArrivalAirportCode: String containing the IATA airport code for the arrival location for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsDepartureAirportCode: String containing the IATA airport code for the departure location for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsAirlineName: String containing the name of the airline that services each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsAirlineCode: String containing the two-letter airline code that services each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsEquipmentDescription: String containing the type of airplane used for each leg of the trip (e.g. "Airbus A321" or "Boeing 737-800"). The entries for each of the legs are separated by '||'.
    segmentsDurationInSeconds: String containing the duration of the flight (in seconds) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsDistance: String containing the distance traveled (in miles) for each leg of the trip. The entries for each of the legs are separated by '||'.
    segmentsCabinCode: String containing the cabin for each leg of the trip (e.g. "coach"). The entries for each of the legs are separated by '||'.


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

## Clean_Dataset.csv
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
    11) Price: Target variable stores information of the ticket price.



# Datasets about Flight Routes

## faa_routes_db.csv
Data Features:

    Origin: 3-5 character departure airport designator. No 'K' prefix for US.
    Destination: 3-5 character arrival airport designator. No 'K' prefix for US.
    Route Type: L(low altitude), H(high alt), LSD(low alt single direction), HSD(high alt single dir), SLD(special low alt directional), HLD, TEC(tower enroute control).
    Area: Area description.
    Aircraft Types: Aircraft allowed/limitations description.
    Altitude: Altitude description.
    Route String: All or any part of the route string.
    Direction: Route direction limitations description.
    Departure ARTCC: 3 character center code.
    Arrival ARTCC: 3 character center code.

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
    
## airport-codes-geocoded.csv
```
Used for joining airport codes onto US_Airline_Flight.csv
```

