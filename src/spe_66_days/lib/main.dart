import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/screen_navigation.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/SignIn.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() async {
  await Global.instance.init();
  runApp(StartApp());
}

/*Creates a stateless widget called startApp. It is stateless as nothing within
  the build method depends on any state update from the app.
*/
class StartApp extends StatelessWidget {
  final bool signIn;

  StartApp({this.signIn = true});

  static final navigatorKey = new GlobalKey<NavigatorState>();

  //All StatelessWidgets need a build method to create the user interface.
  @override
  Widget build(BuildContext context) {
    /*The startApp widget simply creates a new Material App and sets the
      home property to the first page or widget that is to be displayed. In this
      case, the home page.
    */
    /*ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.green,
          canvasColor: Colors.black,
          accentColor: Colors.green,
          cardColor: Colors.grey,
          fontFamily: 'Rubik',
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 26.0),
          title: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          body1: TextStyle(fontSize: 14.0)
        )
      )*/

    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.red,
              primaryColor: brightness == Brightness.dark ? Colors.teal : Colors.red,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) => MaterialApp(
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child),
              navigatorKey: navigatorKey,
              title: '66 Days',
              theme: theme,
              home: ScreenNavigation(),
              routes: {
                "home": (context) => ScreenNavigation(),
                "sign_in": (context) => SignInWidget()
              },
              initialRoute: this.signIn ? "sign_in" : "home",
            ));
  }
}
