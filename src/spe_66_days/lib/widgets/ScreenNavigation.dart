import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressWidget.dart';
import 'package:spe_66_days/widgets/habits/HabitWidget.dart';
import 'package:spe_66_days/widgets/home/HomeWidget.dart';
import 'package:spe_66_days/widgets/course/CourseScreen.dart';
import 'package:spe_66_days/widgets/settings/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spe_66_days/classes/Global.dart';

class ScreenNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScreenNavigationState();
  }
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _bottomNav = [
    HomeWidget(Icon(Icons.home), Text("Home")),
    //HabitsScreen(Icon(Icons.assignment), Text("Habits")),
    //ProgressWidget(Icon(Icons.timeline), Text('Progress')),
    CourseScreen(Icon(Icons.library_books), Text('Course')),
    //SettingsScreen(Icon(Icons.settings), Text('Settings'))
  ];

  final List<Widget> _sideNav = [
    //HomeWidget(Icon(Icons.home), Text("Home")),
    HabitsScreen(Icon(Icons.assignment), Text("Habit Manager")),
    ProgressTab(Icon(Icons.timeline), Text('Stats')),
    //CourseScreen(Icon(Icons.library_books), Text('Course')),
    SettingsScreen(Icon(Icons.settings), Text('Settings'))
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static bool hasDoneNotification = false;

  Future initFuture;

  void setFuture(){
    initFuture = Global.instance.init().whenComplete(() { if(this.mounted) setState((){}); });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFuture();
    Global.instance.notificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((val) {
      if (!hasDoneNotification && val.didNotificationLaunchApp) {
        Global.instance.onSelectNotification(val.payload);
        hasDoneNotification = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar bar = AppBar(
      centerTitle: true,
      title: Text(
        '66  DAYS',
        style: Theme.of(context).textTheme.headline,
      ),
    );

    if (!Global.instance.initialised) {
      if (initFuture == null)
        setFuture();
      //else
        //initFuture?.timeout(Duration(seconds: 1), onTimeout: ()=> setFuture());
      
      var textTheme = Theme.of(context).textTheme.body1;
      return Scaffold(appBar: bar,
          body: Align(alignment: Alignment.center,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  CircularProgressIndicator(),
              Text("Hold on...", textAlign: TextAlign.center),
              Text("Restart the app if this is taking too long",
                  textAlign: TextAlign.center, style:  textTheme.copyWith(color: textTheme.color.withOpacity(0.5)))
          ])));
    }
    return Scaffold(
      appBar: bar,
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder<FirebaseUser>(
            future: Global.auth.currentUser(),
            builder: (BuildContext context,
                AsyncSnapshot<FirebaseUser> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Error: Unstarted');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  FirebaseUser user = snapshot.data;
                  return UserAccountsDrawerHeader(
                    accountName: Text(
                        '${snapshot.data.isAnonymous ? "Anonymous" : snapshot.data.displayName}'),
                    accountEmail: Text(user.email ?? ""),
                    currentAccountPicture: user.isAnonymous
                        ? CircleAvatar(
                            child: Icon(Icons.person, size: 50.0))
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(user.photoUrl),
                            //child: user.isAnonymous ? Icon(Icons.person) : Image.network(user.photoUrl),
                          ),
                  );
              }
              return null; // unreachable
            },
          )
        ].followedBy(_sideNav.map((n) {
          if (n is BottomNavigationBarItem) {
            final bm = n as BottomNavigationBarItem;
            return ListTile(
                leading: CircleAvatar(
                    child: bm.icon,
                    backgroundColor: Theme.of(context).canvasColor,
                    foregroundColor: Theme.of(context).accentColor),
                title: bm.title,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                              appBar: AppBar(title: bm.title),
                              body: n)));
                });
          } else
            return n;
        })).toList(),
      )),
      body: _bottomNav[_currentIndex] as Widget,
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: _bottomNav
              .map((n) => BottomNavigationBarItem(
                  icon: n.icon,
                  title: n.title,
                  activeIcon: n.activeIcon,
                  backgroundColor: n.backgroundColor))
              .toList()),
    );
  }
}
