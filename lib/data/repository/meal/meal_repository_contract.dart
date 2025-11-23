import 'package:nutritime/data/models/meal.dart';

abstract class MealRepositoryContract {
  Future<void> createMeal(Meal newMeal);
  Future<List<Meal>> getMealList();
  Future<void> updateMeal(Meal updatedMeal, Meal meal);
  Future<void> checkMeal(Meal meal, bool isCompleted);
  Future<void> deleteMeal(String id);
}