import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';

class Stat {
  final String title;
  final Icon icon;
  final num Function(List<Tuple2<DateTime, HashSet<DateTime>>> habits) habitFunc;
  final bool onlyAllHabit;

  Stat(this.title, this.icon, this.habitFunc, this.onlyAllHabit);
}