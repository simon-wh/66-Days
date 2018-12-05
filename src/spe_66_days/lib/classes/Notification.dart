import 'dart:collection';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:json_annotation/json_annotation.dart';
import 'type_converters/DayConverter.dart';
import 'type_converters/TimeConverter.dart';

part 'Notification.g.dart';

@JsonSerializable()
@TimeConverter()
@DayConverter()
class HabitNotification {
  bool enabled;
  Time time;
  HashSet<Day> repeatDays;
  String message;

  HabitNotification(this.message, this.time, this.repeatDays, this.enabled);

  factory HabitNotification.fromJson(Map<String, dynamic> json) => _$HabitNotificationFromJson(json);

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
    List<Day> days = repeatDays.toList();
    days.sort((a,b) => a.value.compareTo(b.value));
    return repeatDays.length >= 7 ? "Every day" : days.map((i) => DayStringMap[i]).join(", ");
  }

  Map<String, dynamic> toJson() => _$HabitNotificationToJson(this);
}