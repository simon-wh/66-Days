// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoreHabit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreHabit _$CoreHabitFromJson(Map<String, dynamic> json) {
  return CoreHabit(json['title'] as String, json['experimentTitle'] as String,
      reminders: (json['reminders'] as List)
          ?.map((e) => e == null
              ? null
              : HabitNotification.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      markedOff: HashSet.from((json['markedOff'] as List)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))));
          //?.toSet());
}

Map<String, dynamic> _$CoreHabitToJson(CoreHabit instance) => <String, dynamic>{
      'title': instance.title,
      'experimentTitle': instance.experimentTitle,
      'reminders': instance.reminders,
      'markedOff':
          instance.markedOff?.map((e) => e?.toIso8601String())?.toList()
    };
