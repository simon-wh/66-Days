import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'progress_widget.dart';
import 'package:spe_66_days/widgets/habits_widget.dart';
import 'package:spe_66_days/classes/HabitManager.dart';

/*This widget will act as the homepage. Stateful widgets are useful for when the
  interface will change depending on the state of the application. In this example
  the navigation bar will make the Home widget render a different widget based
  on what tab has been selected.
*/
class ScreenNavigation extends StatefulWidget {
  /*This widget doesn't have a build class. When it comes to StatefulWidgets
    the build method is implemented in the widgets corresponding State class.
    Therefore the only required method in a StatefulWidget is the createState
    method, which simply returns an instance of a _HomeState class. The
    "_" is Dart syntax for private
  */
  @override
  State<StatefulWidget> createState() {
    return _ScreenNavigationState();
  }
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  /*The currentIndex will decide which widget in the list of children is currently
    being used.
  */
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _children = [
    PlaceholderWidget(new Icon(Icons.home), new Text('Home'), Colors.white),
    HabitsWidget(new Icon(Icons.assignment), new Text("Habits")),
    ProgressWidget.withSampleData(new Icon(Icons.timeline), new Text('Progress')),
    PlaceholderWidget(Icon(Icons.person), Text('Profile'), Colors.blue)
  ];

  /*This function updates the state of the widget so that the current index is the
    index that gets passed, in this case which item has been pressed on the navigation bar
  */
  void onTabTapped(int index) {
    setState(() {
      if (_currentIndex == _children.indexWhere((b) => b is HabitsWidget))
        HabitManager.instance.save();

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
        title: Text('6 6 DAYS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      /*This states that the body of the scaffold (the bit between the app and navigation bar)
        will be which ever widget belongs to the currentIndex
      */
      body: _children[_currentIndex] as Widget,
      //We also put a bottom navigation bar in the scaffold
      bottomNavigationBar: BottomNavigationBar(
        /*To allow more than 3 items to be added to a BottomNavigationBar
          it must be declared as fixed, else the framework decides to change
          the BNB type to shifting, which changes the 'theme' or 'colour' scheme
          of the bar to match it's background
        */
        type: BottomNavigationBarType.fixed,

        fixedColor: Colors.black,
        /*This states that when an item on the bar is tapped, it calls the function
          onTabTapped
        */
        onTap: onTabTapped,
        //This sets the currentIndex of the BNB to the current index held in the states' property
        currentIndex: _currentIndex,
        /*Below is all the items that will belong to the navigation bar
          each time this item is pressed, it changes the widget
          We map the list of the children to the BottomNavigationBarItems that we want
        */
        items: _children.map((n) => BottomNavigationBarItem(icon: n.icon, title: n.title, activeIcon: n.activeIcon, backgroundColor: n.backgroundColor)).toList()
      ),
    );
  }
}