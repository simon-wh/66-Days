import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'StreaksChart.dart';

class ProgressWidget extends StatefulWidget {
  final String habitKey;
  
  ProgressWidget({this.habitKey});

  @override
  State<StatefulWidget> createState() => _ProgressState();
}


class ProgressTab extends ProgressWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  ProgressTab(this.icon, this.title, {this.activeIcon, this.backgroundColor, String habitKey}) : super(habitKey: habitKey);
}



class _ProgressState extends State<ProgressWidget>{

  _ProgressState();

  Widget build(context){
    return ListView( padding: EdgeInsets.all(5.0),
        shrinkWrap: true,
        children: <Widget>[
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: this.widget.habitKey == null ? ProgressChart.allHabitsCombined(animate: true) : ProgressChart.habitFromString(this.widget.habitKey)
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: this.widget.habitKey == null ? StreaksChart.allHabits() : StreaksChart.habitFromString(this.widget.habitKey)
          ),
          StatsWidget(habitKey: this.widget.habitKey)
        ]
    );
  }
}



