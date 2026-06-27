import 'package:flutter/material.dart';

import '../models/question.dart';
import '../theme/app_colors.dart';
import '../widgets/app_progress_bar.dart';
import '../widgets/options_list.dart';

/// The active quiz view, matching `#quiz-view`.
///
/// Built as a [StatefulWidget] so each question can hold its own
/// "selected option / answered" state. The parent rebuilds this widget
/// with a fresh [ValueKey] per question index (see `_QuizAppState` in
/// app.dart), which naturally resets [_selectedIndex]/[_answered] for the
/// next question — mirroring the way the original `displayCurrentQuestion()`
/// re-renders a clean options list and resets `feedback-text` each time.
class QuizScreen extends StatefulWidget {
  final Question question;
  final int questionNumber; // 1-based
  final int totalQuestions;
  final int score;
  final double progressPercent;
  final void Function(int selectedIndex, bool isCorrect) onAnswer;
  final VoidCallback onSkip;
  final VoidCallback onHome;

  const QuizScreen({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.totalQuestions,
    required this.score,
    required this.progressPercent,
    required this.onAnswer,
    required this.onSkip,
    required this.onHome,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _selectedIndex;
  bool _answered = false;

  void _handleTap(int index) {
    if (_answered) return;
    final isCorrect = index == widget.question.answer;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });
    widget.onAnswer(index, isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    final isCorrect = _answered && _selectedIndex == widget.question.answer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBase.withOpacity(AppColors.cardOpacity),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.cardBorder.withOpacity(AppColors.cardBorderOpacity),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.37),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row: Home button, question count, score.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: widget.onHome,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  '← Home',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Question ${widget.questionNumber} / ${widget.totalQuestions}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Score: ${widget.score}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFA5B4FC), // indigo-300-ish
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppProgressBar(percent: widget.progressPercent),
          const SizedBox(height: 24),

          Text(
            widget.question.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          OptionsList(
            options: widget.question.options,
            selectedIndex: _selectedIndex,
            correctIndex: widget.question.answer,
            answered: _answered,
            onSelect: _handleTap,
          ),

          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _answered ? null : widget.onSkip,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: AppColors.secondaryBtnText,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                ),
              ),
              child: const Text(
                'Skip Question',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),
          SizedBox(
            height: 24,
            child: _answered
                ? Text(
                    isCorrect ? 'Correct!' : 'Incorrect.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isCorrect
                          ? AppColors.correctText
                          : const Color(0xFFFCA5A5),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
