import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:collection/collection.dart';
import 'dart:convert';


part 'package:spe_66_days/classes/habits/CoreHabit.g.dart';

@JsonSerializable()
class CoreHabit {
  String key;

  //Maybe move this to be associated with the enum values
  String title;
  //String description;
  //bool unlocked;
  String experimentTitle;
  //String checkDescription;
  List<NotificationConfig> reminders;
  HashSet<DateTime> markedOff;

  CoreHabit(this.title, this.experimentTitle, {this.reminders, this.markedOff, this.key}){
    assert(this.title.isNotEmpty);
    assert(this.experimentTitle.isNotEmpty);
    //assert(this.checkDescription.isNotEmpty);
    reminders ??= List<NotificationConfig>();
    markedOff ??= HashSet<DateTime>();
  }

  factory CoreHabit.fromJson(Map<String, dynamic> json) => _$CoreHabitFromJson(json);

  Map<String, dynamic> toJson() => _$CoreHabitToJson(this);

  bool operator ==(o) => o is CoreHabit
      && o.key == this.key
      && o.title == this.title
      && o.experimentTitle == this.experimentTitle
      && ListEquality().equals(o.reminders, this.reminders)
      && SetEquality().equals(o.markedOff, this.markedOff);// o.markedOff.containsAll(this.markedOff) && o.markedOff.length == this.markedOff.length;

  int get hashCode => hash4(title, experimentTitle, reminders, markedOff);

  CoreHabit clone(){
    return CoreHabit.fromJson(json.decode(json.encode(this)));
  }

  void updateFrom(CoreHabit habit){
    this.title = habit.title;
    this.experimentTitle = habit.experimentTitle;
    this.reminders = habit.reminders;
    this.markedOff = habit.markedOff;
  }

  bool isCustom(){
    return this.key.startsWith(HabitManager.customHabitPrefix);
  }
}