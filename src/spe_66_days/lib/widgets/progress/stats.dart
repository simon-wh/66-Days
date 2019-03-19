import 'package:flutter/material.dart';
import 'dart:collection';

class Stat {
  final String title;
  final Icon icon;
  final num Function(List<HashSet<DateTime>> habits) habitFunc;
  final bool onlyAllHabit;

  Stat(this.title, this.icon, this.habitFunc, this.onlyAllHabit);
}