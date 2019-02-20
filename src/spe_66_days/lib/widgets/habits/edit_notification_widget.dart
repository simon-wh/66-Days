import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EditNotificationWidget extends StatefulWidget {
  final NotificationConfig notification;

  EditNotificationWidget(this.notification);

  @override
  State<StatefulWidget> createState() => EditNotificationState();
}

class EditNotificationState extends State<EditNotificationWidget> {
  bool expanded = false;
  bool expandLock = false;
  final TextEditingController messageController = TextEditingController();

  EditNotificationState();

  @override
  void initState(){
    super.initState();
    expandLock = !this.widget.notification.enabled;
    messageController.text = this.widget.notification.message;
  }

  void lockExpansion(bool lock){
    setState(() {
      expandLock = lock;
    });
  }

  void setExpansion(bool expanded) {
    if (expandLock)
      return;
    setState(() {
      this.expanded = expanded;
    });
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
                });
              }
            }),
        Switch(
          activeTrackColor: Theme.of(context).accentColor.withOpacity(0.75),
          inactiveTrackColor: Theme.of(context).disabledColor,
          value: notification.enabled,
          onChanged: (checked) {
            notification.enabled = checked;
            if (!checked)
              setExpansion(false);
            lockExpansion(!checked);
          },
        )
      ]),
      expanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Day>.generate(7, (int index) => Day.values[index],
                      growable: false)
                  .map((day) => Column(children: <Widget>[
                        Text(NotificationConfig.DayStringMap[day][0]),
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
                  controller: messageController,
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
                        style: style,
                        overflow: TextOverflow.ellipsis)
                ),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ])),
    ]);
  }
}
