// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CoreHabit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreHabit _$CoreHabitFromJson(Map<String, dynamic> json) {
  return CoreHabit(json['title'] as String, json['experimentTitle'] as String,
      environmentDesign: json['environmentDesign'] as String,
      reminders: (json['reminders'] as List)
          ?.map((e) => e == null
              ? null
              : NotificationConfig.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      markedOff: json['markedOff'] != null && json['markedOff'] is List ? HashSet.from((json['markedOff'] as List)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))): null);
          //?.toSet());
}

Map<String, dynamic> _$CoreHabitToJson(CoreHabit instance) {
    var markedOff = instance.markedOff?.map((e) => e?.toIso8601String())?.toList();
    markedOff.sort((a,b) => a.compareTo(b));
    return <String, dynamic>{
      'title': instance.title,
      'experimentTitle': instance.experimentTitle,
      'environmentDesign': instance.environmentDesign,
      'reminders': instance.reminders,
      'markedOff': markedOff
    };
}
