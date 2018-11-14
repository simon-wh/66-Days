OO Design & UML
---------------

Provide a high-level architecture diagram of your application. The diagram should make clear if you are building a client-server application, or a stand alone application. It should include relevant external systems (if applicable) your application depends on.

For the diagram, add two or three paragraphs that explain what the meaning of the components represented in the diagram.

Provide one example of a static and a dynamic UML modelling aspect of your system.

Together with the diagram provide a section of written text that describes:

The context within which you created this diagram. This might for example be the use case that you were working on or modelling.
The motivation behind your choice of this particular aspect. This might be due to a challenging design decision or uncertainty about the relationship of domain concepts.
A brief reflection on the modelling choices you made and any knowledge that you gained from this model.
This section must not exceed 3 pages of A4, including the diagrams and their respective analysis.

# High-level Architecture diagram
![The Architecture Diagram](https://raw.githubusercontent.com/simon-wh/66-Days/master/Portfolio%20A/Images/Architecture%20diagram.jpg)

Each annotated arrow desrcibes the following processes:
    1. The user sends data to the device, this could be a checked habit for the day, for example.
    1. The data sent to the device from the user is then forwareded to the Habit manager, which will process and update the appropriate        variables within the application.
    1. The Habit manager will send the appropriate data to the server, i.e. the information surrounding habit completion overall.
    1. The Habit manager processes the score

# Static UML Diagram: Habits
![](https://github.com/simon-wh/66-Days/blob/master/Portfolio%20A/Images/Habits%20UML.png?raw=true)

