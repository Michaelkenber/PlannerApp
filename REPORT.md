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

# Challenges
To my opinion this project really challenged me. The app planning at the start of the project is a good way to have a clear picture
of something you want to work too, hower i did notice my dissapointment when a wasn't able to reach this picture i had.

The first challenge i faced was building the calender. At first i tried a few calendar cocaopods, such as JTApple calendar view and Calenderlib. 
I spent alot of time implementing these, however i failed to implement them. What i noticed is that the documentation of these pods
wasn't always very clear, and most of it was based on earlier swift files. 

After a few days of trying i strongly felt the urge of the time and i decided to find a new way to implement it. 
This meant building the calender from scratch using a collection view. With this view i struggled to find a formula to get each month 
starting on the correct day. I tried to come up with it on my own, or find a formula online, but whatever i tried, i noticed that the calendar
got screwed up after a few months. Because of timestress i switched to another focus and decided to come back to it. When i presesented
my app on friday in front of the class. It was noticed that the months contained 6 boxes per row, instead of 7. This caused my to think
that all the formulas that i tried were wrong, when it was in fact the lay out that was incorrect. The feedback from the group was very usefull.

A big next challenge was that internet data is not received at the run time such as the rest of the app. My app did not function kept giving
wrong values. After putting print statements after every single variable that was made or changed, i noticed this mistake. Because this 
error caused me so much headache, it will definately not be one i will forget.

One of the following challenges i faced was saving the data even after my app is closed. Because i wanted to save it locally,
i thought i would just use UserDefaults, as i did in an earlier app. This didn't work because i had a dictionary that holds an array of
a costum struct for each key value. Martijn showed me that using a plist would be more practical in my case. The problem with a plist 
is that every object needs to confirm to the codable protocol. To accomplish this i had to change some struct and reorganise a lot of my code.
Instead of CLLocation, which i used in many places, i had to use a costum struct that did confirm to the codable protocol. This meant i had
to change every part of my code that used CLLocation, which were quit a few.

What i noticed is that the prework is very important. I am used to starting and adjusting along the way if you see you are going in the wrong direction.
However, in coding, if your data structure, or cocaopod, does not fit your problem really well, it is sometimes neccesarry to start over new.
This restart is very harmfull to the valuable time that is necessary to make an app. In future apps, i will put more an effort in making sure
certain ideas and datastructures are actually possible, usefull and efficient, before starting, because this might possible save a lot of time.

# Decisions
I have learned a lot from this project, which is a big plus. It was however a letdown for me to not end up with the product that i had envisioned
the first day of "Het programmeerproject". Because of the challenges i just mentioned, i had to scrapp some of the functions of the app. 

At first i decided to skip the preferences and have the user give one mode of transport to optimize their day for. Because of time constraints,
and because of some bugs that i gave priority to fix first, i decided to drop preferences al together. In my opinion, a user probably has 
so many preferences, standing apointments, etc. that he will prefer to put the activities in himself. It would be more usefull for an errand
list, where someone has to do alot of errands today and then optimises for time travel. This "errand app", instead of "planner app", has a 
totally different feel, but would be more practical for timetravel optimisation, because users probably don't really care in what order they
go to the Blokker, Hema, Albert Heijn, Gamma and Etos, to get their groceries. 

Last i decided to have users delete only all the activities at once, instead of one single activities. This is again because of how i structured
my datastructure. It was not possible to have users delete one activity and have the app, finding the new travel times. I am aware that this
is not userfriendly and if it would definately prefer not to have it like this.

Other extra options are cirkeling the current date in the calendar. Deleting routes that have already been, so a user only sees the route to be.
Improving the lay out, to make it more pleasing to the users eye.
