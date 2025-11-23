import 'package:flutter/material.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/typography.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({
    super.key,
    required this.onClick,
    required this.label,
    this.isLarge = false,
  });

  final Function onClick;
  final String label;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { onClick(); },
      child: Container(
        padding: EdgeInsets.all(14),
        width: isLarge ? double.infinity : MediaQuery.sizeOf(context).width * 0.4,
        decoration: BoxDecoration(
          color: ThemeColors.secondary(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: ThemeTypography.getTitle4().copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
