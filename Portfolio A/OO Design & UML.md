# OO Design & UML

## High-level Architecture diagram

![Architecture Diagram](https://raw.githubusercontent.com/simon-wh/66-Days/master/Portfolio%20A/Images/Architecture.png)

The architecture is split into three main components. The application code, the server and Firebase. Within the application code are the necessary components to make the app functional, the UI elements simply handle all output to the device. Global intialization communicates both internally with all other components in the app, and externally with Firebase. Internally it handles the intialization of all subsystems along with basis settings such as the end of day notification. It communicates externally with Firebase to handle things such as; authentication from signing in and signing out, Firebase in turn communicates with the server to retrieve the necessary information about the user signing in. 

Futhermore, the habit and course manager handle the main functionality of the app. The habit manager manages all tracking, adding, removing and editing of habits, whether custom or read from the course manager, it also publishes statistics to the server back end. The course manager reads from the server to update the current stage of the course, and then outputs to the habit manager when a habit is to be added as a new week has been unlocked. Both of these components communicate with the UI elements so that the appropriate information is displayed to the device.

The app owner is able to communicate with the front end in order to change the course content of the app, or to read displayed statistics of user's usage of the app.

### Activity diagram
![Activity Diagram](https://raw.githubusercontent.com/simon-wh/66-Days/master/Portfolio%20A/Images/Architecture%20diagram.jpg)

Each annotated arrow describes the following processes:
1. The user tracks a habit, or multiple habits for the day on their device.
1. The tracked habits inputted to the device is then sent as data to the habit manager, which will process and update the appropriate variables within the application.
1. The habit manager will send the appropriate information to the server, i.e. the information surrounding habit completion overall.
1. The habit manager processes the score based on the input from the user and forwards it to the visualisation class.
1. The server communicates interaction data of all users to Ben.
1. Ben sends any updates he wishes to make to the course content to the server.
1. The server forwards these updates to the class holding the course content within the application.
1. The course content is outputted to the device.
1. All data that needs visualising, e.g. Score, days logged in etc. is processed and sent to the device.
1. All recieved data is then displayed on the device for the user to view.

### Components within the application:
There are three main high level components within the application:
1. The habit manager
1. The visualisation manager
1. The course content manager

The habit manager holds information for all the habits that can be tracked and directly retrieves information of the specific instances for these habits, it also ensures that habits are being stored correctly. The visualisation manager outputs data recieved from the habit manager to the device in a specific format e.g. a line graph to show progression of habits tracked over time, any updates to the data must then be updated in real time to the visualastion manager so that the visualised data is representative. 

The course content manager simply outputs any course content that the user wishes to view to the device, and must be able to communicate with the server so that any updates that Ben wishes to make the course can be updated by him, and then displayed as required within the application. 

## Static UML: Habits
![](https://github.com/simon-wh/66-Days/blob/master/Documentation/Development/UML%20Diagrams/Habits.png?raw=true)

The habit tracking system is one of the key aspects of the 66 Days system, being one of the two core systems that the user will interact with. This system serves as a core centre-point that the other systems will interact with so it was crucial to ensure this was designed well. Pretty much everything else in the app interacts with the `HabitManager` in some shape or form, so we felt as though it was important for us to ensure a quality design for this core aspect. The habit system is used for the user to keep track of the various CoreHabits, what experiment is being tracked(See ExperimentTitle and EnvironmentDesign under CoreHabit) and to store when the experiments were marked off (through the MarkedOff property in CoreHabit). The `HabitManager` also serves to handle the notifications that have been chosen by the user for particular habits and ensure that these notifications are pushed to the user at the selected times. The core benefit we experienced from modelling this system was that we were able to find a much simpler design than we had originally planned, we had a couple of iterations of the design which all contrast with each other. For example, at first we planned for the CoreHabit class to be split into an abstract habit class to act as a blueprint for habits called `HabitBase`, and then two subclasses that inherit this for instantiation, namely `CoreHabit` and `Habit`. Upon review of this we realised that this is actually more than we needed and it would over complicate our system, and hence we went back and combined elements of all three of these classes, into one class, now called `CoreHabit`. With the resulting design being much more refined and simple, focusing on the core requirements of the system and should be easier to implement with regards to the wider system. Additionally, from modelling this we were able to find a good generic design for how systems in our app would save their data (i.e. SettingsBase<>). This was extremely helpful as it meant we could set up a basic settings class that we could reuse and improve saving functionality across all aspects of the system at once.

## Dynamic UML: User interaction with the Library

![](https://raw.githubusercontent.com/simon-wh/66-Days/master/Documentation/Development/UML%20Diagrams/Dynamic%20Library.png)

The above Dynamic UML portrays the the week-post display process. 

1. The user clicks on **Library** which opens the **Library** **screen**. The **Library** **screen** needs to display all the weeks in minimised state.
2. The **Course** **Screen** gets the week structure from the **Course Manager** class.
3.  The **Course Manager** class then communicates with the **Server** and gets the week-post information (the raw data) to be displayed (in JSON format).
4. The **Course Manager** process the raw data received by the **Server** and then displays it to the **Library** **Screen**.
5. The **Course** **Screen** displays the week structure for the user to select which **Course Entry** they want to view, as well as locking future weeks of the course from being accessed until they progress that far
6. The **Course** **Screen** generates the required widgets and displays the *Week-Post Structure* to the **User**.
7. When the **User** clicks on the individual post on the **Course** **Screen** they need to be navigated to the **Course Entry Screen**.
8. The **Course Entry** **Screen** calls the **Course Entry** class to get the information from the course to generate the required Widgets and display it to the user.

The **Motivation** behind designing this Dynamic UML is to display the contents of posts to the user in the most simple and efficient manner. Additionally, knowing when it is necessary to communicate with the server and how the data flows between the backend app code and the UI elements of the app.

**Reflection** - From designing this UML it helped us critically think about how this aspect needs to be designed to make it as simple and efficient as possible. Originally we had it so that the Course Manager would initially just get the index of all the course entries, but we decided to simplify it so it would get all the data as the payload was still relatively small. This change helped the implementation to be simpler than we would have done otherwise, avoiding unnecessary API calls. As well as producing a better user experience as it meant the course would be delivered with one load without having to load data every single time you go between each screen in the course.