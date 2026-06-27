import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';

/// The "Add Custom Questions" view, matching `#add-questions-view`.
class AddQuestionsScreen extends StatefulWidget {
  final Future<String?> Function(String jsonInput) onSaveBulk;
  final VoidCallback onBack;

  const AddQuestionsScreen({
    super.key,
    required this.onSaveBulk,
    required this.onBack,
  });

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _feedback = '';
  bool _success = false;
  bool _saving = false;

  static const String _samplePrompt = '''[
  {
    "name": "[Topic Name]",
    "questions": [
      {
        "type": "mcq",
        "text": "This is the question text?",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "answer": 0
      },
      {
        "type": "tf",
        "text": "This is a true or false statement.",
        "options": ["True", "False"],
        "answer": 0
      }
    ]
  }
]''';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _saving = true);
    final result = await widget.onSaveBulk(_controller.text);
    setState(() {
      _saving = false;
      if (result == null) {
        _feedback = 'Bulk questions added successfully!';
        _success = true;
        _controller.clear();
      } else {
        _feedback = result;
        _success = false;
      }
    });
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
      filled: true,
      fillColor: Colors.black.withOpacity(0.2),
      contentPadding: const EdgeInsets.all(14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryBtn, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Custom Questions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bulk Add Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Paste this prompt and generate questions.\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Hello! I am creating a quiz app and need a set of '
                            'questions for the topic: [Topic Name].\n\n'
                            'Please provide a minimum of 25-30 questions in a '
                            'single JSON array. The questions should be a mix of '
                            'multiple-choice (mcq) and true/false (tf) types and '
                            'should be suitable for someone learning the topic, '
                            'potentially including interview-style questions.\n\n'
                            'The JSON structure must follow this exact format, '
                            'with the "type" key appearing before the "text" key '
                            'inside each question object:',
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _samplePrompt,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  minLines: 6,
                  maxLines: 10,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  decoration: _fieldDecoration('Paste your JSON here...'),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: _saving ? 'Saving...' : 'Save Bulk Questions',
                  onPressed: _saving ? null : _handleSave,
                  width: double.infinity,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 18,
                  child: Text(
                    _feedback,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _success
                          ? AppColors.correctText
                          : const Color(0xFFFCA5A5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: AppButton(
              label: 'Back to Main Menu',
              style: AppButtonStyle.secondary,
              onPressed: widget.onBack,
            ),
          ),
        ],
      ),
    );
  }
}
