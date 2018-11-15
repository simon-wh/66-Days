# Development Testing

### Testing each component in the architecture diagram

#### Back end tests

To test that information stored on the server is correct, we will use black box testing. We would like to ensure that our range of inputs to the server, gets stored and remains unedited on the server, so that when the data is recalled, it is exactly the same as we stored it. This tests all aspects of Ben pushing updates of course content to the server, whilst recieveing usage data of all his clients, and also that the course content is replicated correctly to the user.

#### Front end tests

For two of the components within the application program of our architecture diagram, namely the habit manager and the visualisation manager, we will adopt the equivalence partioning strategy. If we hand the habit manager a range of inputs, e.g. habits being checked, then our component should behave the same for all of these inputs. It should refer to the instance of the habit and update any variables as is necessary. If we input a selection of `CoreHabit` instances to the habit manager, then it should also ensure that each of these instances are stored in the correct file format, and can also be read from this file format as appropriate.

Similarly with the visualisation manager, if we hand this component a range of inputs, with these inputs being instances of `CoreHabit`, then it should abstract the appropriate information from these inputs and display it in various formats. The behaviour for the inputs should be the same, we must ensure that that inputs get displayed in a specific form, hence equivalence partioning, but the outputted result may be different, i.e. there may be a line graph output, or a heatmap output.

To test that the course content manager is correct, we will use black box testing. We don't necessarily need to see the internal representation of this component, however we must ensure that the output is correct. The range of acceptable inputs for this component would be all of the course content that is uploaded to the server from Ben, hence the corresponding correct outputs, would simply be the same content to be outputted to the device, meaning that our code for the content manager will simply read, and write without any edits. We can do this by splitting up the input, i.e. the whole course, into the corresponding weeks. That is, we are ensuring that when we input week 1, the course content for week 1 is outputted correctly and unedited, and this is repeated for all weeks.

### Testing framework to develop the tests

We will take advantage of the JUnit framework to test our components, namely the JUnit assertions. We can use assertions on the habit manager to make sure that `CoreHabit` can be stored and read correctly, by feeding a sample `CoreHabit` storing it, and asserting that reading it back in generates the same result, which is also the same technique that can be used to assure that the course content, and other information retrieved from the server is correct. We can also assert that if we feed in a `CoreHabit` with sample specifications, then the habit manager can refer to and return any information that we require, e.g. if the Habit is checked. 

### Challenges that may affect the testability of the components

There may be issues should we wish to test that the widgets within flutter function appropriately according to the underlying logic classes in our application. To overcome this issue we will make use of flutters built in library for widget testing to ensure that values update correctly and hence show that if our logic tests pass, and the our tests for the widgets show that values within the code update appropriately, then our code should be tested to an approriate degree.



