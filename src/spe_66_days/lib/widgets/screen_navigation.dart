import 'package:flutter/material.dart';
import 'package:spe_66_days/widgets/progress/progress_widget.dart';
import 'package:spe_66_days/widgets/habits/habits_widget.dart';
import 'package:spe_66_days/widgets/home/home_widget.dart';
import 'package:spe_66_days/widgets/course/course_screen.dart';
import 'package:spe_66_days/widgets/settings/settings_screen.dart';

class ScreenNavigation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScreenNavigationState();
  }
}

class _ScreenNavigationState extends State<ScreenNavigation> {
  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _children = [
    HomeWidget(Icon(Icons.home), Text("Home")),
    HabitsScreen(Icon(Icons.assignment), Text("Habits")),
    ProgressWidget(Icon(Icons.timeline), Text('Progress')),
    CourseScreen(Icon(Icons.library_books), Text('Course')),
    SettingsScreen(Icon(Icons.settings), Text('Settings'))
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