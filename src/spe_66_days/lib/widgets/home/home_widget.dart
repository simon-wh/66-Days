import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/progress_chart.dart';
import 'home_card.dart';
import 'package:spe_66_days/widgets/habits/habits_widget.dart';

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
  List<HomeCard> cards = [
    HomeCard(Key("progress"), "Progress", ProgressChart.allHabitsCombined()),
    HomeCard(Key("habit"), "Habits", HabitsWidget.compact())
  ];


  @override
  void initState(){
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListView(
        padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
        //shrinkWrap: true,
        children: <Widget>[
          ListView.builder(
              shrinkWrap: true,
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                HomeCard c = cards[index];
                return Dismissible(
                    direction: DismissDirection.startToEnd,
                    // Each Dismissible must contain a Key. Keys allow Flutter to
                    // uniquely identify Widgets.
                    key: c.key,
                    // We also need to provide a function that will tell our app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from our data source.
                      setState(() {
                        cards.removeAt(index);
                      });

                      // Show a snackbar! This snackbar could also contain "Undo" actions.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Card dismissed")));
                    },
                    child: c);
              }) // Item Builder
        ],
      ));
  } // Build
} // _HabitsState
