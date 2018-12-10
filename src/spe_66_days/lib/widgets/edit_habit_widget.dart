import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'edit_notification_widget.dart';
import 'dart:io';
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
  final CoreHabit habit;

  EditHabitState(this.habit);

  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = this.habit.title;
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

  Future<File> saveTitle(String title) async {
    setState(() {
      this.habit.title = title;
    });

    // write the variable as a string to the file
    return HabitManager.instance.save();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Edit Habit"),
        leading: IconButton(icon: Icon(Icons.clear), onPressed: () {
          Navigator.pop(context);
        }),
        actions: <Widget>[

          IconButton(icon: Icon(Icons.check), onPressed: () {
            HabitManager.instance.save();
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
        body: new ListView(
          padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
          //shrinkWrap: true,
          children: <Widget>[
            new TextField(
              //autocorrect: true,
              decoration: InputDecoration(labelText: "Title"),
              controller: titleController,
              onSubmitted: saveTitle,
            ),
            new TextField(
              //autocorrect: true,
              decoration: InputDecoration(labelText: "Experiment"),
              controller: TextEditingController(text: habit.experimentTitle),
              onChanged: (val) {
                habit.experimentTitle = val;
                //HabitManager.instance.save();
              },
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
                          //HabitManager.instance.save();
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
