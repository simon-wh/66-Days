import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/habit_list_widget.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/main.dart';
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
    Widget view =
        new ListView.builder(
            shrinkWrap: true,
            itemCount: Global.habitManager.getHabits().length,
            itemBuilder: (BuildContext context, int index) {
              MapEntry<String, CoreHabit> entry = Global.habitManager.getHabits().entries.toList()[index];
              CoreHabit _habit = entry.value;
              return HabitListWidget(_habit, editable: !this.widget.compact, displayMode: this.widget.compact ? mode.Minimal : mode.Standard);

              /*return entry.key.startsWith(HabitManager.customHabitPrefix) ? Dismissible(
                  direction: DismissDirection.startToEnd,
                  // Each Dismissible must contain a Key. Keys allow Flutter to
                  // uniquely identify Widgets.
                  key: Key(entry.key),
                  // We also need to provide a function that will tell our app
                  // what to do after an item has been swiped away.
                  background: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(5.0),
                  ),
                  onDismissed: (direction) {
                    // Remove the item from our data source.
                    setState(() {
                      Global.habitManager.removeHabit(entry.key);
                      Global.habitManager.save();
                    });

                    // Show a snack bar! This snack bar could also contain "Undo" actions.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Custom Habit \"${_habit.title}\" removed")));
                  },
                  child: content
              ) : content;*/
            } // Item Builder
        )

    ;

    if (this.widget.compact)
      return view;
    else {
    return Scaffold(
      floatingActionButton: !this.widget.compact? FloatingActionButton.extended(
          onPressed: () {
            CoreHabit _habit = Global.habitManager.newCustomHabit();
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit)));
            setState(() {
              //Global.habitManager.save();
            });
          },
          icon: Icon(Icons.add),
          label: const Text('Add Habit')) : null,
      body:  Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: view,
    ));
  }
  } // Build
} // _HabitsState
