import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/stats.dart';
import 'dart:collection';
import 'dart:math';
import 'package:spe_66_days/classes/Global.dart';

class StatsWidget extends StatelessWidget {
  List<Stat> stats = [
    Stat("Perfect Days", Icon(Icons.check), perfectDaysCount),
    Stat("Total Habits Done", Icon(Icons.check_circle_outline), habitsDone),
    Stat("Current Streak", Icon(Icons.whatshot), calcStreak),
    Stat("Best Streak", Icon(Icons.star), bestStreak),
    Stat("Habit Daily Average", Icon(Icons.calendar_today), habitAvgToday),
    Stat("Habits Checked Today", Icon(Icons.calendar_today, color: Colors.red),
        habitsToday)
  ];

  final String habitKey;

  StatsWidget({this.habitKey});

  static HashSet<DateTime> intersection(List<HashSet<DateTime>> habits) {
    return habits.reduce((u, v) => u.intersection(v));
  }

  static HashSet<DateTime> union(List<HashSet<DateTime>> habits) {
    return habits.reduce((u, v) => u.union(v));
  }

  static int perfectDaysCount(List<HashSet<DateTime>> habits) {
    return intersection(habits).length;
  }

  static List<List<DateTime>> streaks(HashSet<DateTime> set) {
    SplayTreeSet<DateTime> sorted = SplayTreeSet.from(set);
    List<List<DateTime>> streaks = List<List<DateTime>>();
    List<DateTime> currentStreak = List<DateTime>();
    DateTime lastDate;
    for (DateTime date in sorted) {
      if (lastDate == null)
        currentStreak.add(date);
      else if (date.difference(lastDate).inDays == 1)
        currentStreak.add(date);
      else {
        streaks.add(currentStreak);
        currentStreak = List<DateTime>();
        currentStreak.add(date);
      }

      lastDate = date;
    }
    if (currentStreak.length != 0)
      streaks.add(currentStreak);
    return streaks;
  }
  static int calcStreak(List<HashSet<DateTime>> habits) {
    return calcStreakWithDate(habits, Global.currentDate);
  }

  static int calcStreakWithDate(List<HashSet<DateTime>> habits, DateTime currentDate) {
    if (habits.length == 0)
      return 0;

    var s = streaks(intersection(habits));
    if (s.length == 0) return 0;
    if (currentDate.isBefore(s.last.last)){
      throw Exception("currentDate out of range!");
    }
    var streak = s.last;
    return streak.contains(currentDate) ||
            streak.contains(currentDate.add(Duration(days: -1)))
        ? streak.length
        : 0;
  }

  static int bestStreak(List<HashSet<DateTime>> habits) {
    if (habits.isEmpty) return 0;
    var s = streaks(intersection(habits));
    if (s.length == 0) return 0;

    return s.map((v) => v.length).reduce(max);
  }

  static int habitsDone(List<HashSet<DateTime>> habits) {
    return habits.fold(0, (n, s) => n + s.length);
  }

  static int habitsOnDate(List<HashSet<DateTime>> habits, DateTime onDate) {
    return habits.fold(0, (n, s) => n + (s.contains(onDate) ? 1 : 0));
  }

  static int habitsToday(List<HashSet<DateTime>> habits) {
    return habitsOnDate(habits, Global.currentDate);
  }

  static double habitAvgOnDate(List<HashSet<DateTime>> habits, DateTime endDate) {
    if (habits.isEmpty) return 0.0;
    var s = union(habits).toList()..sort();
    if (s.length == 0) return 0.0;
    DateTime first = s.first;
    DateTime last = s.last;
    if (last.isAfter(endDate)) return 0.0;
    return (habitsDone(habits) / (endDate.difference(first).inDays + 1));
  }

  static double habitAvgToday(List<HashSet<DateTime>> habits){
    return habitAvgOnDate(habits, Global.currentDate);
  }

  @override
  Widget build(BuildContext context) {
    List<HashSet<DateTime>> habits = this.habitKey == null ?
        Global.habitManager.getHabits().values.map((s) => s.markedOff).toList() : <HashSet<DateTime>>[Global.habitManager.getHabit(this.habitKey).markedOff];
    return Container(
        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: stats.map((stat) {
            num val = stat.habitFunc(habits);
            String str =
                val is double ? val.toStringAsFixed(1) : val.toString();
            return Stack(
              children: <Widget>[Align(child: stat.icon, alignment: Alignment.centerLeft), Center(child: Text("${stat.title}")), Align(child: Text(str), alignment: Alignment.centerRight)],
            );
          }).toList(),
        ));
  }
}
