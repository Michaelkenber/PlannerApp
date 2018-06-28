# PlannerApp
The planner app is a calendar app, that automatically adds the users travel time, given the mode of transport provided by the user.
The app visualises the user's daily route on a map.

# Design
In the picture below we see the top level of the app represented by the PlannerController, CalendarViewController and the MapviewController. The PlannerController holds the planning of daily activities. The CalendarViewController holds the months of the year
and the ability for users to select certain dates. The MapviewController visualises the daily activities of the user on a map.
![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/ViewControllers.png)

From the PlannerViewController, users can go to the ShowActivityViewController and to the AddActivityViewController. The ShowActivityViewController shows the details of an activity. The AddActivityViewController allows users to add an activity.
![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/PlannerRelation.png)

From here we have one final ViewController, the SelectTransportTypeViewController. Here a user can select a transport type.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/AddActivityRelation.png)

If a user starts the app he ise first greeted by the launch screen, which is seen below.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/LaunchScreen.png)

Next the user is prompted for the startlocation, were an autocomplete from google helps him find the location. If the user wishes to change the start location, he may do so may do so.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/LocationScreens.png)

If the user wants to add an activity, he can press the + button right above. In the screen he will only be able to add an activity if he has filled in all the fields. A time picker makes it easier for the user to select the time.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/ActivityScreens.png)

When an activity is added, the user can preview it in his planner screen. He can also click an transportationmode or activity to see more details.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/PlannerScreens.png)

If the user wants to select a date in Juli, he can go to his date scene and move to that month. When he selects a cell it is highlighted an a "Go to date" button appears. He can then select it to go to the corresponding date.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/MonthScreens.png)

Last, but not least, the user can view his entire day in the MapViewController. As seen below.

