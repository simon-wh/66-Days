import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'dart:collection';
import 'package:spe_66_days/classes/Global.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:spe_66_days/main.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'package:tuple/tuple.dart';

class ProgressChart extends StatelessWidget {
  List<charts.Series<MapEntry<DateTime,int>, DateTime>> seriesList;
  final bool animate;

  ProgressChart(this.seriesList, {this.animate});

  ProgressChart.allHabits({this.animate}){
    this.seriesList = [];
    int i = 0;
    var habits = Global.habitManager.getHabits();
    habits.forEach((s, v) {
      var clr = charts.MaterialPalette.getOrderedPalettes(habits.length)[i].shadeDefault;
      this.seriesList.add(charts.Series<MapEntry<DateTime,int>, DateTime>(
      id: 'Habits',
      colorFn: (_, __) => clr,
      domainFn: (MapEntry<DateTime,int> sales, _) => sales.key,
      measureFn: (MapEntry<DateTime,int> sales, _) => sales.value,
      data: _getHabitDataFromHabit(v),
      ));
      i++;
    });
  }

  ProgressChart.allHabitsCombined({this.animate}){
    this.seriesList = [charts.Series<MapEntry<DateTime,int>, DateTime>(
      id: 'Habits',
      colorFn: (_,__) => charts.ColorUtil.fromDartColor(Theme.of(StartApp.navigatorKey.currentContext).accentColor),
      domainFn: (MapEntry<DateTime,int> sales, _) => sales.key,
      measureFn: (MapEntry<DateTime,int> sales, _) => sales.value,
      data: _getData(),
    )];
  }

  ProgressChart.dates(HashSet<DateTime> data, {this.animate}){
    this.seriesList = [charts.Series<MapEntry<DateTime,int>, DateTime>(
      id: 'Habits',
      colorFn: (_,__) => charts.ColorUtil.fromDartColor(Theme.of(StartApp.navigatorKey.currentContext).accentColor),
      domainFn: (MapEntry<DateTime,int> sales, _) => sales.key,
      measureFn: (MapEntry<DateTime,int> sales, _) => sales.value,
      data: _getHabitData(data),
    )];
  }

  ProgressChart.habit(CoreHabit habit, {bool animate}) : this.dates(habit.markedOff, animate: animate);

