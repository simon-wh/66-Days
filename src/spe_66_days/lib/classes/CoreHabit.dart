import 'Notification.dart';
import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';

part 'CoreHabit.g.dart';

@JsonSerializable()
class CoreHabit {
  //Maybe move this to be associated with the enum values
  String title;
  //String description;
  //bool unlocked;
  String experimentTitle;
  //String checkDescription;
  List<HabitNotification> reminders;
  HashSet<DateTime> markedOff;

  CoreHabit(this.title, this.experimentTitle, {this.reminders, this.markedOff}){
    assert(this.title.isNotEmpty);
    assert(this.experimentTitle.isNotEmpty);
    //assert(this.checkDescription.isNotEmpty);
    reminders ??= List<HabitNotification>();
    markedOff ??= HashSet<DateTime>();
  }

  factory CoreHabit.fromJson(Map<String, dynamic> json) => _$CoreHabitFromJson(json);

  Map<String, dynamic> toJson() => _$CoreHabitToJson(this);

}