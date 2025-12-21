import 'package:nutritime/data/models/meal.dart';

abstract class MealRepositoryContract {
  Future<bool> createMeal(Meal newMeal);
  Future<List<Meal>> getMealList();
  Future<bool> updateMeal(Meal updatedMeal, Meal meal);
  Future<void> checkMeal(Meal meal, bool isCompleted);
  Future<void> deleteMeal(String id);
}