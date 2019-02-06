// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CourseEntry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseEntryChange _$CourseEntryChangeFromJson(Map<String, dynamic> json) {
  return CourseEntryChange(
      json['title'] as String,
      json['habitKey'] as String,
      json['habitVar'] as String,
      (json['items'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$CourseEntryChangeToJson(CourseEntryChange instance) =>
    <String, dynamic>{
      'title': instance.title,
      'habitKey': instance.habitKey,
      'habitVar': instance.habitVar,
      'items': instance.items
    };

CourseEntryText _$CourseEntryTextFromJson(Map<String, dynamic> json) {
  return CourseEntryText(json['text'] as String);
}

Map<String, dynamic> _$CourseEntryTextToJson(CourseEntryText instance) =>
    <String, dynamic>{'text': instance.text};
