import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'CourseSettings.dart';
import 'CourseEntry.dart';

class CourseManager extends SettingsBase<CourseSettings> {

  List<CourseEntry> CourseWeeks = <CourseEntry>[
    CourseEntry("Week Two\nEat Slowly and Savour Your Food", <CourseEntryItem>[
      CourseEntryText("Select an Experiment to Apply."),
      CourseEntryChange("Experiments", "eat_slowly", "experimentTitle", <String>[
        "put down your cutlery after each mouthful",
        "eat with your non-dominant hand",
        "set a chew goal per mouthful",
        "halve every mouthful before you eat it",
        "drink water between every mouthful",
        "use chopsticks"
      ]),
      CourseEntryChange("Environment Design", "eat_slowly", "environmentDesign", <String>[
        "eat your meals at a table. Never eat at your desk",
        "eat in a calm environment",
        "give yourself time to eat",
        "don’t eat in front of a screen",
        "eat with other people when possible",
        "don't eat out of a packet - plate up everything, even if it's just a snack",
        "try and relish what you're eating - be grateful and enjoy it!"
      ])
    ])
  ];

  CourseManager() : super("course_manager.json", CourseSettings());

  bool initialised = false;

  Future<File> init() async{
    if (initialised)
      return Future(() {});
    initialised = true;

    return load();
  }


}