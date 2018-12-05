import 'CoreHabit.dart';
import 'Notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';

class HabitManager {
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
  
  void save(){
    String output = json.encode(_habits);
    print("pre:" + output);
    print("post:" + json.encode(getHabitsFromJson(output)));
  }

  void load(){}
}