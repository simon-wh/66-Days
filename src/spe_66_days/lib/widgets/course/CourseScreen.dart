import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'CourseEntryWidget.dart';

class CourseWidget extends StatefulWidget {
  final bool compact;

  CourseWidget({this.compact = false});

  @override
  State<StatefulWidget> createState() {
    return CourseState();
  }
}

class CourseScreen extends CourseWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  CourseScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor, bool compact = false}) : super(compact: compact);
}


class CourseState extends State<CourseWidget> {
  CourseState();

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                await Global.courseManager.getCourseEntries(force: true).catchError((e){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Could not refresh the Course.\nCheck your internet connection?")));
                  return null;
                });
                setState(() {

              });});
            },
            child: Container(padding: EdgeInsets.all(0.0),  child:
          FutureBuilder<List<CourseEntry>>(
            future: Global.courseManager.getCourseEntries(),
            builder: (BuildContext context, AsyncSnapshot<List<CourseEntry>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Error: Unstarted');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Align(alignment: Alignment.topCenter,  child:CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child:Text('Error: ${snapshot.error}'));
                  List<CourseEntry> entries = snapshot.data;
                  return
                //Global.courseManager.courseWeeks == null ? PageView( physics: AlwaysScrollableScrollPhysics(), scrollDirection: Axis.vertical,  children: <Widget>[Center(child:Text("Unable to load course"))]) :
                ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    CourseEntry entry = entries[index];
                    bool current = index == 2;
                    bool enabled = index <= 2;
                    return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.all(5.0),
                        child:
                        Container(
                          //constraints: BoxConstraints(maxHeight: 100.0),
                          child: Container(
                              child: ListTile(
                                  leading: CircleAvatar(backgroundColor: Theme.of(context).canvasColor, foregroundColor: Theme.of(context).accentColor, child: Icon(Icons.book)),
                                  title: Text(entry.title.split("-").first),
                                  subtitle: Text(entry.title.split("- ")[1]),
                                  onTap: () {
                                    if (enabled)Navigator.push(context, MaterialPageRoute(builder: (context) => CourseEntryScreen(entry)));
                                  },
                                  trailing: Icon(enabled ? Icons.arrow_forward_ios : Icons.lock))),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment(0.7, 0.0),
                              // 10% of the width, so there are ten blinds.
                              colors: [current ? Colors.green : (enabled ? Colors.red : Colors.grey), Theme.of(context).cardColor],
                              // whitish to gray
                              tileMode: TileMode.clamp, // repeats the gradient over the canvas
                            ),
                          ),
                        )
                    );
                  })
              ;
              }
              return null; // unreachable
            },
          )
        )));
  } // Build
} // _HabitsState
