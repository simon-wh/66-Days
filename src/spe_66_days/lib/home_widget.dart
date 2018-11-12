import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'progress_widget.dart';
import 'habits_widget.dart';

/*This widget will act as the homepage. Stateful widgets are useful for when the
  interface will change depending on the state of the application. In this example
  the navigation bar will make the Home widget render a different widget based
  on what tab has been selected.
*/
class Home extends StatefulWidget {
  /*This widget doesn't have a build class. When it comes to StatefulWidgets
    the build method is implemented in the widgets corresponding State class.
    Therefore the only required method in a StatefulWidget is the createState
    method, which simply returns an instance of a _HomeState class. The
    "_" is Dart syntax for private
  */
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  /*The currentIndex will decide which widget in the list of children is currently
    being used.
  */
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    HabitsWidget(),
    ProgressWidget.withSampleData(),
    PlaceholderWidget(Colors.yellow),
    PlaceholderWidget(Colors.black)
  ];

  /*This function updates the state of the widget so that the current index is the
    index that gets passed, in this case which item has been pressed on the navigation bar
  */
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //Here is the build method that needs to be implemented for a StatefulWidget
  @override
  Widget build(BuildContext context) {
    //A scaffold widget provides useful properties to layout a main screen
    return Scaffold(
      //We put an Appbar in the scaffold
      appBar: AppBar(
        centerTitle: true,
        title: Text('66 Days',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      /*This states that the body of the scaffold (the bit between the app and navigation bar)
        will be which ever widget belongs to the currentIndex
      */
      body: _children[_currentIndex],
      //We also put a bottom navigation bar in the scaffold
      bottomNavigationBar: BottomNavigationBar(
        /*To allow more than 3 items to be added to a BottomNavigationBar
          it must be declared as fixed, else the framework decides to change
          the BNB type to shifting, which changes the 'theme' or 'colour' scheme
          of the bar to match it's background
        */
        type: BottomNavigationBarType.fixed,
        /*This states that when an item on the bar is tapped, it calls the function
          onTabTapped
        */
        onTap: onTabTapped,
        //This sets the currentIndex of the BNB to the current index held in the states' property
        currentIndex: _currentIndex,
        /*Below is all the items that will belong to the navigation bar
          each time this item is pressed, it changes the widget
        */
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text('Habits'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.timeline),
            title: new Text('Progress'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.laptop),
            title: new Text('Webinar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}