  ProgressChart.habitFromString(String habit, {bool animate}) : this.habit(Global.habitManager.getHabit(habit), animate: animate);

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory ProgressChart.withSampleData() {
    return new ProgressChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  List<MapEntry<DateTime, int>> _getHabitDataFromString(String habit) {
    return _getHabitDataFromHabit(Global.habitManager.getHabit(habit));
  }

  List<MapEntry<DateTime, int>> _getHabitDataFromHabit(CoreHabit habit) {
    return _getHabitData(habit.markedOff);
  }

  List<MapEntry<DateTime, int>> _getHabitData(HashSet<DateTime> markedOff) {
    DateTime _currentDate = Global.currentDate;
    Map<DateTime, int> dates = <DateTime, int>{
      _currentDate : 0
    };
    DateTime earliest = _currentDate;
    markedOff.forEach((ddate) {
        DateTime date = Global.stripTime(ddate);

        //Keep track of the earliest marked off date
        if (earliest.isAfter(date))
          earliest = date;
        dates.update(date, (val) => (val != 0) ? val *= 2 : val = 1, ifAbsent: () => 1);
      });

    //Start a day after the earliest as we know that earliest is already present
    DateTime addDate = Global.stripTime(earliest.add(Duration(days: 1)));
    //Add entries for every day between the current date and the earliest
    while (_currentDate.isAfter(addDate)){
      dates.update(addDate, (val) => val, ifAbsent: () => 0);
      addDate = Global.stripTime(addDate.add(Duration(days: 1)));
    }

    var entries = dates.entries.toList();
    /*if (entries.length == 1) {
      for (int i = 1; i < 7; i++)
        entries.add(MapEntry(_currentDate.add(Duration(days:i)), 0));
    }*/
    entries.sort((a,b) => a.key.compareTo(b.key));

    return entries;
  }

  int calculateScore( num numberOfMarked, DateTime date) {
    int numberOfHabits = Global.habitManager.getHabits().values.length;
    int streaks = StatsWidget.calcStreakWithDate(Global.habitManager.getHabits().values.map((s) => Tuple2<DateTime, HashSet<DateTime>>(s.startDate, s.markedOff)).toList(), date);
    streaks = streaks > 0 ? streaks : 1;
    int returnValue = numberOfMarked * streaks * exp(numberOfHabits).toInt();
    return returnValue;
  }

  int getPreviousValue(DateTime findDate, Map<DateTime, int> dates){
    int returnValue = 0;
    if(dates.containsKey(findDate)){
      dates.forEach((date, value){
        if(date.isAtSameMomentAs(findDate)){
          returnValue = value;
        }
      });
    }
    return returnValue;
  }

  List<MapEntry<DateTime, int>> _getData() {
    int previousValue;
    DateTime _currentDate = Global.currentDate;
    Map<DateTime, int> dates = Map<DateTime, int>();

    var habits = Global.habitManager.getHabits();
    //Find number of marked off habits for each date
    habits.forEach((key, value){
      value.markedOff.forEach((date) {
        dates.update(date, (numberOfMarked) => numberOfMarked += 1, ifAbsent: () => 1);
      });
    });

    /* Ensure there are date entries for every date between the first Start Date and the Current.
    Without this days with no habits checked off wouldn't have any data */
    if (habits.length > 0){
      var startDates = habits.values.map((habit) => habit.startDate).toList();
      startDates.sort();
      for(DateTime date = startDates.first; !date.isAfter(Global.currentDate); date=date.add(Duration(days:1))){
        dates.update(date, (val)=>val, ifAbsent: ()=>0);
      }
    }

    /*Calculate the score of the habit based on the streak for that day, the number of
      marked off habits and the total number of habits*/
    dates.forEach((date, value){
      dates.update(date, (numberOfMarked) => calculateScore(numberOfMarked, date));
    });


    /*Add 90% of the previous day's score on (prevents score from returning to zero
      if a day is missed)*/
    List<DateTime> sortedDates = dates.keys.toList()..sort();
    sortedDates.forEach((date){
      previousValue = getPreviousValue(date.add(Duration(days: -1)), dates);
      dates.update(date, (score) => score + (0.9 * previousValue).toInt());
    });



    var entries = dates.entries.toList();
    if (entries.length == 1) {
      //for (int i = 1; i < 2; i++)
        entries.add(MapEntry(_currentDate.add(Duration(days:-1)), 0));
    }
    entries.sort((a,b) => a.key.compareTo(b.key));

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    var clr = charts.ColorUtil.fromDartColor(Theme.of(context).textTheme.title.color);// DynamicTheme.of(context).brightness == Brightness.dark ? charts.MaterialPalette.white : charts.MaterialPalette.black;
    var labelStyle = new charts.TextStyleSpec(
        color: clr);
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(includeArea: true),
      dateTimeFactory: const charts.LocalDateTimeFactory(),
        behaviors: [
          new charts.LinePointHighlighter(
              selectionModelType: charts.SelectionModelType.info,
              showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.none,
              showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest),
          new charts.PanAndZoomBehavior(),
          new charts.SlidingViewport(),
        ],
        primaryMeasureAxis :  charts.NumericAxisSpec(showAxisLine: false, tickFormatterSpec: charts.BasicNumericTickFormatterSpec((s)=>""), renderSpec: charts.GridlineRendererSpec(labelStyle: labelStyle, lineStyle: charts.LineStyleSpec(color: charts.Color(a: 100, r:clr.r, g:clr.g, b:clr.b)))),
        domainAxis: new charts.DateTimeAxisSpec(
            showAxisLine: false,
          viewport: charts.DateTimeExtents(start: Global.currentDate.add(Duration(days:-30)), end: Global.currentDate.add(Duration(days: 1))),
            renderSpec: charts.SmallTickRendererSpec(labelStyle: labelStyle, lineStyle: charts.LineStyleSpec(color: clr)),
            tickProviderSpec: charts.DayTickProviderSpec(increments: [1,2,3]),
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'MMM d')))
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<MapEntry<DateTime,int>, DateTime>> _createSampleData() {
    final data = [
      MapEntry(new DateTime(2017, 9, 19), 5),
      MapEntry(new DateTime(2017, 9, 26), 25),
      MapEntry(new DateTime(2017, 10, 3), 100),
      MapEntry(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<MapEntry<DateTime,int>, DateTime>(
        id: 'Habits',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (MapEntry<DateTime,int> sales, _) => sales.key,
        measureFn: (MapEntry<DateTime,int> sales, _) => sales.value,
        data: data,
      )
    ];
  }
}
