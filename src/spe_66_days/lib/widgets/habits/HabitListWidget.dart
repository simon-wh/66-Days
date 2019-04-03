import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/EditHabitWidget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/HabitOverview.dart';

enum mode { Compact, Minimal, Standard }

class HabitListWidget extends StatefulWidget {
  final String habitKey;
  final bool editable;
  final mode displayMode;

  HabitListWidget(this.habitKey,
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
                  builder: (context) => HabitOverview(this.widget.habitKey)));
        },
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    CoreHabit habit = Global.habitManager.getHabit(this.widget.habitKey);
    double iconSize = (this.widget.displayMode != mode.Standard) ? 15.0 : 15.0;
    var icon = Icon(Icons.more_vert, size: iconSize);
    return Column(
      children: <Widget>[
        (this.widget.displayMode != mode.Minimal)
            ? overviewTap(Stack(children: <Widget>[
                  Center(
                      child: Text(habit.title,
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

              value: habit.markedOff.contains(_currentDate),
              onChanged: (bool checked) {
                setState(() {
                  Global.habitManager.setCheckHabit(habit.key, checked);
                });
              },
            ),
            overviewTap(Text(habit.experimentTitle,
                style: Theme.of(context).textTheme.body1))]),
            (this.widget.editable && this.widget.displayMode == mode.Minimal) ? Align(alignment: Alignment.centerRight, child: overviewTap(icon)) : Container()
          ],
        ),
        habit.environmentDesign?.isNotEmpty ?? false
            ? Center(
                child: Text(habit.environmentDesign,
                    style: Theme.of(context).textTheme.caption))
            : Container(),

      ],
    );
  }
}
