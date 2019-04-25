import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'HabitSettings.dart';
import '../Global.dart';
import 'package:event_bus/event_bus.dart';
import "package:spe_66_days/classes/API.dart";

class HabitCheckedChangedEvent {
  final CoreHabit habit;
  final DateTime date;
  final bool state;

  HabitCheckedChangedEvent(this.habit, this.date, this.state);
}


class HabitManager extends SettingsBase<HabitSettings> {

  EventBus eventBus = new EventBus();

  HabitManager(String subDir) : super(subDir, "habit_manager.json", HabitSettings());

  bool initialised = false;

  Future<void> init() async{

    if (initialised)
      return;
    initialised = true;

    eventBus.on<HabitCheckedChangedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      this.save();
    });


    await load();
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

    this.settings.habits.putIfAbsent(id, ()=>habit.clone()..key = id..startDate=Global.currentDate);
  }

  bool removeHabit(String id){
    if (id.startsWith(customHabitPrefix) && hasHabit(id)){
      this.settings.habits.remove(id);
      return true;
    }

    return false;
  }

  bool checkHabit(String key, {DateTime date}){
    return setCheckHabit(key, true, date: date);
  }

  bool uncheckHabit(String key, {DateTime date}){
    return setCheckHabit(key, false, date: date);
  }

  bool setCheckHabit(String key, bool state, {DateTime date}){
    if (hasHabit(key)){
      CoreHabit habit = getHabit(key);
      DateTime useDate = date ?? Global.currentDate;
      if (state){
        if (habit.markedOff.add(useDate)){
          eventBus.fire(HabitCheckedChangedEvent(habit, useDate, state));
          return true;
        }
      }
      else{
        if (habit.markedOff.remove(useDate)){
          eventBus.fire(HabitCheckedChangedEvent(habit, useDate, state));
          return true;
        }
      }
    }

    return false;
  }

  CoreHabit getHabit (String core){
    //assert(this.settings.habits.containsKey(core));
    if (!this.settings.habits.containsKey(core))
      return null;
    return this.settings.habits[core];
  }

  bool hasHabit(String core){
    return this.settings.habits.containsKey(core);
  }

  Map<String, CoreHabit> getHabits (){ return Map.unmodifiable(this.settings.habits.map((k, v)=> MapEntry(k, v.clone())));}


  Future<int> scheduleNotifications(FlutterLocalNotificationsPlugin notificationsPlugin, int i) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('habit_reminder',  'User Habit Reminders', 'Reminders to check in/complete a habit');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    int count;
    this.settings.habits.forEach((key, value) {
      value.reminders.forEach((notif) {
        if (!notif.enabled)
          return;
        notif.repeatDays.forEach((day) async {
          count = (count  ?? -1)+1;
          int id = i+count;
          print("$id Notification scheduled for ${day.value.toString()}, ${notif.time.hour}:${notif.time.minute} ");

          await notificationsPlugin.showWeeklyAtDayAndTime(
              id,
              value.title,
              notif.message,
              day,
              notif.time,
              platformChannelSpecifics, payload: key);

        });
      });
    });

    return count;
  }

  Future<int> pushUserStats() async {
    String encoded = json.encode(this.settings.toStatsJson());
    return await API.pushUserStats(encoded);
  }

  @override
  HabitSettings getSettingsFromJson(Map<String, dynamic> json) => HabitSettings.fromJson(json);
}