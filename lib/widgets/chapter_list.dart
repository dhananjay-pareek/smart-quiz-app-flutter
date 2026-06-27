import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Renders the chapter-selection list as a seamless rounded list, matching
/// `.chapter-btn` / `.chapter-btn.completed` in bg.css.
class ChapterList extends StatelessWidget {
  final List<String> names;
  final List<int> questionCounts;
  final List<bool> completedFlags;
  final void Function(int index) onTap;

  const ChapterList({
    super.key,
    required this.names,
    required this.questionCounts,
    required this.completedFlags,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(names.length, (index) {
          final isLast = index == names.length - 1;
          final isCompleted = completedFlags[index];

          final background = isCompleted
              ? AppColors.correct.withOpacity(0.2)
              : AppColors.rowBase.withOpacity(AppColors.rowBaseOpacity);
          final textColor =
              isCompleted ? AppColors.correctText : AppColors.textPrimary;

          return Material(
            color: background,
            child: InkWell(
              onTap: () => onTap(index),
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
                            color: AppColors.rowBorder
                                .withOpacity(AppColors.rowBorderOpacity),
                          ),
                        ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${isCompleted ? '✓ ' : ''}${index + 1}. ${names[index]}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${questionCounts[index]} questions',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
