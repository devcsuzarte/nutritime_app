import 'package:flutter/material.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/ui/widgets/button_default.dart';
import 'package:nutritime/ui/widgets/dialog.dart';
import 'package:nutritime/ui/widgets/text_field_default.dart';

class MealFormPage extends StatefulWidget {
  const MealFormPage({
    super.key,
    this.onCreateMeal,
    this.onUpdateMeal,
    this.mealUpdate,
  });

  final Function(Meal)? onCreateMeal;
  final Function(Meal)? onUpdateMeal;
  final Meal? mealUpdate;
  @override
  State<MealFormPage> createState() => _MealFormPageState();
}

class _MealFormPageState extends State<MealFormPage> {
  final TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      timeController = TextEditingController(),
      caloriesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TimeOfDay? _selectedTime;
  bool newMealAdded = false;

  @override
  void initState() {
    if (widget.mealUpdate != null) {
      final Meal currentMeal = widget.mealUpdate!;

      titleController.text = currentMeal.title ?? '';
      descriptionController.text = currentMeal.description ?? '';
      caloriesController.text = currentMeal.calories?.toString() ?? '';
      _selectedTime = currentMeal.time;

      WidgetsBinding.instance?.addPostFrameCallback((_) {
        if (mounted) timeController.text = _selectedTime?.format(context) ?? '';
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  void createMeal() {
    if (widget.onCreateMeal == null) return;

    widget.onCreateMeal!(
      Meal(
        title: titleController.text,
        description: descriptionController.text,
        calories: int.tryParse(caloriesController.text),
        time: _selectedTime,
      ),
    );
    setState(() {
      titleController.clear();
      descriptionController.clear();
      timeController.clear();
      caloriesController.clear();
    });
  }

  void updateMeal() {
    if (widget.onUpdateMeal == null) return;

    widget.onUpdateMeal!(
      Meal(
        title: titleController.text,
        description: descriptionController.text,
        calories: int.tryParse(caloriesController.text),
        time: _selectedTime,
      ),
    );
    setState(() {
      titleController.clear();
      descriptionController.clear();
      timeController.clear();
      caloriesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    final form = _formKey.currentState;

                    if (form != null && form.validate()) {
                      widget.mealUpdate != null ? updateMeal() : createMeal();

                      Navigator.pop(context);
                    }
                  },
                  mini: true,
                  backgroundColor: ThemeColors.secondary2(),
                  child: Icon(Icons.check),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFieldDefault(
                          controller: titleController,
                          label: 'Meal',
                          hint: 'Dinner',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A title value must be provide';
                            }

                            return null;
                          },
                        ),
                        TextFieldDefault(
                          controller: descriptionController,
                          label: 'Description',
                          hint: 'Eggs with bacon',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A calorie value must be provide';
                            }

                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime ?? TimeOfDay.now(),
                              helpText: 'Select Time',
                              cancelText: 'Cancel',
                              confirmText: 'OK',
                            );

                            if (pickedTime != null) {
                              _selectedTime = pickedTime;
                              timeController.text = pickedTime.format(context);
                            }
                          },
                          child: TextFieldDefault(
                            isEnable: false,
                            controller: timeController,
                            label: 'Time',
                            hint: '09:00 - AM',
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A calorie value must be provide';
                            }

                            return null;
                          },
                          ),
                        ),
                        TextFieldDefault(
                          controller: caloriesController,
                          label: 'Calories',
                          hint: '100kcal',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'A calorie value must be provide';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
