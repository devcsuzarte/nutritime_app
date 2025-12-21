import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/models/time.dart';
import 'package:nutritime/ui/views/meal/meal.dart';
import 'package:nutritime/ui/views/streak/streak.dart';
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
    return MaterialApp(
          title: 'Flutter Demo',
          routes: {
            '/': (context) => MealPage(),
            '/streak': (context) => StreakPage()
          },
          theme: ThemeData(colorScheme: ColorScheme.light()),
    );
  }
}
