import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';

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

  @override
  void initState(){
    super.initState();
    HabitManager.instance.init().then((f) {
      setState(() {

      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            HabitManager.instance.newCustomHabit();
            setState(() {
              //HabitManager.instance.save();
            });
          },
          icon: Icon(Icons.add),
          label: const Text('Add Habit')),
      body:  Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: HabitManager.instance.getHabits().length,
                  itemBuilder: (BuildContext context, int index) {
                    MapEntry<String, CoreHabit> entry = HabitManager.instance.getHabits().entries.toList()[index];
                    CoreHabit _habit = entry.value;
                    var content = Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget> [
                            SizedBox(width: (MediaQuery.of(context).size.width/8)),
                             Text(
                                  _habit.title,
                                  style: Theme.of(context).textTheme.title,
                              ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditHabitWidget(_habit)));
                              }
                            ),
                          ]
                        ),
                        Row(
                            children: <Widget>[
                              Checkbox(
                                activeColor: Colors.black,
                                value: _habit.markedOff.contains(_currentDate),
                                onChanged: (bool checked) {
                                  if (checked) {
                                    if (_habit.markedOff.add(_currentDate))
                                      HabitManager.instance.save();
                                  }
                                  else {
                                    if (_habit.markedOff.remove(_currentDate))
                                      HabitManager.instance.save();
                                  }

                                  setState(() {});
                                },
                              ),
                              Text(_habit.experimentTitle, style: Theme.of(context).textTheme.body2),
                            ]
                        ),
                      ],
                    );

                    return entry.key.startsWith(HabitManager.customHabitPrefix) ? Dismissible(
                        direction: DismissDirection.startToEnd,
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify Widgets.
                        key: Key(entry.key),
                        // We also need to provide a function that will tell our app
                        // what to do after an item has been swiped away.
                        background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(5.0),
                        ),
                        onDismissed: (direction) {
                          // Remove the item from our data source.
                          setState(() {
                            HabitManager.instance.removeHabit(entry.key);
                            HabitManager.instance.save();
                          });

                          // Show a snack bar! This snack bar could also contain "Undo" actions.
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Custom Habit \"${_habit.title}\" removed")));
                        },
                        child: content
                    ) : content;
                  } // Item Builder
              )
          ),
        ],
      ),
    ));
  } // Build
} // _HabitsState
