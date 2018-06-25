# Process

## 7 june
Today i started working on getting a finished prototype by the end of the day, at which i succeeded.

## 11 june
Today i worked on the base of my app. I started working on a functioning calender and i added the Google Maps api,
to display the map in the map section.

## 12 june
Today i continued working on my calendar. I tried using certain cocaopods suchs as JTAppleCalendarView, but failed to get them to work and decided to do it without them. The Calendar proved to be alot harder than expected, so that is going to be a challenge for the days to come.

## 13 June
I am not quit happy with my daily progress. I am putting in a lot of hours, but the daily progress is not a lot. I have tried to do the calendar in a multiple of different ways, but most of them were to hard, but did cost a lot of time to figure out. Today i decided to make the easiest version of my daily calendar due to time constraints. This version is, sadly, quite visually unappealing, however if i want to finish the rest of the app, i believe i have to make it as simple as possible. 
I have also looked at all the API's to start working on the map and all of its distances and times (also for calculating and optimizing for travel time). What i realised is that i need more different API's from google, than i thought was neccessary at firs. It seems i need 4 different API's from google: Maps SDK, Distance Matrix, Places and Directions API. The challenge of tommorow will be to incorporate them into my app. 

## 18 juni
I managed to incorporate google distance api into my code and retrieve the distances between two locations from the code. I also managed to have the activities apear chronologically in the calendar. Furthermore, i updated the calendar so users aren't able to look into past months.

## 19 juni
Today i finally managed to link the calendar dates in the months section to the daily calendar. The daily activities of one date will not be lost if switched to another date, which is very nice. The calendar is finally starting to function as a real calendar would. I have made a dictionary which holds a date as the key value and a list of instances of the activity struct. With all this in place, i believe i can have a functioning daily map for tommorow. The calendar displays all activities chronologically, however it does not account for overlapping events. This is something that i need to take a look at after i have made a functioning map.

## 20 juni
Emma told me today that google has a calendar API. I was dissappointed to learn this, because i have spent a lot of time working on my own calendar and getting it to work. I did learn a lot from it though. Today i managed to visualise the day in a map and the routes from activity to activity. I had some struggles because my app did work on my simulator on the computer, but it did not work on my phone. After a lot of print statements and google searches i realised that this was because my computer has its time settings in US style, while my phone has its settings in the UK style.

## 21 juni
Today i fixed that the app can't add two activities at the same time. I also started working on adding the traveling time and also a possible optimise function for it. I didn't succeed in completing it because the data was downloaded asynchronically. I also fixed minor buggs in the calendar. The function i used to calculate at which day each month started was wrong so i had to think of a new one. Because i couldn't find it online, i had to think of it myself, which turned out te be quit difficult. 
