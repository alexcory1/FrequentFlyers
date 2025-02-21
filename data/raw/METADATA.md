# Datasets about Flight Prices


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
