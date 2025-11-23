import 'package:flutter/material.dart';
import 'package:nutritime/core/theme/colors.dart';

class ThemeTypography {
  static TextStyle getTitle1() => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24
  );

  static TextStyle getTitle2() => TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20
  );

  static TextStyle getTitle3() => TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16
  );

  static TextStyle getTitle4() => TextStyle(
      color: ThemeColors.neutral40(),
      fontWeight: FontWeight.bold,
      fontSize: 16
  );

  static TextStyle getTitle5() => TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14
  );

  static TextStyle getBody1() => TextStyle(
      fontSize: 14
  );

  static TextStyle getBody2() => TextStyle(
    color: Colors.black,
    fontSize: 12
  );

  static TextStyle getBody3() => TextStyle(
      color: Colors.black,
      fontSize: 10
  );
}