import 'dart:collection';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class Notification {
  bool enabled;
  List<Time> repeatTimes;
  HashSet<Day> repeatDays;
  String message;
}