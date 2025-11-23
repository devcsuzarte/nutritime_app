import 'package:equatable/equatable.dart';
import 'package:nutritime/data/models/meal.dart';

abstract class AddMealEvent extends Equatable {
  const AddMealEvent();
  
  @override
  List<Object> get props => [];
}

class AddMealInitial extends AddMealEvent {
  @override
  List<Object> get props => [];
}

class CreateMeal extends AddMealEvent {
  final Meal meal;
  const CreateMeal({required this.meal});

  @override
  List<Object> get props => [meal];
}