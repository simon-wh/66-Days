import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EditNotificationWidget extends StatefulWidget {
  final NotificationConfig notification;
  final editable;
  final Function onChanged;

  EditNotificationWidget(this.notification, {this.editable = true, this.onChanged});

  @override
  State<StatefulWidget> createState() => EditNotificationState(editable);
}

class EditNotificationState extends State<EditNotificationWidget> {
  bool editDays;
  final TextEditingController messageController = TextEditingController();

  EditNotificationState(this.editDays);

  @override
  void initState(){
    super.initState();
    messageController.text = this.widget.notification.message;
  }

  @override
  Widget build(BuildContext context) {
    NotificationConfig notification = this.widget.notification;
    TextStyle style = Theme.of(context).textTheme.body1.copyWith(
        color : Theme.of(context).textTheme.body1.color.withOpacity(notification.enabled ? 1.0 : 0.5)
    );
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        FlatButton(
            child: Text(
                notification.time.hour.toString().padLeft(2, "0") +
                    ":" +
                    notification.time.minute.toString().padLeft(2, "0"),
                style: style.copyWith(fontSize: 24.0),
            ),
            onPressed: () async {
              if (!notification.enabled)
                return;

              TimeOfDay initial = TimeOfDay(
                  hour: notification.time.hour,
                  minute: notification.time.minute);
              final TimeOfDay picked =
                  await showTimePicker(context: context, initialTime: initial);
              if (picked != null && picked != initial) {
                setState(() {
                  notification.time = Time(picked.hour, picked.minute);
                  if (this.widget.onChanged != null)
                    this.widget.onChanged();
                });
              }
            }),
        Switch(
          activeTrackColor: Theme.of(context).accentColor.withOpacity(0.75),
          inactiveTrackColor: Theme.of(context).disabledColor,
          value: notification.enabled,
          onChanged: (checked) {
            setState(() {
              notification.enabled = checked;
              if (this.widget.onChanged != null)
                this.widget.onChanged();
            });
          }
        )
      ]),
      IgnorePointer(
        ignoring: !notification.enabled,
        child: editDays ? ExpansionTile(
          title: Text(notification.message + " : " + notification.getDayString(), overflow: TextOverflow.ellipsis, style: style),
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Day>.generate(7, (int index) => Day.values[index],
                    growable: false)
                    .map((day) => Column(children: <Widget>[
                  Text(NotificationConfig.DayStringMap[day][0]),
                  Checkbox(
                      activeColor: Colors.black,
                      value: notification.repeatDays.contains(day),
                      onChanged: (checked) {

                        setState(() {
                          if (checked) {
                            notification.repeatDays.add(day);
                          } else {
                            notification.repeatDays.remove(day);
                          }
                          if (this.widget.onChanged != null)
                            this.widget.onChanged();
                        });
                      })
                ])).toList()),
            Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: TextField(
                    autocorrect: true,
                    decoration: InputDecoration(labelText: "Message"),
                    controller: messageController,
                    maxLines: 1,
                    onChanged: (val) {
                      notification.message = val;
                      if (this.widget.onChanged != null)
                        this.widget.onChanged();
                    }))
          ],
        ) :
        Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextField(
                autocorrect: true,
                decoration: InputDecoration(labelText: "Message"),
                controller: messageController,
                maxLines: 1,
                onChanged: (val) {
                  notification.message = val;
                  if (this.widget.onChanged != null)
                    this.widget.onChanged();
                }))
      )
    ]);
  }


}
