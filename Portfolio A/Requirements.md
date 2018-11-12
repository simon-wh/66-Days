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

Ben wishes to monitor the overall engagement with his course. To do this, the user's device must send regular update messages to the server with how well the user is doing, and this data must be processed and stored by the server in a way that Ben can use.

### User Goals
* The user wants to track their progress throughout the course, and see how well they are doing. They regularly check off the habits they complete into the app, which the app stores internally and uses to create a score for them and display progress charts. 
* The user wants to read the content related to the course, which server provides to the app. They access the content within the app via a library folder stucture, with the course material broken into blog posts for each week.
* The user wants to update a habit text...
* The user wants to update notification settings...
* The user wants to set a self image goal...
* The user wants to start/restart the course...

## Use Case Goals
> For a core set of the use-case goals, list the sequence of steps involved in achieving each goal. Within this set, describe at least one alternative and one exceptional flow.

* Tracking Progress (exception - the user misses a day! alternative - the first photography observation week)
* Updating Habit Settings (exception - the user puts in bad input. alternative - only certain settings are updated, or the user cancels the update before completing it.)

## Sample Goal Analysis

> Select one goal that you believe to be of paramount importance or of particular interest. For this goal, decompose the flow steps into a set of atomic requirements. Specify both functional and non-functional requirements as structured natural language, using a clear and simple template structure. It is up to you to decide what fields to include in your template, but you are advised to keep things simple (whilst providing as much detail). As with many things, this is a delicate balance to reach !

> To give you an idea of the complexity and detail expected in your portfolio, this whole section should occupy approximately 4 pages of A4.
