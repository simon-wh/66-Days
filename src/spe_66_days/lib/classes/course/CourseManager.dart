import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'CourseSettings.dart';
import 'CourseEntry.dart';
import 'package:flutter/services.dart' show rootBundle;


class CourseManager extends SettingsBase<CourseSettings> {

  List<CourseEntry> CourseWeeks = List<CourseEntry>();

  CourseManager() : super("course_manager.json", CourseSettings());

  bool initialised = false;

  Future<File> init() async{
    if (initialised)
      return Future(() {});
    initialised = true;

    return load().whenComplete(getCourseEntries);
  }


  void getCourseEntries() async {
    for(int i = 1; i <= 9; i++){
      String week = await rootBundle.loadString("assets/course/$i.json");
      CourseWeeks.add(CourseEntry.fromJson(json.decode(week)));
    }
  }

}