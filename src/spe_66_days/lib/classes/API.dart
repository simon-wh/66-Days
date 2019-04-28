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
import 'package:tuple/tuple.dart';

class UnauthorizedException implements Exception {
  UnauthorizedException();
}

abstract class API {
  static Client client = Client();
  static String baseURL = "129.213.90.30";
  static String apiURL = "mobile-api";

  static Uri getEndpointURI(String endpoint){
    return Uri.http(baseURL, '/$apiURL/$endpoint');
  }

  static Future<Response> _apiGET(String endpoint, {bool forceDownload, Map<String, String> header}) async {
    String url = getEndpointURI(endpoint).toString();

    return await client.get(url, headers: header);
  }

  static Future<Map<String,String>> getAuthHeaders() async {
    return <String, String>{ "ID-TOKEN": await (await Global.auth.currentUser()).getIdToken()};
  }

  static Future<Tuple2<int, List<CourseEntry>>> fetchCourseEntries() async {
    if ((await Global.auth.currentUser()).isAnonymous)
      return Tuple2(HttpStatus.unauthorized, null);

    //Use this if we want to always use fresh data when loading, if we have this uncommented it means that if no new data is able to be found (i.e. if no internet connection is avaialble, it can still use the existing loaded data)
    //courseWeeks = null;

    final response = await _apiGET('get-course-content', header: await getAuthHeaders());

    if (response.statusCode == HttpStatus.ok) {
      // If server returns an OK response, parse the JSON
      final contents = response.body;
      return Tuple2(response.statusCode, (json.decode(contents) as List).map((f) => CourseEntry.fromJsonSimplified(f)).toList());
    } else {
      return Tuple2(response.statusCode, null);
    }
  }

  static Future<int> pushUserStats(String json) async {
    var uri = getEndpointURI("update-stats");
    //print(json);
    Response response = await client.post(uri, headers: await getAuthHeaders(), body: json);
    //print(response.body.toString());
    return response.statusCode;
  }
}