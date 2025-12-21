import 'dart:developer';

import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:stacked/stacked.dart';


class AddMealViewmodel extends FutureViewModel{

	final MealRepository mealRepository;

  ReactiveValue<AddMealPageState> state = ReactiveValue(AddMealPageState.none);
	
	AddMealViewmodel({required this.mealRepository});

	@override
	Future futureToRun() async {
		
	}

  Future<void> createMeal(Meal meal,) async {
    try {

     final bool mealAdded = await runBusyFuture(
      mealRepository.createMeal(meal)
    );

    if (mealAdded) {
      setState(AddMealPageState.mealAdded);
      notifyListeners();
    }

    } catch (e) {
      log('Add meal failed: $e');
    }
  }

  void setState(AddMealPageState newState) {
    setState(newState);
    notifyListeners();
  }
}

enum AddMealPageState {
  none,
  error,
  mealAdded
}