import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/classes/Global.dart';

enum mode { Compact, Minimal, Standard }

class HabitListWidget extends StatefulWidget {
  final CoreHabit habit;
  final bool editable;
  final mode displayMode;
  final Function onHabitChanged;

  HabitListWidget(this.habit,
      {this.editable = true, this.displayMode = mode.Standard, this.onHabitChanged});

  @override
  State<StatefulWidget> createState() => HabitListState();
}

class HabitListState extends State<HabitListWidget> {
  DateTime _currentDate = Global.currentDate;

  HabitListState();

  @override
  Widget build(BuildContext context) {
    double iconSize = (this.widget.displayMode != mode.Standard) ? 15.0 : 24.0;
    GestureDetector icon = GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditHabitWidget(this.widget.habit)));
        },
        child: Container(
          child: Icon(Icons.edit, size: iconSize),
        ));
    return Column(
      children: <Widget>[
        (this.widget.displayMode != mode.Minimal)
            ? Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Stack(children: <Widget>[
                  Center(
                      child: Text(this.widget.habit.title,
                          textAlign: TextAlign.center,
                          style: (this.widget.displayMode == mode.Compact)
                              ? TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold)
                              : Theme.of(context).textTheme.title)),
                  this.widget.editable
                      ? Align(child: icon, alignment: Alignment.centerRight)
                      : Container()
                ]))
            : Container(),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Checkbox(
              activeColor: Colors.black,
              value: this.widget.habit.markedOff.contains(_currentDate),
              onChanged: (bool checked) {
                if (checked) {
                  if (this.widget.habit.markedOff.add(_currentDate))
                    Global.habitManager.save();
                } else {
                  if (this.widget.habit.markedOff.remove(_currentDate))
                    Global.habitManager.save();
                }
                //this.widget?.onStateChanged();

                setState(() {
                  if (this.widget?.onHabitChanged != null)
                    this.widget?.onHabitChanged();
                });
              },
            ),
            Text(this.widget.habit.experimentTitle,
                style: Theme.of(context).textTheme.body1),
            Container()
          ],
        ),
        this.widget.habit.environmentDesign?.isNotEmpty ?? false
            ? Center(
                child: Text(this.widget.habit.environmentDesign,
                    style: Theme.of(context).textTheme.caption))
            : Container(),
        (this.widget.editable && this.widget.displayMode == mode.Minimal)
            ? icon
            : Container(),
      ],
    );
  }
}
