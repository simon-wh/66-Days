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
      theme: ThemeData(fontFamily: 'Rubik'),
      home: ScreenNavigation(),
    );
  }
}
