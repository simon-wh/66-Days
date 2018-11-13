import 'CoreHabit.dart';


enum CoreHabits {DrinkWater, EatSlowly, EatWhole, PortionControl}

class HabitManager {
  Map<CoreHabits, CoreHabit> _habits;

  CoreHabit getHabit (CoreHabits core){
    assert(_habits.containsKey(core));
    if (!_habits.containsKey(core))
      return null;
    return _habits[core];
  }

  void save(){}

  void load(){}
}