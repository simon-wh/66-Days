import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';

enum mode{Compact, Minimal, Standard}

class HabitListWidget extends StatefulWidget {
  final CoreHabit habit;
  final bool editable;
  final mode displayMode;

  HabitListWidget(this.habit, {this.editable = true, this.displayMode = mode.Standard});

  @override
  State<StatefulWidget> createState() => HabitListState();
}

class HabitListState extends State<HabitListWidget> {
  DateTime _currentDate =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  HabitListState();

  @override
  Widget build(BuildContext context) {
    double iconSize = (this.widget.displayMode != mode.Standard) ? 15.0 : 24.0;
    GestureDetector icon = GestureDetector(onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(this.widget.habit)));
    }, child: Container(
      padding: EdgeInsets.only(right: 15.0),
      child: Icon(Icons.edit, size: iconSize),
    ));
    return Column(
      children: <Widget>[
        (this.widget.displayMode != mode.Minimal) ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Expanded(
                child: Padding(
                  padding: this.widget.editable ? EdgeInsets.only(left: 15.0 + iconSize) : const EdgeInsets.all(0.0),
                  child:
                  Text(this.widget.habit.title,
                      textAlign: TextAlign.center,
                      style: (this.widget.displayMode == mode.Compact) ? TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)
                          : Theme.of(context).textTheme.title),
                ),
              ),

              this.widget.editable ? icon : Container()
            ]) : Container(),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Checkbox(
                    activeColor: Colors.black,
                    value: this.widget.habit.markedOff.contains(_currentDate),
                    onChanged: (bool checked) {
                      if (checked) {
                        if (this.widget.habit.markedOff.add(_currentDate))
                          HabitManager.instance.save();
                      }
                      else {
                        if (this.widget.habit.markedOff.remove(_currentDate))
                          HabitManager.instance.save();
                      }

                      setState(() {});
                    },
                  ),
                  Text(this.widget.habit.experimentTitle, style: Theme.of(context).textTheme.body2),
                ],
              ),
              (this.widget.editable && this.widget.displayMode == mode.Minimal) ? icon : Container(),
            ]
        ),
      ],
    );
  }
}
