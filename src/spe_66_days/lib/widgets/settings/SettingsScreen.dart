import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/EditNotificationWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


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
        resizeToAvoidBottomPadding: false,
        body:  Container(
            padding: const EdgeInsets.all(10.0),
            child: ListView(children: <Widget>[
              FutureBuilder<FirebaseUser>(
                future: _user,
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
                      var user = snapshot.data;
                      return Stack(children: <Widget>[
                        Align(child: Row( children: <Widget>[
                          user.isAnonymous ? CircleAvatar(child: Icon(Icons.person, size: 50.0), radius: 25.0) : CircleAvatar(
                            backgroundImage: NetworkImage(user.photoUrl),
                            radius: 25.0,
                            //child: user.isAnonymous ? Icon(Icons.person) : Image.network(user.photoUrl),
                          ),
                          Container(child: Text('${user.isAnonymous ? "Anonymous" : user.displayName}'), padding: EdgeInsets.only(left:5.0))]), alignment: Alignment.centerLeft),
                        Align(child: FlatButton(child: Text("Sign out"), onPressed: (){
                          Global.auth.signOut();
                          Navigator.pushNamedAndRemoveUntil(context, "sign_in", (Route<dynamic> route) => false);
                        }), alignment: Alignment.centerRight)
                      ]);
                  }
                  return null; // unreachable
                },
              ),
              Divider(indent: 5.0, color: Colors.black),
              ExpansionTile(title: Text("End of day habit checking"), children: <Widget>[EditNotificationWidget(Global.instance.settings.dailyNotification, editable: false, onChanged: (){
                Global.instance.save();
                Global.instance.scheduleAllNotifications();
              })]),
              CheckboxListTile(value: DynamicTheme.of(context).brightness == Brightness.dark, title: Text("Use Dark Mode"), onChanged: (state){
                setState((){
                  DynamicTheme.of(context).setBrightness(DynamicTheme.of(context).brightness == Brightness.light ? Brightness.dark: Brightness.light);
                });
              })
            ])
        ));
  } // Build
} // _HabitsState
