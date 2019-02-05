import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/widgets/progress/progress_chart.dart';
import 'package:spe_66_days/widgets/progress/stats_widget.dart';

class ProgressWidget extends StatefulWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  ProgressWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState() => _ProgressState();
}


class _ProgressState extends State<ProgressWidget>{

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

  Widget build(context){
    return ListView( padding: EdgeInsets.all(5.0),
        shrinkWrap: true,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: ProgressChart.allHabitsCombined()
          ),
          StatsWidget()
        ]
    );
  }
}
