Functional Requirements
=======================
These requirements describe how the app and supporting systems will function.
- TIMELINE
- HABITS
- COURSE
- PROGRESSION
- SETTINGS

Timeline Features
-----------------
These functional requirements are to do with how the app changes and progresses over time, from the start of the course until after the course has finished. TIMELINE-0.x requirements should be functional throughout the entire user journey, and TIMELINE-y.x requirements should be functional on week y.

- **TIMELINE-0.0** At the end of each week, blog posts for the next week must unlock. This is also true for all future weeks until the end of the course. (This stops the user from rushing through all the content.)
- TIMELINE-0.1 Within the blog posts for the current week, new blog post content is unlocked as the user finishes reading the previous blog post. This continues until the user runs out of material for the current week, and they then have to wait until the next week to be able to access more.

- **TIMELINE-1.0** The app must greet a new user with a welcoming message and tutorial guide. (The first tutorial blog post shall explain features of the app to new users, and the users first experiment - self observation of diet for a week, through taking photos regularly.)
- TIMELINE-1.1 The app must have a habit for the first week, which the user can check to show they've taken photos of their meals. (This familiarises the user with the habit checking system and scoring system.

- **TIMELINE-2.0** At the end of the first week, the app must allow the user to enter a **self-image goal**. (This self image goal is displayed on the home screen, and is the underlying motivation for completing the habits.)
- TIMELINE-2.2 At the end of the first week, the user sets their first habit around the theme of **eating slowly**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.
- TIMELINE-2.3 At the end of the first week, the food observation habit stops running, and the users first self defined habit replaces it.

- **TIMELINE-4.0** At the end of the third week, the user sets their first habit around the theme of **drinking water**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-6.0** At the end of the fifth week, the user sets their first habit around the theme of **portion control**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-8.0** At the end of the fifth week, the user sets their first habit around the theme of **eating whole foods**. They set the habit by reading a blog post, and being prompted with ideas for how to implement the habit, and then typing out their own implementation into a text input.

- **TIMELINE-10.0** At the end of the course, a congratulatory message should be displayed, and the user is invited to look over the progress thoughout the ten weeks.
- TIMELINE-10.1 The user must be able to continue to use the app after the course has finished, new content will not be unlocked, but they are able to keep adding to their score / completing habits as normal.

Progression Features
--------------------
These functional requirements are to do with how habits are scored, in what way the users progress is tracked and visualised.

- PROGRESSION-0.0 The completion of habits must contribute/add to an overall score, stored within the app.
- PROGRESSION-0.1 As you complete habits, a multiplier effect occurs to the score you gain from completing a habit. For example, completing a habit once may gain you 5 points, twice - 6 points, three times, 8 points. 
- PROGRESSION-0.2 There is a streak bonus adding to the users total score for consistently performing habits daily. This should be implemented in a way that doesn't punish failure.

- PROGRESSION-1.0 There must be a line graph on the home page showing the users overall progress in terms of score since the start of the course.
- PROGRESSION-1.1 When the user taps on the line graph, additional statistics should be displayed regarding the users frequency of completing habits. For example, a heatmap showing activity per day.

Habit Features
--------------
These functional requirements are to do with how habits work, in what way they are managed and displayed.

- HABIT-0.0 Habits must be displayed as a checklist on the home screen of the app (this allows the user to easily check off their progress at the end of the day, making the barrier for tracking their progress as low as possible).
- HABIT-0.1 Habits are ticked off once daily. The habit gets reset (it can be ticked again) after a time specified by the user. By default, the habit checker should reset at 3am in the morning.
- HABIT-1.0 Habits must be able to be edited after two weeks of that habit being part of their daily routine. (This is either to make the habit easier if the habit is unrealistic or to build on the habit). 
- HABIT-1.1 When a habit is availible to be edited, the user should be notified that they have unlocked this feature. (Ideally, the notification should tell the user why they might want to edit the habit).
- HABIT-2.0 The user must have control over how they are notified to act on each habit / check in. Control includes whether the notification shows, and what time the notification shows. There is only one notification for each habit. (The app should help the user in their day to day life, and not annoy or distract them. Hence, the control of notifications is vital.)

Course Features
------------------
These functional requirements are to do with how the app displays and curates course content.

- COURSE-0.0 Course content must be stored externally on a website and then pulled into the app for display. (This means that Ben can edit the course content without having to modify or update the app itself.)
- COURSE-0.1 Course content must be readable, that is a font-size greater than 8px on mobile devices.

<br>
<br>
<br>

Non-Functional Requirements
===========================
