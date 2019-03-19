import 'package:spe_66_days/widgets/progress/stats_widget.dart';
import 'dart:collection';
import 'package:flutter_test/flutter_test.dart';

void main() {
  HashSet<DateTime> streak = HashSet.from(<DateTime> [DateTime(2019, 1, 1), DateTime(2019, 1, 2), DateTime(2019, 1, 3),
                                                      DateTime(2019, 1, 4), DateTime(2019, 1, 5)]);
  HashSet<DateTime> streak1 = HashSet.from(<DateTime> [DateTime(2019, 1, 2), DateTime(2019, 1, 3), DateTime(2019, 1, 4),
                                                       DateTime(2019, 1, 5), DateTime(2019, 1, 6)]);

  HashSet<DateTime> acrossMonth = HashSet.from(<DateTime> [DateTime(2019, 1, 29), DateTime(2019, 1, 30),
                                                           DateTime(2019, 1, 31), DateTime(2019, 2, 1)]);
  HashSet<DateTime> acrossMonth1 = HashSet.from(<DateTime> [DateTime(2019, 1, 30), DateTime(2019, 1, 31),
                                                            DateTime(2019, 2, 1), DateTime(2019, 2, 2)]);

  HashSet<DateTime> acrossYear = HashSet.from(<DateTime> [DateTime(2018, 12, 29), DateTime(2018, 12, 30),
                                                          DateTime(2018, 12, 31), DateTime(2019, 1, 1)]);
  HashSet<DateTime> acrossYear1 = HashSet.from(<DateTime> [DateTime(2018, 12, 30), DateTime(2018, 12, 31),
                                                           DateTime(2019, 1, 1), DateTime(2019, 1, 2)]);

  HashSet<DateTime> brokenStreak = HashSet.from(<DateTime> [DateTime(2019, 1, 26), DateTime(2019, 1, 27),
                                                            DateTime(2019, 1, 29), DateTime(2019, 1, 30),
                                                            DateTime(2019, 1, 31)]);
  HashSet<DateTime> brokenStreak1 = HashSet.from(<DateTime> [DateTime(2019, 1, 25), DateTime(2019, 1, 26),
                                                             DateTime(2019, 1, 28), DateTime(2019, 1, 29),
                                                             DateTime(2019, 1, 30)]);

  HashSet<DateTime> brokenMonth = HashSet.from(<DateTime> [DateTime(2019, 1, 26), DateTime(2019, 1, 27),
                                                           DateTime(2019, 1, 30), DateTime(2019, 1, 31),
                                                           DateTime(2019, 2, 1)]);
  HashSet<DateTime> brokenMonth1 = HashSet.from(<DateTime> [DateTime(2019, 1, 25), DateTime(2019, 1, 26),
                                                            DateTime(2019, 1, 31), DateTime(2019, 2, 1),
                                                            DateTime(2019, 2, 2)]);

  HashSet<DateTime> brokenYear = HashSet.from(<DateTime> [DateTime(2018, 12, 26), DateTime(2018, 12, 27),
                                                          DateTime(2018, 12, 30), DateTime(2018, 12, 31),
                                                          DateTime(2019, 1, 1)]);
  HashSet<DateTime> brokenYear1 = HashSet.from(<DateTime> [DateTime(2018, 12, 25), DateTime(2018, 12, 26),
                                                           DateTime(2018, 12, 31), DateTime(2019, 1, 1),
                                                           DateTime(2019, 1, 2)]);

  HashSet<DateTime> bestStartStreaks = HashSet.from(<DateTime> [DateTime(2018, 11, 25), DateTime(2018, 11, 26),
                                                                DateTime(2018, 11, 27), DateTime(2018, 11, 28),
                                                                DateTime(2018, 11, 29), DateTime(2018, 12, 1),
                                                                DateTime(2018, 12, 2), DateTime(2018, 12, 3),
                                                                DateTime(2018, 12, 5), DateTime(2018, 12, 6),
                                                                DateTime(2018, 12, 7), DateTime(2018, 12, 8)]);

  HashSet<DateTime> bestMiddleStreaks = HashSet.from(<DateTime> [DateTime(2018, 11, 25), DateTime(2018, 11, 26),
                                                                 DateTime(2018, 11, 27), DateTime(2018, 11, 29),
                                                                 DateTime(2018, 11, 30), DateTime(2018, 12, 1),
                                                                 DateTime(2018, 12, 2), DateTime(2018, 12, 3),
                                                                 DateTime(2018, 12, 5), DateTime(2018, 12, 6),
                                                                 DateTime(2018, 12, 7), DateTime(2018, 12, 8)]);

  HashSet<DateTime> bestFinalStreaks = HashSet.from(<DateTime> [DateTime(2018, 11, 25), DateTime(2018, 11, 26),
                                                                DateTime(2018, 11, 27), DateTime(2018, 11, 29),
                                                                DateTime(2018, 11, 30), DateTime(2018, 12, 1),
                                                                DateTime(2018, 12, 2), DateTime(2018, 12, 4),
                                                                DateTime(2018, 12, 5), DateTime(2018, 12, 6),
                                                                DateTime(2018, 12, 7), DateTime(2018, 12, 8)]);


  group("Test functions", (){
    group ("Streaks is correct", (){
      test('Empy list', () {
        expect(StatsWidget.streaks(HashSet<DateTime>()), equals(<List<DateTime>>[]));
      });
      test('Correct streak', (){
        expect(StatsWidget.streaks(streak), equals(< List<DateTime> > [streak.toList()..sort()]));
      });
      test('Correct streak for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak, streak1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [streak.toList()..sort()..removeAt(0)]));
      });
      test('Correct streak over month', (){
        expect(StatsWidget.streaks(acrossMonth), equals(< List<DateTime> > [acrossMonth.toList()..sort()]));
      });
      test('Correct streak over month for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossMonth, acrossMonth1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [acrossMonth.toList()..sort()..removeAt(0)]));
      });
      test('Correct streak over year', (){
        expect(StatsWidget.streaks(acrossYear), equals(< List<DateTime> > [acrossYear.toList()..sort()]));
      });
      test('Correct streak over year for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossYear, acrossYear1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [acrossYear.toList()..sort()..removeAt(0)]));
      });
      test('Correct broken streak', (){
        expect(StatsWidget.streaks(brokenStreak), equals(< List<DateTime> > [[DateTime(2019, 1, 26), DateTime(2019, 1, 27)],
                                                                             [DateTime(2019, 1, 29), DateTime(2019, 1, 30),
                                                                              DateTime(2019, 1, 31)]]));
      });
      test('Correct broken streak for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenStreak, brokenStreak1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [
                                                                          //[DateTime(2019, 1, 26)] ,
                                                                          [DateTime(2019, 1, 29), DateTime(2019, 1, 30)]]));
      });
      test('Correct broken streak over month', (){
        expect(StatsWidget.streaks(brokenMonth), equals(< List<DateTime> > [[DateTime(2019, 1, 26), DateTime(2019, 1, 27)],
                                                                            [DateTime(2019, 1, 30), DateTime(2019, 1, 31),
                                                                             DateTime(2019, 2, 1)]]));
      });
      test('Correct broken streak over month for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenMonth, brokenMonth1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [
                                                                          //[DateTime(2019, 1, 26)] ,
                                                                          [DateTime(2019, 1, 31), DateTime(2019, 2, 1)]]));
      });
      test('Correct broken streak over year', (){
        expect(StatsWidget.streaks(brokenYear), equals(< List<DateTime> > [[DateTime(2018, 12, 26), DateTime(2018, 12, 27)],
                                                                           [DateTime(2018, 12, 30), DateTime(2018, 12, 31),
                                                                            DateTime(2019, 1, 1)]]));
      });
      test('Correct broken streak over year for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenYear, brokenYear1];
        HashSet<DateTime> intersect = StatsWidget.intersection(dates);
        expect(StatsWidget.streaks(intersect), equals(< List<DateTime> > [
                                                                          //[DateTime(2018, 12, 26)] ,
                                                                          [DateTime(2018, 12, 31), DateTime(2019, 1, 1)]]));
      });
    });

    group("Calculate Streak", () {
      test('Empty list', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 5)), equals(0));
      });

      test('Empty Hashset', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [HashSet<DateTime>()];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 5)), equals(0));
      });

      test('Multiple Empty Hashsets', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [HashSet<DateTime>(), HashSet<DateTime>()];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 5)), equals(0));
      });
      test('Correct streak unmarked current day after', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 5).add(Duration(days: 1))), equals(5));
      });
      test('Correct streak broken after 2 days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.calcStreakWithDate(dates,DateTime(2019, 1, 5).add(Duration(days: 2))), equals(0));
      });
      test('Check for exception when currentdate is before the last streak date', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(() => StatsWidget.calcStreakWithDate(dates,DateTime(2019, 1, 5).add(Duration(days: -1))), throwsException);
      });
    });

    group("Best Streak", (){
      test('Test best streak on emptpy set returns 0', () {
        expect(StatsWidget.bestStreak(List<HashSet<DateTime>>()), equals(0));
      });
      test('Test correct best streak at start of set', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [bestStartStreaks];
        expect(StatsWidget.bestStreak(dates), equals(5));
      });
      test('Test correct best streak in middle of set', (){
        List<HashSet<DateTime>> datesMid = <HashSet<DateTime>> [bestMiddleStreaks];
        expect(StatsWidget.bestStreak(datesMid), equals(5));
      });
      test('Test correct best streak at end of set', (){
        List<HashSet<DateTime>> datesEnd = <HashSet<DateTime>> [bestFinalStreaks];
        expect(StatsWidget.bestStreak(datesEnd), equals(5));
      });
    });

    group("Habits Done", () {
      test('Test no habits returns 0', () {
        expect(StatsWidget.habitsDone(List<HashSet<DateTime>>()), equals(0));
      });
      test('Test correct habits done for a single habit', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenStreak];
        expect(StatsWidget.habitsDone(dates), equals(brokenStreak.length));
      });
      test('Test correct habits done for multiple habits', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenStreak, brokenStreak1];
        expect(StatsWidget.habitsDone(dates), equals(brokenStreak.length + brokenStreak1.length));
      });
    });

    group("Habits on date", () {
      test('No habits on date returns 0', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.habitsOnDate(dates, DateTime(2019, 1, 6)), equals(0.0));
      });
      test('Habits on date for single habits', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.habitsOnDate(dates, DateTime(2019, 1, 5)), equals(1.0));
      });
      test('Habits on date for multiple habits', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak, streak1, brokenYear1];
        expect(StatsWidget.habitsOnDate(dates, DateTime(2019, 1, 2)), equals(3));
      });
    });

    group("Habits average on date", (){
      test('Habits before end date returns 0', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [];
        expect(StatsWidget.habitAvgOnDate(dates, DateTime(2019, 1, 4)), equals(0));
      });
      test('No habits on date returns 0', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [];
        expect(StatsWidget.habitAvgOnDate(dates, DateTime(2019, 1, 6)), equals(0));
      });
      test('Habits on date for single habits', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.habitAvgOnDate(dates, DateTime(2019, 1, 5)), equals(1));
      });
      test('Habits on date for multiple habits', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak, streak1, brokenYear1];
        expect(StatsWidget.habitAvgOnDate(dates, DateTime(2019, 1, 6)), equals(15/13));
      });
    });
  });
}