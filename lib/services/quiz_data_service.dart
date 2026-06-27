import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chapter.dart';
import '../models/question.dart';

/// Handles loading chapter content from bundled assets and persisting
/// custom questions / chapter-completion progress.
///
/// This is the Flutter equivalent of the original `loadChapters`,
/// `saveCustomQuestion`, `getChapterProgress`, `markChapterAsCompleted`,
/// `isChapterCompleted` and `getCompletedChaptersCount` methods from
/// script.js. `localStorage` is replaced with `shared_preferences`.
class QuizDataService {
  static const String _chaptersIndexAsset = 'assets/chapters.json';
  static const String _chaptersDirAsset = 'assets/chapters/';
  static const String _customQuestionsKey = 'customQuizQuestions';
  static const String _chapterProgressKey = 'chapterProgress';

  /// Loads the base chapters bundled as assets, then merges in any
  /// custom questions previously saved by the user.
  Future<List<Chapter>> loadChapters() async {
    final List<Chapter> chapters = [];

    // 1. Load base chapters from bundled JSON asset files.
    final indexString = await rootBundle.loadString(_chaptersIndexAsset);
    final List<dynamic> chapterFiles = jsonDecode(indexString) as List<dynamic>;

    for (final fileName in chapterFiles) {
      try {
        final fileString =
            await rootBundle.loadString('$_chaptersDirAsset$fileName');
        final List<dynamic> arr = jsonDecode(fileString) as List<dynamic>;
        for (final item in arr) {
          chapters.add(Chapter.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {
        // Mirrors the original `.then(res => res.ok ? res.json() : null)`
        // filter — a failed/missing chapter file is simply skipped.
      }
    }

    // 2. Load custom-added questions from local storage and merge them.
    final prefs = await SharedPreferences.getInstance();
    final customData = prefs.getString(_customQuestionsKey);
    if (customData != null) {
      final List<dynamic> customChaptersJson =
          jsonDecode(customData) as List<dynamic>;
      for (final cj in customChaptersJson) {
        final customChapter = Chapter.fromJson(cj as Map<String, dynamic>);
        final existingIndex = chapters
            .indexWhere((c) => c.normalizedName == customChapter.normalizedName);
        if (existingIndex != -1) {
          chapters[existingIndex].questions.addAll(customChapter.questions);
        } else {
          chapters.add(customChapter);
        }
      }
    }

    return chapters;
  }

  /// Saves a single custom question under [chapterName], merging into an
  /// existing chapter (case-insensitively) or creating a new one — both in
  /// persistent storage and in the supplied in-memory [liveChapters] list,
  /// matching the original `saveCustomQuestion` behaviour.
  Future<void> saveCustomQuestion(
    String chapterName,
    Question newQuestion,
    List<Chapter> liveChapters,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final customData = prefs.getString(_customQuestionsKey);
    final List<dynamic> customChapters =
        customData != null ? jsonDecode(customData) as List<dynamic> : [];

    Map<String, dynamic>? target;
    for (final c in customChapters) {
      final map = c as Map<String, dynamic>;
      final name = (map['name'] as String?)?.trim().toLowerCase() ?? '';
      if (name == chapterName.trim().toLowerCase()) {
        target = map;
        break;
      }
    }

    if (target != null) {
      (target['questions'] as List<dynamic>).add(newQuestion.toJson());
    } else {
      customChapters.add({
        'name': chapterName,
        'questions': [newQuestion.toJson()],
      });
    }

    await prefs.setString(_customQuestionsKey, jsonEncode(customChapters));

    // Update the live in-memory state for the current session.
    final liveIndex = liveChapters.indexWhere(
      (c) => c.normalizedName == chapterName.trim().toLowerCase(),
    );
    if (liveIndex != -1) {
      liveChapters[liveIndex].questions.add(newQuestion);
    } else {
      liveChapters.add(Chapter(name: chapterName, questions: [newQuestion]));
    }
  }

  /// Reads the chapter-completion progress map from local storage.
  /// Keys are normalized (trimmed + lowercased) chapter names.
  Future<Map<String, dynamic>> getChapterProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_chapterProgressKey);
    return data != null
        ? Map<String, dynamic>.from(jsonDecode(data) as Map)
        : <String, dynamic>{};
  }

  /// Marks [chapterName] as completed with the current timestamp.
  Future<Map<String, dynamic>> markChapterAsCompleted(
      String chapterName) async {
    final prefs = await SharedPreferences.getInstance();
    final progress = await getChapterProgress();
    progress[chapterName.trim().toLowerCase()] = {
      'completed': true,
      'completedAt': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_chapterProgressKey, jsonEncode(progress));
    return progress;
  }

  /// Whether [chapterName] has previously been completed.
  bool isChapterCompleted(
      Map<String, dynamic> progress, String chapterName) {
    final entry = progress[chapterName.trim().toLowerCase()];
    if (entry == null) return false;
    return entry is Map && entry['completed'] == true;
  }

  /// Total number of chapters ever marked completed.
  int getCompletedChaptersCount(Map<String, dynamic> progress) {
    return progress.values
        .where((p) => p is Map && p['completed'] == true)
        .length;
  }
}
