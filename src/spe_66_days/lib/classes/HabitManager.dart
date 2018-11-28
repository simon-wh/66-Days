import 'CoreHabit.dart';

class HabitManager {
  Map<String, CoreHabit> _habits;

  CoreHabit getHabit (String core){
    assert(_habits.containsKey(core));
    if (!_habits.containsKey(core))
      return null;
    return _habits[core];
  }

  void save(){}

  void load(){}
}