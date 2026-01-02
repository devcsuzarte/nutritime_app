import 'package:nutritime/core/utils/extensions.dart';
import 'package:nutritime/data/models/meal.dart';

class Utils {
  static bool isNextCard(Meal meal) {
    if (meal.time == null) return false;
    
    return meal.time!.differenceFromNow() < 3600;
  }
}