import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'StatsWidget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:intl/intl.dart';
import 'dart:collection';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:spe_66_days/main.dart';


class StreaksChart extends StatelessWidget {
  List<charts.Series<List<DateTime>, String>> seriesList;
  final bool animate;

  StreaksChart(this.seriesList, {this.animate});

  StreaksChart.fromDates(List<List<DateTime>> dates, {this.animate}){
    dates = dates.where((lst) => lst.length > 1).toList().reversed.take(8).toList();
    this.seriesList= [
      new charts.Series<List<DateTime>, String>(
        id: 'Sales',
        colorFn: (_,__) => charts.ColorUtil.fromDartColor(Theme.of(StartApp.navigatorKey.currentContext).accentColor),
        domainFn: (List<DateTime> streak, _) => streak.first.toString(),
        measureFn: (List<DateTime> streak, _) => streak.length,
        data: dates,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (List<DateTime> streak, _) {
          var formatter = new DateFormat('dd MMM');
          return '${formatter.format(streak.first)} - ${formatter.format(streak.last)}';
        },

      )
    ];
  }

  StreaksChart.allHabits({bool animate}) : this.fromDates(StatsWidget.streaks(StatsWidget.intersection(Global.habitManager.getHabits().values.map((s) => s.markedOff).toList())), animate: animate);

  StreaksChart.habitFromString(String habitKey, {bool animate}) : this.fromDates(StatsWidget.streaks(Global.habitManager.getHabit(habitKey).markedOff), animate: animate);

  /// Creates a [BarChart] with sample data and no transition.
  factory StreaksChart.withSampleData() {
    return new StreaksChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit and the
  // area outside of the bar is larger than the bar, it will draw outside of the
  // bar. Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  Widget build(BuildContext context) {
    var clr = charts.ColorUtil.fromDartColor(Theme.of(context).textTheme.title.color);// DynamicTheme.of(context).brightness == Brightness.dark ? charts.MaterialPalette.white : charts.MaterialPalette.black;
    var clr2 = charts.ColorUtil.fromDartColor(Theme.of(context).canvasColor);// DynamicTheme.of(context).brightness == Brightness.dark ? charts.MaterialPalette.white : charts.MaterialPalette.black;
    var labelStyle = new charts.TextStyleSpec(
        color: clr);
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      behaviors: [new charts.PanAndZoomBehavior(),
      new charts.SlidingViewport()],
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator: new charts.BarLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      barRendererDecorator: new charts.BarLabelDecorator<String>(outsideLabelStyleSpec: labelStyle, insideLabelStyleSpec: charts.TextStyleSpec(color: clr2)),
      // Hide domain axis.
      domainAxis: new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      primaryMeasureAxis: charts.NumericAxisSpec(showAxisLine: true, renderSpec: charts.SmallTickRendererSpec(labelStyle: labelStyle, axisLineStyle: charts.LineStyleSpec(color: charts.Color(a: 100, r:clr.r, g:clr.g, b:clr.b)))),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<List<DateTime>, String>> _createSampleData() {
    HashSet<DateTime> bestStartStreaks = HashSet.from(<DateTime> [DateTime(2018, 11, 25), DateTime(2018, 11, 26),
    DateTime(2018, 11, 27), DateTime(2018, 11, 28),
    DateTime(2018, 11, 29), DateTime(2018, 12, 1),
    DateTime(2018, 12, 2), DateTime(2018, 12, 3),
    DateTime(2018, 12, 5), DateTime(2018, 12, 6),
    DateTime(2018, 12, 7), DateTime(2018, 12, 8)]);
    var streaks = StatsWidget.streaks(bestStartStreaks);

    return  [
      new charts.Series<List<DateTime>, String>(
        id: 'Sales',
        domainFn: (List<DateTime> streak, _) => streak.first.toString(),
        measureFn: (List<DateTime> streak, _) => streak.length,
        data: streaks,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (List<DateTime> streak, _) {
          var formatter = new DateFormat('dd-MM-yyyy');
          return '${formatter.format(streak.first)} - ${formatter.format(streak.last)}';
        },

      )
    ];
  }
}