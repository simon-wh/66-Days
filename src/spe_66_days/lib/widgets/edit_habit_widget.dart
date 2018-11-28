import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/Notification.dart';

class EditHabitWidget extends StatefulWidget {
  final CoreHabit habit;

  EditHabitWidget(this.habit);

  @override
  State<StatefulWidget> createState() => EditHabitState(habit);
}

class EditHabitState extends State<EditHabitWidget> {
  final CoreHabit habit;

  EditHabitState(this.habit);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Edit Habit")
        ),
        body: new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Title"),
                  controller: TextEditingController(text: habit.title),
                  onSubmitted: (val) { habit.title = val; },
                ),
                new TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Experiment"),
                  controller: TextEditingController(text: habit.experimentTitle),
                  onSubmitted: (val) { habit.experimentTitle = val; },
                )
              ],
            )
        )
    );
  }
}