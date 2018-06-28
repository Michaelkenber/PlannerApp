# Process

## June 7th
Today i started working on getting a finished prototype by the end of the day, at which i succeeded.

## June 11th
Today i worked on the base of my app. I started working on a functioning calender and i added the Google Maps api,
to display the map in the map section.

## June 12th
Today i continued working on my calendar. I tried using certain cocaopods suchs as JTAppleCalendarView, but failed to get them to work and decided to do it without them. The Calendar proved to be alot harder than expected, so that is going to be a challenge for the days to come.

## June 13th
I am not quit happy with my daily progress. I am putting in a lot of hours, but the daily progress is not a lot. I have tried to do the calendar in a multiple of different ways, but most of them were to hard, but did cost a lot of time to figure out. Today i decided to make the easiest version of my daily calendar due to time constraints. This version is, sadly, quite visually unappealing, however if i want to finish the rest of the app, i believe i have to make it as simple as possible. 
I have also looked at all the API's to start working on the map and all of its distances and times (also for calculating and optimizing for travel time). What i realised is that i need more different API's from google, than i thought was neccessary at firs. It seems i need 4 different API's from google: Maps SDK, Distance Matrix, Places and Directions API. The challenge of tommorow will be to incorporate them into my app. 

## June 14th
I managed to incorporate a version of maps into my app and i have completed some parts of the add activity viewocontroller.

## June 18th
I managed to incorporate google distance api into my code and retrieve the distances between two locations from the code. I also managed to have the activities apear chronologically in the calendar. Furthermore, i updated the calendar so users aren't able to look into past months.

## June 19th
Today i finally managed to link the calendar dates in the months section to the daily calendar. The daily activities of one date will not be lost if switched to another date, which is very nice. The calendar is finally starting to function as a real calendar would. I have made a dictionary which holds a date as the key value and a list of instances of the activity struct. With all this in place, i believe i can have a functioning daily map for tommorow. The calendar displays all activities chronologically, however it does not account for overlapping events. This is something that i need to take a look at after i have made a functioning map.

## June 20th
Emma told me today that google has a calendar API. I was dissappointed to learn this, because i have spent a lot of time working on my own calendar and getting it to work. I did learn a lot from it though. Today i managed to visualise the day in a map and the routes from activity to activity. I had some struggles because my app did work on my simulator on the computer, but it did not work on my phone. After a lot of print statements and google searches i realised that this was because my computer has its time settings in US style, while my phone has its settings in the UK style.

## June 21st
Today i fixed that the app can't add two activities at the same time. I also started working on adding the traveling time and also a possible optimise function for it. I didn't succeed in completing it because the data was downloaded asynchronically. I also fixed minor buggs in the calendar. The function i used to calculate at which day each month started was wrong so i had to think of a new one. Because i couldn't find it online, i had to think of it myself, which turned out te be quit difficult. I also noticed that my calendar had 6 cells per each day, instead of 7. I also struggled to fixed this, because the functions that i found that were supposed to return 7 cells, only returned six. I changed the function to 8 cells, and now it returns 7.

## June 25th
The calendar now adds travel time for each activity. I have also tried making an optimisation function, but it crashes the program as of now. The user now has to add a starting point for each day and is able to change this if he chooses. Furthermore, i have tidied up my repository and have put my app in its own folder.

## June 26th
Today i focussed on some bugs the calendar had and fixed most of them. I also started with commenting each function in the code, i know i should learn to do this while coding and not after, but up till now i have always prioritised the code above the commenting. I tried to save my dictionary in userdefaults, but this didn't work because it is not a NSObject. After a lot of internet searching, i have sadly not managed to fix the problem. I am hoping that tommorow i can solve the problem with the help of one of the TA's.

## June 27th
I was not able to use UserDefaults. This was because of my data structure. I was however, as Marijn pointed out, able to save my variables into a plist. This also meant that i had to rearange a lot of my data structure. This was because a struct needs to conform to the codable
protocol to save to a plist. I used CLLocation for the most part, which was also not practical to use, because CLLocation uses a lot more
information than i needed. To make my code confirm to the codable protocol, i had to make a struct coordinates, and change all instances
of CLLocation for coordinate. I had to rearange a lot of my code, and scan which line of my codes become redundant. I have also fixed some bugs, allow users to change the starting location, allow users to delete all activities for the day (instead of a single one, which i had prior). Furthermore i added an icon to the app and a launch screen. In the beginning i had only one day in my calendar and i started with an addActivities array. I later switched to an add activities dictionary. However i did not properly convert all the code, because it was not neccessary for the code to function properly. This choice made it harder to incorporate the decoding and using of the plist. I have switched my data structure alot, in the future it would definately be beneficial to give alot  of thought to the datastructure, so you don't have to change alot of code multiple times during a project. At the end of the day saving it in a plist did work though.
I also started writing my report today.

## 28 June
Today is D-day. The day, sadly, started of bad, because one of my classmate told me you get graded for committing frequently. I have not done this because merge errors in the subject Heuristics have made me afraid of commenting.
Because i had a lot to do today i decided to keep writing everything down, which i had done, as i did it. In hindside i should have done this each day, because when you look back at your day, you always forget a lot of tiny bug-fixes and implementations into the code.
The object for today was having a clean code, having a working program with no bugs and finishing the report.
To start of there was a bug in the planner. Data dissapeared after the program was shut down, even though the data was saved in a plist. This was because i had an dictionary with activities and also an array and they got confused. As i mentioned before this was because of the different datastructure i sttarted out with. After fixing this bug, the calendar had another bug. 
The calendar displayed travel times as activities, and placed markers for them on the map. Looking back i should have made a different struct for travel than for normal activities. Maybe i should have also combined them in a dictionary. 
After this i immediately faced my next bug, if i shut down the entire app, close it off and reopen it. The activities would display, however if i added new ones, they would be overwriten. Again, this was caused by the switch in data structure. Also activities could not be selected to show details after the app had closen, for the same reason. 
Next there was a mistake in the planner app. When an activity was addedd in between two others, traveltimes didn't change. This was because travel time was only added along with one activity, therefore the other travel times did not change. I fixed it by recalculating all travel times each time an activity was added.
After this, the calculate traveltime function didn't work anymore. This function selected the last and second to last activities and found the traveltime in between them. However, now everytime i add an activity, the traveltime in between each activity is calculated. I had to change that function, so it takes in two entire activities instead of two locations and a transportype. This lead to alot of reordening of the code.
After this i scanned my code for redundand lines, because the structure was changed so frequently. As it turned out there appeared to be quite a few redunded lines. I also deleted unnecessary pods JTAppleCalender and CalenderLib. 
I included visuals in the report and finished the classes within it. I added a .gitignore and a license and made a new read me.
