import 'package:flutter/material.dart';

import '../models/question.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';

/// The post-quiz results view, matching `#quiz-complete-view`.
class QuizCompleteScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Question> incorrectlyAnswered;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToMenu;

  const QuizCompleteScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.incorrectlyAnswered,
    required this.onPlayAgain,
    required this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You've completed the quiz.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            'Final Score: $score / $totalQuestions',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA5B4FC),
            ),
          ),
          const SizedBox(height: 24),
          _buildSummary(),
          const SizedBox(height: 28),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [
              AppButton(label: 'Play Same Chapter', onPressed: onPlayAgain),
              AppButton(
                label: 'Main Menu',
                style: AppButtonStyle.secondary,
                onPressed: onBackToMenu,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    if (incorrectlyAnswered.isEmpty) {
      return const Text(
        'Perfect score! No incorrect answers to review.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.correctText,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Review Incorrect Answers',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: List.generate(incorrectlyAnswered.length, (index) {
              final q = incorrectlyAnswered[index];
              final correctAnswerText = q.options[q.answer];
              final isLast = index == incorrectlyAnswered.length - 1;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Correct answer: $correctAnswerText',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
