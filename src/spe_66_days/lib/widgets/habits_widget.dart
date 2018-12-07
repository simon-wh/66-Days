import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/widgets/edit_habit_widget.dart';

class HabitsWidget extends StatefulWidget implements BottomNavigationBarItem {
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
  DateTime _currentDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Widget build(BuildContext context) {
    HabitManager.instance.save();
    return new Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: HabitManager.instance.getHabits().length,
                  itemBuilder: (BuildContext context, int index) {
                    CoreHabit _habit = HabitManager.instance.getHabits().values.toList()[index];
                    return new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            SizedBox(width: (MediaQuery.of(context).size.width/8)),
                             new Text(
                                  _habit.title,
                                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)
                              ),
                            new IconButton(
                              icon: new Icon(Icons.edit),
                              padding: EdgeInsets.all(2.0),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit)));
                              }
                            ),
                          ]
                        ),
                        new Row(
                            children: <Widget>[
                              new Checkbox(
                                activeColor: Colors.black,
                                value: _habit.markedOff.contains(_currentDate),
                                onChanged: (bool checked) {
                                  if (checked) { _habit.markedOff.add(_currentDate); }
                                  else { _habit.markedOff.remove(_currentDate); }
                                  setState(() {});
                                },
                              ),
                              new Text(_habit.experimentTitle, style: new TextStyle(color: Colors.black)),
                            ]
                        ),
                      ],
                    );
                  } // Item Builder
              )
          ),
        ],
      ),
    );
  } // Build
} // _HabitsState
