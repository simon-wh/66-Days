import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/widgets/habits/edit_habit_widget.dart';

class HabitListWidget extends StatefulWidget {
  CoreHabit _core;

  HabitListWidget(this._core);

  @override
  State<StatefulWidget> createState() => HabitListState(_core);
}

class HabitListState extends State<HabitListWidget> {
  CoreHabit _habit;
  DateTime _currentDate =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  HabitListState(this._habit);

  @override
  Widget build(BuildContext context) {
    return Column(
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
  }
}
