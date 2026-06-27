/// Represents a single quiz question.
///
/// Mirrors the JSON question objects used by the original web app:
/// {
///   "type": "mcq" | "tf",
///   "text": "Question text?",
///   "options": ["Option A", "Option B", ...],
///   "answer": 0
/// }
class Question {
  final String type;
  final String text;
  final List<String> options;
  final int answer;

  Question({
    required this.type,
    required this.text,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: (json['type'] as String?) ?? 'mcq',
      text: (json['text'] as String?) ?? '',
      options: (json['options'] as List<dynamic>? ?? const [])
          .map((o) => o.toString())
          .toList(),
      answer: (json['answer'] is int)
          ? json['answer'] as int
          : int.tryParse('${json['answer']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'text': text,
        'options': options,
        'answer': answer,
      };

  /// Creates a copy of this question (used when building a shuffled quiz
  /// queue so the original chapter data is never mutated).
  Question copy() => Question(
        type: type,
        text: text,
        options: List<String>.from(options),
        answer: answer,
      );
}
