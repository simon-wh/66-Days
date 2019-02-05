import 'package:flutter/material.dart';
import 'dart:collection';

class Stat {
  final String title;
  final Icon icon;
  final  num Function(List<HashSet<DateTime>> habits) habitFunc;

  Stat(this.title, this.icon, this.habitFunc);
}