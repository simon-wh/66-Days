# Stakeholders
- Ben (our client)<br>
*Ben is the leader of the 66 Days course. His course material will be released to users throughout the program, and he'll be keeping an eye on the users interaction with the app to see how well the course is working.*
- Self-help gurus, professional trainers, nutrionists.<br>
*This app is a competitor to many other self-help courses and habit building apps, and as such other professionals in this field will have an interest in it.*
- Data protection enforcers and other legal entities.<br>
*This app must comply to data protection laws and not infringe the intellectual property of another party.*
- **Users of the app**
  - People looking to build new habits to meet various goals/needs. *E.g. improving self-confidence, changing body image, having a healthier diet.*
  - Self-help community members, who would be interested in trying out a new form of self-improvement course based around habit building.
  - People who are obese, have eating disorders, or are otherwise unsatisfied with their current relationship with food.
  - Users who download the app but haven't signed up to the 66 Days course with Ben. *As the app and the course go together, these users shouldn't be able to access any of the course content on the app.*
  - Users who aren't familiar with technology, and so need extra guidance and support when using features of the app.

# Use Case Diagram
![The Use Case Diagram](https://raw.githubusercontent.com/simon-wh/66-Days/master/Portfolio%20A/Images/UserCaseDiagram3.0.JPG)

# Primary Functional Goals
### Ben
* Ben wishes to monitor the overall engagement with his course to see how well it is working. To do this, the App must send update messages to the server with status reports on how the User is doing (5), and this data is then shared with Ben from the server (4).
* Ben wants the User to unlock parts of the course over time. More specifically, several blog-like course posts will be made availible to the User each week, and the User must read the previous course post to unlock the next course post. Ben uploads and edits the course content on the server (1), and the App stores the data of what course posts are unlocked when, and also tracks which posts have been read so far. 
> The App should update which posts are unlocked when the library screen of the App is accessed and after a post has been read.
### The User
* **Tracking Progress.** The User wants to see how well they are doing with the course, and see what progress they have made since starting the course. They *regularly check off the habits they complete into the App* (6), the App stores this data internally. This data is used to create a score for their activity completed today, and this data is stored and displayed (3) in charts to show progress over time. 
* **Following the Course.** 
  - The User wants to read the content related to the course, which server provides to the App (2). They access the content within the App via a library folder stucture, with the *course material broken into several blog posts for each week*. As described above, certain parts of the course are unlocked and availible for the User to access depending on how far they have progressed through the course.
  - The User wants to set a new habit as they have met a new course milestone. After reading key course content blog posts, which suggest to the User several ideas for the new habit, *the User is prompted to enter the description text of their next habit* (6).
* **Updating Settings**
  - The User wants to update the text for a habit - this feature is unlocked within the App after having the habit active for two weeks (i.e. part of their daily habit checklist). The User can access the *habit management screen within the App to edit the habit*.
  - The User wants to update the notification settings for a habit. A *custom notification is made for every habit*, which can be activated or deactivated by the User as they prefer. The timing of the notification can also be edited within the App. The User is then notified accordingly (3).
  - The User wants to control various settings about their account and other features of the App. These can be controlled within the *App settings screen*.
* **Training Week.** The User wants to complete the training week (first week of the course). 
  - They want to download and open the App for the first time, logging into their account.
  - They want to understand the features of the App - scoring, notifications, habit management.
  - Throughout the first week of use, they want to check off that they've done the observation tasks - this information is relayed to the server (5).
  - They want to set their first habit and their self image goal which they'll follow throughout the course.
  
> The training week is different to the rest of the course structure, as it is a week of observation and reading instead of habit forming. Where the habit checklist is displayed, there is instead displayed a single checkbox, which the User checks to show that they've taken photos of their meals for today (the observation task for the first week). The User will set their first habit and the self image goal after reading relevant course blog posts - there will be text input and prompts at the bottom of the course posts in question (3 and 6 are involved throughout). A mixture of blog posts and tutorial pop-ups will familiarize the User with features of the App.

# Core Use Case Goals
## The User Wants To Track Their Habits 
*This covers the core user goals of habit tracking and progression through the course being displayed.*
#### Basic Flow ####
1. The user opens the app.
1. If a new day has begun, the previous day's score is stored into the system. *HABIT-0.3*
1. The score for today is reset to zero. *HABIT-0.2*
1. The home screen of the app is displayed. *See LAYOUT requirements below*
  1. The checklist of habits to complete is shown. *Habits are displayed depending on requirement HABIT-3.0 below.*
  1. A graph of the users progress over time is rendered. *LAYOUT & PROGRESSION-1.0*
  1. Statistics about the users current streak is shown. *LAYOUT & PROGRESSION-0.4*
1. The user checks off the habits they have completed. *HABIT-0.1*
1. If the user has completed daily exercise, they check another box which is displayed seperate to their main habits. *LAYOUT 1.3*
1. While the previous steps of checking habits and daily exercise are occuring, the score achieved for today is being updated, and the corresponding streaks and charts are updated. *PROGRESSION-0.2*
#### Alternative Flow ####
* The user has previously opened the app that day and already selected their habits.
  - The checklist of habits completed for the day is shown. *HABIT-0.6*
  - The user can uncheck and check the list of habits, and the score and visualisation is updated accordingly. *PROGRESSION-0.2*
#### Exceptional Flow ####
* The user misses a day.
  - On loading the app, the app checks the current date. If a day has been missed, the score gain for the previous missed days is recorded as zero. *PROGRESSION-0.5*
  - The home screen of the app is rendered with the new data. *LAYOUT & PROGRESSION*
## The User Wants To Update Their Habit Settings 
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

# Key Goal Analysis

The main purpose of the app is to help the user to become aware of their habits, which involves daily logging of the habits they've completed into the app.

# Functional Requirements

Habit Features
--------------
How do habits work?

- HABIT-0.0 Habits must be displayed as a **checklist** on the home screen of the app (this prominence allows the user to easily check off their progress at the end of the day, making the barrier for tracking their progress as low as possible.)
- HABIT-0.1 Habits must be able to be **ticked off daily** by the user. This process should take less than 10 seconds to complete, to open the app, check items, and close the app again. (Once agian, making the barrier for engagement with the app as low as possible, and hence engagement with the overall course higher.)
- HABIT-0.2 The habit checklist must get **reset** (all items unchecked to be ticked again) when the app detects a **new day** has begun. The precise time should be after 3am in the morning, the user should be able to change this time to a custom value. (If a user is a night shift worker, then a different time might be more suitable for them.)
- HABIT-0.3 The score for the previous day's habits must be **stored** into the app when the app detects a new day has begun. The app should check for a new day when the app is reopened. 
- HABIT-0.4 The user should receive a **daily notification** in the evening to update their habit tracking for today. If this is implemented, the user must be able control whether this notification is active.
- HABIT-0.5 There must be a single, seperate check box for **daily movement** which must act like the core habits of the course (HABIT-0.1, HABIT-0.2, HABIT-0.3). (This part of the course is non-customizable and non-negoatiable, all users should do some form of daily movement - because this part of the course isn't customisable, it is displayed as seperate to the other habits.)
- HABIT-0.6 On closing the app, the habits checked off for the day **must remain in the same state** when the app is opened again if it isn't a new day. (This means is the app is closed accidentally, or reopened later, the data the user entered is still in the app.)

- HABIT-1.0 The text for a habit must be able to be **edited** after two weeks of that habit being part of the users daily routine. (This edit can either make the habit easier if the habit is unrealistic or to build on the habit). A potential alternative is that the habit can be edited after two weeks of consistently completing it - this should be tested with users. 
- HABIT-1.1 When a habit is availible to be edited, the user should be **notified** that they have **unlocked this feature**. (Ideally, the notification should tell the user why they might want to edit the habit).
- HABIT-2.0 The user must have **control** over how they are notified to act on each habit / check in. Control includes **whether** the notification shows, and what **time** the notification shows. There is only one notification for each habit. (The app should help the user in their day to day life, and not annoy or distract them. Hence, the control of notifications is vital.)
- HABIT-3.0 Habits must be **created by the user** after reading certain key course material pieces, which occur throughout the course. Within the course material there will be suggestions of different habits the user can implement, but it is up to the user to **type in** the habit which they shall commit to. (The user of the app takes ownership of the habits they are implementing, and they type their own habit instead of choosing from a list as they know best what will work for themselves - a list of habits won't cover all the possibilities.)
- HABIT-3.1 The habit that the user commits to at the end of certain course content posts must be what is **later displayed** to the user on their home page.

Layout Features
---------------
How is the app displayed to the user?

- LAYOUT-0.0 There must be a **menu bar** at the bottom of the screen which allows the user to navigate different areas of the app.
- LAYOUT-1.0 The Home screen is the **first page that loads** when opening the app. (To make ticking off habits as easy as possible, which will encourage engagement with the course.)
  - LAYOUT-1.1 Home must contain a **checklist** of the current users habits that the user can tick off.
  - LAYOUT-1.2 Home must contain a **score overview chart** showing the users progression since day one. (To encourage the user to commit to the course and motivate them with the progress they've made).
  - LAYOUT-1.3 Home must contain a single, seperate check box for **daily movement**. (This part of the course is non-customizable and non-negoatiable, all users should do some form of daily movement - because this part of the course isn't customisable, it is displayed as seperate to the other habits.)
  - LAYOUT-1.4 Home should contain **occasional messages of encouragement** when habits are missed. (To encourage the user that failure isn't a bad thing, but in fact part of the process.)
  - LAYOUT-1.5 Home should contain the users **self-image goal**. (To remind the user why they are trying to change, and what they are trying to change to.)

Progression Features
--------------------
How will we track and visualise the users progress over time?

- PROGRESSION-0.0 The completion of habits must contribute/add to **an overall score**, stored within the app.
- PROGRESSION-0.1 The more habits you complete each day, the **higher the score** awarded for that days efforts should be. (More engagement with the course promises more rewards, and due to the principle of compounding, a clear benefit of completing multiple habits should be reflected in the score.)
- PROGRESSION-0.2 As the user ticks and unticks checkbox items, the score for the day and the **visualisations must update** to reflect that change. (Making the app interactive and showing the user that every action towards their goal is having a postive effect.)
- PROGRESSION-0.3 On completing the **daily movement action, a score bonus** should be awarded. This could be a multplier applied to todays total score so far. (Once agian, emphasising to the user about the rewards of the principle of compounding.)
- PROGRESSION-0.4 There is a **streak bonus** adding to the users total score for consistently performing habits daily. This should be implemented in a way that doesn't punish failure of missing the streak for one day, but clearly rewards consistent habit action.

A potential streak bonus scheme could look like...
> If the user completes all habits for the day, 1 point gets added to a streak bonus score award, and the streak bonus score award gets added to their score. The streak bonus score award starts at 0, and is continually built up on over time. If the user misses a day, they don't increase the streak bonus award or receive the extra points - however, the streak bonus award isn't reset, so they can regain their progress the next day. The gradient of the score chart will decrease, but the user won't loose progress.

- PROGRESSION-0.5 If the user misses a day, then the app logs the score gain for that day as **zero**. (There is no negative minus number connotation here, the app instead should demonstate that if you don't engage you won't progress.)
- PROGRESSION-1.0 There must be **a line graph on the home page** showing the users overall progress in terms of score since the start of the course. 
- PROGRESSION-1.1 When the user taps on the line graph, **additional statistics** should be displayed regarding the users frequency of completing habits. For example, a heatmap showing activity per day. (An additional level of detail for users who are interested in the statistics behind their progress which will hopefully help them engage more in the app.)

# Non-Functional Requirements

### Usability Requirements
1. **Simple Design** - The app should be self‐explanatory and intuitive such that a user shall be able to use core features described above within 10 minutes of encountering the app for the first time.

1. **Simple Navigation** - When a user first downloads the app, they need to clearly understand how to navigate to complete their goal. The app shall have a menu bar apparent on every screen with suitable icons for the sections of the app. There will be a maximum of four items on the navigation bar.

1. **Platform Usability** - This app is being developed using Flutter, and must be availible on both Android and iOS devices. When making design choices between Android and iOS, the preference should be towards the iOS version of the app.

  1. The iOS app should run on **iPhone 5s devices and later with iOS 11 onwards**.
  1. The Android app should run on **Android devices with Android 6 onwards**.
     ​	
### Accessibility Requirements

1. The app should be accessible to people with disabilities in accordance with the **Disabilities Act of 1990**. As the two operating systems, Android and iOS support this act, our app should be compatible with the disability tools that Android and iOS provide.
1. The system should be accessible by people with **specific vision needs**, to the extent that a user should be able to:
	- Display the whole user interface in a large font without truncating displayed text or other values.
  - Use a native **screen magnifier** to magnify a selected part of the screen.
  - Use a native **screen reader** to read aloud information displayed.
  - Read alternative text for web images loaded into the app.

### Security Requirements

1. HTTP is strongly not recommended. Since iOS 9.0 App Transport Security (ATS) is enabled by default, so we must **use HTTPS instead of not encrypted HTTP**. Unfortunately ATS can be easily disabled. That's fine if the app is during development and your server doesn't offer SSL yet, but an AppStore build must never call HTTP requests and ATS should be enabled.
According to NowSecure 80% of 201 of the most downloaded free iOS apps did opt out of ATS in December 2016.

1. **Login / Access levels** - only users who are a part of the 66 Days course should be able to access the course material, and a user should only be able to access their own habit data.
1. **Password requirements** – Should follow Google's standards on length, special characters, expiry, recycling policies and 2FA. 
1. **Encryption** (data in flight and at rest) – All external communications between the system’s data server and clients **should be encrypted**.
   
### Performance Requirements

1. The app shall respond to user commands within **500 milliseconds**, ensuring a high level of interactivity.
1. The scroll command should be responded to within **200 milliseconds**, as lag with this feature is particularly noticable and gives a poor impression of quality, as well as disrupting the user from reading the course content.

