import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'HomeCard.dart';
import 'package:spe_66_days/widgets/habits/HabitWidget.dart';
import 'package:spe_66_days/widgets/habits/HabitListWidget.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/widgets/card swipes/index.dart';
import 'package:spe_66_days/classes/GlobalSettings.dart';
import 'dart:async';


class HomeWidget extends StatefulWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  HomeWidget(this.icon, this.title, {this.activeIcon, this.backgroundColor});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeWidget> {
  List<HomeCard> cards;
  StreamSubscription<HabitCheckedChangedEvent> _event;

  @override
  void initState(){
    super.initState();
    cards = [
      HomeCard(Key("progress"), "Progress", () => Container(child: ProgressChart.allHabitsCombined(), constraints: BoxConstraints(maxHeight: 275.0))),
      HomeCard(Key("habit"), "Habits", () => HabitsWidget(displayMode: mode.Minimal, editable: true)),
      HomeCard(Key("stats"), "Statistics", () => StatsWidget())
    ];
    _event = Global.habitManager.eventBus.on<HabitCheckedChangedEvent>().listen((event) {
      if (this.mounted){
      setState(() {

      });}
    });
  }

  @override
  void dispose(){
    super.dispose();
    _event.cancel();
  }

  Widget build(BuildContext context) {
    DateTime EndOfDayHabit = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, Global.instance.settings.dailyNotification.time.hour);
    print(EndOfDayHabit);
    print(DateTime.now());
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () {
            return Future(() {setState(() {

            });});
          },
          child: PageView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          new Stack(
            children: <Widget>[
              ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    HomeCard c = cards[index];
                    if (c.hidden)
                      return Container();
                    return Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: c.key,
                        onDismissed: (direction) {

                          setState(() {
                            cards[index].hidden = true;
                          });

                          // Show a snackbar! This snackbar could also contain "Undo" actions.
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Card dismissed"), action: SnackBarAction(label: "Undo", onPressed: () {
                                setState(() {
                                  cards[index].hidden = false;
                                });
                              }),));
                        },
                        child: c.getCard(context));
                  }),
              DateTime.now().isAfter(EndOfDayHabit) ? CardSwipes() : Container()// Item Builder
            ],
          ),
        ],
      )));
  } // Build
} // _HabitsState
