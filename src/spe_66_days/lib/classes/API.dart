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
import 'package:spe_66_days/classes/Global.dart';

class APIResponse{

}

abstract class API {
  static String baseURL = "129.213.90.30";
  static String apiURL = "mobile-api";

  static Future<File> _apiCall(String endpoint, {bool forceDownload, Map<String, String> header}) async {
    String url = Uri.http(baseURL, '/$apiURL/$endpoint').toString();
    File response;
    if (forceDownload)
      response = (await DefaultCacheManager().downloadFile(url, authHeaders: header))?.file;
    else
      response = await DefaultCacheManager().getSingleFile(url, headers: header);

    return response;
  }

  static Future<List<CourseEntry>> fetchCourseEntries({bool force = false}) async {
    //Use this if we want to always use fresh data when loading, if we have this uncommented it means that if no new data is able to be found (i.e. if no internet connection is avaialble, it can still use the existing loaded data)
    //courseWeeks = null;
    var user = await Global.auth.currentUser();

    final response = await _apiCall('get-course-content', forceDownload: force, header: <String, String>{ "ID-TOKEN": await user.getIdToken()});

    if (response != null) {
      // If server returns an OK response, parse the JSON
      final contents = await response.readAsString();
      return (json.decode(contents) as List).map((f) => CourseEntry.fromJsonSimplified(f)).toList();
    } else {
      return null;
    }
  }
}