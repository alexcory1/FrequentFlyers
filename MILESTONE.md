## 2025-02-17: Acquire Data Milestone 
### Data Wrangling
  The datasets that we have include data about different airlines and ticket pricing. So far, we have created a map that visualizes the routes that flights take in the US with airports at the nodes. We have an additional table that contains airport codes, longitude and latitude, and other information about specific airports. This table has been joined with our other datasets to add to the information that we already have gathered. This was necessary to help build the map and will continue to be useful during our other modeling processes. We haven’t really encountered any serious roadblocks with the data. The only problem is that the data is not super current, but we are working with the data that we have. Another potential issue is the fact that our US routes dataset doesn’t have specific dates for the flights; it only has year and quarter. This will potentially make price prediction difficult for specific flights on specific days. 

### Project Goals
  Our project is to develop a data-driven dashboard that provides insights into flight pricing and routes. We seek to address questions such as: What are the most frequent routes? and How do flight prices fluctuate over time? The dashboard will feature an interactive map that displays flight routes and has nodes representing the airports, with their sizes indicating the traffic volume and colors indicating the average flight fares. Other than that, we will include various charts to visualize pricing trends over the years and across different airports. We are also planning to use some machine learning models for future price predictions.

### Technology Plan
  For our project we are using R for the back-end and Shiny for the front-end and dashboard creation. We are using Leaflet for interactive maps and graphs. We are using CSV files for our data, meaning we do not need to use SQL.

### Team Evaluation
  Our team is doing really well working together to accomplish our goals. We already have a minimum viable dashboard up and running. We are ahead of the milestone schedule that the class planned out. One obstacle that might prevent us from meeting future goals is class absence. We have typically had at least one person missing class each day so that definitely slows down progress a bit as we have to work without them and catch them up when they return. However, this obstacle can be worked around by staying active in the team group chat. We can send messages each class outlining what was accomplished in class that day and any objectives that need to be completed before the next class. This way, team members can stay up to date on how the project is progressing. 



## 2025-02-21: Project Goals Milestone 
### Project Goals 
Our target audience includes frequent travelers and travel agencies who want insights into flight prices and routes. Budget-conscious travelers could also use the dashboard to plan and optimize their travel expenses. This dashboard will be useful for helping travelers make informed decisions based on historical pricing trends and predictive analysis. To effectively communicate our project, we need clear visualizations, interactive elements, and concise summaries of trends and insights. Our dashboard aims to answer questions such as “How do flight prices fluctuate over time?”, “Which routes are most frequently travelled?”, “How do factors like seasonality, departure airport, and airlines impact flight prices?”

### Exploratory Analysis 
Some issues that we have encountered with our dataset is its size. The amount of data that we have is not as much as we hoped it would be to create a full, up to date dashboard. However, we will continue to use the data that we have and see what we can create from them. We haven’t started doing any of the modeling yet, but we will next week. We will look at predictors such as source of the flight, destination, length of the flight, time of the year, etc. to attempt to predict the price of the flight. 

We have created an initial map of flight routes. From this map we can already see popular airports and flights. This map will be included in the final dashboard as it shows trends in popularity for airports and flights 

### Modeling Plan 
For the modeling part of our dashboard, we found a new dataset that worked better for our goals. Our aim is to predict fluctuations in ticket price over time. Some of our predictors would be how far out from the flight it is, how long the flight is, where the flight is from, where the flight is going to, if the flight is economy, and other data points about the flight. We want to look into using a gradient boosted tree or any tree model to predict the price. We haven’t really started the modeling processes yet, so these are just ideas of what we are going to look into. 

### Project Progress 
This week we did not make a ton of progress due to being busy with other things. We updated the UI and created a writeup of the features we currently have. We also fixed a bug in the airport filtering causing writing airport codes in lowercase (dsm, sea) to break the map. We also changed some things with the UI to make it slightly cleaner. In the process we broke the log scale for setting the radius of the airports. We think this is because of making the pre-log sum of flights larger, effectively compressing them on the log-scale. Our team is working together well and we are all contributing ideas. In class we discussed deliverables for coming classes.
