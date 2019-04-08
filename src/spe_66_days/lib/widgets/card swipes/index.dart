import 'dart:async';
import 'package:spe_66_days/widgets/card swipes/habitCard.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CardSwipes extends StatefulWidget {
  @override
  CardSwipesState createState() => new CardSwipesState();
}

class CardSwipesState extends State<CardSwipes> with TickerProviderStateMixin {
  AnimationController _buttonController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;
  int flag = 0;

  var date = Global.currentDate;
  List uncheckedHabits;


  void initState() {
    super.initState();
    uncheckedHabits = Global.habitManager.getHabits().values.where((h)=> !h.markedOff.contains(date)).toList();
    _buttonController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = uncheckedHabits.removeLast();
          uncheckedHabits.insert(0, i);

          _buttonController.reset();
        }
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = new Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  dismissHabit(CoreHabit habit) {
    setState(() {
      Global.habitManager.uncheckHabit(habit.key, date:date);
      uncheckedHabits.remove(habit);
    });
  }

  completeHabit(CoreHabit habit) {
    setState(() {
      Global.habitManager.setCheckHabit(habit.key, true, date:date);
      uncheckedHabits.remove(habit);
    });
  }


  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    var datalength = uncheckedHabits.length;

    return datalength > 0 ? Container(
      color: Color.fromARGB(150, 0, 0, 0),
      child: new Stack(
          alignment: AlignmentDirectional.center,
          children: uncheckedHabits.map((item) {
            return swipeCard(
                item,
                bottom.value - (10 * uncheckedHabits.indexOf(item)),
                right.value,
                0.0,
                rotate.value,
                rotate.value < -10 ? 0.1 : 0.0,
                context,
                flag,
                dismissHabit,
                completeHabit);
          }).toList())
    ) : Container();
  }
}
