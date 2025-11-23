import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/data/repository/streak/streak_repository.dart';

part 'streak_event.dart';
part 'streak_state.dart';

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  final MealRepository mealRepository;
  final StreakRepository streakRepository;
  StreakBloc({required this.mealRepository, required this.streakRepository})
    : super(StreakInitial()) {
    on<LoadStreak>(_onLoadStreak);
  }

  _onLoadStreak(LoadStreak event, Emitter<StreakState> emit) async {
    final List<Meal> meals = await mealRepository.getMealList();
    final List<Streak> streakList = await streakRepository.getStreakList(meals);

    if (streakList.isNotEmpty) {
      emit(StreakLoadedState(streakList, meals));
      return;
    }

    emit(StreakErrorState());
  }
}
