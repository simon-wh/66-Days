import 'dart:async';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/course/CourseManager.dart';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'package:spe_66_days/classes/GlobalSettings.dart';
import 'dart:io';


class Global extends SettingsBase<GlobalSettings> {
  static DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static final Global instance = Global._internal();

  static final HabitManager habitManager = HabitManager();
  static final CourseManager courseManager = CourseManager();

  Global._internal() : super("main_settings.json", GlobalSettings());

  bool initialised = false;

  Future<File> init() async{
    if (initialised)
      return Future(() {});
    initialised = true;
    await habitManager.init();
    await courseManager.init();

    return load();
  }

  @override
  GlobalSettings getSettingsFromJson(Map<String, dynamic> json) => GlobalSettings.fromJson(json);
}