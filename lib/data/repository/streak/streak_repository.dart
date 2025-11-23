import 'dart:io';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/repository/streak/streak_repository_contract.dart';

class StreakRepository implements StreakRepositoryContract {
  @override
  Future<List<Streak>> getStreakList(List<Meal> meals) async {
    var streakBox = await Hive.openBox('streak');
    var configBox = await Hive.openBox('configBox');

    final DateTime currentDate = DateTime.now();
    final DateTime streakCreatedTime = await configBox.get('streakCreatedTime') ?? currentDate;

    if (streakBox.isEmpty) {
      await _createNewStreakList(meals);
      if (streakBox.isNotEmpty) {
        final streakList = await _convertListFromHive(streakBox.values.toList());
        return streakList;
      }
    }

    if (currentDate.weekday == 0 &&
        (currentDate.difference(streakCreatedTime).inDays > 0)) {

      await streakBox.clear();
      await _createNewStreakList(meals);
      if (streakBox.isNotEmpty) {
        final streakList = await _convertListFromHive(streakBox.values.toList());
        return streakList;
      }
    }

    final List<Streak> streakList = await _convertListFromHive(streakBox.values.toList());
    
    List<Streak> finalList = await _handlePreviousDays(streakList, currentDate.weekday);

    return finalList;
  }

  @override
  Future<bool> updateStreak({
    required Streak streak,
    required String status,
    required int goal,
    required int currentMealsCount,
    required int checkedMealsCount,
  }) async {
    streak.status = status;
    streak.goal = goal;
    streak.currentMealsCount = currentMealsCount;
    streak.checkedMealsCount = checkedMealsCount;

    try {
      await streak.save();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _createNewStreakList(List<Meal> meals) async {
    var streakBox = await Hive.openBox('streak');
    var configBox = await Hive.openBox('configBox');

    final DateTime currentDate = DateTime.now();

    List<String> days = _generateStreakDays();
    configBox.put('streakCreatedTime', currentDate);
    for (int i = 0; i < days.length; i++) {
      String status = 'none';

      if (i == currentDate.weekday) {
        status = 'current';
      } else if (i < currentDate.weekday) {
        status = 'none';
      } else if (i > currentDate.weekday) {
        status = 'incoming';
      }

      streakBox.put(
        days[i],
        Streak(
          day: days[i].substring(0, 3),
          weekday: i,
          status: status,
          goal: meals.length,
          currentMealsCount: _getCompletedMealsCount(meals),
        ),
      );
    }
  }

  Future<List<Streak>> _convertListFromHive(List<dynamic> boxList) async {
    final List<Streak> streakList = List.empty(growable: true);

    for (var streakDay in boxList) {
      streakList.add(streakDay);
    }

    return streakList
      ..sort((a, b) => a.weekday.compareTo(b.weekday))
      ..toList();
  }

  Future<List<Streak>> _handlePreviousDays(
    List<Streak> streakList,
    int weekday,
  ) async {
    if (weekday == 0) return streakList;

    for (int i = weekday - 1; i > 0; i--) {
      final Streak lastStreak = streakList[i];
      if (streakList[i].status == 'current' ||
          streakList[i].status == 'incoming') {
        lastStreak.status =
            lastStreak.currentMealsCount == lastStreak.checkedMealsCount
            ? 'checked'
            : 'missed';

        streakList[i].save();
      }
    }

    return streakList;
  }

  List<String> _generateStreakDays() {
    final List<String> days = DateFormat.EEEE(
      Platform.localeName,
    ).dateSymbols.SHORTWEEKDAYS;

    return days;
  }

  int _getCompletedMealsCount(List<Meal> meals) {
    int completedCount = 0;
    for (var meal in meals) {
      if (meal.isCompleted) {
        completedCount++;
      }
    }

    return completedCount;
  }
}
