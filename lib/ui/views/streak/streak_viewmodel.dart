import 'dart:developer';

import 'package:stacked/stacked.dart';

import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/data/repository/streak/streak_repository.dart';


class StreakViewmodel extends FutureViewModel{
  static const _tag = 'StreakViewmodel';

	final MealRepository mealRepository;
  final StreakRepository streakRepository;

  ReactiveValue<StreakPageState> state = ReactiveValue(StreakPageState.none);
  ReactiveValue<List<Streak>> streakList = ReactiveValue(List.empty());
  ReactiveValue<List<Meal>> mealsList = ReactiveValue(List.empty());
	
	StreakViewmodel({
    required this.streakRepository,
    required this.mealRepository
  });

	@override
	Future futureToRun() async {
    await _loadStreak();
	}

  Future<void> _loadStreak() async {
    await _getMealsList();

    try {

    } catch (e) {
      log('$_tag – _loadStreak(): $e');
    }

    final List<Streak> streak = await runBusyFuture(
      streakRepository.getStreakList(mealsList.value)
    );

    if (streak.isEmpty) return;

    streakList.value = streak;

  }

  Future<void> _getMealsList() async {

    try {
      final List<Meal> meals = await runBusyFuture(mealRepository.getMealList());

      if (meals.isEmpty) return; 

      mealsList.value = meals;
    } catch (e) {
      log('$_tag – _getMealsList(): $e');
      setState(StreakPageState.error);
    }
    notifyListeners();
  }

  Future<void> onChecked(Meal checkedMeal) async {
    await mealRepository.checkMeal(checkedMeal, true);
    _loadStreak();
  }

  void setState(StreakPageState newState) {
    state.value = newState;
    notifyListeners();
  }
}

enum StreakPageState {
  none,
  error,
  completed
}