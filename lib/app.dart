import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'models/chapter.dart';
import 'models/question.dart';
import 'screens/add_questions_screen.dart';
import 'screens/chapter_selection_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/quiz_complete_screen.dart';
import 'screens/quiz_screen.dart';
import 'services/quiz_data_service.dart';
import 'widgets/animated_gradient_background.dart';
import 'widgets/confirm_dialog.dart';

enum AppView {
  mainMenu,
  chapterSelection,
  quiz,
  quizComplete,
  addQuestions,
}

/// Root stateful controller for the whole app.
///
/// This is the direct Flutter counterpart of the `App` object in the
/// original script.js: it owns the same state fields (`chapters`,
/// `quizQueue`, `currentQuestionIndex`, `selectedChapterIndex`, `score`,
/// `totalInitialQuestions`, `incorrectlyAnswered`) and the same methods
/// (`switchView`, `startChapterQuiz`, `handleAnswer`, `skipQuestion`,
/// `completeQuiz`, `loadChapters`, `saveCustomQuestion`,
/// `saveBulkQuestions`, progress-tracking helpers, and the confirm modal),
/// just expressed with Flutter state management instead of DOM
/// manipulation.
class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  final QuizDataService _dataService = QuizDataService();
  final Random _random = Random();

  // ---- STATE (mirrors `App.state` in script.js) ----
  AppView _currentView = AppView.mainMenu;
  List<Chapter> _chapters = [];
  List<Question> _quizQueue = [];
  int _currentQuestionIndex = 0;
  int _selectedChapterIndex = -1;
  int _score = 0;
  int _totalInitialQuestions = 0;
  final List<Question> _incorrectlyAnswered = [];

  Map<String, dynamic> _chapterProgress = {};
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  // ---- INITIALIZATION (mirrors `App.init()`) ----
  Future<void> _init() async {
    await _loadChapters();
  }

  // ---- CONTENT LOADING (mirrors `App.loadChapters()`) ----
  Future<void> _loadChapters() async {
    try {
      final chapters = await _dataService.loadChapters();
      final progress = await _dataService.getChapterProgress();
      setState(() {
        _chapters = chapters;
        _chapterProgress = progress;
        _isLoading = false;
        _loadError = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _loadError =
            "Could not load quiz content. Please ensure 'chapters.json' "
            "and chapter files exist and are correct.";
      });
    }
  }

  // ---- VIEW MANAGEMENT (mirrors `App.switchView()`) ----
  void _switchView(AppView view) {
    setState(() => _currentView = view);
  }

  bool _isChapterCompleted(String chapterName) {
    return _dataService.isChapterCompleted(_chapterProgress, chapterName);
  }

  int _getCompletedChaptersCount() {
    return _dataService.getCompletedChaptersCount(_chapterProgress);
  }

  // ---- QUIZ LOGIC (mirrors `App.startChapterQuiz()`) ----
  Future<void> _startChapterQuiz(int chapterIndex) async {
    if (chapterIndex < 0 || chapterIndex >= _chapters.length) return;
    final chapter = _chapters[chapterIndex];

    if (chapter.questions.isEmpty) {
      await showConfirmModal(
        context,
        'This chapter has no questions.',
        () => _switchView(AppView.chapterSelection),
      );
      return;
    }

    // Deep copy + shuffle, matching:
    // JSON.parse(JSON.stringify(chapter.questions)).sort(() => Math.random() - 0.5)
    final shuffled = chapter.questions.map((q) => q.copy()).toList()
      ..shuffle(_random);

    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _selectedChapterIndex = chapterIndex;
      _incorrectlyAnswered.clear();
      _quizQueue = shuffled;
      _totalInitialQuestions = shuffled.length;
      _currentView = AppView.quiz;
    });
  }

  // ---- (mirrors `App.handleAnswer()`) ----
  void _handleAnswer(int selectedIndex, bool isCorrect) {
    final question = _quizQueue[_currentQuestionIndex];

    if (isCorrect) {
      setState(() => _score++);
    } else {
      setState(() => _incorrectlyAnswered.add(question));
    }

    // Matches the original 1500ms delay before advancing.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _advanceToNextQuestion();
    });
  }

  // ---- (mirrors `App.skipQuestion()`) ----
  void _skipQuestion() {
    if (_currentQuestionIndex >= _quizQueue.length) return;
    final skippedQuestion = _quizQueue[_currentQuestionIndex];
    setState(() => _incorrectlyAnswered.add(skippedQuestion));
    _advanceToNextQuestion();
  }

  void _advanceToNextQuestion() {
    setState(() => _currentQuestionIndex++);
    if (_currentQuestionIndex >= _quizQueue.length) {
      _completeQuiz();
    }
  }

  // ---- (mirrors `App.completeQuiz()`) ----
  Future<void> _completeQuiz() async {
    if (_selectedChapterIndex >= 0 &&
        _selectedChapterIndex < _chapters.length) {
      final currentChapter = _chapters[_selectedChapterIndex];
      final updatedProgress =
          await _dataService.markChapterAsCompleted(currentChapter.name);
      setState(() => _chapterProgress = updatedProgress);
    }
    setState(() => _currentView = AppView.quizComplete);
  }

  // ---- (mirrors `App.saveBulkQuestions()`) ----
  /// Returns `null` on success, or an error message string on failure.
  Future<String?> _saveBulkQuestions(String jsonInput) async {
    final trimmed = jsonInput.trim();
    if (trimmed.isEmpty) {
      return 'Textarea is empty.';
    }

    try {
      final dynamic bulkData = jsonDecode(trimmed);

      if (bulkData is! List) {
        throw const FormatException(
            'Invalid format. Must be an array of chapters.');
      }
      for (final c in bulkData) {
        if (c is! Map ||
            c['name'] == null ||
            (c['name'] is! String) ||
            c['questions'] is! List) {
          throw const FormatException(
              'Invalid format. Must be an array of chapters.');
        }
      }

      for (final c in bulkData) {
        final map = c as Map<String, dynamic>;
        final chapterName = map['name'] as String;
        final questionsList = map['questions'] as List;
        for (final q in questionsList) {
          final newQuestion = Question.fromJson(q as Map<String, dynamic>);
          await _dataService.saveCustomQuestion(
              chapterName, newQuestion, _chapters);
        }
      }

      setState(() {}); // refresh chapter list / counts after merge
      return null;
    } catch (e) {
      final message = e is FormatException
          ? e.message
          : 'Invalid format. Must be an array of chapters.';
      return 'Error: $message';
    }
  }

  // ---- RENDERING (mirrors `App.render()`) ----
  Widget _buildCurrentView() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_loadError != null) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Error',
              style: TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _loadError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFFCA5A5)),
            ),
          ],
        ),
      );
    }

    switch (_currentView) {
      case AppView.mainMenu:
        return MainMenuScreen(
          totalChapters: _chapters.length,
          completedChapters: _getCompletedChaptersCount(),
          onStartQuiz: () => _switchView(AppView.chapterSelection),
          onAddQuestions: () => _switchView(AppView.addQuestions),
        );

      case AppView.chapterSelection:
        return ChapterSelectionScreen(
          chapters: _chapters,
          isChapterCompleted: _isChapterCompleted,
          onSelectChapter: _startChapterQuiz,
          onBack: () => _switchView(AppView.mainMenu),
        );

      case AppView.quiz:
        if (_currentQuestionIndex >= _quizQueue.length) {
          // Safety net; completeQuiz() should already have fired.
          return const SizedBox.shrink();
        }
        final question = _quizQueue[_currentQuestionIndex];
        final progress = _totalInitialQuestions > 0
            ? (_currentQuestionIndex / _totalInitialQuestions) * 100
            : 0.0;
        return QuizScreen(
          // Fresh key per question resets the per-question answer state.
          key: ValueKey('question_$_currentQuestionIndex'),
          question: question,
          questionNumber: _currentQuestionIndex + 1,
          totalQuestions: _quizQueue.length,
          score: _score,
          progressPercent: progress,
          onAnswer: _handleAnswer,
          onSkip: _skipQuestion,
          onHome: () => showConfirmModal(
            context,
            'End quiz and return home? Progress will be lost.',
            () => _switchView(AppView.mainMenu),
          ),
        );

      case AppView.quizComplete:
        return QuizCompleteScreen(
          score: _score,
          totalQuestions: _totalInitialQuestions,
          incorrectlyAnswered: _incorrectlyAnswered,
          onPlayAgain: () => _startChapterQuiz(_selectedChapterIndex),
          onBackToMenu: () => _switchView(AppView.mainMenu),
        );

      case AppView.addQuestions:
        return AddQuestionsScreen(
          onSaveBulk: _saveBulkQuestions,
          onBack: () => _switchView(AppView.mainMenu),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: _buildCurrentView(),
            ),
          ),
        ),
      ),
    );
  }
}
