import 'package:equatable/equatable.dart';
import 'package:nutritime/data/models/meal.dart';

abstract class MealState extends Equatable {
  const MealState();
}


// Initial MealBloc state
class MealInitialState extends MealState {
  @override
  List<Object> get props => [];
}

class MealListLoadedState extends MealState {
  final List<Meal> items;
  const MealListLoadedState(this.items);
  @override
  List<Object> get props => [items];
}

class MealListEmptyState extends MealState {
  @override
  List<Object> get props => [];
}

class MealCompletedState extends MealState {
  @override
  List<Object> get props => [];
}

class MealListErrorState extends MealState {
  @override
  List<Object> get props => [];
}

class MealLoadingState extends MealState {
  @override
  List<Object> get props => [];
}