import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutritime/core/theme/typography.dart';
import 'package:nutritime/core/utils/enums.dart';

class CheckStreak extends StatelessWidget {
  const CheckStreak({
    super.key,
    required this.streakStatus,
    required this.day,
    required this.backgroundColor,
    required this.foregroundColor,
    this.onTap,
  });

  final String streakStatus;
  final String? day;
  final Function(bool)? onTap;
  final Color backgroundColor, foregroundColor;

  Widget _getCheckIcon(String streakStatus) {
    if (streakStatus == 'checked') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset('assets/checked.svg'),
      );
    }

    if (streakStatus == 'current') {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(Icons.circle, size: 19, color: foregroundColor),
      );
    }
    if (streakStatus == 'missed') {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Icon(Icons.cancel, size: 19, color: foregroundColor),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Icon(Icons.circle, size: 19, color: backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: streakStatus == 'incoming' ? 0.5 : 1,
      child: InkWell(
        onTap: () {
          if (onTap != null){ onTap!(streakStatus == 'checked'); }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: _getCheckIcon(streakStatus),
            ),
        
            if (day != null)
              Text(
                day!,
                style: ThemeTypography.getBody1().copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
