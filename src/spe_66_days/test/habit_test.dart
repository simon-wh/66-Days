
import 'package:flutter_test/flutter_test.dart';
import 'package:spe_66_days/classes/HabitManager.dart';
import 'package:spe_66_days/classes/CoreHabit.dart';
import 'package:spe_66_days/classes/HabitNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:collection';
import 'dart:convert';

void main() {
  group("HabitManager JSON", () {
    test('Encode/Decode', () {
      expect(HabitManager.instance.getHabits(), equals(
          HabitManager.instance.getHabitsFromJson(
              HabitManager.instance.getJson())));
    });

    test('Encode/Decode', () {
      expect(HabitManager.instance.getJson(), equals(json.encode(
          HabitManager.instance.getHabitsFromJson(
              HabitManager.instance.getJson()))));
    });
  });

  group("CoreHabits", () {
    group("Equality", () {
      test('Matching pair', () {
        CoreHabit c1 = CoreHabit("Eating slowly", "Chew each mouthful 5 times");
        CoreHabit c2 = CoreHabit("Eating slowly", "Chew each mouthful 5 times");
        expect(c1 == c2, equals(true));
      });
      test ('Matching reminders', (){
        CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[ HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), false) ]);
        CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[ HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), false) ]);
        expect(c1 == c2, equals(true));
      });
      test('Matching marked off', (){
        CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[ HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]);
        CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[ HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]);
        expect(c1 == c2, equals(true));
      });
    });
  });

}