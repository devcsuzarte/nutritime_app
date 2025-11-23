import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'meal.g.dart';
@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? recipe;

  @HiveField(4)
  int? calories;

  @HiveField(5)
  TimeOfDay? time;

  @HiveField(6)
  bool isCompleted;

  Meal({
    this.id,
    this.title,
    this.description,
    this.recipe,
    this.calories,
    this.time,
    this.isCompleted = false,
  });
}
