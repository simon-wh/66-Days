import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:spe_66_days/classes/course/CourseEntry.dart';
import 'dart:io';

void main() {
  group("CourseEntry Decode JSON", () {
    test('Decode', () {
      String text = new File('test_resources/CourseEntryDecode1.json').readAsStringSync();
      expect(CourseEntry.fromJson(json.decode(text)), equals(
        CourseEntry("Week Two - Eat Slowly and Savour Your Food", <CourseEntryItem>[
          CourseEntryChange("Experiments", "eat_slowly", "experimentTitle", <String>[
            "put down your cutlery after each mouthful",
            "eat with your non-dominant hand",
            "set a chew goal per mouthful",
            "halve every mouthful before you eat it",
            "drink water between every mouthful",
            "use chopsticks"
          ]),
          CourseEntryChange("Environment Design", "eat_slowly", "environmentDesign", <String>[
            "eat your meals at a table. Never eat at your desk",
            "eat in a calm environment",
            "give yourself time to eat",
            "don’t eat in front of a screen",
            "eat with other people when possible",
            "don't eat out of a packet - plate up everything, even if it's just a snack",
            "try and relish what you're eating - be grateful and enjoy it!"
          ])
        ])
      ));
    });
  });
}