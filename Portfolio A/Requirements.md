Requirements
------------

## Stakeholders
> Provide a comprehensive list containing all of the system stakeholders you are able to identified. For each stakeholder provide a suitable name and single (short) descriptive sentence.

- Ben (our client)<br>
*Ben is the leader of the 66 Days course. He needs to release content to users throughout the course, and check that users are engaging with the course through completing their habit tracking.*
- Self-Help gurus, professional trainers, nutrionists.<br>
*This app is a competitor to many other self-help courses and habit building apps, and as such other professionals in this field will have an interest in it.*
- Data protection enforcers and other legal entities.<br>
*This app must comply to data protection laws and not infringe the intellectual property of another party.*
- **Users of the app**
  - People looking to build new habits to meet underlying needs.
  - Self-help community members.
  - People who are obese, have eating disorders, or are otherwise unsatisfied with their current relationship with food.
  - Users who download the app but haven't signed up to the 66 Days course with Ben.
  - Users who aren't familiar with technology.

## Use Case Diagram
> Include a high-level use-case diagram(s) showing the key actors who engage with the system and the primary functional goals they may wish to achieve. Note: Not all stakeholders will appear as actors in the use-case diagrams ! Not all actors are human !!!

![The Use Case Diagram](https://i.imgur.com/6wA9GGc.jpg)

### Primary Functional Goals
#### Ben
* Ben wishes to monitor the overall engagement with his course. To do this, the user's device must send regular update messages to the server with status reports on how user is doing, and this data must be processed and stored by the server in a way that Ben can use.
* Ben wants the user to unlock parts of the course over time. More specifically, several blog-like course posts will be made availible to the user each week, and the user must read the previous course post to unlock the next course post. Ben doesn't want to control this himself (like his current email scheme), so the app should store the data of which course posts are unlocked on which week, and also track which posts have been read so far. The app should update which posts are unlocked when the library screen of the app is accessed and after a post has been read.
#### The User
* **Tracking Progress.** The user wants to see how well they are doing with the course, and see what progress they have made since starting the course. They *regularly check off the habits they complete into the app*, the app stores this data internally. This data is used to create a score for their activity completed today, and this data is stored and displayed in charts to show progress over time. 
* **Following the Course.** 
  - The user wants to read the content related to the course, which server provides to the app. They access the content within the app via a library folder stucture, with the *course material broken into several blog posts for each week*. As described above, certain parts of the course are unlocked and availible for the user to access depending on how far they have progressed through the course.
  - The user wants to set a new habit as they have met a new course milestone. After reading key course content blog posts, which suggest to the user several ideas for the new habit, *the user is prompted to enter the description text of their next habit*.
* **Updating Settings**
  - The user wants to update the text for a habit - this feature is unlocked within the app after having the habit active for two weeks (i.e. part of their daily habit checklist). The user can access the *habit management screen within the app to edit the habit*.
  - The user wants to update the notification settings for a habit. A *custom notification is made for every habit*, which can be activated or deactivated by the user as they prefer. The timing of the notification can also be edited within the app.
  - The user wants to control various settings about their account and other features of the app. These can be controlled within the *app settings screen*.
* **Training Week.** The user wants to complete the training week (first week of the course). 
  - They want to download and open the app for the first time, logging into their account.
  - They want to understand the features of the app - scoring, notifications, habit management.
  - Throughout the first week of use, they want to check off that they've done the observation tasks.
  - They want to set their first habit and their self image goal which they'll follow throughout the course.
  
> The training week is different to the rest of the course structure, as it is a week of observation and reading instead of habit forming. Where the habit checklist is displayed, there is instead displayed a single checkbox, which the user checks to show that they've taken photos of their meals for today (the observation task for the first week). The user will set their first habit and the self image goal after reading relevant course blog posts - there will be text input and prompts at the bottom of the course posts in question. A mixture of blog posts and tutorial pop-ups will familiarize the user with features of the app.

## Core Use Case Goals
> For a core set of the use-case goals, list the sequence of steps involved in achieving each goal. Within this set, describe at least one alternative and one exceptional flow.

* Tracking Progress 
  (exception - the user misses a day! alternative - the first photography observation week)
* Updating Habit Settings (exception - the user puts in bad input. alternative - only certain settings are updated, or the user cancels the update before completing it.)

## Sample Goal Analysis

> Select one goal that you believe to be of paramount importance or of particular interest. For this goal, decompose the flow steps into a set of atomic requirements. Specify both functional and non-functional requirements as structured natural language, using a clear and simple template structure. It is up to you to decide what fields to include in your template, but you are advised to keep things simple (whilst providing as much detail). As with many things, this is a delicate balance to reach !

> To give you an idea of the complexity and detail expected in your portfolio, this whole section should occupy approximately 4 pages of A4.
