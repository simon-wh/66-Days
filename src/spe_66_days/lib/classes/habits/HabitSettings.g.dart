// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HabitSettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitSettings _$HabitSettingsFromJson(Map<String, dynamic> json) {
  return HabitSettings()
    ..habits = (json['habits'] as Map<String, dynamic>)?.map((k, e) => MapEntry(
        k, e == null ? null : CoreHabit.fromJson(e as Map<String, dynamic>)));
}

Map<String, dynamic> _$HabitSettingsToJson(HabitSettings instance) =>
    <String, dynamic>{'habits': instance.habits};
