import 'package:flutter/material.dart';

class HomeCard extends Card {
  HomeCard(
    Key key,
    String title,
    Widget child,
  ) : super(key: key, elevation:5.0, child: Container(padding: EdgeInsets.all(5), child: Column(

    children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
      Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))]),
      Container(child:child, constraints: BoxConstraints(maxHeight: 275))
    ],
  ))) {

  }
}
