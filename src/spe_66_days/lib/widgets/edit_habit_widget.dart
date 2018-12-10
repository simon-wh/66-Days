import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';

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
    return Column(
      children: <Widget>[
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
              child: Text(
                  notification.time.hour.toString().padLeft(2, "0") +
                      ":" +
                      notification.time.minute.toString().padLeft(2, "0"),
                  style: Theme.of(context).textTheme.body1
              ),
              onPressed: () async {
                TimeOfDay initial = TimeOfDay(
                    hour: notification.time.hour,
                    minute: notification.time.minute);
                final TimeOfDay picked = await showTimePicker(
                    context: context, initialTime: initial);
                if (picked != null && picked != initial) {
                  setState(() {
                    notification.time = Time(picked.hour, picked.minute);
                    });
                }
              }
          ),
          Switch(activeTrackColor: Colors.lightGreenAccent,
            inactiveTrackColor: Colors.grey,
            value: notification.enabled,
            onChanged: (checked) {
            notification.enabled = checked;
            setState(() {});
            },
          )
        ]),
        expanded ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Day>.generate(7, (int index) => Day.values[index],
          growable: false).map((day) => Column(children: <Widget>[
            Text(HabitNotification.DayStringMap[day][0]),
            Checkbox(
              activeColor: Colors.black,
              value: notification.repeatDays.contains(day),
              onChanged: (checked) {
                if (checked) { notification.repeatDays.add(day);}
                else { notification.repeatDays.remove(day); }
                setState(() {});})
          ])).toList()): Container(),
        expanded ? Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: TextField(
            autocorrect: true,
            decoration: InputDecoration(labelText: "Message"),
            controller: TextEditingController(text: notification.message),
                        maxLines: 1,
                        onChanged: (val) { notification.message = val;})
          ): Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  !expanded ? notification.message +
                    " : " +
                  notification.getDayString(): "",
                  style: Theme.of(context).textTheme.body2,
                  overflow: TextOverflow.ellipsis)
              ),
              IconButton( icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {setExpansion(!expanded);}),
            ]
        ),
      ]
    );
  }
}

class EditHabitWidget extends StatefulWidget {
  final CoreHabit habit;

  EditHabitWidget(this.habit);

  @override
  State<StatefulWidget> createState() => EditHabitState(habit);

  //Created with help from: https://stackoverflow.com/questions/49824461/how-to-pass-data-from-child-widget-to-its-parent/49825756
  static EditHabitState of(BuildContext context) {
    final EditHabitState navigator =
        context.ancestorStateOfType(const TypeMatcher<EditHabitState>());

    assert(() {
      if (navigator == null) {
        throw new FlutterError(
            'EditHabitState operation requested with a context that does '
            'not include a EditHabitWidget.');
      }
      return true;
    }());

    return navigator;
  }
}

class EditHabitState extends State<EditHabitWidget> {
  final CoreHabit habit;

  EditHabitState(this.habit);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Edit Habit")),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              DateTime current = DateTime.now();
              habit.reminders.add(HabitNotification(
                  "New Notification",
                  Time(current.hour, current.minute),
                  HashSet.from(Day.values),
                  true));
              setState(() {});
            },
            icon: Icon(Icons.add),
            label: const Text('Add Notification')),
        body: new ListView(
          padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
          //shrinkWrap: true,
          children: <Widget>[
            new TextField(
              autocorrect: true,
              decoration: InputDecoration(labelText: "Title"),
              controller: TextEditingController(text: habit.title),
              onSubmitted: (val) {habit.title = val;},
            ),
            new TextField(
              autocorrect: true,
              decoration: InputDecoration(labelText: "Experiment"),
              controller: TextEditingController(text: habit.experimentTitle),
              onSubmitted: (val) { habit.experimentTitle = val;},
            ),
            new ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: habit.reminders.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                      direction: DismissDirection.startToEnd,
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify Widgets.
                      key: Key(habit.reminders[index].hashCode.toString()),
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
                          habit.reminders.removeAt(index);
                        });

                        // Show a snackbar! This snackbar could also contain "Undo" actions.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Notification removed")));
                      },
                      child: EditNotificationWidget(habit.reminders[index]));
                } // Item Builder
                )
          ],
        ));
  }
}
