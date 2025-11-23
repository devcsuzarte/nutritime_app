import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';

abstract class StreakRepositoryContract {
  Future<List<Streak>> getStreakList(List<Meal> meals);
   Future<bool> updateStreak({
    required Streak streak,
    required String status,
    required int goal,
    required int currentMealsCount,
    required int checkedMealsCount,
  });
}