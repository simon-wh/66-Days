// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spe_66_days/widgets/progress/ProgressChart.dart';
import 'package:spe_66_days/widgets/progress/StreaksChart.dart';
import 'package:spe_66_days/widgets/course/CourseScreen.dart';
import 'package:spe_66_days/widgets/habits/HabitListWidget.dart';
import 'package:spe_66_days/classes/habits/CoreHabit.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/classes/NotificationConfig.dart';
import 'dart:collection';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:spe_66_days/main.dart';

void main() async {
  await Global.instance.init(test: true);
  Global.habitManager.addHabit('observation', CoreHabit("Eating Observation", "Taken a photo of my meal", reminders: <NotificationConfig>[ NotificationConfig("Take a photo of your meal!", Time(14, 0), HashSet.from(<Day>[Day.Monday, Day.Tuesday, Day.Friday]), true) ]));
  Global.habitManager.addHabit("eat_slowly", CoreHabit("Eat Slowly", "Put down your cutlery after each mouthful"));
  testWidgets('Initialisation is correct', (WidgetTester tester) async {
    //Build app
    await tester.pumpWidget(new StartApp(signIn: false));

    await tester.pump(Duration(seconds: 3));

    // Verify that navigation screen is correctly set up
    expect(find.text('66  DAYS'), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(3));
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.library_books), findsOneWidget);
  });

  testWidgets('Test Navigation to course is  correct', (WidgetTester tester) async{
    await tester.pumpWidget(new StartApp(signIn: false));
    await tester.tap(find.byIcon(Icons.library_books));
    await tester.pump(new Duration(seconds: 1));

    expect(find.byType(CourseScreen), findsWidgets);
  });

  testWidgets('Test return to home is  correct', (WidgetTester tester) async{
    await tester.pumpWidget(new StartApp(signIn: false));
    await tester.tap(find.byIcon(Icons.library_books));
    await tester.pump(new Duration(seconds: 1));
    await tester.tap(find.byIcon(Icons.home));
    await tester.pump(new Duration(seconds: 1));

    expect(find.byType(Card), findsNWidgets(3));
  });

  testWidgets('Test habit checked updates', (WidgetTester tester) async{
    //Global.habitManager.newCustomHabit();
    await tester.pumpWidget(new StartApp(signIn: false));
    Finder habitFind = find.byType(HabitListWidget);
    Finder ck = find.byType(Checkbox);
    HabitListWidget habitWidget = tester.firstElement(habitFind).widget;
    CoreHabit habit = Global.habitManager.getHabit(habitWidget.habitKey);
    expect(habit.markedOff, isNot(contains(Global.currentDate)));
    await tester.tap(find.descendant(of: habitFind, matching: ck).first);
    expect(habit.markedOff, contains(Global.currentDate));
  });

  testWidgets('Test Course unlock is correct', (WidgetTester tester) async{
    await tester.pumpWidget(new StartApp(signIn: false));
    await tester.tap(find.byIcon(Icons.library_books));
    await tester.pump(new Duration(seconds: 1));

    expect(find.byType(CourseScreen), findsOneWidget);

  });
}
