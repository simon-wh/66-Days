import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'CourseEntryWidget.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/API.dart';

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
  static List<CoreHabit> habits = Global.habitManager.getHabits().values.toList();
  DateTime earliestDate = habits.isEmpty ? Global.currentDate : findEarliest( habits );

  static DateTime findEarliest( List<CoreHabit> habits) {
    DateTime earliest = Global.currentDate;
    habits.forEach((habit) {
      if(habit.startDate.isBefore(earliest)){
        earliest = habit.startDate;
      }
    });
    return earliest;
  }

  String _errorText(Exception e){
    return e is UnauthorizedException ? "You are unauthoized. Contact the App Owner" : "Could not refresh the Course.\nCheck your internet connection?";
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                await Global.courseManager.getCourseEntries(force: true).catchError((e){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(_errorText(e))));
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
                    return Center(child:Text(_errorText(snapshot.error as Exception)));
                  List<CourseEntry> entries = snapshot.data;
                  return
                ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    CourseEntry entry = entries[index];
                    bool current =
                    (Global.currentDate.isAfter(earliestDate.add(Duration(days: 7 * (entry.weekNo - 1), milliseconds: -1)))
                        &&
                      Global.currentDate.isBefore(earliestDate.add(Duration(days: 7 * entry.weekNo))));
                    bool enabled = (entry.weekNo == 1) ? true
                        : (Global.currentDate.isAfter(earliestDate.add(Duration(days: (7 * (entry.weekNo - 1)), milliseconds: -1))));
                    return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.all(5.0),
                        child:
                        Container(
                          //constraints: BoxConstraints(maxHeight: 100.0),
                          child: Container(
                              child: ListTile(
                                  leading: CircleAvatar(backgroundColor: Theme.of(context).canvasColor, foregroundColor: Theme.of(context).accentColor, child: Icon(Icons.book)),
                                  title: Text("Week ${entry.weekNo}"),
                                  subtitle: Text(entry.title),
                                  onTap: () {
                                    if (enabled)Navigator.push(context, MaterialPageRoute(builder: (context) => CourseEntryScreen(entry)));
                                  },
                                  trailing: Icon(enabled ? Icons.arrow_forward_ios : Icons.lock))),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment(0.7, 0.0),
                              // 10% of the width, so there are ten blinds.
                              colors: [current ? Colors.green : (enabled ? Colors.orange : Colors.grey), Theme.of(context).cardColor],
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
