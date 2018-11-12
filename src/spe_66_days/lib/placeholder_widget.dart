import 'package:flutter/material.dart';
/*This class is only temporary so that it can be added to the list of children
  widgets in home_widget, a proper implementation would have many widgets which
  correspond to the different tabs e.g. progress tab displaying graphs, profile
  tab displaying account information etc.
*/
class PlaceholderWidget extends StatelessWidget implements BottomNavigationBarItem {
  final Color color;
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;
  //The constructor of this widget gets passed a color
  PlaceholderWidget(this.icon, this.title, this.color, {this.activeIcon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    /*The build method then returns a container of this color and puts it in the
      body of the page
    */
    return Container(
      color: color,
    );
  }
}