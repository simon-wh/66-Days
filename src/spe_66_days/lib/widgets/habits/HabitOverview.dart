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

  Widget sanitiseWidget(BuildContext context, Widget widget, {String title, BoxConstraints constraints, EdgeInsets margin}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          title?.isNotEmpty ?? false ? Container(margin: EdgeInsets.only(top: 5.0), child: Text(title, style: Theme.of(context).textTheme.subhead)) : Container(),
          Container(constraints: constraints, margin:margin, child:widget)
        ]
    );
  }

  Widget build(context) {
    var habit = Global.habitManager.getHabit(this.widget.habitKey);
    if(habit == null) {Navigator.pop(context);}
    var formatter = new DateFormat('MMM\ndd');
    var startDate = habit.startDate ?? Global.currentDate;
    //print(habit.startDate?.toString() ?? "StartDate is null");
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
          sanitiseWidget(context,
              ListTile(
                  leading: Checkbox(
                    value: habit.markedOff.contains(Global.currentDate),
                      onChanged: (checked)=>setState(()=> Global.habitManager.setCheckHabit(this.widget.habitKey, checked))
                  ),
                  title: Text(habit.title),
                  subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Text(habit.experimentTitle),
                        (habit.environmentDesign?.isEmpty ?? true)
                            ? Container()
                            : Text(habit.environmentDesign, style: Theme.of(context).textTheme.caption)
                      ]
                  ),
                  //isThreeLine: (habit.environmentDesign?.isNotEmpty ?? false)
              ),
              margin: EdgeInsets.only(top:5.0, bottom: (habit.environmentDesign?.isNotEmpty ?? false) ? 5.0 : 0.0)
          ),
          Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
              height: 100,
              child: ListView.builder(reverse:true, scrollDirection: Axis.horizontal,itemCount: Global.currentDate.difference(startDate).inDays+1,  itemBuilder: (context, i){
                var date = Global.currentDate.add(Duration(days: -i));
                return Card(color: Theme.of(context).backgroundColor, child: Column(children: <Widget>[
                    Container(padding: EdgeInsets.only(top:5.0, left:5.0, right: 5.0), child: Text(formatter.format(date), textAlign: TextAlign.center,)),
                    Checkbox(  value: habit.markedOff.contains(date), onChanged: (checked) => setState(()=>Global.habitManager.setCheckHabit(this.widget.habitKey, checked, date:date)))
                ]));
              })
          ),
          sanitiseWidget(context, ProgressChart.habitFromString(this.widget.habitKey),
                    title: "History", constraints: BoxConstraints(maxHeight: 100.0), margin: EdgeInsets.only(bottom:5.0)),
          sanitiseWidget(context, StreaksChart.habitFromString(this.widget.habitKey),
                    title: "Streaks", constraints: BoxConstraints(maxHeight: 200.0), margin: EdgeInsets.only(bottom:5.0)),

          sanitiseWidget(context, StatsWidget(habitKey: this.widget.habitKey), margin: EdgeInsets.symmetric(vertical:5.0))
        ].map((s) => Card(child: s)).toList()));
  }
}
