import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';

enum mode{Compact, Minimal, Standard}

class HabitListWidget extends StatefulWidget {
  final CoreHabit core;
  final bool editable;
  final mode displayMode;

  HabitListWidget(this.core, {this.editable = true, this.displayMode = mode.Standard});

  @override
  State<StatefulWidget> createState() => HabitListState(core, editable, displayMode);
}

class HabitListState extends State<HabitListWidget> {
  final CoreHabit habit;
  final mode displayMode;
  final bool editable;
  DateTime _currentDate =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  HabitListState(this.habit, this.editable, this.displayMode);

  @override
  Widget build(BuildContext context) {
    double iconSize = (displayMode != mode.Standard) ? 15.0 : 24.0;
    GestureDetector icon = GestureDetector(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(habit)));
    }, child: Container(
      padding: EdgeInsets.only(right: 15.0),
      child: Icon(Icons.edit, size: iconSize),
    ));
    return Column(
      children: <Widget>[
        (displayMode != mode.Minimal) ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Expanded(
                child: Padding(
                  padding: editable ? EdgeInsets.only(left: 15.0 + iconSize) : const EdgeInsets.all(0.0),
                  child:
                  Text(habit.title,
                      textAlign: TextAlign.center,
                      style: (displayMode == mode.Compact) ? TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
                          : Theme.of(context).textTheme.title),
                ),
              ),

              editable ? icon : Container()
            ]) : Container(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.black,
                    value: habit.markedOff.contains(_currentDate),
                    onChanged: (bool checked) {
                      if (checked) {
                        if (habit.markedOff.add(_currentDate))
                          HabitManager.instance.save();
                      }
                      else {
                        if (habit.markedOff.remove(_currentDate))
                          HabitManager.instance.save();
                      }

                      setState(() {});
                    },
                  ),
                  Text(habit.experimentTitle, style: Theme.of(context).textTheme.body2),
                ],
              ),
              (editable && displayMode == mode.Minimal) ? icon : Container(),
            ]
        ),
      ],
    );
  }
}
