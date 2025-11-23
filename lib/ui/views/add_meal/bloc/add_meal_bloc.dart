import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/ui/views/add_meal/bloc/add_meal_event.dart';
part 'add_meal_state.dart';

class AddMealBloc extends Bloc<AddMealEvent, AddMealState> {
  final MealRepository mealRepository;

  AddMealBloc({required this.mealRepository})
      : super(AddMealInitialState()) {
    
    on<CreateMeal>(_onCreateMeal);
    on<AddMealInitial>(_onReset);
  }

  Future<void> _onCreateMeal(
    CreateMeal event,
    Emitter<AddMealState> emit,
  ) async {
    try {
      emit(AddMealLoadingState());

      final Meal newMeal = event.meal;

      await mealRepository.createMeal(newMeal);

      emit(AddMealSuccessState(mealAdded: true));

    } catch (e) {
      print('Add meal failed: $e');
      //emit(AddMealErrorState(message: e.toString()));
    }
  }

  void _onReset(AddMealInitial event, Emitter<AddMealState> emit) {
    emit(AddMealInitialState());
  }
}

