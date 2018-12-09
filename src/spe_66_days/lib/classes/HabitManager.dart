import 'CoreHabit.dart';
import 'HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HabitManager {
  static const String saveFileName = "habit_manager.json";
  static final HabitManager instance = HabitManager();

  Map<String, CoreHabit> _habits = <String, CoreHabit> {
    "observation": CoreHabit("Eating Observation", "Taken a photo of my meal", reminders: <HabitNotification>[ HabitNotification("Surprise", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]),
    "eat_slowly": CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful ")
  };

  CoreHabit getHabit (String core){
    assert(_habits.containsKey(core));
    if (!_habits.containsKey(core))
      return null;
    return _habits[core];
  }

  Map<String, CoreHabit> getHabits (){ return Map.unmodifiable(_habits);}
  
  String getJson(){
    return json.encode(_habits);
  }
  
  Map<String, CoreHabit> getHabitsFromJson(String data){
    Map habitMap = json.decode(data);
    Map<String, CoreHabit> habits = habitMap.map((k, v) => MapEntry<String, CoreHabit>(k.toString(), CoreHabit.fromJson(v)));
    return habits;
  }

  Future<File> save() async {
    print("Saving Habits...");
    final file = await _localFile;
    String output = json.encode(_habits);
    return file.writeAsString(output);
  }

  void load() async {
    try {
      print("Loading Habits...");
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      final habits = getHabitsFromJson(contents);
      this._habits = habits;

    } catch (e) {
      // If we encounter an error, return 0

    }
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$saveFileName');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}