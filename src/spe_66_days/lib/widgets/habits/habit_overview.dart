import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/progress_chart.dart';
import 'package:spe_66_days/widgets/progress/stats_widget.dart';
import '../progress/progress_widget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';
import 'package:spe_66_days/widgets/progress/streaks_chart.dart';

class HabitOverview extends StatefulWidget {
  final String habitKey;

  HabitOverview(this.habitKey);

  @override
  State<StatefulWidget> createState() => HabitOverviewState();
}

class HabitOverviewState extends State<HabitOverview> {
  HabitOverviewState();

  Widget build(context) {
    var habit = Global.habitManager.getHabit(this.widget.habitKey);
    return new Scaffold(
        appBar:
            AppBar(title: Text(habit.title + " Overview"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => EditHabitWidget(this.widget.habitKey))
                );
              })
        ]),
        body: ListView(children: <Widget>[
          ListTile(title: Text(habit.title), subtitle: Text(habit.experimentTitle + (habit.environmentDesign == null ? "" : '\n' + habit.environmentDesign)), isThreeLine: habit.environmentDesign != null),
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: ProgressChart.habitFromString(this.widget.habitKey)
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: StreaksChart.habitFromString(this.widget.habitKey)
          ),
          StatsWidget(habitKey: this.widget.habitKey)
        ]));
  }
}
