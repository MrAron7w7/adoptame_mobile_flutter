import 'package:flutter/material.dart';

class AppColor {
  AppColor._(); // PRIVADO
  static const Color transparent = Colors.transparent;

  // Light Mode
  static const Color surface = Colors.white;
  static const Color primary = Color(0xff6096ba);
  static const Color secondary = Color(0xff494949);
  static const Color tertiary = Color(0xffFF6F61);
  static const Color inversePrimary = Color(0xff82B1FF);

  // Dark Mode
  static const Color surfaceDark = Color(0xFF121212);
  static const Color primaryDark = Color(0xff82B1FF);
  static const Color secondaryDark = Colors.grey;
  static const Color tertiaryDark = Color(0xffFF8A65);
  static const Color inversePrimaryDark = Color(0xff2979FF);
}
