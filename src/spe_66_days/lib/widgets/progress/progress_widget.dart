import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/progress_chart.dart';
import 'package:spe_66_days/widgets/progress/stats_widget.dart';
import 'streaks_chart.dart';

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

  Widget build(context){
    return ListView( padding: EdgeInsets.all(5.0),
        shrinkWrap: true,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: ProgressChart.allHabitsCombined(animate: true)
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: StreaksChart.allHabits()
          ),
          StatsWidget()
        ]
    );
  }
}
