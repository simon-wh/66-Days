# Development Testing

### Testing each component in the architecture diagram

#### Server tests

To test that information stored on the server is correct, we will use black box testing. We would like to ensure that our range of inputs to the server, gets stored and remains unedited on the server, so that when the data is recalled, it is exactly the same as we stored it. This tests all aspects of Ben pushing updates of course content to the server, whilst receiving usage data of all his clients, and also that the course content is replicated correctly to the user.

#### Mobile App tests

In the App, for all the classes behind the scenes (i.e. Habit Manager, not the UI) we are approaching it using Unit testing with a mixed Black box and White box testing strategy. Firstly we will design tests based on what we would expect the result to be from the aspect we are testing. For example, for a function like `getHabit(String) : CoreHabit` we would test it giving it valid input which we would expect to return an existing `CoreHabit` and additionally check how it acts when giving it invalid input. Once we set-up a range of black box tests and ensure those are working from our implementation, we design white box tests that focus primarily on parts of the code we think may break on certain input. We also do this to see if we can throw out some tests in cases where the function is just passing along some default parameters to another fully tested function (i.e. `checkHabit` and `uncheckHabit` in `HabitManager` which can be seen in the Static UML diagram). Doing testing with this strategy can be very beneficial as we can ensure that we don't miss out on any particular edge cases that we may not have found through the Black box testing.

For the UI part of the App we will approach it using the Widget testing that's available in the Flutter SDK. We concluded that the UI would be changing rapidly as we were iterating on the design in parallel with feedback from Ben. As a result we decided that we would not write very in-depth Widget tests for the UI as they would become outdated fairly often and would require a lot of time to maintain. In other situations however, we felt as though the UI wouldn't vary that much so it would be fairly easy to ensure everything is working without the use of Unit tests, just through our experimenting with the app in the development environment. We will do more general overall tests to ensure the core functionality that won't really change drastically that often. However, this is mainly due to the relatively short nature of this project, if we were developing it for longer we would have more detailed tests. This would be because for a longer term project we would likely have a UI which would be staying more consistent and only seeing minor alterations, so in-depth tests would make more sense.

### Testing framework to develop the tests

Flutter and Dart have a very nice range of Testing capabilities built right in. These include Unit testing, Widget Testing (for testing UI components) and Integration testing (Which tests the system working as a whole in an emulator). For our system we'll only be making using of primarily Unit testing and some Widget testing to ensure data is processed correctly and displayed properly to the user. 

### Challenges that may affect the testability of the components

The primarily difficulty we will have when writing tests is the fact that a lot of our code will be using aspects which don't have implicit testability. Such as FirebaseAuth and the server API. Without any intervention this will result in tests not working at all. As, for example, the testing environment won't and can't have a signed in user, so all code that tries to use the signed in user will fail. To get around this we will design the system so that it's easy for aspects such as FirebaseAuth and the API can be swapped out with Mock versions which give sample returns so that the code can progress.



