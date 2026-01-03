import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/text_color.dart';
import 'package:nutritime/core/theme/typography.dart';

class Empty extends StatelessWidget {
  const Empty({
    super.key,
    required this.title,
    required this.description,
    this.ilustration,
  });

  final String title, description;
  final Widget? ilustration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ilustration ?? SvgPicture.asset('assets/empty_meals.svg'),

        ThemeSpacers.h28,
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(text: '$title\n\n', style: ThemeTypography.getTitle1()),
              TextSpan(
                text: description,
                style: ThemeTypography.getBody1().copyWith(
                  color: TextColor.getNeutral(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
