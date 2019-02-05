//STATS CLASS:
//Stats (title, icon, calc: double Function(CoreHabit[] habits)
// finals
// this.stuff


//IN WIDGET:
//List Stats = [
// stats (perfect days, icon, calcperf)
// stats (current streak, icon, count streak)
// ]
// double calcperf{}

import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/stats.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'dart:collection';
import 'dart:math';
import 'package:spe_66_days/main.dart';

class StatsWidget extends StatelessWidget {
  List<Stat> stats = [
    Stat("Perfect Days", Icon(Icons.check), perfectDaysCount),
    Stat("Total Habits Done", Icon(Icons.check_circle_outline), habitsDone),
    Stat("Current Streak", Icon(Icons.whatshot), calcStreak),
    Stat("Best Streak", Icon(Icons.star), bestStreak),
    Stat("Habit Daily Average", Icon(Icons.calendar_today), habitAvg)
  ];

  StatsWidget();

  static HashSet<DateTime> intersection(List<HashSet<DateTime>> habits){
    return habits.reduce((u, v) => u.intersection(v));
  }

  static HashSet<DateTime> union(List<HashSet<DateTime>> habits){
    return habits.reduce((u, v) => u.union(v));
  }

  static int perfectDaysCount(List<HashSet<DateTime>> habits){
    return intersection(habits).length;
  }

  static List<List<DateTime>> streaks(HashSet<DateTime> set){
    SplayTreeSet<DateTime> sorted = SplayTreeSet.from(set);
    List<List<DateTime>> streaks = List<List<DateTime>>();
    List<DateTime> currentStreak = List<DateTime>();
    DateTime lastDate;
    for (DateTime date in sorted){
      if (lastDate == null)
        currentStreak.add(date);
      else if (lastDate.difference(date).inDays == 1)
        currentStreak.add(date);
      else
      {
        streaks.add(currentStreak);
        currentStreak = List<DateTime>();
      }

      lastDate = date;
    }
    streaks.add(currentStreak);
    return streaks;
  }

  static int calcStreak(List<HashSet<DateTime>> habits){
    var s = streaks(intersection(habits));
    if (s.length ==0)
      return 0;
    var streak = s.last;
    return streak.contains(Global.currentDate) || streak.contains(Global.currentDate.add(Duration(days: -1))) ? streak.length : 0;
  }

  static int bestStreak(List<HashSet<DateTime>> habits){
    var s = streaks(intersection(habits));
    if (s.length ==0)
      return 0;

    return s.map((v) => v.length).reduce(max);
  }

  static int habitsDone(List<HashSet<DateTime>> habits){
    return habits.fold(0, (n, s) => n + s.length);
  }

  static double habitAvg(List<HashSet<DateTime>> habits){
    var s = union(habits).toList()
      ..sort();
    DateTime first = s.first;
    return habitsDone(habits) / (Global.currentDate.difference(first).inDays + 1);
  }

  @override
  Widget build(BuildContext context){
    List<HashSet<DateTime>> habits = HabitManager.instance.getHabits().values.map((s) => s.markedOff).toList();
    return ListView(
      shrinkWrap: true,
      //physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
      //shrinkWrap: true,
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: stats.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  stats[index].icon,
                  Text("${stats[index].title}"),
                  Text("${stats[index].habitFunc(habits).toString()}")
                ],
              );
            }) // Item Builder
      ],
    );
  }
}
