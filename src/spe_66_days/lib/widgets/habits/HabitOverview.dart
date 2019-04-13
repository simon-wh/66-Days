import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/EditHabitWidget.dart';
import 'package:spe_66_days/widgets/progress/StreaksChart.dart';
import 'package:intl/intl.dart';

class HabitOverview extends StatefulWidget {
  final String habitKey;

  HabitOverview(this.habitKey);

  @override
  State<StatefulWidget> createState() => HabitOverviewState();
}

class HabitOverviewState extends State<HabitOverview> {
  HabitOverviewState();

  Widget build(context) {
    var habit = Global.habitManager.getHabit(this.widget.habitKey);
    if(habit == null) {Navigator.pop(context);}
    var formatter = new DateFormat('MMM\ndd');
    var startDate = habit.startDate ?? Global.currentDate;
    print(habit.startDate?.toString() ?? "StartDate is null");
    return new Scaffold(
        appBar:
            AppBar(title: Text(habit.title + " Overview"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => EditHabitWidget(this.widget.habitKey))
                );
              })
        ]),
        body: ListView(children: <Widget>[
          ListTile(
              leading: Checkbox(
                value: habit.markedOff.contains(Global.currentDate),
                  onChanged: (checked)=>setState(()=> Global.habitManager.setCheckHabit(this.widget.habitKey, checked))
              ),
              /*trailing: IconButton(icon: Icon(Icons.menu), onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HabitOverview(this.widget.habitKey)));
              }),*/
              title: Text(habit.title),
              subtitle: Text(habit.experimentTitle + (habit.environmentDesign == null ? "" : '\n' + habit.environmentDesign)),
              isThreeLine: habit.environmentDesign != null
          ),
          Container(
              margin: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
              height: 100,
              child: ListView.builder(reverse:true, scrollDirection: Axis.horizontal,itemCount: Global.currentDate.difference(startDate).inDays+1,  itemBuilder: (context, i){
                var date = Global.currentDate.add(Duration(days: -i));
                return Card(child: Column(children: <Widget>[
                    Container(padding: EdgeInsets.only(top:5.0, left:5.0, right: 5.0), child: Text(formatter.format(date), textAlign: TextAlign.center,)),
                    Checkbox(  value: habit.markedOff.contains(date), onChanged: (checked) => setState(()=>Global.habitManager.setCheckHabit(this.widget.habitKey, checked, date:date)))
                ]));
              })
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: ProgressChart.habitFromString(this.widget.habitKey)
          ),
          Container(
              constraints: BoxConstraints(maxHeight: 200.0),
              child: StreaksChart.habitFromString(this.widget.habitKey)
          ),
          StatsWidget(habitKey: this.widget.habitKey)
        ]));
  }
}
