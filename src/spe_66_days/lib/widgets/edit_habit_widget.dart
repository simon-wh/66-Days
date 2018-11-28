import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/Notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class EditNotificationWidget extends StatefulWidget {
  final HabitNotification notification;

  EditNotificationWidget(this.notification);

  @override
  State<StatefulWidget> createState() => EditNotificationState(notification);
}

class EditNotificationState extends State<EditNotificationWidget> {
  bool expanded = false;
  final HabitNotification notification;

  EditNotificationState(this.notification);

  void setExpansion(bool expanded) {
    setState(() {
      this.expanded = expanded;
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                TimeOfDay initial = TimeOfDay(hour: notification.time.hour, minute: notification.time.minute);
                final TimeOfDay picked = await showTimePicker(
                    context: context,
                    initialTime: initial
                );

                if (picked != null && picked != initial){
                  setState(() {
                    notification.time = Time(picked.hour, picked.minute);
                  });
                }
              },
              child: Text(notification.time.hour.toString().padLeft(2, "0") + ":" + notification.time.minute.toString().padLeft(2, "0"), style: TextStyle(fontSize: 24) )
            ),
              Checkbox(
                activeColor: Colors.black,
                value: notification.enabled,
                onChanged: (checked) {
                  notification.enabled = checked;
                  setState(() {});
                },
            )
          ],
        ),
        expanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Day>.generate(
                        7, (int index) => Day.values[index],
                        growable: false)
                    .map((day) => new Checkbox(
                        activeColor: Colors.blue,
                        value: notification.repeatDays.contains(day),
                        onChanged: (checked) {
                          if (checked) {
                            notification.repeatDays.add(day);
                          } else {
                            notification.repeatDays.remove(day);
                          }
                          setState(() {});
                        }))
                    .toList(),
              )
            : new Container(),
        expanded
            ? new Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                //width: 100,
                child: TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Message"),
                  controller: TextEditingController(text: notification.message),
                  maxLines: 1,
                  onSubmitted: (val) {
                    notification.message = val;
                  },
                ))
            : new Container(),
        Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
          Flexible(child:
          Text(!expanded ? notification.message  + " : " + notification.getDayString() : "", overflow: TextOverflow.ellipsis)),
          IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setExpansion(!expanded);
              })
        ])
      ],
    );
  }
}

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
        appBar: AppBar(title: Text("Edit Habit")),
        body: new Container(
            padding: EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Title"),
                  controller: TextEditingController(text: habit.title),
                  onSubmitted: (val) {
                    habit.title = val;
                  },
                ),
                new TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Experiment"),
                  controller:
                      TextEditingController(text: habit.experimentTitle),
                  onSubmitted: (val) {
                    habit.experimentTitle = val;
                  },
                ),
                new ListView.builder(
                    shrinkWrap: true,
                    itemCount: habit.reminders.length,
                    itemBuilder: (BuildContext context, int index) {
                      return EditNotificationWidget(habit.reminders[index]);
                    } // Item Builder
                    )
              ],
            )));
  }
}
