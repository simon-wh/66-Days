import 'package:flutter/material.dart';

class HabitsWidget extends StatefulWidget implements BottomNavigationBarItem{
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  HabitsWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState() {
    return _HabitsState();
  }
}

class _HabitsState extends State<HabitsWidget> {
  TextEditingController eCtrl = new TextEditingController();
  List<String> textList = ["Put down cuterly after each mouthful",
                           "Chew food five times for each bite",
                           "50 pressups after each bite"
                          ];
  List<bool> textCheckBox = [false, false, false];

  Widget build(BuildContext context) {
    //Return a new scaffold to output to screen
    return Scaffold(
      //Body of the scaffold is a column that displays text and a flexible check list
      body: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text("Core Habit: Lengthening meal times",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: textList.length,
                  itemBuilder: (BuildContext context, int index){
                    //Return row to align text and button, can change to column if text is to be
                    //beneath checkbox
                    return new Row(
                      children: <Widget>[
                        new Checkbox(
                            activeColor: Colors.black,
                            value: textCheckBox[index],
                            onChanged: (bool checked){
                               textCheckBox[index] = checked;
                               setState(() {});
                            },
                        ),
                        new Text(textList[index], style: new TextStyle(color: Colors.black)),
                      ],
                    );
                  }
              )
          ),
          new Text("Core Habit: Reduce liquid calories",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: textList.length,
                  itemBuilder: (BuildContext context, int index){
                    //Return row to align text and button, can change to column if text is to be
                    //beneath checkbox
                    return new Row(
                      children: <Widget>[
                            new IconButton(icon: Icon(Icons.lock), onPressed: null),
                            new Text("Unlocked on week 3",
                                style: new TextStyle(color: Colors.grey)
                            )
                          ],
                    );
                  }
              )
          ),
          new Text("Core Habit: Eat whole food",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: textList.length,
                  itemBuilder: (BuildContext context, int index){
                    //Return row to align text and button, can change to column if text is to be
                    //beneath checkbox
                    return new Row(
                      children: <Widget>[
                        new IconButton(icon: Icon(Icons.lock), onPressed: null),
                        new Text("Unlocked on week 5",
                            style: new TextStyle(color: Colors.grey)
                        )
                      ],
                    );
                  }
              )
          ),
          new Text("Core Habit: Portion control",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Flexible(
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: textList.length,
                  itemBuilder: (BuildContext context, int index){
                    //Return row to align text and button, can change to column if text is to be
                    //beneath checkbox
                    return new Row(
                      children: <Widget>[
                        new IconButton(icon: Icon(Icons.lock), onPressed: null),
                        new Text("Unlocked on week 7",
                            style: new TextStyle(color: Colors.grey)
                        )
                      ],
                    );
                  }
              )
          ),
        ],
      ),
    );
  }
}