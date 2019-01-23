import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:spe_66_days/classes/HabitManager.dart';
import 'dart:ui' as ui show Paint;
import 'package:flutter/material.dart' as material show Colors;
import 'dart:math';

class ProgressWidget extends StatefulWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  ProgressWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState(){return _ProgressState();}
}


class _ProgressState extends State<ProgressWidget>{
  charts.LineChartOptions _lineChartOptions;
  charts.LabelLayoutStrategy _xContainerLabelLayoutStrategy;
  charts.ChartData _chartData;

  _ProgressState();

  int _habitsChecked(){
    DateTime _currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    int checked = 0;
    HabitManager.instance.getHabits().forEach((_, val) {
      if (val.markedOff.contains(_currentDate)){
        checked += 1;
      }
    });
    return checked;
  }

  List<MapEntry<DateTime, double>> _getDates(){
    DateTime _currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    Map<DateTime, double> dates = <DateTime, double>{
     _currentDate : 0.0001
    };
    HabitManager.instance.getHabits().forEach((key, value){
      value.markedOff.forEach((date) {
        dates.update(date, (val) => (val != 0.0001) ? val *= 2.0 : val = 2.0, ifAbsent: () => 2.0);
      });
    });
    var entries = dates.entries.toList();
    if (entries.length == 1) {
      for (int i = 1; i < 7; i++)
        entries.add(MapEntry(_currentDate.add(Duration(days:i)), 0.0001));
    }
    entries.sort((a,b) => a.key.compareTo(b.key));

    return entries;
  }

  void defineOptionsAndData() {
    _lineChartOptions = charts.LineChartOptions();
    _lineChartOptions.hotspotInnerRadius = 2.0;
    _lineChartOptions.hotspotOuterRadius = 3.0;
    _lineChartOptions.hotspotInnerPaint = ui.Paint()..color = material.Colors.red;
    _lineChartOptions.lineStrokeWidth = 2.0;
    _chartData = charts.ChartData();
    var data = _getDates();
    Iterable<MapEntry<DateTime, double>> dData = data;
    if (data.length >= 20){
      int i = -1;
      dData = data.where((val) {
        i += 1;
        return i % ((data.length/30).floor()) == 0;
      });
    }

    _chartData.dataRowsLegends = [""];
    var scores = dData.map((ent) => ent.value).where((a) => a > 0.1).toList();
    if (scores.isEmpty)
      scores.add(0.0001);
    _chartData.dataRows = [scores];
    var dates = dData.map((ent) => "${ent.key.day}/${ent.key.month}/${ent.key.year}").toList();

    _chartData.xLabels = dates;
    _chartData.dataRowsColors = [Colors.black];
  }

  Widget build(context){
    defineOptionsAndData();
    charts.LineChart lineChart = charts.LineChart(
      painter: charts.LineChartPainter(),
      container: charts.LineChartContainer(
        chartData: _chartData, // @required
        chartOptions: _lineChartOptions, // @required
        xContainerLabelLayoutStrategy: _xContainerLabelLayoutStrategy, // @optional
      ),
    );
    return Container( padding: EdgeInsets.all(5.0), child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Expanded(child: lineChart)]
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Habits tracked today: ${_habitsChecked()}/"
                  "${HabitManager.instance.getHabits().length}",
                  style: Theme.of(context).textTheme.title)
            ],
          )
        ]
    ));
  }
}
