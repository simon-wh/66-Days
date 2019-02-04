import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'package:spe_66_days/widgets/habits/edit_notification_widget.dart';
import 'package:spe_66_days/classes/HabitManager.dart';

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
  CoreHabit ogHabit;

  CoreHabit habit;

  EditHabitState(this.ogHabit){
    this.habit = this.ogHabit.clone();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController experimentTitleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = this.habit.title;
    experimentTitleController.text = this.habit.experimentTitle;
    /*titleController.addListener(() async {
      if (this.habit.title != titleController.text){
        print("diff");
        this.habit.title = titleController.text;
        //await HabitManager.instance.save();
      }
    });*/
  }

  @override
  void dispose() {
    //HabitManager.instance.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Edit Habit"),
        leading: IconButton(icon: Icon(Icons.clear), onPressed: () {
          Navigator.pop(context);
        }),
        actions: <Widget>[
          this.ogHabit.isCustom() ? IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Delete Confirmation"),
                  content: new Text("Are you sure you want to delete this habit forever?"),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Delete"),
                      onPressed: () {
                        HabitManager.instance.removeHabit(this.ogHabit.key);
                        HabitManager.instance.save();
                        HabitManager.instance.scheduleNotifications();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );




          }) : Container(),

          IconButton(icon: Icon(Icons.check), onPressed: () {
            this.ogHabit.updateFrom(this.habit);
            HabitManager.instance.save();
            HabitManager.instance.scheduleNotifications();
            Navigator.pop(context);
          })
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              DateTime current = DateTime.now();
              habit.reminders.add(HabitNotification(
                  "New Notification",
                  Time(current.hour, current.minute),
                  HashSet.from(Day.values),
                  true));
              setState(() {
                //HabitManager.instance.save();
              });
            },
            icon: Icon(Icons.add),
            label: const Text('Add Notification')),
        body: ListView(
          padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
          //shrinkWrap: true,
          children: <Widget>[
            TextField(
              //autocorrect: true,
              decoration: InputDecoration(labelText: "Title"),
              controller: titleController,
              onChanged: (val) {
                habit.title = val;
              },
            ),
            TextField(
              //autocorrect: true,
              decoration: InputDecoration(labelText: "Experiment"),
              controller: experimentTitleController,
              onChanged: (val) {
                habit.experimentTitle = val;
                //HabitManager.instance.save();
              },
            ),
            ListView.builder(
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
                          //HabitManager.instance.save();
                        });

                        // Show a snackbar! This snackbar could also contain "Undo" actions.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Notification removed")));
                      },
                      child: EditNotificationWidget(habit.reminders[index]));
                } // Item Builder
                ),
          ],
        ));
  }
}
