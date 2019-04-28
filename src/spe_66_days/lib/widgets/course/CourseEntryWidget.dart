import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/Global.dart';

class CourseEntryScreen extends StatefulWidget {
  final CourseEntry entry;

  CourseEntryScreen(this.entry);

  @override
  State<StatefulWidget> createState() => CourseEntryScreenState();
}

class CourseEntryScreenState extends State<CourseEntryScreen> {
  CourseEntryScreenState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //Global.habitManager.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(this.widget.entry.title.replaceFirst('- ', '\n'))),
        body: Container(padding: EdgeInsets.all(5.0),
            child: CourseEntryWidget(this.widget.entry))
        );
  }
}

class CourseEntryWidget extends StatefulWidget {
  final CourseEntry entry;

  CourseEntryWidget(this.entry);

  @override
  State<StatefulWidget> createState() => CourseEntryState();
}

class CourseEntryState extends State<CourseEntryWidget> {
  CourseEntryState();

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return ListView(
            children: this.widget.entry.items.map((item) {
          if (item is CourseEntryText) {
            CourseEntryText text = item;
            return Center(child: Container(padding: EdgeInsets.all(5.0), child: Text(text.text, textAlign: TextAlign.left)));
          } else if (item is CourseEntryChange) {
            //if (!Global.habitManager.hasHabit(item.habitKey))
            //  throw new Exception("Habit doesn't exist!");
            //TODO: make it add habit with default params when it is fresh with default params

            return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text('Select one to update for ${Global.habitManager.hasHabit(item.habitKey) ? Global.habitManager.getHabit(item.habitKey).title : item.defaultHabit.title}'),
                  )
                ]
                    .followedBy(item.items.map((s) => Align(alignment: Alignment.center, child: FlatButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String text = s;
                                var controller = TextEditingController(text: s);
                                return AlertDialog(
                                    title: Text("Confirm", style: Theme.of(context).textTheme.body2),
                                    content: TextField(
                                      //autocorrect: true,
                                      decoration: InputDecoration(
                                          labelText: item.title),
                                      controller: controller,

                                      onChanged: (t) {
                                        text = t;
                                      },
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("Set"),
                                          onPressed: () {
                                            if (!Global.habitManager.hasHabit(item.habitKey)){
                                              if (item.defaultHabit != null){
                                                Global.habitManager.addHabit(item.habitKey, item.defaultHabit);
                                              }
                                              else
                                                throw("Trying to set the ${item.habitVar} on ${item.habitKey} that doesn't exist and no default has been specified!");
                                            }

                                            CoreHabit habit = Global
                                                .habitManager
                                                .getHabit(item.habitKey);
                                            switch (item.habitVar) {
                                              case "experimentTitle":
                                                habit.experimentTitle = text;
                                                break;

                                              case "environmentDesign":
                                                habit.environmentDesign = text;
                                                break;
                                              default:
                                                throw Exception(
                                                    "habitVar ${item.habitVar} not found!");
                                                break;
                                            }
                                            Global.habitManager.save();
                                            Navigator.pop(context);
                                          })
                                    ]);
                              });
                        },
                        child: Text(s, style: Theme.of(context).textTheme.body1)))))
                    .toList());
          } else {
            throw Exception("CourseEntryItem type unknown!");
          }
        }).map((s) => Card(child: s)).toList() // Item Builder
            );
  }
}
