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


  group("Test functions", (){
    //Move tests over edge cases to streak function
    group ("Current streak", (){
      test('Correct streak', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 5)), equals(5));
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
      test('Correct streak for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [streak, streak1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 6)), equals(4));
      });
      test('Correct streak over month', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossMonth];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 2, 1)), equals(4));
      });
      test('Correct streak over month for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossMonth, acrossMonth1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 2, 2)), equals(3));
      });
      test('Correct streak over year', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossYear];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 1)), equals(4));
      });
      test('Correct streak over year for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [acrossYear, acrossYear1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 2)), equals(3));
      });
      test('Correct broken streak', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenStreak];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 31)), equals(3));
      });
      test('Correct broken streak for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenStreak, brokenStreak1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 31)), equals(2));
      });
      test('Correct broken streak over month', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenMonth];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 2, 1)), equals(3));
      });
      test('Correct broken streak over month for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenMonth, brokenMonth1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 2, 2)), equals(2));
      });
      test('Correct broken streak over year', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenYear];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 1)), equals(3));
      });
      test('Correct broken streak over year for perfect days', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [brokenYear, brokenYear1];
        expect(StatsWidget.calcStreakWithDate(dates, DateTime(2019, 1, 2)), equals(2));
      });
    });

    group("Best Streak", (){
      test('Test correct best streak', (){
        List<HashSet<DateTime>> dates = <HashSet<DateTime>> [bestStartStreaks];
        List<HashSet<DateTime>> datesMid = <HashSet<DateTime>> [bestMiddleStreaks];
        expect(StatsWidget.bestStreak(dates), equals(5));
        expect(StatsWidget.bestStreak(datesMid), equals(5));
      });
    });
  });
}