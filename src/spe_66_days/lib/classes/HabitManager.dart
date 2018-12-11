import 'CoreHabit.dart';
import 'HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HabitManager {
  static const String saveFileName = "habit_manager.json";
  static final HabitManager instance = HabitManager();
  final FlutterLocalNotificationsPlugin notificationsPlugin = new FlutterLocalNotificationsPlugin();

  Map<String, CoreHabit> _habits = <String, CoreHabit> {
    "observation": CoreHabit("Eating Observation", "Taken a photo of my meal", reminders: <HabitNotification>[ HabitNotification("Surprise", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]),
    "eat_slowly": CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful ")
  };

  HabitManager() {


   //this.scheduleNotifications();
  }

  void init(){
    var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    load().whenComplete(() {
      this.scheduleNotifications();
    });
  }

  void scheduleNotifications() async {
    notificationsPlugin.cancelAll();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('habit_reminder',  'User Habit Reminders', 'Reminders to check in/complete a habit');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    int i = 0;
    this._habits.forEach((key, value) {
      value.reminders.forEach((notif) {
        if (!notif.enabled)
          return;
        notif.repeatDays.forEach((day) {
            print("$i Notification scheduled for ${day.value.toString()}, ${notif.time.hour}:${notif.time.minute} ");
          notificationsPlugin.showWeeklyAtDayAndTime(
              i,
              value.title,
              notif.message,
              day,
              notif.time,
              platformChannelSpecifics);
            i++;
        });

        /*notificationsPlugin.showDailyAtTime(
            0,
            value.title,
            notif.message,
            notif.time,
            platformChannelSpecifics);*/
      });
    });

  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    /*await Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  CoreHabit getHabit (String core){
    assert(_habits.containsKey(core));
    if (!_habits.containsKey(core))
      return null;
    return _habits[core];
  }

  Map<String, CoreHabit> getHabits (){ return Map.unmodifiable(_habits);}
  
  String getJson(){
    return json.encode(_habits);
  }
  
  Map<String, CoreHabit> getHabitsFromJson(String data){
    Map habitMap = json.decode(data);
    Map<String, CoreHabit> habits = habitMap.map((k, v) => MapEntry<String, CoreHabit>(k.toString(), CoreHabit.fromJson(v)));
    return habits;
  }

  Future<File> save() async {
    print("Saving Habits...");
    final file = await _localFile;
    String output = json.encode(_habits);
    return file.writeAsString(output);
  }

  Future<File> load() async {
    try {
      print("Loading Habits...");
      return _localFile.then((file) => file.readAsString().then((contents) {
        final habits = getHabitsFromJson(contents);
        this._habits = habits;
      })
      );
    } catch (e) {
      // If we encounter an error, return 0

    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$saveFileName');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}