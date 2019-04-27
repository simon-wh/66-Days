import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spe_66_days/classes/habits/HabitSettings.dart';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spe_66_days/classes/API.dart';
import 'package:collection/collection.dart';
import 'package:mockito/mockito.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}
class FirebaseUserMock extends Mock implements FirebaseUser {}



void main() async {
  Global.auth = FirebaseAuthMock();
  var user = FirebaseUserMock();
  when(Global.auth.currentUser()).thenAnswer((_) => Future<FirebaseUserMock>.value(user));
  when(user.getIdToken()).thenAnswer((_) => Future<String>.value("token"));
  when(user.isAnonymous).thenAnswer((_) => false);

  await Global.instance.init(test: true);
  var habitManager = Global.habitManager;
  var resourcePath = "../test_resources/";

  API.client = MockClient((request) async {
    String url = request.url.toString();
    if (url.endsWith("update-statistics")){
      return Response("success", 200);
    }
    else if (url.endsWith("get-course-content")){
      String text = new File(resourcePath + 'CourseAPI.json').readAsStringSync();
      return Response(text, 200);
    }
    else
      return Response("Unauthorised access", 401);

  });




  group("Course content", () {
    test('Gets course content', () async {
      final item = await API.fetchCourseEntries();
      expect(item, isNotNull);
    });

    test('Unlocks course correctly', () async {
      final data = await API.fetchCourseEntries();
      List<CourseEntry> entries = data.item2;
      DateTime earliestDate = Global.currentDate.add(Duration(days: - 14));
      expect(
          Global.currentDate.isAfter(earliestDate.add(
              Duration(days: (7 * (entries.where((entry) => entry.weekNo == 2).toList().first.weekNo - 1)),
                  milliseconds: -1))), isTrue);
      expect(
          Global.currentDate.isAfter(earliestDate.add(
              Duration(days: (7 * (entries.where((entry) => entry.weekNo == 3).toList().first.weekNo - 1)),
                  milliseconds: -1))), isTrue);
      for(int i = 4; i < 11; i++){
        expect(
            Global.currentDate.isAfter(earliestDate.add(
                Duration(days: (7 * (entries.where((entry) => entry.weekNo == i).toList().first.weekNo - 1)),
                    milliseconds: -1))), isFalse);
      }
    });

    test('Unathourised access', () async {
      final url = API.getEndpointURI("fail").toString();
      final response = await API.client.get(url);

      expect(response.statusCode, equals(401));
      expect(response.body, equals("Unauthorised access"));
    });

  });


  group("HabitManager JSON", () {
    test('Encode/Decode 1', () {
      HabitSettings settings1 = habitManager.settings;
      HabitSettings settings2 = habitManager.getSettingsFromJson(
          json.decode(habitManager.getJson()));
      expect(settings1.habits, equals(
          settings2.habits));
    });

    test('Encode/Decode 2', () {
      expect(habitManager.getJson(), equals(json.encode(
          habitManager.getSettingsFromJson(
              json.decode(habitManager.getJson())))));
    });
  });



  group("HabitManager Stats JSON", () {
    var testData = (settings, data){

      expect(data, hasLength(settings.habits.length));
      expect(data.every((elem) {
        CoreHabit habit = settings.habits[elem['habitKey']];
        List<int> check = (elem['daysChecked'] as List<dynamic>).cast();
        return habit != null
            && DateTime.parse(elem['dateStarted'] as String).isAtSameMomentAs(habit.startDate)
            && check.length == 10
            && check.every((e) => e == 1 || e == 0)
            && ListEquality().equals(List.generate(10, (i) => i % 2 == 0 ? 1 : 0), check);
      }), isTrue);
    };

    test('Encode', () {
      HabitSettings settings = HabitSettings();
      settings.habits.forEach((s, habit) {
        habit.startDate = Global.currentDate.add(Duration(days:-10));
        habit.markedOff.addAll(List.generate(5, (i)=> habit.startDate.add(Duration(days:i*2))));
      });
      List<Map<String, dynamic>> data = settings.toStatsJson();
      testData(settings, data);
      data = (json.decode(json.encode(data))as List<dynamic>).cast();
      testData(settings, data);

    });
  });

  group("HabitManager habits", () {
    test('Test init', () {
      //habitManager.init();
      expect(habitManager.getHabits().values.where((s) => s.startDate == Global.currentDate), equals(habitManager.getHabits().values));
    });

    test('Contains habits', () {
      expect(habitManager.getHabits(), isNotNull);
    });

    test('New Custom Habit', () {
      int len = habitManager.getHabits().length;
      CoreHabit habit = habitManager.newCustomHabit();
      expect(habit.startDate, equals(Global.currentDate));
      expect(habit.title, isNotEmpty);
      expect(habit.key, isNotEmpty);
      expect(habit.isCustom(), isTrue);
      
      var habits = habitManager.getHabits();
      expect(habits.containsKey(habit.key), isTrue);
      expect(habits.containsValue(habit), isTrue);
      expect(habits.length, equals(len + 1));
    });

    CoreHabit habit = CoreHabit("Test Title", "Test desc");
    test('Add Habit', () {
      String key = "test";
      int len = habitManager.getHabits().length;

      habitManager.addHabit(key, habit);
      var habits = habitManager.getHabits();
      expect(habits.containsKey(key), isTrue);
      //expect(habits.containsValue(habit..key = key), isTrue);
      expect(habitManager.getHabit(key).title, equals(habit.title));
      expect(habitManager.getHabit(key).experimentTitle, equals(habit.experimentTitle));
      expect(habitManager.getHabit(key).startDate, equals(Global.currentDate));
      expect(habitManager.getHabit(key).key, equals(key));
      expect(habitManager.getHabit(key).markedOff, isEmpty);
      expect(habitManager.getHabit(key).reminders, isEmpty);
      expect(habitManager.getHabit(key).environmentDesign, isEmpty);
      expect(habits.length, equals(len + 1));
    });

    test('Add Habit Already Exists', () {
      String key = "test1";
      //if (!habitManager.hasHabit(key))
      habitManager.addHabit(key, habit);

      int len = habitManager.getHabits().length;
      expect(() => habitManager.addHabit(key, habit), throws);
      var habits = habitManager.getHabits();
      expect(habits.containsKey(key), isTrue);
      expect(habits.length, equals(len));
    });

    test('Has Habit', () {
      String key = "test2";
      expect(habitManager.hasHabit(key), isFalse);
      //if (!habitManager.hasHabit(key))
      habitManager.addHabit(key, habit);
      expect(habitManager.hasHabit(key), isTrue);
    });

    test('Get Habit Exists', () {
      String key = "test-get-habit";
      habitManager.addHabit(key, habit);
      expect(habitManager.getHabit(key), isNotNull);
    });

    test('Get Habit Doesn\'t exist', () {
      String key = "test-get-habit-doesnt-exist";
      expect(habitManager.getHabit(key), isNull);
    });

    test('Remove Habit Normal', () {
      String key = "test3";

      expect(habitManager.removeHabit(key), isFalse);

      habitManager.addHabit(key, habit);

      expect(habitManager.removeHabit(key), isFalse);
    });

    test('Remove Habit Custom', () {
      var habit = habitManager.newCustomHabit();

      expect(habitManager.removeHabit(habit.key), isTrue);
      expect(habitManager.removeHabit(habit.key), isFalse);
    });
    group("Set Check Habit", (){
      test('No Habit', () {
        var key = "set-check-habit-no-habit";

        expect(habitManager.setCheckHabit(key, true), isFalse);
      });

      test('Check habit - CurrentDate', () {
        var habit = habitManager.newCustomHabit();
        var key = habit.key;

        expect(habitManager.setCheckHabit(key, true), isTrue);
        expect(habit.markedOff, contains(Global.currentDate));
        expect(habitManager.setCheckHabit(key, false), isTrue);
        expect(habit.markedOff, isNot(contains(Global.currentDate)));
      });

      test('Check habit - Already Set - CurrentDate', () {
        var habit = habitManager.newCustomHabit();
        var key = habit.key;

        expect(habit.markedOff, isNot(contains(Global.currentDate)));
        expect(habitManager.setCheckHabit(key, false), isFalse);
        expect(habit.markedOff, isNot(contains(Global.currentDate)));
      });

      DateTime date = DateTime(2018, 12, 25);
      test('Check habit - Fixed Date', () {
        var habit = habitManager.newCustomHabit();
        var key = habit.key;

        expect(habitManager.setCheckHabit(key, true, date: date), isTrue);
        expect(habit.markedOff, contains(date));
        expect(habitManager.setCheckHabit(key, false, date: date), isTrue);
        expect(habit.markedOff, isNot(contains(date)));
      });

      test('Check habit - Already Set - Fixed Date', () {
        var habit = habitManager.newCustomHabit();
        var key = habit.key;

        expect(habit.markedOff, isNot(contains(date)));
        expect(habitManager.setCheckHabit(key, false, date: date), isFalse);
        expect(habit.markedOff, isNot(contains(date)));
      });
    });
  });


  group("CoreHabits", () {
    group("Clone", (){
      String key = "test";
      test('Clone', () {
        CoreHabit habit = CoreHabit("Test Title", "Test desc");
        CoreHabit clone = habit.clone();
        expect(clone, equals(habit));
        clone.key = key;
        expect(clone, isNot(equals(habit)));
      });

      test('Clone Custom', () {
        CoreHabit habit = habitManager.newCustomHabit();
        CoreHabit clone = habit.clone();
        expect(clone, equals(habit));
        clone.key = key;
        expect(clone, isNot(equals(habit)));
      });
    });

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
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching enabled reminder', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              expect(c1 == c2, equals(true));
            });
            test('Irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Tuesday, Day.Friday, Day.Monday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              expect(c1 == c2, equals(true));
            });
          });
          group('Multiple notifications', () {
            test('Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              expect(c1 == c2, equals(true));
            });
            test('Matching enabaled reminders', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              expect(c1 == c2, equals(true));
            });
            test('Irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Wednesday, Day.Sunday, Day.Monday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Thursday, Day.Monday, Day.Friday, Day.Wednesday, Day.Tuesday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Thursday, Day.Monday, Day.Friday, Day.Tuesday, Day.Wednesday, Day.Sunday, Day.Saturday]), true)]);
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
              CoreHabit c1 = CoreHabit("Time", "Times", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(16, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Time", "Times", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Day", "Days", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Day", "Days", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Wednesday, Day.Sunday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching enabled reminder', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Non-matching irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Tuesday, Day.Friday, Day.Monday]), true)]);
              CoreHabit c2 = CoreHabit("Enable", "Enabled", reminders: <NotificationConfig>[NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Friday, Day.Tuesday, Day.Sunday]), true)]);
              expect(c1 != c2, equals(true));
            });
          });
          group('Multiple notifications', () {
            test('Matching reminder times', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(10, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(13, 0), HashSet.from(<Day>[]), false),
                NotificationConfig("Perform your end of day summary!", Time(19, 0), HashSet.from(<Day>[]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching reminder days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Sunday]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Friday, Day.Saturday, Day.Sunday]), false)]);
              expect(c1 != c2, equals(true));
            });
            test('Matching enabaled reminders', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), false),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              expect(c1 != c2, equals(true));
            });
            test('Non-Matching irrelevant ordering of notification days', () {
              CoreHabit c1 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Monday, Day.Wednesday, Day.Sunday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday]), true)]);
              CoreHabit c2 = CoreHabit("Remind", "Reminder", reminders: <NotificationConfig>[
                NotificationConfig("Take a photo of your meal!", Time(08, 0), HashSet.from(<Day>[Day.Wednesday, Day.Monday]), true),
                NotificationConfig("Be mindful of your experiments eating lunch today!", Time(12, 0), HashSet.from(<Day>[Day.Thursday, Day.Wednesday, Day.Tuesday]), false),
                NotificationConfig("Perform your end of day summary!", Time(20, 0), HashSet.from(<Day>[Day.Tuesday, Day.Wednesday, Day.Sunday, Day.Saturday]), true)]);
              expect(c1 != c2, equals(true));
            });
          });
        });
      });
    });
  });
}