import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutritime/core/theme/colors.dart';
import 'package:nutritime/core/theme/spacers.dart';
import 'package:nutritime/core/theme/typography.dart';

class TextFieldDefault extends StatelessWidget {
  const TextFieldDefault({
    super.key, 
    this.label, 
    this.hint,
    this.maxLines,
    this.showBottomSpacer = true,
    this.isEnable = true,
    this.validator,
    required this.controller
  });

  final String? label, hint;
  final int? maxLines;
  final bool showBottomSpacer, isEnable;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Text(
            label!,
            style: ThemeTypography.getTitle3().copyWith(
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        TextFormField(
          enabled: isEnable,
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: hint,
            hintStyle: ThemeTypography.getBody1().copyWith(
              color: ThemeColors.neutral80()
            ),
            hintMaxLines: maxLines,
            filled: true,
            fillColor: ThemeColors.neutral90(),
            border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
          ),
        ),

        if (showBottomSpacer)
        ThemeSpacers.h12
      ],
    );
  }
}