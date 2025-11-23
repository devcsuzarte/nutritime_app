import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/models/time.dart';
import 'package:nutritime/data/repository/streak/streak_repository.dart';
import 'package:nutritime/ui/views/add_meal/bloc/add_meal_bloc.dart';
import 'package:nutritime/ui/views/add_meal/bloc/add_meal_event.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_bloc.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_event.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/ui/views/add_meal/add_meal_view.dart';
import 'package:nutritime/ui/views/meal/meal_view.dart';
import 'package:nutritime/ui/views/streak/bloc/streak_bloc.dart';
import 'package:nutritime/ui/views/streak/streak_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en_US', null); //TODO: GET CURRENT LOCALE
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(MealAdapter())
    ..registerAdapter(StreakAdapter())
    ..registerAdapter(TimeOfDayAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => MealRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                MealBloc(
                  mealRepository: context.read<MealRepository>(),
                  streakRepository: StreakRepository()
                )
                  ..add(LoadMeal()),
          ),
          BlocProvider(
            create: (context) =>
                StreakBloc(
                  mealRepository: context.read<MealRepository>(),
                  streakRepository: StreakRepository()
                )
                  ..add(LoadStreak()),
          ),
          BlocProvider(
            create: (context) =>
                AddMealBloc(mealRepository: context.read<MealRepository>())
                  ..add(AddMealInitial()),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          routes: {
            '/': (context) => MealPage(),
            '/add_meal': (context) => AddMealPage(),
            '/streak': (context) => StreakPage(),
          },
          theme: ThemeData(colorScheme: ColorScheme.light()),
        ),
      ),
    );
  }
}
