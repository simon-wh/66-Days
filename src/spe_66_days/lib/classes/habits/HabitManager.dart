import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'HabitSettings.dart';


class HabitManager extends SettingsBase<HabitSettings> {
  final FlutterLocalNotificationsPlugin notificationsPlugin = new FlutterLocalNotificationsPlugin();

  HabitManager() : super("habit_manager.json", HabitSettings());

  bool initialised = false;

  Future<void> init() async{
    if (initialised)
      return;
    initialised = true;
    var initializationSettingsAndroid = new AndroidInitializationSettings('mipmap/launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    await load();
    this.scheduleNotifications();
  }

  static const String customHabitPrefix = "custom-";
  CoreHabit newCustomHabit(){
    int id = 0;
    List<int> customIds = this.settings.habits.keys.where((id) => id.startsWith(customHabitPrefix)).map((id) => int.parse(id.split('-').last)).toList()
        ..sort((a, b) => a.compareTo(b));
    if (customIds.length > 0)
      id = customIds.last + 1;
    String key = customHabitPrefix + id.toString();

    this.settings.habits.putIfAbsent(key, () => CoreHabit("New Custom Habit Title", "New Custom Habit Experiment", key: key));
    return this.settings.habits[key];
  }

  void addHabit(String id, CoreHabit habit){
    if (this.settings.habits.containsKey(id))
      throw("Habit with key $id already exists!");

    this.settings.habits.putIfAbsent(id, ()=>habit.clone()..key = id);
  }

  void removeHabit(String id){
    if (id.startsWith(customHabitPrefix))
      this.settings.habits.remove(id);
  }

  void scheduleNotifications() async {
    notificationsPlugin.cancelAll();

    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('habit_reminder',  'User Habit Reminders', 'Reminders to check in/complete a habit');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    int i = 0;
    this.settings.habits.forEach((key, value) {
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
      });
    });

  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  CoreHabit getHabit (String core){
    assert(this.settings.habits.containsKey(core));
    if (!this.settings.habits.containsKey(core))
      return null;
    return this.settings.habits[core];
  }

  bool hasHabit(String core){
    return this.settings.habits.containsKey(core);
  }

  Map<String, CoreHabit> getHabits (){ return Map.unmodifiable(this.settings.habits);}

  @override
  HabitSettings getSettingsFromJson(Map<String, dynamic> json) => HabitSettings.fromJson(json);
}