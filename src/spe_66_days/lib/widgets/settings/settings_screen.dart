import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/edit_notification_widget.dart';

class SettingsWidget extends StatefulWidget {
  final bool compact;

  SettingsWidget({this.compact = false});

  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsScreen extends SettingsWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  SettingsScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor, bool compact = false}) : super(compact: compact);
}


class SettingsState extends State<SettingsWidget> {
  SettingsState();

  Widget build(BuildContext context) {

    return Scaffold(

        body:  Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(children: <Widget>[
             EditNotificationWidget(Global.instance.settings.dailyNotification)
            ])
        ));
  } // Build
} // _HabitsState
