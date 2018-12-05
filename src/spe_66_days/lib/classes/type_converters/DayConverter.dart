import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DayConverter implements JsonConverter<Day, String> {
  const DayConverter();

  @override
  Day fromJson(String json) =>
      json == null ? null : Day.values[int.parse(json)-1];

  @override
  String toJson(Day object) => object.value.toString();
}