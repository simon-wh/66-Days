
import 'package:flutter_test/flutter_test.dart';
import 'package:spe_66_days/classes/HabitManager.dart';

void main() {
  test('JSON encode/decode', () {
    expect(HabitManager.instance.getHabits(), equals(HabitManager.instance.getHabitsFromJson(HabitManager.instance.getJson())));
  });
}