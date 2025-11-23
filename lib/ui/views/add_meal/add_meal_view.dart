import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/ui/views/add_meal/bloc/add_meal_bloc.dart';
import 'package:nutritime/ui/views/add_meal/bloc/add_meal_event.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/ui/widgets/button_default.dart';
import 'package:nutritime/ui/widgets/dialog.dart';
import 'package:nutritime/ui/widgets/text_field_default.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      timeController = TextEditingController(),
      caloriesController = TextEditingController(),
      recipeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TimeOfDay? _selectedTime;
  bool newMealAdded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, newMealAdded),
          icon: Icon(Icons.arrow_back, color: ThemeColors.secondary()),
        ),
        title: Text('Add Meal', style: ThemeTypography.getTitle2()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: BlocConsumer<AddMealBloc, AddMealState>(
          builder: (BuildContext context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldDefault(
                        controller: titleController,
                        label: 'Meal',
                        hint: 'Dinner',
                      ),
                      TextFieldDefault(
                        controller: descriptionController,
                        label: 'Description',
                        hint: 'Eggs with bacon',
                      ),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
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
                        ),
                      ),
                      TextFieldDefault(
                        controller: caloriesController,
                        label: 'Calories',
                        hint: '100kcal',
                      ),
                      TextFieldDefault(
                        controller: recipeController,
                        label: 'Recipe',
                        hint: '2x - Eggs\n1x - Bacon',
                      ),
                      ThemeSpacers.h32,
                      ButtonDefault(
                        onClick: () {
                          
                          final form = _formKey.currentState;

                          if (form != null && form.validate()) {
                            final Meal meal = Meal(
                              title: titleController.text,
                              description: descriptionController.text,
                              recipe: recipeController.text,
                              calories: int.tryParse(caloriesController.text),
                              time: _selectedTime,
                            );

                            context.read<AddMealBloc>().add(
                              CreateMeal(meal: meal),
                            );
                            if (state is AddMealSuccessState) {
                              newMealAdded = state.mealAdded;
                              setState(() {
                                form.reset();
                              });
                            }
                          }
                        },
                        isLarge: true,
                        label: 'Save',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          listener: (BuildContext context, state) {
            if (state is AddMealSuccessState) {
              DefaultDialog(
                context: context,
                defaultFunction: () {
                  Navigator.pop(context);
                },
                title: 'Done',
                message: 'Meal successfuly added',
                buttonTitle: 'Ok',
              ).showDefaultDialog();
            }

            if (state is AddMealErrorState) {
              DefaultDialog(
                context: context,
                defaultFunction: () {
                  Navigator.pop(context);
                },
                title: 'Something went wrong',
                message: 'Try again later',
                buttonTitle: 'Entendi',
              ).showDefaultDialog();
            }
          },
        ),
      ),
    );
  }
}
