# PlannerApp

# Problem Statement
This app will optimize a users daily travel time.

# Solution
This app imports travel times, from the google API. The user will be able to give all daily activities and optimisze travel times.

The minimum viable features of this app are:
* A personal planner that users can fill in
* Give preferences for activities (morning, afternoon)
* The app will present the planning with the shortest travel time

Optional features are:
* The ability to decline the optimal travel time planning and have the app present the second best option
* More constraints (one activity must follow another)
* A map visualisation of your daily planning
* Also retrieving train travel information
* Giving an optional travel to and from mode of transport (but being aware that it is not possible to leave the car somewhere)
* Later adding activities
  
In the doc folder you can find a visualisation of what the endproduct might look like

# Prerequisites
For the project we will need the folowing data sources:
* An API key for the travel times retrieved from: https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=YOUR_API_KEY
* 9292 reisadvies api retrieved from: https://www.9292.nl/zakelijk/9292-reisadvies-api

The TIME planner app has simular features, such as a planner and showing locations for each activity. The planner master app is also somewhat simular. It can also show your day on a map. It does not, however, calculate an optimized travel time. I have found no app that does such a thing.

The hardest part of the app will be calculating the shortest route and making a planning that gives such a route that satisfies all the 
users' wishes. One difficulty will be capturing these wishes, so that the user will get a daily planning that he will like, but also
being user friendly in adding activities in a users' daily planning.
