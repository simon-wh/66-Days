import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'CourseSettings.g.dart';

@JsonSerializable()
class CourseSettings{
  int week;

  CourseSettings({bool setDefaults = true}){
    if (setDefaults)
      this.setDefaults();
  }

  bool operator ==(o) => o is CourseSettings
      && o.week == this.week;

  int get hashCode => this.week.hashCode;

  factory CourseSettings.fromJson(Map<String, dynamic> json) => _$CourseSettingsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CourseSettingsToJson(this);

  void setDefaults(){
    this.week = 0;
  }
}