// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitNotification _$HabitNotificationFromJson(Map<String, dynamic> json) {
  return HabitNotification(
      json['message'] as String,
      json['time'] == null
          ? null
          : const TimeConverter().fromJson(json['time'] as Map<String, dynamic>),
      HashSet<Day>.from((json['repeatDays'] as List)
          ?.map((e) =>
              e == null ? null : const DayConverter().fromJson(e as String))),
          //?.toSet(),
      json['enabled'] as bool);
}

Map<String, dynamic> _$HabitNotificationToJson(HabitNotification instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'time': instance.time == null
          ? null
          : const TimeConverter().toJson(instance.time),
      'repeatDays': instance.repeatDays
          ?.map((e) => e == null ? null : const DayConverter().toJson(e))
          ?.toList(),
      'message': instance.message
    };
