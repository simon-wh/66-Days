import 'package:flutter/material.dart';

class HabitsWidget extends StatefulWidget{
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
    return Scaffold(
      body: new Column(
        children: <Widget>[
          new Text("Core Habit: Lengthening meal times",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          new Flexible(
              child: new ListView.builder(
                  itemCount: textList.length,
                  itemBuilder: (BuildContext context, int index){
                    return new Row(
                      children: <Widget>[
                        new Checkbox(
                            activeColor: Colors.black,
                            value: textCheckBox[index],
                            onChanged: (bool Checked){
                               textCheckBox[index] = Checked;
                               setState(() {
                               });
                            },
                        ),
                        new Text(textList[index], style: new TextStyle(color: Colors.black)),
                      ],
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}