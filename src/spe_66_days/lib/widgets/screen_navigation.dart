import 'package:flutter/material.dart';
import 'progress_widget.dart';
import 'package:spe_66_days/widgets/habits_widget.dart';

class ScreenNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScreenNavigationState();
  }
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _children = [
    HabitsWidget(Icon(Icons.assignment), Text("Habits")),
    ProgressWidget(Icon(Icons.timeline), Text('Progress')),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('6 6  DAYS',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      body: _children[_currentIndex] as Widget,
      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: _children.map((n) => BottomNavigationBarItem(icon: n.icon, title: n.title, activeIcon: n.activeIcon, backgroundColor: n.backgroundColor)).toList()
      ),
    );
  }
}