import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';

Positioned swipeCard(
    CoreHabit habit,
    double bottom,
    double right,
    double left,
    double rotation,
    double skew,
    BuildContext context,
    int flag,
    Function dismissHabit,
    Function completeHabit)
{
  Size screenSize = MediaQuery.of(context).size;

  return new Positioned(
    bottom: 100.0 + bottom,
    right: flag == 0 ? right != 0.0 ? right : null : null,
    left: flag == 1 ? right != 0.0 ? right : null : null,
    child: new Dismissible(
      key: Key(habit.experimentTitle),
      crossAxisEndOffset: -0.3,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart)
          dismissHabit(habit);
        else
          completeHabit(habit);
      },
      child: new Transform(
        alignment: flag == 0 ? Alignment.bottomRight : Alignment.bottomLeft,
        transform: new Matrix4.skewX(skew),
        child: new RotationTransition(
          turns: new AlwaysStoppedAnimation(
              flag == 0 ? rotation / 360 : -rotation / 360),
              child: new Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(75, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(10.0),
                ),
                child: new Container(
                  alignment: Alignment.center,
                  width: screenSize.width / 1.3,
                  height: screenSize.height / 1.8,
                  child: new Stack(
                    children: <Widget>[
                      new Align(
                        child: Text("${habit.title}", softWrap: true,
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        alignment: Alignment(0, -0.9),
                      ),
                      new Align(
                          alignment: Alignment.center,
                          child:
                          Container(width: screenSize.width /1.5,
                              child: Text("${habit.experimentTitle}",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)),
                      ),
                      new Align(
                        alignment: Alignment(0, 0.7),
                        child: Container(
                            child: Text("Swipe to", style: TextStyle(fontSize: 15.0))
                        )
                      ),
                      new Align(
                          alignment: Alignment(0, 0.9),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.arrow_back, color: Colors.grey),
                                      Text(" DISMISS", style: TextStyle(color: Colors.grey))
                                    ]),
                                Column(mainAxisSize: MainAxisSize.min,  children: <Widget>[
                                  Icon(Icons.arrow_forward, color: Colors.green),
                                  Text("COMPLETE", style: TextStyle(color: Colors.green))
                                ])
                              ])
                      )
                    ],
                  ),
                ),
              ),
        ),
      ),
    ),
  );
}
