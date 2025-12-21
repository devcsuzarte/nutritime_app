import 'dart:developer';

import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:stacked/stacked.dart';


class MealViewmodel extends FutureViewModel{
  static const _tag = 'MealViewmodel';

	final MealRepository mealRepository;

  ReactiveValue<MealPageState> state = ReactiveValue(MealPageState.none);
  ReactiveValue<List<Meal>> mealsList = ReactiveValue(List.empty());
	
	MealViewmodel({required this.mealRepository});

	@override
	Future futureToRun() async {
		await loadList();
	}

  Future<void> loadList() async {
    try {

      final List<Meal> meals = await mealRepository.getMealList();

      final filtered = meals.where((m) => !m.isCompleted).toList();

      if (meals.isEmpty) {
        setState(MealPageState.mealListEmpty);
        return;
      } 

      if (filtered.isEmpty) { 
         setState(MealPageState.mealListCompleted);
        return;
      }

      mealsList.value = filtered;
      setState(MealPageState.mealListLoaded);
      notifyListeners();

    } catch (error) {
      print(error);
      //emit(MealListErrorState(error.toString()));
    }
  }

  Future<void> onChecked(Meal meal) async {
    try {

      await mealRepository.checkMeal(meal, true);

      await loadList();

    } catch (error) {
      log('$_tag: $error');
    }
  }

  void setState(MealPageState newState) {
    state.value = newState;
    notifyListeners();
  }
}

enum MealPageState {
  none,
  error,
  firstAccess,
  mealListLoaded,
  mealListEmpty,
  mealListCompleted
}