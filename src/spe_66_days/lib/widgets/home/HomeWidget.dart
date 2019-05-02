import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'HomeCard.dart';
import 'package:spe_66_days/widgets/habits/HabitWidget.dart';
import 'package:spe_66_days/widgets/habits/HabitListWidget.dart';
import 'package:spe_66_days/widgets/progress/StatsWidget.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/widgets/card swipes/CardSwipes.dart';
import 'package:spe_66_days/classes/GlobalSettings.dart';
import 'dart:async';
import 'dart:collection';

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
  bool showCards = false;
  static HashSet<DateTime> cardsComplete = new HashSet<DateTime>();
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
    if (!cardsComplete.contains(Global.currentDate)) {
      final bool args = ModalRoute
          .of(context)
          .settings
          .arguments ?? false;
      if (args)
        showCards = true;

      /*if (!showCards){
        DateTime endOfDayHabit =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            Global.instance.settings.dailyNotification.time.hour,
            Global.instance.settings.dailyNotification.time.minute);

        if (DateTime.now().isAfter(endOfDayHabit)){
          showCards = true;
        }
      }*/
    }

    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () {
            return Future(() {setState(() {});});
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
                        return c.getCard(context);
                      }),
                  showCards ? CardSwipes((){
                    this.showCards = false;
                    cardsComplete.add(Global.currentDate);
                  }) : Container()// Item Builder
           ],
          ),
        ],
      )));
  } // Build
} // _HabitsState
