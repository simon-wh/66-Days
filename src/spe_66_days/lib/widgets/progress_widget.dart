import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:spe_66_days/classes/HabitManager.dart';

class ProgressWidget extends StatefulWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  ProgressWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState(){
    return _ProgressState();
  }
}


class _ProgressState extends State<ProgressWidget>{
  DateTime _currentDate =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<charts.Series<MapEntry<DateTime, int>, DateTime>> _habitsGraph(){
    Map<DateTime, int> record = <DateTime, int>{
      //Record will contain the start date the user began the course
      DateTime(2018, 12, 1): 0,
      DateTime(2018, 12, 2): 1,
      DateTime(2018, 12, 3): 2,
      DateTime(2018, 12, 4): 3,
      DateTime(2018, 12, 5): 4,
      DateTime(2018, 12, 6): 5,
      DateTime(2018, 12, 7): 6,
      DateTime(2018, 12, 8): 7,
      DateTime(2018, 12, 9): 8,
    };
    HabitManager.instance.getHabits().forEach((_, val) {
      val.markedOff.forEach((date) {
        if (record.containsKey(date))
          record.update(date, (val) => val *= 2);
        else
          record.putIfAbsent(date, () => 1);
      });
    });

    return [
      new charts.Series<MapEntry<DateTime, int>, DateTime>(
        id: 'Habits',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (MapEntry<DateTime, int> val, _) => val.key,
        measureFn: (MapEntry<DateTime, int> val, _) => val.value,
        data: List.from(record.entries),
      )
    ];
  }

  int _habitsChecked(){
    int checked = 0;
    HabitManager.instance.getHabits().forEach((_, val) {
      if (val.markedOff.contains(_currentDate)){
        checked += 1;
      }
    });
    return checked;
  }

  Widget build(context){
    return Column(
        children: <Widget>[
          Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
              child: charts.TimeSeriesChart(
                  _habitsGraph(),
                  defaultRenderer: charts.LineRendererConfig(includePoints: true),
                  domainAxis: charts.DateTimeAxisSpec(
                    tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                      day: charts.TimeFormatterSpec(
                        format: 'd/MM', transitionFormat: 'dd/MM/yyyy'
                      )
                    ),
                  )
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
        ],
    );
  }
}
