Functional Requirements
=======================
These requirements describe how the app and supporting systems will function.
- TIMELINE
- HABITS
- COURSE
- PROGRESSION
- LAYOUT
- SETTINGS
- REPORTING

Timeline Features
-----------------
How does the app change over the duration of the course?

*These functional requirements are to do with how the app changes and progresses over time, from the start of the course until after the course has finished. TIMELINE-0.x requirements must apply to every week in the  user journey, and TIMELINE-y.x requirements must be functional on week y.*

- **TIMELINE-0.0** At the end of each week, blog posts for the next week must unlock. This is also true for all future weeks until the end of the course. (This stops the user from rushing through all the content.)
- TIMELINE-0.1 Within the blog posts for the current week, new blog post content is unlocked as the user finishes reading the previous blog post. This continues until the user runs out of material for the current week, and they then have to wait until the next week to be able to access more.

- **TIMELINE-1.0** The app must greet a new user with a welcoming message and tutorial guide. (The first tutorial blog post shall explain features of the app to new users, and the users first experiment - self observation of diet for a week, through taking photos regularly.)
- TIMELINE-1.1 The app must have a habit for the first week, which the user can check to show they've taken photos of their meals. (This familiarises the user with the habit checking system and scoring system.

- **TIMELINE-2.0** At the end of the first week, the app must allow the user to enter a **self-image goal**. (This self image goal is displayed on the home screen, and is the underlying motivation for completing the habits.)
- TIMELINE-2.2 At the end of the first week, the user sets their first habit around the theme of **eating slowly**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.
- TIMELINE-2.3 At the end of the first week, the food observation habit stops running, and the users first self defined habit replaces it.

- **TIMELINE-4.0** At the end of the third week, the user sets their first habit around the theme of **drinking water**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-6.0** At the end of the fifth week, the user sets their first habit around the theme of **portion control**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-8.0** At the end of the seventh week, the user sets their first habit around the theme of **eating whole foods**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-10.0** At the end of the course, a congratulatory message should be displayed, and the user is invited to look over the progress thoughout the ten weeks, and reflect on lessons learned.
- TIMELINE-10.1 The user must be able to continue to use the app after the course has finished, new content will not be unlocked, but they are able to keep adding to their score / completing habits as normal. (This is to encourage continuous engagement with the course, leading to longer and lasting positive change.)

Progression Features
--------------------
How will we track and visualise the users progress over time?

- PROGRESSION-0.0 The completion of habits must contribute/add to an overall score, stored within the app.
- PROGRESSION-0.1 The more habits you complete each day, the higher the score awarded for that days efforts.
- PROGRESSION-0.2 On completing the daily movement action, a score bonus should be awarded. This could be a multplier applied to todays total score so far.
- PROGRESSION-0.3 There is a streak bonus adding to the users total score for consistently performing habits daily. This should be implemented in a way that doesn't punish failure of missing the streak for one day, but clearly rewards consistent habit action.

A potential streak bonus scheme could look like...
> If the user completes all habits for the day, 1 point gets added to a streak bonus score award, and the streak bonus score award gets added to their score. The streak bonus score award starts at 0, and is continually built up on over time. If the user misses a day, they don't increase the streak bonus award or receive the extra points - however, the streak bonus award isn't reset, so they can regain their progress the next day. The gradient of the score chart will decrease, but the user won't loose progress.

- PROGRESSION-1.0 There must be a line graph on the home page showing the users overall progress in terms of score since the start of the course.
- PROGRESSION-1.1 When the user taps on the line graph, additional statistics should be displayed regarding the users frequency of completing habits. For example, a heatmap showing activity per day.

Habit Features
--------------
How do habits work?

- HABIT-0.0 Habits must be displayed as a checklist on the home screen of the app (this allows the user to easily check off their progress at the end of the day, making the barrier for tracking their progress as low as possible).
- HABIT-0.1 Habits must be ticked off once daily by the user. The habit gets reset (it can be ticked again) after a time specified by the user. By default, the habit checker should reset at 3am in the morning.
- HABIT-0.2 The user should receive a daily notification in the evening to update their habit tracking for today. If this is implemented, the user must be able control whether this notification is active.
- HABIT-1.0 Habits must be able to be edited after two weeks of that habit being part of their daily routine. (This edit can either make the habit easier if the habit is unrealistic or to build on the habit). A potential alternative is that the habit can be edited after two weeks of consistently completing it - this should be tested with users. 
- HABIT-1.1 When a habit is availible to be edited, the user should be notified that they have unlocked this feature. (Ideally, the notification should tell the user why they might want to edit the habit).
- HABIT-2.0 The user must have control over how they are notified to act on each habit / check in. Control includes whether the notification shows, and what time the notification shows. There is only one notification for each habit. (The app should help the user in their day to day life, and not annoy or distract them. Hence, the control of notifications is vital.)
- HABIT-3.0 Habits must be created by the user after reading certain key course material pieces. Within the course material there will be suggestions of different habits the user can implement, but it is up to the user to type in the habit which they shall commit to. (The user of the app takes ownership of the habits they are implementing, and they type their own habit instead of choosing from a list as they know best what will work for themselves - a list of habits won't cover all the possibilities.)
- HABIT-3.1 The habit that the user commits to at the end of certain course content posts must be what is later displayed to the user on their home page.


Course Features
---------------
How does the app display and curate course content?

- COURSE-0.0 Course content must be stored externally on a website and then loaded into the app for display. (This means that Ben can edit the course content without having to modify or update the app itself.)
- COURSE-0.1 Course content must be readable, that is a font-size greater than 8px on mobile devices. 

Layout Features
---------------
How is the app displayed to the user?

- LAYOUT-0.0 There must be a menu bar at the bottom of the screen which allows the user to navigate different areas of the app.
- LAYOUT-1.0 The Home screen is the first page that loads when opening the app. 
  - LAYOUT-1.1 Home must contain a checklist of the current users habits that the user can tick off.
  - LAYOUT-1.2 Home must contain a score overview chart showing the users progression since day one.
  - LAYOUT-1.3 Home must contain a single, seperate check box for daily movement.
  - LAYOUT-1.4 Home should contain occasional messages of encouragement when habits are missed.
  - LAYOUT-1.5 Home should contain the users self-image goal.

- LAYOUT-2.0 The Library screen contains all the course content.
  - LAYOUT-2.1 The user must be able to scroll through course content which has been grouped into weeks.
  - LAYOUT-2.2 The user should be able to access the course content as if it where a folder system, with the individual posts of unimportant weeks hidden from view until required.
  - LAYOUT-2.3 When the user taps on a course content title in the library screen, the content must load in a new screen for reading.
  
- LAYOUT-3.0 The Manage Habit screen allows the user to manage their habits (see below).
  - LAYOUT-3.1 The user must be able to select any one of the four key habits and be able to edit the text of the habit, if they have unlocked this habit/feature.
  - LAYOUT-3.2 The user must be able to select any of the active habits and control notification settings for that habit.
  
- LAYOUT-4.0 The Settings screen gives the user control over their account and fundamental workings of the app.
  - LAYOUT-4.1 There must be a user interface to control various nofitication settings.
  - LAYOUT-4.2 There must be a user interface to control the time that the habit tracker will reset.
  
Reporting Features
------------------
How will you learn about the progression of your clients? (Not fully defined.)

- REPORTING-0.0 The progress of the user must be reported weekly, depending on when the user opens the app to send data.
- REPORTING-0.1 The progress is anonymised, and the data is gathered to get an idea of how well the data is working. 
