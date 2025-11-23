import 'package:equatable/equatable.dart';
import 'package:nutritime/data/models/meal.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();
  @override
  List<Object> get props => [];
}

class LoadMeal extends MealEvent {
  @override
  List<Object> get props => [];
}

class CheckMeal extends MealEvent {
  final Meal mealChecked;
  const CheckMeal({required this.mealChecked});
  
  @override
  List<Object> get props => [mealChecked];
}