import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/habit_list_widget.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/classes/Global.dart';

class HabitsWidget extends StatefulWidget {
  final bool editable;
  final mode displayMode;
  final Function onHabitChanged;

  HabitsWidget({this.editable = true, this.displayMode = mode.Standard, this.onHabitChanged});

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

  HabitsScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor}) : super(displayMode: mode.Standard, editable: true);
}


class _HabitsState extends State<HabitsWidget> {

  Widget build(BuildContext context) {
    List<Widget> habits = Global.habitManager.getHabits().entries.map((entry) {
      CoreHabit _habit = entry.value;
      return HabitListWidget(_habit, editable: this.widget.editable, displayMode: this.widget.displayMode, onHabitChanged: this.widget.onHabitChanged);
    }).toList();

    if (this.widget.displayMode != mode.Standard)
      return Column(mainAxisSize: MainAxisSize.min, children: habits);
    else {
    return Scaffold(
      floatingActionButton:  FloatingActionButton.extended(
          onPressed: () {
            CoreHabit _habit = Global.habitManager.newCustomHabit();
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit)));
            setState(() {
              Global.habitManager.save();
            });
          },
          icon: Icon(Icons.add),
          label: const Text('Add Habit')),
      body:  Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(itemCount: habits.length, itemBuilder: (context, i)=>Card(child:Container(padding: EdgeInsets.only(top: 5.0, bottom: 5.0), child: habits[i]), elevation: 2.0), shrinkWrap: true),
    ));
  }
  } // Build
} // _HabitsState
