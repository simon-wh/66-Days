import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:quiver/core.dart';
import 'package:spe_66_days/classes/Global.dart';

part 'package:spe_66_days/classes/habits/HabitSettings.g.dart';


@JsonSerializable()
class HabitSettings{
  Map<String, CoreHabit> habits;

  HabitSettings({bool setDefaults = true}){
    if (setDefaults)
      this.setDefaults();
  }

  bool operator ==(o) => o is HabitSettings
      && MapEquality().equals(o.habits, this.habits);

  int get hashCode => habits.hashCode;

  factory HabitSettings.fromJson(Map<String, dynamic> json) => _$HabitSettingsFromJson(json)..habits.forEach((s,v) {
    v.key = s;
    var dates = (v.markedOff.toList()..sort());
    v.startDate = v.startDate ?? (dates.length > 0 ? dates.first : null);
  });

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$HabitSettingsToJson(this);
  
  void setDefaults(){
    habits = habits ?? <String, CoreHabit> {
      "observation": CoreHabit("Eating Observation", "Taken a photo of my meal", reminders: <NotificationConfig>[ NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]),
      "eat_slowly": CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful ")
    }..forEach((s, v) => v..key = s..startDate=Global.currentDate);
  }
}