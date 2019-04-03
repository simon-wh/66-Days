import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/HabitListWidget.dart';
import 'package:spe_66_days/widgets/habits/EditHabitWidget.dart';
import 'package:spe_66_days/classes/Global.dart';

class HabitsWidget extends StatefulWidget {
  final bool editable;
  final mode displayMode;

  HabitsWidget({this.editable = true, this.displayMode = mode.Standard});

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
    List<Widget> habits = Global.habitManager.getHabits().keys.map((key) {
      return HabitListWidget(key, editable: this.widget.editable, displayMode: this.widget.displayMode);
    }).toList();

    if (this.widget.displayMode != mode.Standard)
      return Column(mainAxisSize: MainAxisSize.min, children: habits);
    else {
    return Scaffold(
      floatingActionButton:  FloatingActionButton.extended(
          onPressed: () {
            CoreHabit _habit = Global.habitManager.newCustomHabit();
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit.key)));
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
