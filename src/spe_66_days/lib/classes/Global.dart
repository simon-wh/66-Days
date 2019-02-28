import 'dart:async';
import 'package:spe_66_days/classes/habits/HabitManager.dart';
import 'package:spe_66_days/classes/course/CourseManager.dart';
import 'package:spe_66_days/classes/SettingsBase.dart';
import 'package:spe_66_days/classes/GlobalSettings.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';




class Global extends SettingsBase<GlobalSettings> {
  static DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static final Global instance = Global._internal();

  static final HabitManager habitManager = HabitManager();
  static final CourseManager courseManager = CourseManager();

  static final FirebaseAuth auth = FirebaseAuth.instance;

  Global._internal() : super("main_settings.json", GlobalSettings());

  bool initialised = false;

  Future<File> init() async{
    if (initialised)
      return Future(() {});

    initialised = true;

    await habitManager.init();
    await courseManager.init();
    /*_handleSignIn()
        .then((FirebaseUser user) => print(user))
        .catchError((e) => print(e));*/

    return load();
  }

  /*Future<FirebaseUser> _handleSignIn() async {

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }*/

  @override
  GlobalSettings getSettingsFromJson(Map<String, dynamic> json) => GlobalSettings.fromJson(json);
}