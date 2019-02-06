import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/habit_list_widget.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/classes/Global.dart';

class HabitsWidget extends StatefulWidget {
  final bool compact;

  HabitsWidget({this.compact = false});

  @override
  State<StatefulWidget> createState() {
    return _HabitsState();
  }
}

class HabitsScreen extends HabitsWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  HabitsScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor, bool compact = false}) : super(compact: compact);
}


class _HabitsState extends State<HabitsWidget> {
  _HabitsState();

  Widget build(BuildContext context) {
    List<Widget> habits = Global.habitManager.getHabits().entries.map((entry) {
      CoreHabit _habit = entry.value;
      return HabitListWidget(_habit, editable: !this.widget.compact, displayMode: this.widget.compact ? mode.Minimal : mode.Standard);
    }).toList();

    if (this.widget.compact)
      return Column(mainAxisSize: MainAxisSize.min, children: habits);
    else {
    return Scaffold(
      floatingActionButton: !this.widget.compact? FloatingActionButton.extended(
          onPressed: () {
            CoreHabit _habit = Global.habitManager.newCustomHabit();
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit)));
            setState(() {
              Global.habitManager.save();
            });
          },
          icon: Icon(Icons.add),
          label: const Text('Add Habit')) : null,
      body:  Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView(children: habits, shrinkWrap: true),
    ));
  }
  } // Build
} // _HabitsState
