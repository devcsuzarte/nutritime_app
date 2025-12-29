import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/ui/views/meal/meal_form.dart';
import 'package:nutritime/ui/views/meal/meal_viewmodel.dart';
import 'package:nutritime/ui/widgets/button_default.dart';
import 'package:nutritime/ui/widgets/dialog.dart';
import 'package:nutritime/ui/widgets/empty.dart';
import 'package:nutritime/ui/widgets/meal_card.dart';
import 'package:nutritime/ui/widgets/next_meal_card.dart';
import 'package:stacked/stacked.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      timeController = TextEditingController(),
      caloriesController = TextEditingController();

  bool newMealAdded = false;
  MealPageState currentState = MealPageState.none;
  List<Meal> meals = List.empty();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    timeController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  void listen(MealPageState state) {
    if (state == MealPageState.error) {
      DefaultDialog(
        context: context,
        defaultFunction: () {
          Navigator.pop(context);
        },
        title: 'Something went wrong',
        message: 'Try again later',
        buttonTitle: 'Ok',
      ).showDefaultDialog();
    }
  }

  void showAddMealBottomSheet(MealViewmodel viewmodel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => MealFormPage(
        onCreateMeal: (Meal newMeal) {
          viewmodel.createMeal(newMeal);
        },
      ),
    );
  }

  void showUpdateMealBottomSheet(MealViewmodel viewmodel, Meal meal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => MealFormPage(
        mealUpdate: meal,
        onCreateMeal: (Meal newMeal) {
          viewmodel.createMeal(newMeal);
        },
        onUpdateMeal: (Meal newMeal) {
          viewmodel.updateMeal(meal, newMeal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
             style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/notification_icon.svg',
              color: ThemeColors.secondary(),
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, "/streak");
            },
            icon: SvgPicture.asset(
              'assets/flame_icon.svg',
              color: ThemeColors.secondary(),
              height: 23,
            ),
          ),
        ],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Image.asset(
                'assets/nutritime.png',
              ),
            ),
            ThemeSpacers.w8,
            Text(
              'Nutritime',
              style: ThemeTypography.getTitle2(),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: ViewModelBuilder<MealViewmodel>.reactive(
          viewModelBuilder: () =>
              MealViewmodel(mealRepository: MealRepository()),
          onViewModelReady: (model) {
            model
              ..state.onChange.listen((event) => currentState = event.neu)
              ..mealsList.onChange.listen((event) => meals = event.neu);
          },
          builder: (context, model, child) {
            if (currentState == MealPageState.mealListLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: meals.length,
                      itemBuilder: (context, index) {
                        final Meal currentMeal = meals[index];

                        if (currentMeal.isCompleted) {
                          return const SizedBox.shrink();
                        }

                        if (index == 0) {
                          return NextMealCard(
                            onClick: () =>
                                showUpdateMealBottomSheet(model, currentMeal),
                            onComplete: () {
                              model.onChecked(meals[index]);
                            },
                            time: currentMeal.time?.format(context),
                            title: currentMeal.title,
                            calories: currentMeal.calories,
                            description: currentMeal.description,
                          );
                        }

                        return MealCard(
                          onClick: () =>
                              showUpdateMealBottomSheet(model, currentMeal),
                          title: currentMeal.title,
                          time: currentMeal.time?.format(context),
                          calories: currentMeal.calories,
                        );
                      },
                      separatorBuilder: (_, __) => ThemeSpacers.h28,
                    ),
                  ),

                  // botão
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 18,
                    ),
                    child: ButtonDefault(
                      onClick: () {
                        showAddMealBottomSheet(model);
                      },
                      isLarge: true,
                      label: 'Add Meal',
                    ),
                  ),
                ],
              );
            }

            if (currentState == MealPageState.mealListEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Empty(
                      title: 'Lets start',
                      description:
                          'Bring you diet and let us hel you follow and get you nutrition goals',
                    ),
                    ButtonDefault(
                      onClick: () async {
                        showAddMealBottomSheet(model);
                      },
                      isLarge: true,
                      label: 'Start',
                    ),
                  ],
                ),
              );
            }

            if (currentState == MealPageState.mealListCompleted) {
              return Center(
                child: Empty(
                  title: 'Congratulations!',
                  description: 'You completed your goals todays.',
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
