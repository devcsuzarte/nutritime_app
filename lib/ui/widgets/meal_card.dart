// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/decoration.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.time,
    required this.calories,
    required this.title,
    this.onClick
  });

  final String? time;
  final String? title;
  final int? calories;
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onClick != null) onClick!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            ThemeDecoration.getDefaultBoxShadow()
          ],
        ),
        padding: const EdgeInsets.fromLTRB(15, 10, 10, 15),
        margin: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            Row(
              children: [
                if (time != null)
                Text(time!, style: TextStyle(color: Color(0xFF90A5B4))),
                ThemeSpacers.w12,
                Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.primary(),
                    borderRadius: BorderRadius.circular(9)
                    ),
                  height: 4,
                  width: 44,
                ),
              ],
            ),
            ThemeSpacers.h18,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icon_meal.svg'),
                    ThemeSpacers.w12,
                    Text(title ?? '', style: TextStyle(color: Colors.black)),
                  ],
                ),
                Text('${calories}kcal', style: ThemeTypography.getTitle4()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
