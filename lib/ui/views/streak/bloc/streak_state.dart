part of 'streak_bloc.dart';

sealed class StreakState extends Equatable {
  const StreakState();
  
  @override
  List<Object> get props => [];
}

final class StreakInitial extends StreakState {

}

final class StreakLoadedState extends StreakState {
  final List<Streak> streak;
  final List<Meal> meals;
  const StreakLoadedState(this.streak, this.meals);
  @override
  List<Object> get props => [streak, meals];
}

class StreakErrorState extends StreakState {
  @override
  List<Object> get props => [];
}
