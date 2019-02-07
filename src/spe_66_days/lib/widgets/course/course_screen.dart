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
          child: CourseEntryWidget(CourseEntry("Week Two\nEat Slowly and Savour Your Food", <CourseEntryItem>[
            CourseEntryText("Select an Experiment to Apply."),
            CourseEntryChange("Experiments", "eat_slowly", "experimentTitle", <String>[
              "put down your cutlery after each mouthful",
              "eat with your non-dominant hand",
              "set a chew goal per mouthful",
              "halve every mouthful before you eat it",
              "drink water between every mouthful",
              "use chopsticks"
            ]),
            CourseEntryChange("Environment Design", "eat_slowly", "environmentDesign", <String>[
              "eat your meals at a table. Never eat at your desk",
              "eat in a calm environment",
              "give yourself time to eat",
              "don’t eat in front of a screen",
              "eat with other people when possible",
              "don't eat out of a packet - plate up everything, even if it's just a snack",
              "try and relish what you're eating - be grateful and enjoy it!"
            ])
          ]))
        ));
  } // Build
} // _HabitsState
