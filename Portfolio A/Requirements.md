Requirements
------------

# Stakeholders
- Ben (our client)<br>
*Ben is the leader of the 66 Days course. He needs to release content to users throughout the course, and check that users are engaging with the course through completing their habit tracking.*
- Self-Help gurus, professional trainers, nutrionists.<br>
*This app is a competitor to many other self-help courses and habit building apps, and as such other professionals in this field will have an interest in it.*
- Data protection enforcers and other legal entities.<br>
*This app must comply to data protection laws and not infringe the intellectual property of another party.*
- **Users of the app**
  - People looking to build new habits to meet underlying needs (an underlying need would be to improve self confidence).
  - Self-help community members, who would be interested in trying out a new form of course based around habit building.
  - People who are obese, have eating disorders, or are otherwise unsatisfied with their current relationship with food.
  - Users who download the app but haven't signed up to the 66 Days course with Ben.
  - Users who aren't familiar with technology, and so need extra guidance and support when using features of the app.

# Use Case Diagram
![The Use Case Diagram](https://raw.githubusercontent.com/simon-wh/66-Days/master/Portfolio%20A/Images/UserCaseDiagram3.0.JPG)

# Primary Functional Goals
### Ben
* Ben wishes to monitor the overall engagement with his course. To do this, the user's device must send regular update messages to the server with status reports on how user is doing (5), and this data is then shared with Ben from the server (4).
* Ben wants the User to unlock parts of the course over time. More specifically, several blog-like course posts will be made availible to the user each week, and the user must read the previous course post to unlock the next course post. Ben uploads and edits the course content on the server (1), and the App stores the data of what course posts are unlocked when, and also tracks which posts have been read so far. 
> The App should update which posts are unlocked when the library screen of the app is accessed and after a post has been read.
### The User
* **Tracking Progress.** The User wants to see how well they are doing with the course, and see what progress they have made since starting the course. They *regularly check off the habits they complete into the app* (6), the app stores this data internally. This data is used to create a score for their activity completed today, and this data is stored and displayed (3) in charts to show progress over time. 
* **Following the Course.** 
  - The user wants to read the content related to the course, which server provides to the app (2). They access the content within the app via a library folder stucture, with the *course material broken into several blog posts for each week*. As described above, certain parts of the course are unlocked and availible for the user to access depending on how far they have progressed through the course.
  - The user wants to set a new habit as they have met a new course milestone. After reading key course content blog posts, which suggest to the user several ideas for the new habit, *the user is prompted to enter the description text of their next habit* (6).
* **Updating Settings**
  - The user wants to update the text for a habit - this feature is unlocked within the app after having the habit active for two weeks (i.e. part of their daily habit checklist). The user can access the *habit management screen within the app to edit the habit*.
  - The user wants to update the notification settings for a habit. A *custom notification is made for every habit*, which can be activated or deactivated by the user as they prefer. The timing of the notification can also be edited within the app. The user is then notified accordingly (3).
  - The user wants to control various settings about their account and other features of the app. These can be controlled within the *app settings screen*.
* **Training Week.** The user wants to complete the training week (first week of the course). 
  - They want to download and open the app for the first time, logging into their account.
  - They want to understand the features of the app - scoring, notifications, habit management.
  - Throughout the first week of use, they want to check off that they've done the observation tasks - this information is relayed to the server (5).
  - They want to set their first habit and their self image goal which they'll follow throughout the course.
  
> The training week is different to the rest of the course structure, as it is a week of observation and reading instead of habit forming. Where the habit checklist is displayed, there is instead displayed a single checkbox, which the user checks to show that they've taken photos of their meals for today (the observation task for the first week). The user will set their first habit and the self image goal after reading relevant course blog posts - there will be text input and prompts at the bottom of the course posts in question (3 and 6 are involved throughout). A mixture of blog posts and tutorial pop-ups will familiarize the user with features of the app.

# Core Use Case Goals
## Tracking Progress 
(exception - the user misses a day! alternative - the first photography observation week)
#### Basic Flow ####
1. The user opens the app once daily in the evening.
1. The home screen of the app is displayed.
  1. The checklist of habits to complete is shown, habits are displayed depending on what stage of the course the user is in.
  1. A graph of the users progress over time is rendered.
  1. Statistics about the users current streak - how many days in a row have they completed all their habits?
1. The user checks off the habits they have completed.
1. If the user has completed daily exercise, they check another box which is seperate to their defined habits.
1. The user taps a submit button to finalise their checklist.
1. The score achieved for today is displayed, the streaks and charts are updated.
#### Alternative Flow ####
* The user is completing the first week of the course.
  - Only one item to check off is displayed, alongside a useful explainer text which describes how the habit checklist works. 
  - The first time the user checks the habit, text appears explaining about how scoring works.
  - The second time the user checks the habit, text appears explaining the streak function.
  - The third time the user checks the habit, the overall progress chart appears.
#### Exceptional Flow ####
* The user misses a day.
  - On loading the app, the app checks the current date. If a day has been missed, the score gain for the previous missed days is recorded as zero.
  - The home screen of the app is rendered with the new data. 
## Updating Habit Settings 
*This covers the core user goals of changing the notification settings and text of individual habits.*
#### Basic Flow ####
1. The user opens the app.
1. The user goes to the habit management screen.
1. The habit management screen is rendered - only habits which the user has unlocked are displayed.
1. The user taps on a habit to edit the habit details.
1. The habit edit screen is displayed, with the contents of the habit selected.
1. The user edits the text of the habit using a text input and updates the notification settings using a checkbox (is it active?) and a time picker (when does it trigger?).
1. The user taps the Save Changes button.
1. The app displays the habit management screen.
#### Alternative Flow ####
* The user has unlocked the habit, but not unlocked the edit text feature for the habit.
  1. The habit edit screen displays the text input for habit text as inactive (grey background & text).
  1. If the user tries to edit the text, they are prompted with a reminder that this feature doesn't unlock until after two weeks since of starting the habit.
* The user has edited the contents of the habit, but would't like to save the changes.
  1. Instead of tapping the save changes button, the user taps exit without saving.
  1. A prompt asks them if they want to continue and quit without saving.
#### Exceptional Flow ####
* The user enters erronous text into the habit text input.
  - The user enters no text - this habit is too short!
  - The user enters too much text - if the text is greater than 140 characters, the message will take up too much space on the screen to display. It is also unadvisable to set complicated habits to complete. 
  1. An error pop-up message is displayed to the user.
  1. The text field is reverted to the value it was before it was edited.

# Sample Goal Analysis

> Select one goal that you believe to be of paramount importance or of particular interest. For this goal, decompose the flow steps into a set of atomic requirements. Specify both functional and non-functional requirements as structured natural language, using a clear and simple template structure. It is up to you to decide what fields to include in your template, but you are advised to keep things simple (whilst providing as much detail). As with many things, this is a delicate balance to reach !

> To give you an idea of the complexity and detail expected in your portfolio, this whole section should occupy approximately 4 pages of A4.
