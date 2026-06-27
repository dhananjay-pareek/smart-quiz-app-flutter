import 'question.dart';

/// Represents a quiz chapter/topic.
///
/// Mirrors the JSON structure used by the original web app, where each
/// chapter file contains a one-item array like:
/// [
///   { "name": "Introduction to Programming", "questions": [ ... ] }
/// ]
class Chapter {
  final String name;
  final List<Question> questions;

  Chapter({required this.name, required this.questions});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      name: (json['name'] as String?) ?? '',
      questions: (json['questions'] as List<dynamic>? ?? const [])
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'questions': questions.map((q) => q.toJson()).toList(),
      };

  /// Lowercased + trimmed key used for case-insensitive chapter name
  /// comparisons, matching the original JS `name.trim().toLowerCase()`.
  String get normalizedName => name.trim().toLowerCase();
}
