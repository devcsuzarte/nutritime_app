import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/core/utils/enums.dart';
import 'package:nutritime/data/models/meal.dart';
import 'package:nutritime/ui/views/streak/bloc/streak_bloc.dart';
import 'package:nutritime/ui/widgets/check_streak.dart';

class StreakPage extends StatefulWidget {
  const StreakPage({super.key});

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  late List<Meal> mealList = List.empty();

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
      body: BlocConsumer<StreakBloc, StreakState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is StreakLoadedState) {
            return Column(
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
                                    day: state.streak[index].day,
                                    streakStatus: state.streak[index].status,
                                    backgroundColor: Colors.white,
                                    foregroundColor: ThemeColors.secondary2(),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                itemCount: state.streak.length,
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
                      child: InkWell(
                        child: Row(
                          children: [
                            CheckStreak(
                              day: null,
                              backgroundColor: ThemeColors.secondary2(),
                              foregroundColor: Colors.white,
                              streakStatus: 'current'
                            ),
                            ThemeSpacers.w12,
                            Text(
                              state.meals[index].title ?? '',
                              style: ThemeTypography.getBody1(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount: state.meals.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.black12),
                  ),
                ),
              ],
            );
          }

          return Text('Something went wrong, try again later');
        },
      ),
    );
  }
}
