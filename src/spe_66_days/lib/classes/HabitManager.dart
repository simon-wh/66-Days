import 'CoreHabit.dart';

class HabitManager {
  static final HabitManager instance = HabitManager();

  Map<String, CoreHabit> habits = <String, CoreHabit> {
    "observation": CoreHabit("Eating Observation", "Taken a photo of my meal", ),
    "eat_slowly": CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful ")
  };

  CoreHabit getHabit (String core){
    assert(habits.containsKey(core));
    if (!habits.containsKey(core))
      return null;
    return habits[core];
  }

  void save(){}

  void load(){}
}