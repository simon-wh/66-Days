import 'package:flutter/material.dart';

@immutable
abstract class INavBar {
  final Icon icon;
  final Text title;

  INavBar(this.icon, this.title);
}