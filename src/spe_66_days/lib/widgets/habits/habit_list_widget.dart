import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/habit_overview.dart';

enum mode { Compact, Minimal, Standard }

class HabitListWidget extends StatefulWidget {
  final CoreHabit habit;
  final bool editable;
  final mode displayMode;

  HabitListWidget(this.habit,
      {this.editable = true, this.displayMode = mode.Standard});

  @override
  State<StatefulWidget> createState() => HabitListState();
}

class HabitListState extends State<HabitListWidget> {
  DateTime _currentDate = Global.currentDate;

  HabitListState();

  Widget overviewTap(Widget child){
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HabitOverview(this.widget.habit.key)));
        },
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = (this.widget.displayMode != mode.Standard) ? 15.0 : 15.0;
    var icon = Icon(Icons.more_vert, size: iconSize);
    return Column(
      children: <Widget>[
        (this.widget.displayMode != mode.Minimal)
            ? overviewTap(Stack(children: <Widget>[
                  Center(
                      child: Text(this.widget.habit.title,
                          textAlign: TextAlign.center,
                          style: (this.widget.displayMode == mode.Compact)
                              ? TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold)
                              : Theme.of(context).textTheme.subhead)),
                  this.widget.editable
                      ? Align(child: icon, alignment: Alignment(0.95, 0.5))
                      : Container()
                ]))
            : Container(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
            Checkbox(

              value: this.widget.habit.markedOff.contains(_currentDate),
              onChanged: (bool checked) {
                setState(() {
                  Global.habitManager.setCheckHabit(this.widget.habit.key, checked);
                });
              },
            ),
            overviewTap(Text(this.widget.habit.experimentTitle,
                style: Theme.of(context).textTheme.body1))]),
            (this.widget.editable && this.widget.displayMode == mode.Minimal) ? Align(alignment: Alignment.centerRight, child: overviewTap(icon)) : Container()
          ],
        ),
        this.widget.habit.environmentDesign?.isNotEmpty ?? false
            ? Center(
                child: Text(this.widget.habit.environmentDesign,
                    style: Theme.of(context).textTheme.caption))
            : Container(),

      ],
    );
  }
}
