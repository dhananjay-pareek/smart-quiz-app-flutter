import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Renders the quiz answer options as a seamless rounded list, matching
/// `.option-btn` in bg.css: translucent rows separated by hairlines, with
/// only the outer corners of the whole list rounded, and green/red
/// highlighting once an answer has been chosen.
class OptionsList extends StatelessWidget {
  final List<String> options;
  final int? selectedIndex;
  final int? correctIndex;
  final bool answered;
  final void Function(int index) onSelect;

  const OptionsList({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.correctIndex,
    required this.answered,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final isLast = index == options.length - 1;
          final isSelected = answered && selectedIndex == index;
          final isCorrectAnswer = answered && correctIndex == index;

          Color background = AppColors.rowBase.withOpacity(
            AppColors.rowBaseOpacity,
          );
          Color textColor = AppColors.textPrimary;

          if (isCorrectAnswer) {
            background = AppColors.correct.withOpacity(0.3);
          } else if (isSelected) {
            // Selected but wrong.
            background = AppColors.incorrect.withOpacity(0.3);
          }

          return Material(
            color: background,
            child: InkWell(
              onTap: answered ? null : () => onSelect(index),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: AppColors.rowBorder.withOpacity(0.15),
                          ),
                        ),
                ),
                child: Opacity(
                  opacity: answered && !isSelected && !isCorrectAnswer
                      ? 0.7
                      : 1.0,
                  child: Text(
                    options[index],
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
