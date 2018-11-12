import 'package:flutter/material.dart';

class HabitsWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HabitsState();
  }
}

class _HabitsState extends State<HabitsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.volume_up),
        tooltip: 'Change Icon',
        onPressed: () {  },
      )
    );
  }
}