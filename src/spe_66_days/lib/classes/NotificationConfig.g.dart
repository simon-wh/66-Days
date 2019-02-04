// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationConfig _$NotificationFromJson(Map<String, dynamic> json) {
  return NotificationConfig(
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

Map<String, dynamic> _$NotificationToJson(NotificationConfig instance) {
    var days = instance.repeatDays.toList();
    days.sort((a,b) => a.value.compareTo(b.value));
    return <String, dynamic>{
      'enabled': instance.enabled,
      'time': instance.time == null
          ? null
          : const TimeConverter().toJson(instance.time),
      'repeatDays': days
          ?.map((e) => e == null ? null : const DayConverter().toJson(e))
          ?.toList(),
      'message': instance.message
    };
}
