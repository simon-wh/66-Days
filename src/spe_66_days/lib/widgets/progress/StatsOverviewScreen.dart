import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'StreaksChart.dart';

class StatsOverviewWidget extends StatefulWidget {
  final String habitKey;
  
  StatsOverviewWidget({this.habitKey});

  @override
  State<StatefulWidget> createState() => StatsOverviewState();
}


class StatsOverviewScreen extends StatsOverviewWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  StatsOverviewScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor, String habitKey}) : super(habitKey: habitKey);
}



class StatsOverviewState extends State<StatsOverviewWidget>{

  StatsOverviewState();

  Widget sanitiseWidget(BuildContext context, Widget widget, {String title, BoxConstraints constraints, EdgeInsets margin}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          title?.isNotEmpty ?? false ? Container(margin: EdgeInsets.only(top: 5.0), child: Text(title, style: Theme.of(context).textTheme.subhead)) : Container(),
          Container(constraints: constraints, margin:margin, child:widget)
        ]
    );
  }

  Widget build(context){
    return ListView( padding: EdgeInsets.all(5.0),
        shrinkWrap: true,
        children: <Widget>[
        sanitiseWidget(context, this.widget.habitKey == null ? ProgressChart.allHabitsCombined(animate: true) : ProgressChart.habitFromString(this.widget.habitKey),
          constraints: BoxConstraints(maxHeight:300), title: "Overall Progress" ),
        sanitiseWidget(context, this.widget.habitKey == null ? StreaksChart.allHabits() : StreaksChart.habitFromString(this.widget.habitKey),
          constraints: BoxConstraints(maxHeight: 300), title: "Streaks"
          ),
          StatsWidget(habitKey: this.widget.habitKey)
        ].map((widget) => Card(child: widget)).toList()
    );
  }
}



