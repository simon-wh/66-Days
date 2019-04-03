import 'package:flutter/material.dart';

class HomeCard {
  final Key key;
  final String title;
  final Widget Function() child;
  bool hidden = false;

  HomeCard(this.key, this.title, this.child) {}

  Card getCard(BuildContext context) {
    return Card(
        key: key,
        elevation: 2.0,
        child: Container(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Align(alignment: Alignment.center, child: Text(title,
                    style: Theme.of(context).textTheme.subhead)),
                Container(
                    child: child())
              ],
            )));
  }
}
