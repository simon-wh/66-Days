import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'course_entry_widget.dart';

class CourseWidget extends StatefulWidget {
  final bool compact;

  CourseWidget({this.compact = false});

  @override
  State<StatefulWidget> createState() {
    return CourseState();
  }
}

class CourseScreen extends CourseWidget implements BottomNavigationBarItem {
  final Icon icon;
  final Text title;
  final Icon activeIcon;
  final Color backgroundColor;

  CourseScreen(this.icon, this.title, {this.activeIcon, this.backgroundColor, bool compact = false}) : super(compact: compact);
}


class CourseState extends State<CourseWidget> {
  CourseState();

  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              return Future(() async {
                await Global.courseManager.getCourseEntries(force: true).catchError((e){
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("Could not refresh the Course.\nCheck your internet connection?")));
                  return null;
                });
                setState(() {

              });});
            },
            child: Container(padding: EdgeInsets.all(0.0),  child:
          FutureBuilder<List<CourseEntry>>(
            future: Global.courseManager.getCourseEntries(),
            builder: (BuildContext context, AsyncSnapshot<List<CourseEntry>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Error: Unstarted');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Align(alignment: Alignment.topCenter,  child:CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Center(child:Text('Error: ${snapshot.error}'));
                  List<CourseEntry> entries = snapshot.data;
                  return
                //Global.courseManager.courseWeeks == null ? PageView( physics: AlwaysScrollableScrollPhysics(), scrollDirection: Axis.vertical,  children: <Widget>[Center(child:Text("Unable to load course"))]) :
                ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    CourseEntry entry = entries[index];
                    return Card(
                      elevation: 2.0,
                        margin: EdgeInsets.all(5.0),
                        child: ListTile( leading: CircleAvatar(backgroundColor: Theme.of(context).canvasColor, foregroundColor: Theme.of(context).accentColor, child:Icon(Icons.book)), title: Text(entry.title.split("-").first), subtitle: Text(entry.title.split("- ")[1]),onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseEntryScreen(entry)));
                        })
                    );
                  })
              ;
              }
              return null; // unreachable
            },
          )
        )));
  } // Build
} // _HabitsState