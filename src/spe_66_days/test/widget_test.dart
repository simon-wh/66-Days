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

import 'package:spe_66_days/main.dart';

void main() {
  testWidgets('Initialisation is correct', (WidgetTester tester) async {
    //Build app
    await tester.pumpWidget(new StartApp(signIn: false));

    // Verify that navigation screen is correctly set up
    expect(find.text('66  DAYS'), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(3));
    expect(find.byIcon(Icons.home), findsOneWidget);
    /*expect(find.byIcon(Icons.assignment), findsOneWidget);
    expect(find.byIcon(Icons.timeline), findsOneWidget);*/
    expect(find.byIcon(Icons.library_books), findsOneWidget);
  });

  /*testWidgets('Test Navigation to progress is  correct', (WidgetTester tester) async{
    Global.auth.signInAnonymously();
    await tester.pumpWidget(new StartApp(signIn: false));
    await tester.tap(find.byIcon(Icons.timeline));
    await tester.pump(new Duration(seconds: 1));

    expect(find.byType(ProgressChart), findsOneWidget);
    expect(find.byType(StreaksChart), findsOneWidget);
    expect(find.text("Perfect Days", skipOffstage: false), findsOneWidget);
    expect(find.text("Total Habits Done", skipOffstage: false), findsOneWidget);
    expect(find.text("Current Streak", skipOffstage: false), findsOneWidget);
    expect(find.text("Best Streak", skipOffstage: false), findsOneWidget);
    expect(find.text("Habit Daily Average", skipOffstage: false), findsOneWidget);
    expect(find.text("Habits Checked Today", skipOffstage: false), findsOneWidget);
  });

  testWidgets('Test Navigation to habits is  correct', (WidgetTester tester) async{
    await tester.pumpWidget(new StartApp(signIn: false));
    await tester.tap(find.byIcon(Icons.assignment));
    await tester.pump(new Duration(seconds: 1));

    expect(find.byType(Checkbox), findsWidgets);
    expect(find.byIcon(Icons.edit), findsWidgets);
  });*/

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
    await tester.pumpWidget(new StartApp(signIn: false));
    //await tester.tap(find.byIcon(Icons.assignment));
    Finder habitFind = find.byType(HabitListWidget);
    Finder ck = find.byType(Checkbox);
    HabitListWidget habitWidget = tester.firstElement(habitFind).widget;
    CoreHabit habit = Global.habitManager.getHabit(habitWidget.habitKey);
    expect(habit.markedOff, isNot(contains(Global.currentDate)));
    await tester.tap(find.descendant(of: habitFind, matching: ck).first);
    expect(habit.markedOff, contains(Global.currentDate));
  });
}
