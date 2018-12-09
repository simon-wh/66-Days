
import 'package:flutter_test/flutter_test.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'dart:convert';

void main() {
  group("HabitManager JSON", () {
    test('encode/decode', () {
      expect(HabitManager.instance.getHabits(), equals(HabitManager.instance.getHabitsFromJson(HabitManager.instance.getJson())));
    });

    test('encode/decode', () {
      expect(HabitManager.instance.getJson(), equals(json.encode(HabitManager.instance.getHabitsFromJson(HabitManager.instance.getJson()))));
    });
  });
}