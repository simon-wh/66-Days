import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'package:spe_66_days/classes/HabitManager.dart';

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
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        FlatButton(
            child: Text(
                notification.time.hour.toString().padLeft(2, "0") +
                    ":" +
                    notification.time.minute.toString().padLeft(2, "0"),
                style: Theme.of(context).textTheme.body1),
            onPressed: () async {
              TimeOfDay initial = TimeOfDay(
                  hour: notification.time.hour,
                  minute: notification.time.minute);
              final TimeOfDay picked =
                  await showTimePicker(context: context, initialTime: initial);
              if (picked != null && picked != initial) {
                setState(() {
                  notification.time = Time(picked.hour, picked.minute);
                });
              }
            }),
        Switch(
          activeTrackColor: Colors.lightGreenAccent,
          inactiveTrackColor: Colors.grey,
          value: notification.enabled,
          onChanged: (checked) {
            notification.enabled = checked;
            setState(() {});
          },
        )
      ]),
      expanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Day>.generate(7, (int index) => Day.values[index],
                      growable: false)
                  .map((day) => Column(children: <Widget>[
                        Text(HabitNotification.DayStringMap[day][0]),
                        Checkbox(
                            activeColor: Colors.black,
                            value: notification.repeatDays.contains(day),
                            onChanged: (checked) {
                              if (checked) {
                                notification.repeatDays.add(day);
                              } else {
                                notification.repeatDays.remove(day);
                              }
                              setState(() {});
                            })
                      ]))
                  .toList())
          : Container(),
      expanded
          ? Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: TextField(
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Message"),
                  controller: TextEditingController(text: notification.message),
                  maxLines: 1,
                  onChanged: (val) {
                    notification.message = val;
                  }))
          : Container(),
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setExpansion(!expanded);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                    child: Text(
                        !expanded
                            ? notification.message +
                                " : " +
                                notification.getDayString()
                            : "",
                        style: Theme.of(context).textTheme.body2,
                        overflow: TextOverflow.ellipsis)),
                IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  //onPressed: () {
                  //  setExpansion(!expanded);
                  //}
                ),
              ])),
    ]);
  }
}
