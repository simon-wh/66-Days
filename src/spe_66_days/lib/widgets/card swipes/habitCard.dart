import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';

Positioned cardDemo(
    CoreHabit habit,
    double bottom,
    double right,
    double left,
    double rotation,
    double skew,
    BuildContext context,
    int flag,
    Function swipeRight,
    Function swipeLeft) {
  Size screenSize = MediaQuery.of(context).size;
  return new Positioned(
    bottom: 100.0 + bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: new Key(new Random().toString()),
      crossAxisEndOffset: -0.3,
      onResize: () {
      },
      onDismissed: (DismissDirection direction) {
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: new Matrix4.skewX(skew),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
          child: new Hero(
            tag: "card",
            child: new GestureDetector(
              onTap: () {
              },
              child: new Card(
                elevation: 4.0,
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.3,
                  height: screenSize.height / 1.8,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          width: screenSize.width / 1.3,
                          height: screenSize.height / 2.8,
                          alignment: Alignment.center,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("${habit.experimentTitle}"),
                            ])),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new FlatButton(
                              padding: new EdgeInsets.all(0.0),
                              onPressed: () {
                                swipeLeft();
                              },
                              child: new Container(
                                height: 60.0,
                                width: 130.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                  new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "NOT DONE",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              )),
                          new FlatButton(
                              padding: new EdgeInsets.all(0.0),
                              onPressed: () {
                                swipeRight();
                              },
                              child: new Container(
                                height: 60.0,
                                width: 130.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                  new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "DONE",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
