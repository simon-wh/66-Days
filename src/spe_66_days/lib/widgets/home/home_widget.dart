import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/progress_chart.dart';
import 'home_card.dart';
import 'package:spe_66_days/widgets/habits/habits_widget.dart';
import 'package:spe_66_days/widgets/progress/stats_widget.dart';

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

  @override
  void initState(){
    super.initState();
    cards = [
      HomeCard(Key("progress"), "Progress", () => Container(child: ProgressChart.allHabitsCombined(), constraints: BoxConstraints(maxHeight: 275.0))),
      HomeCard(Key("habit"), "Habits", () => HabitsWidget(compact: true, onHabitChanged: () => setState((){})  )),
      HomeCard(Key("stats"), "Statistics", () => StatsWidget())
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () {
            return Future(() {setState(() {

            });});
          },
          child: PageView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                    child: c.getCard());
              }) // Item Builder
        ],
      )));
  } // Build
} // _HabitsState