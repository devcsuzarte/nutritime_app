import 'dart:io';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/repository/meal/meal_repository_contract.dart';

class MealRepository implements MealRepositoryContract {
  @override
  Future<void> createMeal(Meal newMeal) async {
    var box = await Hive.openBox('mealBox');

    newMeal.id = (box.length + 1).toString();

    await box.add(newMeal);

    final meals = box.values.toList();
  }

  @override
  Future<void> deleteMeal(String id) {
    // TODO: implement deleteMeal
    throw UnimplementedError();
  }

  @override
  Future<List<Meal>> getMealList() async {
    var box = await Hive.openBox('mealBox');

    final List<Meal> mealsList = List.empty(growable: true);
    final meals = box.values.toList();
    for (var meal in meals) {
      mealsList.add(meal);
    }

    mealsList.sort((a, b) => a.time!.compareTo(b.time!));

    return mealsList;
  }

  @override
  Future<void> updateMeal(Meal updatedMeal, Meal meal) async {
    if (updatedMeal.title != null) {
      meal.title = updatedMeal.title;
    }
    if (updatedMeal.description != null) {
      meal.description = updatedMeal.description;
    }

    await meal.save();
  }

  @override
  Future<void> checkMeal(Meal meal, bool isCompleted) async {
    meal.isCompleted = isCompleted;
    await meal.save();
  }
}
