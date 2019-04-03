import 'dart:async';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/course/CourseManager.dart';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'package:spe_66_days/classes/GlobalSettings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:spe_66_days/main.dart';
import 'package:spe_66_days/widgets/habits/HabitWidget.dart';
import 'package:spe_66_days/widgets/habits/HabitOverview.dart';



class Global extends SettingsBase<GlobalSettings> {
  final FlutterLocalNotificationsPlugin notificationsPlugin = new FlutterLocalNotificationsPlugin();
  static DateTime get currentDate => DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static final Global instance = Global._internal();

  static final HabitManager habitManager = HabitManager();
  static final CourseManager courseManager = CourseManager();

  static final FirebaseAuth auth = FirebaseAuth.instance;

  Global._internal() : super("main_settings.json", GlobalSettings());

  bool initialised = false;

  Future<void> init() async{
    if (initialised)
      return;

    initialised = true;

    await habitManager.init();
    await courseManager.init();
    var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    await load();
    this.scheduleAllNotifications();

  /*_handleSignIn()
        .then((FirebaseUser user) => print(user))
        .catchError((e) => print(e));*/

  }

  Future onSelectNotification(String payload) async {
    if (payload == "all") {
      var bm = HabitsScreen(Icon(Icons.assignment), Text("Habit Manager"));
      await  StartApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) =>Scaffold(appBar: AppBar(title: bm.title) ,body: bm)));
    }
    else
    {
      if (habitManager.hasHabit(payload)){
        await StartApp.navigatorKey.currentState.push(MaterialPageRoute(builder: (context) =>HabitOverview(payload)));
      }
    }
  }

  void scheduleAllNotifications() async {
    await notificationsPlugin.cancelAll();
    int i = 0;
    i+=await this.scheduleNotifications(notificationsPlugin, i);
    i+=await habitManager.scheduleNotifications(notificationsPlugin, i);

  }

  Future<int> scheduleNotifications(FlutterLocalNotificationsPlugin notificationsPlugin, int i) async{
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('end_of_day_reminder', 'End of Day Habit Reminder', 'Reminder to check in on habits at the end of the day');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.showDailyAtTime(
        i,
        this.settings.dailyNotification.message,
        "Tap to check off your habits!",
        this.settings.dailyNotification.time,
        platformChannelSpecifics, payload:'all');
    return 1;
  }

    /*Future<FirebaseUser> _handleSignIn() async {

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }*/
  static DateTime stripTime(DateTime date){
    return DateTime.utc(date.year, date.month, date.day);
  }

  @override
  GlobalSettings getSettingsFromJson(Map<String, dynamic> json) => GlobalSettings.fromJson(json);
}