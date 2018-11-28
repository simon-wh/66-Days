import 'CoreHabit.dart';

class HabitManager {
  static final HabitManager instance = HabitManager();

  Map<String, CoreHabit> _habits = <String, CoreHabit> {
    "observation": CoreHabit("Eating Observation", "Taken a photo of my meal", ),
    "eat_slowly": CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful ")
  };

  CoreHabit getHabit (String core){
    assert(_habits.containsKey(core));
    if (!_habits.containsKey(core))
      return null;
    return _habits[core];
  }

  Map<String, CoreHabit> getHabits (){ return Map.unmodifiable(_habits);}

  void save(){}

  void load(){}
}