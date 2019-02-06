import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/Global.dart';

class CourseEntryWidget extends StatefulWidget {
  final CourseEntry entry;

  CourseEntryWidget(this.entry);

  @override
  State<StatefulWidget> createState() => CourseEntryState();
}

class CourseEntryState extends State<CourseEntryWidget> {
  CourseEntryState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Center(child: Text(this.widget.entry.title, style: Theme.of(context).textTheme.headline)),
        Column(
            children: this.widget.entry.items.map((item) {
          if (item is CourseEntryText) {
            CourseEntryText text = item as CourseEntryText;
            return Center(child: Text(text.text));
          } else if (item is CourseEntryChange) {
            if (!Global.habitManager.hasHabit(item.habitKey))
              throw new Exception("Habit doesn't exist!");
            //TODO: make it add habit with default params when it is fresh with default params

            return Column(
                children: <Widget>[Text(item.title, style: Theme.of(context).textTheme.title)]
                    .followedBy(item.items.map((s) => FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String text = s;
                                var controller = TextEditingController(text: s);
                                return AlertDialog(
                                    title: Text("Confirm"),
                                    content: TextField(
                                        //autocorrect: true,
                                        decoration: InputDecoration(
                                            labelText: item.habitVar),
                                        controller: controller,

                                        onChanged: (t) {
                                          text = t;
                                        },
                                      ),
                                      actions: <Widget>[FlatButton(child: Text("Set"), onPressed: (){
                                        CoreHabit habit = Global.habitManager.getHabit(item.habitKey);
                                        switch(item.habitVar){
                                          case "experimentTitle":
                                            habit.experimentTitle = text;
                                            break;
                                          default:
                                            throw Exception("habitVar ${item.habitVar} not found!");
                                            break;
                                        }
                                        Navigator.pop(context);
                                      })]
                                    );
                              });
                        },
                        child: Text(s))))
                    .toList());
          } else {
            throw Exception("CourseEntryItem type unknown!");
          }
        }).toList() // Item Builder
            )
      ],
    ));
  }
}