![alt text](https://github.com/Michaelkenber/PlannerApp/blob/master/doc/MapScreen.png)

# Classes and Functions
## PlannerViewController.swift
This viewcontroller displays the daily activities of the user chronologically in a tableview. 
In the a dictionary is defined with a string representing a date as key, and an array of activities of values. This representation is important because it determines most of the data structure.

All the functions within this viewController concern themselves with user interaction and representing the tableview.

## CalendarViewController.swift
This is a custom UIViewController class. It contains functions relating to users operating with the calendar. 

It has a button right and a button left function, for when the right and the left button are pressed. 

It has an updateUI function that tells the Collectionview how to fill itself for a new month. The updateUI function
calls upon CollectionView.reloadtable data which calls all the other collectionview functions within the class telling how
the collection function must be initialized and how it should act when interacted with.

## MapViewController.swift
This is a custom UIViewController class that represents the map.

Its most important functions drawPath and createMarkers, which draws a path between two activities and creates markers for each of these 
activities, which the name already suggests.

The other functions within this class tell the viewcontroller how to display the map, and how to act when interacted with.

## AddActivityTableViewController.swift
This is the table view controller class where users can add an activity. Most of the functions concern themselves with updating the labels.

The most important function within this class is the function calculate traveltime. This function calculates the traveltime betweentwo activities.

## CollectionViewCell.swift
This class is a custom UICollectionView class. It contains only an outlet to the label of the collectionviewcell within the collectionview.

## TransportType.swift
This is a struct for the transport type that confirms to the equatable protocol.

## SelectTransportTypeViewController.swift
This is the viewcontroller where a user can select the transport type. It contains only tableview functions.

## Activity.swift
This struct is a struct that holds an activity of the user. It confirms to the Equatable, Comparable and Codable protocol.

## Coordinate.swift
This is a struct that holds the coordinates and placename of a location. It confirms to the Codable protocol.

# Prerequisites
For the project we will need the folowing data sources:
* Google Directions API retrieved from the google developers site
* Google Distance Matrix API retrieved from the google developers site
* Google Maps SDK for IOS API retrieved from the google developers site
* Google Places SDK for IOS API retrieved from the google developers site

# Challenges
To my opinion this project really challenged me. The app planning at the start of the project is a good way to have a clear picture
of something you want to work too, howeverr i did notice my dissapointment when i wasn't able to reach this picture i had.

The first challenge i faced was building the calender. At first i tried a few calendar cocaopods, such as JTApple calendar view and Calenderlib. 
I spent alot of time implementing these, however i failed to implement them. What i noticed is that the documentation of these pods
wasn't always very clear, and most of it was based on earlier swift versions. 

After a few days of trying i strongly felt the urge of the time and i decided to find a new way to implement it. 
This meant building the calender from scratch using a collection view. With this view i struggled to find a formula to get each month 
starting on the correct day. I tried to come up with a formula on my own, or find a one online, but whatever i tried, i noticed that the calendar
got screwed up after a few months. Because of timestress i switched to another focus and decided to come back to it. When i presesented
my app on friday in front of the class. It was noticed that the months contained 6 boxes per row, instead of 7. This caused me to think
that all the formulas that i tried were wrong, when it was in fact the lay out that was incorrect. The feedback from the group was very usefull.

A big next challenge was that the app does not receive internet data at run time such as the rest of the app. My app did not function kept giving
wrong values. After putting print statements after every single variable that was made or changed, i noticed this mistake. Because this 
error caused me so much headache, it will definately not be one i will forget.

One of the following challenges i faced was saving the data even after my app is closed. Because i wanted to save it locally,
i thought i would just use UserDefaults, as i did in an earlier app. This didn't work because i had a dictionary that holds an array of
a costum struct for each key value. Martijn showed me that using a plist would be more practical in my case. The problem with a plist 
is that every object needs to confirm to the codable protocol. To accomplish this i had to change some struct and reorganise a lot of my code.
Instead of CLLocation, which i used in many places, i had to use a costum struct that confirmed to the codable protocol. This meant that i had
to change every part of my code that used CLLocation, which were quit a few.

What i noticed is that the prework is very important. I am used to starting and adjusting along the way if you see you are going in the wrong direction.
However, in coding, if your data structure, or cocaopod, does not fit your problem really well, it is sometimes neccesarry to start over new.
This restart is very harmfull to the valuable time that is necessary to make an app. In future apps, i will put more an effort in making sure
certain ideas and datastructures are actually possible, usefull and efficient, before starting, because this might possible save a lot of time.

# Decisions
I have learned a lot from this project, which is a big plus. It was however a letdown for me to not end up with the product that i had envisioned
the first day of "Het programmeerproject". Because of the challenges i just mentioned, i had to scrap some of the functions of the app. 

At first i decided to skip the preferences and have the user give one mode of transport to optimize their day for. Because of time constraints,
and because of some bugs that i gave priority to fix first, i decided to drop preferences all together. In my opinion, a user probably has 
so many preferences, standing apointments, etc. that he will prefer to put the activities in himself. It would be more usefull for an errand
list, where someone has to do alot of errands today and then optimises for time travel. This "errand app", instead of "planner app", has a 
totally different feel, but would be more practical for timetravel optimisation, because users probably don't really care in what order they
go to the Blokker, Hema, Albert Heijn, Gamma and Etos, to get their groceries and other items. 

Last i decided to have users delete only all the activities at once, instead of one single activities. This is again because of how i structured
my datastructure. It was not possible to have users delete one activity and have the app, finding the new travel times. I am aware that this is not userfriendly and if it would definately preferable not to have it like this. On the last day i noticed one way to fix this and some other problems is to move the calculation function to the PlannerViewController instead of the AddActivityViewController. This would have been a lot more practical and it would have solved quite a few problems. I had no time to do this, but if i would have done this from day one that would have been alot easier. Again the data structure is crucial, that is, for me the most important lession. It might not be the case with all apps, but with a calendar app, which is, in essence, a data app, the insight about data structures which i have gained during this project will definately help.

Other extra options to improve is that the app cirkels the current date in the calendar, or that the app deletes routes that have already been travelled on earlier that day. Another really important, and i think crucial improvement is the lay out. It should be more apealing to the users eye.

# Product demonstration
A product demonstration of the app can be found on:
https://youtu.be/WP4KgqysdDk

