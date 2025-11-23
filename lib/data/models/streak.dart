import 'package:hive/hive.dart';

part 'streak.g.dart';
@HiveType(typeId: 1)
class Streak extends HiveObject{

  @HiveField(0)
  String day;
  @HiveField(1)
  int weekday;
  @HiveField(2)
  String status;
  @HiveField(3)
  int goal;
  @HiveField(4)
  int currentMealsCount;  
  @HiveField(5)
  int checkedMealsCount;  

  Streak({
    required this.day,
    required this.weekday,
    required this.status,
    required this.goal,
    required this.currentMealsCount,
    this.checkedMealsCount = 0
  });
}