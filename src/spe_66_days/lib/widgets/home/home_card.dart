import 'package:flutter/material.dart';

class HomeCard {
  final Key key;
  final String title;
  final Widget Function() child;
  bool hidden = false;

  HomeCard(this.key, this.title, this.child) {}

  Card getCard() {
    return Card(
        key: key,
        elevation: 5.0,
        child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold))
                    ]),
                Container(
                    child: child(), constraints: BoxConstraints(maxHeight: 275.0))
              ],
            )));
  }
}
