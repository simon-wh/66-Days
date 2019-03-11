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

class CourseManager extends SettingsBase<CourseSettings> {

  List<CourseEntry> courseWeeks;
  String courseWeeksError;

  CourseManager() : super("course_manager.json", CourseSettings());

  bool initialised = false;

  Future<void> init() async{
    if (initialised)
      return;
    initialised = true;
    await load();
    //await fetchCourseEntries();
  }

  Future<List<CourseEntry>> fetchCourseEntries({bool force = false}) async {
    courseWeeksError = null;
    if (courseWeeks != null && !force)
      return courseWeeks;
    //Use this if we want to always use fresh data when loading, if we have this uncommented it means that if no new data is able to be found (i.e. if no internet connection is avaialble, it can still use the existing loaded data)
    //courseWeeks = null;
    final response =
    await get('https://wt-a2f50f91fada7f05131c207a29276c24-0.sandbox.auth0-extend.com/spe-all-course-weeks');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return courseWeeks = (json.decode(response.body) as List)?.map((f) => CourseEntry.fromJsonSimplified(f)).toList();
    } else {
      // If that response was not OK, throw an error.
      courseWeeksError = 'Failed to load post: ${response.statusCode}';
      //return null;
    }
  }

  /*void getCourseEntries() async {
    for(int i = 1; i <= 9; i++){
      String week = await rootBundle.loadString("assets/course/$i.json");
      CourseWeeks.add(CourseEntry.fromJson(json.decode(week)));
    }
  }*/

}