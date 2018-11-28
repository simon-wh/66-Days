import 'dart:collection';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HabitNotification {
  bool enabled;
  Time time;
  HashSet<Day> repeatDays;
  String message;

  HabitNotification(this.message, this.time, this.repeatDays, this.enabled);
}