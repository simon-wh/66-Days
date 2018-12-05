import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TimeConverter implements JsonConverter<Time, Map<String, dynamic>> {
  const TimeConverter();

  @override
  Time fromJson(Map<String, dynamic> json) =>
      json == null ? null : Time(json['hour'], json['minute']);

  @override
  Map<String, dynamic> toJson(Time object) => object.toMap();
}
