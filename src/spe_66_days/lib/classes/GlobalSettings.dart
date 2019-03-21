import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'package:quiver/core.dart';


part 'GlobalSettings.g.dart';


@JsonSerializable()
class GlobalSettings{
  NotificationConfig dailyNotification;

  GlobalSettings({bool setDefaults = true}){
    if (setDefaults)
      this.setDefaults();
  }

  bool operator ==(o) => o is GlobalSettings
      && this.dailyNotification == o.dailyNotification;

  int get hashCode => dailyNotification.hashCode;

  factory GlobalSettings.fromJson(Map<String, dynamic> json) => _$GlobalSettingsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GlobalSettingsToJson(this);

  void setDefaults(){
    dailyNotification = dailyNotification ?? NotificationConfig("Time to check off your habits!", Time(22, 0), HashSet.from(Day.values), true);
  }
}