import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/Stats.dart';
import 'dart:collection';
import 'dart:math';
import 'package:spe_66_days/classes/Global.dart';
import 'package:tuple/tuple.dart';

class StatsWidget extends StatelessWidget {
  final List<Stat> stats = [
    Stat("Perfect Days", Icon(Icons.check), perfectDaysCount, false),
    Stat("Total Habits Done", Icon(Icons.check_circle_outline), habitsDone, true),
    Stat("Current Streak", Icon(Icons.whatshot), calcStreak, false),
    Stat("Best Streak", Icon(Icons.star), bestStreak, false),
    Stat("Habit Daily Average", Icon(Icons.calendar_today), habitAvgToday, false),
    Stat("Habits Checked Today", Icon(Icons.calendar_today, color: Colors.red),
        habitsToday, true)
  ];

  final String habitKey;

  StatsWidget({this.habitKey});

  static HashSet<DateTime> intersection(List<HashSet<DateTime>> habits) {
    return habits.length>0 ? habits.reduce((u, v) => u.intersection(v)) : HashSet<DateTime>();
  }

  static HashSet<DateTime> intersectionWithStartDate(List<Tuple2<DateTime, HashSet<DateTime>>> fhabits) {
    if (fhabits.length ==0)
      return HashSet<DateTime>();

    var habits = fhabits.toList();
    habits.sort((u,v) => u.item1.compareTo(v.item1));
    var first = habits.removeAt(0);
    return habits.fold(first.item2, (s, u) {
      var intersectElements = s.where((e)=>!e.isBefore(u.item1)).toSet();
      var intersected = intersectElements.intersection(u.item2);
      var prevElems = s.where((e)=>e.isBefore(u.item1)).toSet();
      var set = prevElems.union(intersected);
      return HashSet<DateTime>.from(set);
    });
    //return habits.length>0 ? habits.reduce((u, v) => Tuple2<DateTime, HashSet<DateTime>>(u.item1, HashSet<DateTime>.from( u.item2.takeWhile((d) => d.isAfter(v.item1)).toSet().intersection(v.item2).toSet().union(u.item2.takeWhile(((d) => d.isBefore(v.item1))).toSet()).toSet()))).item2 : HashSet<DateTime>();
  }

  static HashSet<DateTime> union(List<Tuple2<DateTime, HashSet<DateTime>>> habits) {
    return habits.fold(HashSet<DateTime>(), (u, v) => u.union(v.item2));
    //return habits.reduce((u, v) => Tuple2<DateTime, HashSet<DateTime>>(u.item1, u.item2.union(v.item2))).item2;
  }

  static int perfectDaysCount(List<Tuple2<DateTime, HashSet<DateTime>>> habits) {

    return intersectionWithStartDate(habits).length;
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
        if (currentStreak.length > 0)
          streaks.add(currentStreak);
        currentStreak = List<DateTime>();
        currentStreak.add(date);
      }

      lastDate = date;
    }
    if (currentStreak.length > 0)
      streaks.add(currentStreak);
    return streaks;
  }

  static int calcStreak(List<Tuple2<DateTime, HashSet<DateTime>>>  habits) {
    return calcStreakWithDate(habits, Global.currentDate);
  }

  static int calcStreakWithDate(List<Tuple2<DateTime, HashSet<DateTime>>> habits, DateTime currentDate) {
    List<DateTime> streak = new List<DateTime>();
    int streakCount = 0;
    if (habits.length == 0)
      return 0;

    var s = streaks(intersectionWithStartDate(habits));
    if (s.isEmpty) return 0;
    if (currentDate.isBefore(s.last.last)){
      s.forEach((list) {
        if(list.contains(currentDate)){
          streak = list;
        }
      });
    }
    else {
      streak = s.last;
    }
    if(streak.contains(currentDate)){
      streakCount = streak.indexOf(currentDate) + 1;
    }
    else if( streak.contains(currentDate.add(Duration(days: -1))) ){
      streakCount = streak.indexOf(currentDate.add(Duration(days: -1))) + 1;
    }
    return streakCount;
  }

  static int bestStreak(List<Tuple2<DateTime, HashSet<DateTime>>> habits) {
    if (habits.isEmpty) return 0;
    var s = streaks(intersectionWithStartDate(habits));
    if (s.length == 0) return 0;

    return s.map((v) => v.length).reduce(max);
  }

  static int habitsDone(List<Tuple2<DateTime, HashSet<DateTime>>> habits) {
    return habits.fold(0, (n, s) => n + s.item2.length);
  }

  static int habitsOnDate(List<Tuple2<DateTime, HashSet<DateTime>>> habits, DateTime onDate) {
    return habits.fold(0, (n, s) => n + (s.item2.contains(onDate) ? 1 : 0));
  }

  static int habitsToday(List<Tuple2<DateTime, HashSet<DateTime>>> habits) {
    return habitsOnDate(habits, Global.currentDate);
  }

  static double habitAvgOnDate(List<Tuple2<DateTime, HashSet<DateTime>>> habits, DateTime endDate) {
    if (habits.isEmpty) return 0.0;
    var s = union(habits).toList()..sort();
    if (s.length == 0) return 0.0;
    DateTime first = s.first;
    DateTime last = s.last;
    if (last.isAfter(endDate)) return 0.0;
    return (habitsDone(habits) / (endDate.difference(first).inDays + 1));
  }

  static double habitAvgToday(List<Tuple2<DateTime, HashSet<DateTime>>> habits){
    return habitAvgOnDate(habits, Global.currentDate);
  }

  @override
  Widget build(BuildContext context) {

    List<Tuple2<DateTime, HashSet<DateTime>>> habits = this.habitKey == null ?
        Global.habitManager.getHabits().values.map((s) => Tuple2<DateTime, HashSet<DateTime>>(s.startDate, s.markedOff)).toList() : <Tuple2<DateTime, HashSet<DateTime>>>[Tuple2<DateTime, HashSet<DateTime>>(Global.habitManager.getHabit(this.habitKey).startDate, Global.habitManager.getHabit(this.habitKey).markedOff)];
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: stats.map((stat) {
            if (this.habitKey != null && stat.onlyAllHabit)
              return Container();

            num val = stat.habitFunc(habits);
            String str = val is double ? val.toStringAsFixed(1) : val.toString();
            return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Container(width:40,alignment: Alignment.centerLeft, child:stat.icon), Text("${stat.title}"), Container(width:40, alignment: Alignment.centerRight, child:Text(str))],
            );
          }).toList(),
        ));
  }
}
