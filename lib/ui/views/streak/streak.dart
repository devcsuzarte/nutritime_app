import 'package:flutter/material.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/data/models/streak.dart';
import 'package:nutritime/data/repository/meal/meal_repository.dart';
import 'package:nutritime/data/repository/streak/streak_repository.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/ui/views/streak/streak_viewmodel.dart';
import 'package:nutritime/ui/widgets/check_streak.dart';
import 'package:nutritime/ui/widgets/dialog.dart';
import 'package:stacked/stacked.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {

  StreakPageState currentState = StreakPageState.none;
  List<Meal> meals = List.empty();
  List<Streak> streak = List.empty();


  void listen(StreakPageState state) {
    if (state == StreakPageState.error) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streak', style: ThemeTypography.getTitle2()),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: ThemeColors.secondary()),
        ),
      ),
      body: ViewModelBuilder<StreakViewmodel>.reactive(
        viewModelBuilder: () =>
            StreakViewmodel(
              streakRepository: StreakRepository(),
              mealRepository: MealRepository()
            ),
        onViewModelReady: (model) {
          model
          ..state.onChange.listen(
            (event) => listen(currentState)
          )
          ..streakList.onChange.listen(
            (event) => streak = event.neu
          )
          ..mealsList.onChange.listen(
            (event) => meals = event.neu
          );
        },
        builder: (context, model, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      color: ThemeColors.secondary2(),
                      padding: EdgeInsets.all(12),
                      constraints: BoxConstraints(maxHeight: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Weekly Completion',
                            style: ThemeTypography.getTitle5().copyWith(
                              color: Colors.white,
                            ),
                          ),
                          ThemeSpacers.h12,
                          Expanded(
                            child: Center(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return CheckStreak(
                                    day: streak[index].day,
                                    streakStatus: streak[index].status,
                                    backgroundColor: Colors.white,
                                    foregroundColor: ThemeColors.secondary2(),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: streak.length,
                                separatorBuilder: (context, index) =>
                                    ThemeSpacers.w18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(23.0, 23.0, 0, 16.0),
                  child: Text(
                    'Meals',
                    style: ThemeTypography.getTitle5(),
                  ),
                ),
                Divider(color: Colors.black12),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: Row(
                        children: [
                          CheckStreak(
                            onTap: (bool isCompleted) {
                             model.onChecked(meals[index]);
                            },
                            day: null,
                            backgroundColor: ThemeColors.secondary2(),
                            foregroundColor: Colors.white,
                            streakStatus: meals[index].isCompleted ? 'checked' : 'current'
                          ),
                          ThemeSpacers.w12,
                          Text(
                            meals[index].title ?? '',
                            style: ThemeTypography.getBody1(),
                          ),
                        ],
                      ),
                    ),
                    itemCount: meals.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.black12),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
