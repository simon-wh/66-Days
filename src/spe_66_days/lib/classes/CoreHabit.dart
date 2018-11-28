import 'Notification.dart';
import 'dart:collection';

class CoreHabit {
  //Maybe move this to be associated with the enum values
  String title;
  //String description;
  //bool unlocked;
  String experimentTitle;
  //String checkDescription;
  List<HabitNotification> reminders;
  HashSet<DateTime> markedOff;

  CoreHabit(this.title, this.experimentTitle, {this.reminders, this.markedOff}){
    assert(this.title.isNotEmpty);
    assert(this.experimentTitle.isNotEmpty);
    //assert(this.checkDescription.isNotEmpty);
    reminders ??= List<HabitNotification>();
    markedOff ??= HashSet<DateTime>();
  }
}