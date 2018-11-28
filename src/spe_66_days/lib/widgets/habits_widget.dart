import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/HabitManager.dart';

class HabitsWidget extends StatefulWidget implements BottomNavigationBarItem{
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  HabitsWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState() {
    return _HabitsState();
  }
}

class _HabitsState extends State<HabitsWidget> {
  DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Widget build(BuildContext context) {
    //Return a new scaffold to output to screen
    return Scaffold(
      //Body of the scaffold is a column that displays text and a flexible check list
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: HabitManager.instance.habits.length,
                  itemBuilder: (BuildContext context, int index){
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(HabitManager.instance.habits.values.toList()[index].title,
                          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        new Row(
                         children: <Widget> [
                           new Checkbox(
                            activeColor: Colors.black,
                            value: HabitManager.instance.habits.values.toList()[index].markedOff.contains(currentDate),
                            onChanged: (bool checked){
                              if (checked)
                                HabitManager.instance.habits.values.toList()[index].markedOff.add(currentDate);
                              else
                                HabitManager.instance.habits.values.toList()[index].markedOff.remove(currentDate);
                              setState(() {});
                            },
                          ),
                          new Text(HabitManager.instance.habits.values.toList()[index].checkTitle,
                              style: new TextStyle(color: Colors.black)),
                          ]
                        ),
                      ],
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
}