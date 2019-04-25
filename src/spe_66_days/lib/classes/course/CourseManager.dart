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
import 'package:http/http.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:spe_66_days/classes/API.dart';

class CourseManager extends SettingsBase<CourseSettings> {

  List<CourseEntry> courseWeeks;

  CourseManager(String subDir) : super(subDir, "course_manager.json", CourseSettings());

  bool initialised = false;

  Future<void> init() async{
    if (initialised)
      return;
    initialised = true;
    await load();
    //await fetchCourseEntries();
  }

  Future<List<CourseEntry>> getCourseEntries({bool force = false}) async {
    if (courseWeeks != null && !force)
      return courseWeeks;
    //Use this if we want to always use fresh data when loading, if we have this uncommented it means that if no new data is able to be found (i.e. if no internet connection is avaialble, it can still use the existing loaded data)
    //courseWeeks = null;

    final result = await API.fetchCourseEntries();
    if (result.item2 != null)
      return courseWeeks = result.item2;
    else
      throw new Exception("Unable to load Course. Error ${result.item1}");
  }

  void dispose(){
    DefaultCacheManager().emptyCache();
  }
}