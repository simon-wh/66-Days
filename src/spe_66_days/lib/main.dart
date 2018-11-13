import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/home_widget.dart';

void main() => runApp(StartApp());

/*Creates a stateless widget called startApp. It is stateless as nothing within
  the build method depends on any state update from the app.
*/
class StartApp extends StatelessWidget{
  //All StatelessWidgets need a build method to create the user interface.
  @override
  Widget build(BuildContext context){
    /*The startApp widget simply creates a new Material App and sets the
      home property to the first page or widget that is to be displayed. In this
      case, the home page.
    */
    return MaterialApp(
      title: '66 Days',
      home: Home(),
    );
  }
}
