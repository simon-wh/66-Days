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
        appBar: AppBar(title: Center(child: Text(this.widget.entry.title)),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              Navigator.pop(context);
            })),
        body: Container(padding: EdgeInsets.all(5.0), child: CourseEntryWidget(this.widget.entry))

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
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        /*Center(child: Center(child: Text(this.widget.entry.title, textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline))),*/
        Column(
            children: this.widget.entry.items.map((item) {
          if (item is CourseEntryText) {
            CourseEntryText text = item;
            return Center(child: Text(text.text));
          } else if (item is CourseEntryChange) {
            if (!Global.habitManager.hasHabit(item.habitKey))
              throw new Exception("Habit doesn't exist!");
            //TODO: make it add habit with default params when it is fresh with default params

            return Column(
                children: <Widget>[
                  Text(item.title, style: Theme.of(context).textTheme.subtitle)
                ]
                    .followedBy(item.items.map((s) => FlatButton(
                        onPressed: () {
                          /*showModalBottomSheet(context: context, builder: (context){
                            String text = s;
                            controller.text = text;
                            return Column( mainAxisSize: MainAxisSize.min, children: <Widget>[
                              Text("Confirm", style: Theme.of(context).textTheme.title),
                              TextField(
                                //autocorrect: true,
                                decoration: InputDecoration(
                                    labelText: item.habitVar),
                                controller: controller,

                                onChanged: (t) {
                                  text = t;
                                },
                              ),
                              FlatButton(
                                  child: Text("Set"),
                                  onPressed: () {
                                    CoreHabit habit = Global
                                        .habitManager
                                        .getHabit(item.habitKey);
                                    switch (item.habitVar) {
                                      case "experimentTitle":
                                        habit.experimentTitle = text;
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
                          });*/


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
                        child: Text(s, style: Theme.of(context).textTheme.body1))))
                    .toList()..insert(0, Divider(indent:4.0, height: 20.0, color: Theme.of(context).accentColor)));
          } else {
            throw Exception("CourseEntryItem type unknown!");
          }
        }).toList() // Item Builder
            )
      ],
    ));
  }
}
