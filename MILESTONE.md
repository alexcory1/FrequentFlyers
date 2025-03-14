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



## 2025-02-28: Exploratory Analysis Milestone 
### Brainstorm Dashboard 
We are using R and R Shiny to create our dashboard that will have 5 tabs. The “Home” tab will show a summary of our dataset and some direct observations. The “Map” tab has an interactive map that displays all the routes and airports in the dataset. There will also be a slider where users can filter for routes from a specific year range. The “Plots” tab will display various types of plots for data visualizations. Some of the plots we are thinking of doing are time-series plot for price fluctuations over months, heatmap of flight prices by routes or depart/arrival airports, bar chart of total number of flights each month, scatter plot for flight price vs duration of flights and more. The “Price Prediction” tab will be implemented with a random forest model taking inputs such as departure date & time, airports, etc. and output a graph showing the predictions of flight prices. Lastly, there will be an “About” tab that has a write-up of the project overview and recommendations for the future.

### Data Report 
We decided to find a new dataset. The one we currently had was not US data, which was what we wanted to focus on, and the other one we had did not have as much specific information as we wanted for price prediction. So, we found another dataset that has more specific price information over time as well as other information about the flight itself. This will allow us to make a better model for price prediction. We will no longer be using the dataset with international data, but the other datasets we already had, we will keep as they have good information about flights that we can use for other aspects of the dashboard. 

### Project Progress 
The team has been working well together, combining our skills to advance the project. Everyone is communicating well with each other both on availability and on the project itself. Ideas are shared and discussed as a team before moving forward. Everyone does well explaining what they’ve been working on and commenting on their code so others can learn from it and contribute to it. Some roadblocks we’ve encountered as a team would just be availability as it is hard to coordinate a good meeting time for 4 people. Next steps for our group would be pulling in our new dataset to be able to begin modeling and then meeting up to work on the next aspect of our dashboard. 

### Exploratory Analysis 
With the datasets that we have, we have created a map that shows the flights to and from airports. We have not found any major outliers with our data so far, but one thing we have noticed is that the dataset is small and does not include as much information as we would like it to. The new dataset we found will also present some challenges. It is a very large dataset, but the data only spans 8 months out of a single year. This small span of time will make accurate prediction and modeling difficult, but we will try to work with the data that we have. We have also created some basic graphs that show the distribution of some variables over time and one that shows price vs the distance that the flight is. Something interesting we noted is that there is not as large of a correlation between those variables as we thought. 



## 2025-03-07: Brainstorm Dashboard Milestone 
### Brainstorm Dashboard
Our dashboard will include multiple tabs with different features on each. One will include a map of popular flights. This map will have user input features to allow a user to select specific airports for a range of years. Another tab will include exploratory analysis graphs and statistical information that we have found, including the month with the most routes, most popular flight, etc. The target audience for this dashboard is travelers or travel agents who want to figure out the price of a particular flight when planning out a trip. To make the dashboard, we have been using R and Shiny. The plots are made using plotly so they are able to be interacted with. 

### Finalize Data Models 
We have some usable datasets loaded to our GitHub repo that could be called directly in the R scripts. We are still working on our data models to predict flight prices and analyze flight trends. For price prediction, we will train a model and use it to predict flight prices based on the user's inputs. We are exploring XGBoost and linear regression. Our model aims to help users estimate flight prices based on selected criteria and understand price trends. Challenges we faced include dealing with high-cardinality categorical variables especially the airport codes. We are also trying out suitable ways to implement data validation on the user input side to solve the problem of non-existing input combinations in the dataset. 

### Data Plan 
We have encountered a few issues with our dataset. The dataset that we had at first was not exactly what we were hoping to have for our price prediction. It didn’t have the price of the same flight as it changes over time. Any datasets we found that included that information was too large and unusable or not free. So we have decided to use a dataset that we had found a while ago that included that information but was scrapped due to the fact that it was only composed of data from airports within India. To be able to complete our project, we will switch the focus to this dataset. This dataset should be big enough to be useful but small enough to be stored on github.

### Project Progress
We have the dashboard frames ready for each component and navigation through different screens is set up. We have added more plots for the data visualization part, and we started to train the ML model for price prediction. There is no major issue within team collaboration as everyone contributed to the project. The next steps for our group will be focusing on the price prediction ML model. We need to look into our datasets and decide the variables that should be used to train the model, and identify possible flaws when considering user input for prediction. We will also add more plots to the dashboard. The team has been working well together to figure out the layout of the dashboard and how to approach modeling. Everyone has been able to bring forward ideas and things that could be improved upon. 



## 2025-03-14: Finalize Data Models Milestone 
### Dashboard Sketch 
The goal of our dashboard is to better inform travelers so they can make educated flight decisions. They will be able to visit our website and input their desired source and destination and will be outputted an estimated cost for that flight. We did find an example map that showed flight routes that we liked and modeled our map after. Our dashboard layout includes 5 tabs, each displaying different information. There is a home tab introducing the project and an about tab introducing the background information. We also have a tab for displaying various graphs we made. Another tab is our flights map. This map can be filtered by the user to choose different year ranges and specific airports. Our last tab is the price prediction tab. The user will be able to input source and destination to receive their predicted price. 

### Project Progress 
We added some new plots and improvised some of the existing plots. One of the big changes is changing the color palette to be colorblind friendly. We also explored a few machine learning models for flight price prediction. Our current roadblock is not being able to train a good enough ML model, as all the models have a high RMSE. Moving forward, we will be creating more plots and start adding some project overview to the Home tab.

### Finalize Data Models 
We continued working on our flight price prediction model from last week. We explored more machine learning models like Elastic Net and CatBoost. However, we found out that they all resulted in a high RMSE so we still need to explore other potential options. Our focus remains on selecting the most effective model that delivers reliable price estimates and helps users understand flight price trends.

### Spring Break Plans 
As a team we decided not to do any work on the dashboard over break. If a team member really wants to do some work, they are more than welcome to, of course, but they are not obligated to do any. 


