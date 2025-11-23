import 'package:bloc/bloc.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/repository/streak/streak_repository.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_event.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_state.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';

//TODO: DO SOME ERROS STRING TO ERROR ON THE CONSOLE

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository mealRepository;
  final StreakRepository streakRepository;

  MealBloc({
    required this.mealRepository,
    required this.streakRepository,
  }) : super(MealInitialState()) {
    on<LoadMeal>(_onLoaded);
    on<CheckMeal>(_onChecked);
  }

  Future<void> _onLoaded(LoadMeal event, Emitter<MealState> emit) async {
    try {
      emit(MealLoadingState());

      final List<Meal> meals = await mealRepository.getMealList();

      final filtered = meals.where((m) => !m.isCompleted).toList();

      if (meals.isEmpty) {
        emit(MealListEmptyState());
      } else if (filtered.isEmpty){
        emit(MealCompletedState());
      } else {
        emit(MealListLoadedState(filtered));
      }
    } catch (error) {
      print(error);
      //emit(MealListErrorState(error.toString()));
    }
  }

  Future<void> _onChecked(CheckMeal event, Emitter<MealState> emit) async {
    try {
      final Meal meal = event.mealChecked;

      // Atualiza no repositório
      await mealRepository.checkMeal(meal, true);

      // Agora recarrega e EMITE novo estado
      final List<Meal> updated = await mealRepository.getMealList();
      final filtered = updated.where((m) => !m.isCompleted).toList();

      if (filtered.isEmpty) {
        emit(MealListEmptyState());
      } else {
        emit(MealListLoadedState(filtered));
      }
    } catch (error) {
      print(error);
      //emit(MealErrorState(error.toString()));
    }
  }
}

