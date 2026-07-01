import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_progress_bar.dart';
import '../widgets/glass_card.dart';

/// The main menu / home view, matching `#main-menu` in index.html.
class MainMenuScreen extends StatelessWidget {
  final int totalChapters;
  final int completedChapters;
  final VoidCallback onStartQuiz;
  final VoidCallback onAddQuestions;
  final VoidCallback onLegal;

  const MainMenuScreen({
    super.key,
    required this.totalChapters,
    required this.completedChapters,
    required this.onStartQuiz,
    required this.onAddQuestions,
    required this.onLegal,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalChapters > 0
        ? ((completedChapters / totalChapters) * 100).round()
        : 0;

    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Learn With SmartQuiz',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Master every subject with quizzes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // "Your Progress" section (renderMainMenuProgress equivalent).
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Completed Chapters',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$completedChapters / $totalChapters ($percentage%)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppProgressBar(
                  percent: percentage.toDouble(),
                  fillColor: const Color(0xFF22C55E), // bg-green-500
                  height: 8,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          AppButton(
            label: 'Start Programming Quiz',
            onPressed: onStartQuiz,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Add Custom Questions',
            style: AppButtonStyle.secondary,
            onPressed: onAddQuestions,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onLegal,
            child: const Text(
              'Privacy Policy & Terms',
              style: TextStyle(
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
