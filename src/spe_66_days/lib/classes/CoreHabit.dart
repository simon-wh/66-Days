import 'Notification.dart';

class CoreHabit {
  //Maybe move this to be associated with the enum values
  String title;
  //String description;
  //bool unlocked;
  String checkTitle;
  //String checkDescription;
  List<Notification> reminders;
  Map<DateTime, bool> markedOff;

  CoreHabit(this.title, this.checkTitle, {this.reminders, this.markedOff}){
    assert(this.title.isNotEmpty);
    assert(this.checkTitle.isNotEmpty);
    //assert(this.checkDescription.isNotEmpty);
    reminders ??= List<Notification>();
    markedOff ??= Map<DateTime,bool>();
  }
}