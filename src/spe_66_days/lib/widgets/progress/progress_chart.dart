/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'dart:collection';
import 'package:spe_66_days/classes/Global.dart';

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

    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),

        behaviors: [
          // Optional - Configures a [LinePointHighlighter] behavior with a
          // vertical follow line. A vertical follow line is included by
          // default, but is shown here as an example configuration.
          //
          // By default, the line has default dash pattern of [1,3]. This can be
          // set by providing a [dashPattern] or it can be turned off by passing in
          // an empty list. An empty list is necessary because passing in a null
          // value will be treated the same as not passing in a value at all.
          new charts.LinePointHighlighter(
              selectionModelType: charts.SelectionModelType.info,
              showHorizontalFollowLine:
              charts.LinePointHighlighterFollowLineType.none,
              showVerticalFollowLine:
              charts.LinePointHighlighterFollowLineType.nearest),
          // Optional - By default, select nearest is configured to trigger
          // with tap so that a user can have pan/zoom behavior and line point
          // highlighter. Changing the trigger to tap and drag allows the
          // highlighter to follow the dragging gesture but it is not
          // recommended to be used when pan/zoom behavior is enabled.
          //new charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),

          new charts.PanAndZoomBehavior(),
          new charts.SlidingViewport(),
        ],
        domainAxis: new charts.DateTimeAxisSpec(
            tickProviderSpec: charts.DayTickProviderSpec(increments: [1,2,4]),
            tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'dd/MM')))
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
