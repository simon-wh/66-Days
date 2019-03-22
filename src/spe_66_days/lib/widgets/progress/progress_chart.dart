import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'dart:collection';
import 'package:spe_66_days/classes/Global.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

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
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (MapEntry<DateTime,int> sales, _) => sales.key,
      measureFn: (MapEntry<DateTime,int> sales, _) => sales.value,
      data: _getData(),
    )];
  }

  ProgressChart.dates(HashSet<DateTime> data, {this.animate}){
    this.seriesList = [charts.Series<MapEntry<DateTime,int>, DateTime>(
      id: 'Habits',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
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
    markedOff.forEach((date) {
        //Keep track of the earliest marked off date
        if (earliest.isAfter(date))
          earliest = date;
        dates.update(date, (val) => (val != 0) ? val *= 2 : val = 1, ifAbsent: () => 1);
      });

    //Start a day after the earliest as we know that earliest is already present
    DateTime addDate = earliest.add(Duration(days: 1));
    //Add entries for every day between the current date and the earliest
    while (_currentDate.isAfter(addDate)){
      dates.update(addDate, (val) => val, ifAbsent: () => 0);
      addDate = addDate.add(Duration(days: 1));
    }

    var entries = dates.entries.toList();
    if (entries.length == 1) {
      for (int i = 1; i < 7; i++)
        entries.add(MapEntry(_currentDate.add(Duration(days:i)), 0));
    }
    entries.sort((a,b) => a.key.compareTo(b.key));

    return entries;
  }

  List<MapEntry<DateTime, int>> _getData() {
    DateTime _currentDate = Global.currentDate;
    Map<DateTime, int> dates = <DateTime, int>{
      _currentDate : 0
    };
    DateTime earliest = _currentDate;
    Global.habitManager.getHabits().forEach((key, value){
      value.markedOff.forEach((date) {
        //Keep track of the earliest marked off date
        if (earliest.isAfter(date))
          earliest = date;
        dates.update(date, (val) => (val != 0) ? val *= 2 : val = 2, ifAbsent: () => 2);
      });
    });

    //Start a day after the earliest as we know that earliest is already present
    DateTime addDate = earliest.add(Duration(days: 1));
    //Add entries for every day between the current date and the earliest
    while (_currentDate.isAfter(addDate)){
      dates.update(addDate, (val) => val, ifAbsent: () => 0);
      addDate = addDate.add(Duration(days: 1));
    }

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
    var clr = DynamicTheme.of(context).brightness == Brightness.dark ? charts.MaterialPalette.white : charts.MaterialPalette.black;
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
        primaryMeasureAxis : charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.GridlineRendererSpec(labelStyle: labelStyle, lineStyle: charts.LineStyleSpec(color: charts.Color(a: 100, r:clr.r, g:clr.g, b:clr.b)))),
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
