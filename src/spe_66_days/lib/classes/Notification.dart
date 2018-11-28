import 'dart:collection';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HabitNotification {
  bool enabled;
  Time time;
  HashSet<Day> repeatDays;
  String message;

  HabitNotification(this.message, this.time, this.repeatDays, this.enabled);

  static const Map<Day, String> DayStringMap = <Day, String>{
    Day.Monday: "Monday",
    Day.Tuesday: "Tuesday",
    Day.Wednesday: "Wednesday",
    Day.Thursday: "Thursday",
    Day.Friday: "Friday",
    Day.Saturday: "Saturday",
    Day.Sunday: "Sunday",
  };

  String getDayString(){
    return repeatDays.length >= 7 ? "Every day" : repeatDays.map((i) => DayStringMap[i]).join(", ");
  }
}