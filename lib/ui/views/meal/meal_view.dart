import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_bloc.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_event.dart';
import 'package:nutritime/ui/views/meal/bloc/meal_state.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/ui/widgets/button_default.dart';
import 'package:nutritime/ui/widgets/empty.dart';
import 'package:nutritime/ui/widgets/meal_card.dart';
import 'package:nutritime/ui/widgets/next_meal_card.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  List<Meal> mealList = [];

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MealBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        actions: [
          IconButton(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning,', style: ThemeTypography.getTitle4()),
            ThemeSpacers.h4,
            Text('Claudio Suzarte', style: ThemeTypography.getTitle2()),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: BlocListener<MealBloc, MealState>(
          listener: (context, state) {
            if (state is MealListLoadedState) {
              setState(() {
                mealList = state.items;
              });
            }
          },
          child: BlocBuilder<MealBloc, MealState>(
            builder: (context, state) {
              if (state is MealListLoadedState) {
                final meals = state.items;

                if (meals.isEmpty) {
                  return const Center(child: Text("No meals"));
                }

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
                              onComplete: () {
                                context.read<MealBloc>().add(
                                  CheckMeal(mealChecked: currentMeal),
                                );
                              },
                              time: currentMeal.time?.format(context),
                              title: currentMeal.title,
                              calories: currentMeal.calories,
                              description: currentMeal.description,
                            );
                          }

                          return MealCard(
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
                        onClick: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/add_meal',
                          );
                          if (result == true) {
                            context.read<MealBloc>().add(LoadMeal());
                          }
                        },
                        isLarge: true,
                        label: 'Add Meal',
                      ),
                    ),
                  ],
                );
              }

              if (state is MealListEmptyState) {
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
                          final result = await Navigator.pushNamed(
                            context,
                            '/add_meal',
                          );
                          if (result == true) {
                            context.read<MealBloc>().add(LoadMeal());
                          }
                        },
                        isLarge: true,
                        label: 'Start',
                      ),
                    ],
                  ),
                );
              }

              if (state is MealCompletedState) {
                return Center(
                  child: Empty(
                    title: 'Congratulations!',
                    description:
                        'You completed your goals todays.',
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
