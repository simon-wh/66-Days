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

  group("HabitManager habits", () {
    test('Contains habits', () {
      expect(HabitManager.instance.getHabits(), isNotNull);
    });
  });


  group("CoreHabits", () {
    group("Equality", () {
      group('Required parameters', () {
        test('Matching CoreHabit pair', () {
          CoreHabit c1 = CoreHabit("Eating slowly", "Chew each mouthful five times");
          CoreHabit c2 = CoreHabit("Eating slowly", "Chew each mouthful five times");
          expect(c1 == c2, equals(true));
        });
        group('Notifcaitons', () {
          group('Single nofiication', () {
            test('Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching enabled reminder', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              expect(c1 == c2, equals(true));
            });
            test('Irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Tuesday, Day.Friday, Day.Monday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              expect(c1 == c2, equals(true));
            });
          });
          group('Multiple notifications', () {
            test('Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching enabaled reminders', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              expect(c1 == c2, equals(true));
            });
            test('Irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Wednesday, Day.Sunday, Day.Monday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Thursday, Day.Monday, Day.Friday, Day.Wednesday, Day.Tuesday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Thursday, Day.Monday, Day.Friday, Day.Tuesday, Day.Wednesday, Day.Sunday, Day.Saturday]), true)]);
              expect(c1 == c2, equals(true));
            });
          });
        });
      });
    });
    group("Inequality", () {
      group('Required parameters', () {
        test('Non-Matching CoreHabit pair', () {
          CoreHabit c1 = CoreHabit("Eating slowly", "Chew each mouthful five times");
          CoreHabit c2 = CoreHabit("Eat slow", "Chew each mouthful five times");
          expect(c1 != c2, equals(true));
        });
        group('Notifcaitons', () {
          group('Single nofiication', () {
            test('Non-Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Time", "Times", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(16, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Time", "Times", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Day", "Days", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Day", "Days", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Wednesday, Day.Sunday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching enabled reminder', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Non-matching irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Tuesday, Day.Friday, Day.Monday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <HabitNotification>[HabitNotification("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Friday, Day.Tuesday, Day.Sunday]), true)]);
              expect(c1 != c2, equals(true));
            });
          });
          group('Multiple notifications', () {
            test('Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(10, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(13, 0), HashSet.from(<Day>[]), false),
                HabitNotification("Perform your end of day summary!", Time(19, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Sunday]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching enabaled reminders', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              expect(c1 != c2, equals(true));
            });
            test('Non-Matching irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <HabitNotification>[
                HabitNotification("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Wednesday, Day.Monday]), true),
                HabitNotification("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Thursday, Day.Wednesday, Day.Tuesday]), false),
                HabitNotification("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Tuesday, Day.Wednesday, Day.Sunday, Day.Saturday]), true)]);
              expect(c1 != c2, equals(true));
            });
          });
        });
      });
    });
  });
}