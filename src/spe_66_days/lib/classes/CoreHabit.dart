import 'Notification.dart';

class CoreHabit {
  //Maybe move this to be associated with the enum values
  String title;
  //String description;
  //bool unlocked;
  String checkTitle;
  String checkDescription;
  List<Notification> reminders;
  Map<DateTime, bool> markedOff;
}