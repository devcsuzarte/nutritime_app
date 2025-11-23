import 'package:flutter/material.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/decoration.dart';
import 'package:nutritime/core/theme/typography.dart';

class NextMealCard extends StatelessWidget {
  const NextMealCard({
    super.key,
    required this.onComplete,
    required this.time,
    required this.title,
    required this.description,
    required this.calories,
  });

  final String? time, title, description;
  final int? calories;
  final Function onComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(28, 24, 28, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [ThemeDecoration.getDefaultBoxShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$title – $time ',
                    style: ThemeTypography.getTitle2(),
                  ),
                  // WidgetSpan(
                  //   child: Icon(
                  //     Icons.access_time,
                  //     size: 20,
                  //   )
                  // ),
                  TextSpan(
                    text: '\n$description',
                    style: ThemeTypography.getTitle4(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            decoration: BoxDecoration(
              color: ThemeColors.primary(),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    onComplete();
                  },
                  child: Text(
                    'Meal complete',
                    style: ThemeTypography.getBody2(),
                  ),
                ),
                Text(
                  "${calories}kcal",
                  style: ThemeTypography.getTitle2().copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
