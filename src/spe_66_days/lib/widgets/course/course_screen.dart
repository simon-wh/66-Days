import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'course_entry_widget.dart';

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
        body:  Container(
          padding: const EdgeInsets.only(top: 10.0),
          child: ListView.builder(
              itemCount: Global.courseManager.CourseWeeks.length,
              itemBuilder: (context, index) {
                CourseEntry entry = Global.courseManager.CourseWeeks[index];
                return Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(8.0)),
                    child: FlatButton(child: Text(entry.title),onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CourseEntryScreen(entry)));
                    })
                );
              })
        ));
  } // Build
} // _HabitsState
