import 'package:flutter/material.dart';

extension ExtensionsTimeOfDay on TimeOfDay {
  int timeInSeconds() {

    final int timeInMinutes = (hour * 60) + minute;

    return timeInMinutes * 60;
  }

  int differenceFromNow() {
    final int now = TimeOfDay.now().timeInSeconds();

    int difference = now - timeInSeconds();

    if (difference < 0) {
     difference = difference * -1;
    }

    return difference;
  }
}