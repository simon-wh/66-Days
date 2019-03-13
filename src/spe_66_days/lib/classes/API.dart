import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'course/CourseSettings.dart';
import 'course/CourseEntry.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class APIResponse{

}

abstract class API {
  static String baseURL = "wt-a2f50f91fada7f05131c207a29276c24-0.sandbox.auth0-extend.com";
  static String apiURL = "";

  static Future<File> _apiCall(String endpoint, {bool forceDownload, Map<String, String> args}) async {
    String url = Uri.https(baseURL, '$apiURL$endpoint', args).toString();
    File response;

    if (forceDownload)
      response = (await DefaultCacheManager().downloadFile(url))?.file;
    else
      response = await DefaultCacheManager().getSingleFile(url);

    return response;
  }

  static Future<List<CourseEntry>> fetchCourseEntries({bool force = false}) async {
    //Use this if we want to always use fresh data when loading, if we have this uncommented it means that if no new data is able to be found (i.e. if no internet connection is avaialble, it can still use the existing loaded data)
    //courseWeeks = null;
    final response = await _apiCall('spe-all-course-weeks', forceDownload: force);

    if (response != null) {
      // If server returns an OK response, parse the JSON
      final contents = await response.readAsString();
      return (json.decode(contents) as List).map((f) => CourseEntry.fromJsonSimplified(f)).toList();
    } else {
      return null;
    }
  }
}