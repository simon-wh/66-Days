import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:spe_66_days/classes/HabitManager.dart';
/*This class will display some sample lineGraph
*/
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

  List<charts.Series<MapEntry<DateTime, int>, DateTime>> _habitsGraph(){
    Map<DateTime, int> record = <DateTime, int>{
      //Record will contain the start date the user began the course initially
      DateTime(2018, 12, 1): 0,
    };
    HabitManager.instance.getHabits().forEach((_, val) {
      val.markedOff.forEach((date) {
        if (record.containsKey(date))
          record.update(date, (val) => val++);
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

  Widget build(context){
    return Column(
        children: <Widget>[
          Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2),
              child: charts.TimeSeriesChart(
                  _habitsGraph(),
                  domainAxis: new charts.EndPointsTimeAxisSpec()
              )
          ),
        ],

    );
  }
}
