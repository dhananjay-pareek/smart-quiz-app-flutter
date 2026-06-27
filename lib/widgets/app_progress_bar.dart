import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Thin rounded progress bar, matching `#progress-bar` (quiz progress,
/// indigo fill) and the green main-menu chapter-completion bar.
class AppProgressBar extends StatelessWidget {
  final double percent; // 0-100
  final Color fillColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.percent,
    this.fillColor = AppColors.primaryBtn,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0, 100).toDouble();
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppColors.progressTrack,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: clamped / 100,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: fillColor,
          ),
        ),
      ),
    );
  }
}
