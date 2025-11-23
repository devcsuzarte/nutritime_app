import 'package:flutter/material.dart';

class ThemeDecoration {
  static BoxShadow getDefaultBoxShadow() => BoxShadow(
    color: Color.fromARGB(0, 219, 215, 215).withOpacity(1),
    offset: Offset(0, 0),
    blurRadius: 8,
    spreadRadius: 1,
  );
}
