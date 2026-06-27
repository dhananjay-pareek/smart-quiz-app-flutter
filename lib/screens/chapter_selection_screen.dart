import 'package:flutter/material.dart';

import '../models/chapter.dart';
import '../widgets/app_button.dart';
import '../widgets/chapter_list.dart';
import '../widgets/glass_card.dart';

/// The chapter-picker view, matching `#chapter-selection-view`.
class ChapterSelectionScreen extends StatelessWidget {
  final List<Chapter> chapters;
  final bool Function(String chapterName) isChapterCompleted;
  final void Function(int index) onSelectChapter;
  final VoidCallback onBack;

  const ChapterSelectionScreen({
    super.key,
    required this.chapters,
    required this.isChapterCompleted,
    required this.onSelectChapter,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select a Chapter',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          if (chapters.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'No chapters found. Try adding some custom questions!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9CA3AF)),
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: SingleChildScrollView(
                child: ChapterList(
                  names: chapters.map((c) => c.name).toList(),
                  questionCounts:
                      chapters.map((c) => c.questions.length).toList(),
                  completedFlags: chapters
                      .map((c) => isChapterCompleted(c.name))
                      .toList(),
                  onTap: onSelectChapter,
                ),
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: AppButton(
              label: 'Back to Main Menu',
              style: AppButtonStyle.secondary,
              onPressed: onBack,
            ),
          ),
        ],
      ),
    );
  }
}
