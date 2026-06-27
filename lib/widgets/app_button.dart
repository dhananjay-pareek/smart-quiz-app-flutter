import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonStyle { primary, secondary }

/// Reusable button matching `.btn`, `.btn-primary` and `.btn-secondary`
/// from bg.css.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonStyle style;
  final double? width;
  final double fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = AppButtonStyle.primary,
    this.width,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = style == AppButtonStyle.primary;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? AppColors.primaryBtn : Colors.white.withOpacity(0.1),
          foregroundColor:
              isPrimary ? Colors.white : AppColors.secondaryBtnText,
          disabledBackgroundColor: isPrimary
              ? AppColors.primaryBtn.withOpacity(0.5)
              : Colors.white.withOpacity(0.05),
          disabledForegroundColor:
              (isPrimary ? Colors.white : AppColors.secondaryBtnText)
                  .withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Colors.white.withOpacity(0.2)),
          ),
          textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: fontSize),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.hovered)) {
              return isPrimary
                  ? AppColors.primaryBtnHover.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1);
            }
            return null;
          }),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
