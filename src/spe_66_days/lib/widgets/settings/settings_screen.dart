import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/edit_notification_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<FirebaseUser> _user;

  @override
  void initState() {
    super.initState();
    _user = Global.auth.currentUser();
  }

  Widget build(BuildContext context) {

    return Scaffold(

        body:  Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              FutureBuilder<FirebaseUser>(
                future: _user, // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('Error: Unstarted');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Text('Awaiting result...');
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      print(snapshot.data.toString());

                      return Stack(children: <Widget>[
                        Align(child: Row( children: <Widget>[
                          snapshot.data.isAnonymous ? Icon(Icons.person, size: 50) : Image.network(snapshot.data.photoUrl, height: 50),
                          Container(child: Text('${snapshot.data.isAnonymous ? "Anonymous" : snapshot.data.displayName}'), padding: EdgeInsets.only(left:5.0))]), alignment: Alignment.centerLeft),
                        Align(child: FlatButton(child: Text("Sign out"), onPressed: (){
                          Global.auth.signOut();
                          Navigator.pushReplacementNamed(context, "sign_in");
                        }), alignment: Alignment.centerRight)
                      ]);
                  }
                  return null; // unreachable
                },
              ),
              Divider(indent: 5.0, color: Colors.black),
              ExpansionTile(title: Text("End of day Notification"), children: <Widget>[EditNotificationWidget(Global.instance.settings.dailyNotification)]),
            ])
        ));
  } // Build
} // _HabitsState
