import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/screen_navigation.dart';
import 'package:spe_66_days/classes/HabitManager.dart';

void main() => runApp(StartApp());

/*Creates a stateless widget called startApp. It is stateless as nothing within
  the build method depends on any state update from the app.
*/
class StartApp extends StatelessWidget{
    //All StatelessWidgets need a build method to create the user interface.
  @override
  Widget build(BuildContext context){
    HabitManager.instance.load();

    /*The startApp widget simply creates a new Material App and sets the
      home property to the first page or widget that is to be displayed. In this
      case, the home page.
    */
    return MaterialApp(
      builder: (context, child) =>
          MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
      title: '66 Days',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          canvasColor: Colors.white,
          accentColor: Colors.white,
          fontFamily: 'Rubik',
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          body1: TextStyle(fontSize: 24.0),
          body2: TextStyle(fontSize: 14.0)
        )
      ),
      home: ScreenNavigation(),
    );
  }
}
