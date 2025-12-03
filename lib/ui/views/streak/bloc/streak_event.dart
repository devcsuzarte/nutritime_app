part of 'streak_bloc.dart';

abstract class StreakEvent extends Equatable {
  const StreakEvent();

  @override
  List<Object> get props => [];
}


class LoadStreak extends StreakEvent {
  @override
  List<Object> get props => [];
}

class CheckMeal extends StreakEvent {
  final Meal mealChecked;
  const CheckMeal({required this.mealChecked});
  
  @override
  List<Object> get props => [mealChecked];
}