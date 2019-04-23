import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:collection/collection.dart';

part 'CourseEntry.g.dart';




abstract class CourseEntryItem{

}

@JsonSerializable()
class CourseEntryChange extends CourseEntryItem{

  final String title;
  final String habitKey;
  final String habitVar;
  final List<String> items;
  final CoreHabit defaultHabit;

  CourseEntryChange(this.title, this.habitKey, this.habitVar, this.items, {this.defaultHabit});

  bool operator ==(o) => o is CourseEntryChange
      && o.title == this.title
      && o.habitKey == this.habitKey
      && o.habitVar == this.habitVar
      && o.defaultHabit == this.defaultHabit
      && ListEquality().equals(o.items, this.items);

  factory CourseEntryChange.fromJson(Map<String, dynamic> json) => _$CourseEntryChangeFromJson(json);

  Map<String, dynamic> toJson() => _$CourseEntryChangeToJson(this);
}

//TODO: CourseEntryText with hyperlink and title

@JsonSerializable()
class CourseEntryText extends CourseEntryItem {
  final String text;

  CourseEntryText(this.text);

  bool operator ==(o) => o is CourseEntryText
      && o.text == this.text;

  factory CourseEntryText.fromJson(Map<String, dynamic> json) => _$CourseEntryTextFromJson(json);

  Map<String, dynamic> toJson() => _$CourseEntryTextToJson(this);
}

/*@JsonSerializable()
class CourseEntryUpdate extends CourseEntryItem {
  final String text;
  final String habitKey;
  final String habitVar;

  CourseEntryUpdate(this.text, this.habitKey, this.habitVar);

  factory CourseEntryUpdate.fromJson(Map<String, dynamic> json) => _$CourseEntryUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$CourseEntryUpdateToJson(this);
}*/


//@JsonSerializable()
class CourseEntry
{
  final int weekNo;

  final String title;

  final List<CourseEntryItem> items;

  CourseEntry(this.title, this.items, {this.weekNo});

  bool operator ==(o) => o is CourseEntry
      && o.title == this.title
      && ListEquality().equals(o.items, this.items);

  factory CourseEntry.fromJson(Map<String, dynamic> json) => CourseEntry(
        json['title'] as String,
        (json['items'] as List)?.map((e) {
          if (e is String)
            return CourseEntryText(e);
          else {
            Map<String, dynamic> map = e as Map<String, dynamic>;
            if (map?.containsKey("text") ?? false)
              return CourseEntryText.fromJson(map);
            else if (map?.containsKey("habitKey") ?? false)
              return CourseEntryChange.fromJson(map);
          }
          return null;

        })?.toList());

  factory CourseEntry.fromJsonSimplified(Map<String, dynamic> json) => CourseEntry(
      json['weekTitle'] as String,
      <CourseEntryItem>[
        CourseEntryText(json['weekDescription'] as String),
        CourseEntryChange("Experiments", json['habitKey'] as String, "experimentTitle", (json['habitExperimentsList'] as List)?.map((e) => e as String)?.toList(), defaultHabit: CoreHabit(json['habitTitle'] as String, "")),
        CourseEntryChange("Environment Design", json['habitKey'] as String, "environmentDesign", (json['environmentDesignList'] as List)?.map((e) => e as String)?.where((s) => s.isNotEmpty)?.toList(), defaultHabit: CoreHabit(json['habitTitle'] as String, "")),
      ].where((s) => s is CourseEntryText || (s is CourseEntryChange && s.items.length>0)).toList(),
      weekNo: json['weekNumber'] as int);

  //Map<String, dynamic> toJson() => _$CourseEntryToJson(this);
}