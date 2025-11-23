part of 'add_meal_bloc.dart';

sealed class AddMealState extends Equatable {
  const AddMealState();
  
  @override
  List<Object> get props => [];
}

final class AddMealInitialState extends AddMealState {}
final class AddMealSuccessState extends AddMealState {
  final bool mealAdded;

  const AddMealSuccessState({required this.mealAdded});
  @override
  List<Object> get props => [mealAdded];
}
final class AddMealErrorState extends AddMealState {}
final class AddMealLoadingState extends AddMealState {}
