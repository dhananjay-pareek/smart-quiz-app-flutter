import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/glass_card.dart';

class LegalScreen extends StatelessWidget {
  final VoidCallback onBack;

  const LegalScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: onBack,
              ),
              const Expanded(
                child: Text(
                  'Legal Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
          const SizedBox(height: 24),
          _buildLegalItem(
            context,
            'Privacy Policy',
            'How we handle your data.',
            () => _showPolicyDialog(
              context,
              'Privacy Policy',
              _privacyPolicyText,
            ),
          ),
          const SizedBox(height: 16),
          _buildLegalItem(
            context,
            'Terms & Conditions',
            'Rules for using the app.',
            () => _showPolicyDialog(
              context,
              'Terms & Conditions',
              _termsAndConditionsText,
            ),
          ),
          const SizedBox(height: 16),
          _buildLegalItem(
            context,
            'About the App',
            'Version 1.0.0',
            null,
          ),
          const SizedBox(height: 16),
          _buildLegalItem(
            context,
            'Contact Support',
            'support@smartquizapp.com',
            () => _showPolicyDialog(
              context,
              'Contact Support',
              'For support, please email us at support@smartquizapp.com. We will get back to you as soon as possible.',
            ),
          ),
          const SizedBox(height: 16),
          _buildLegalItem(
            context,
            'Rate Our App',
            'Support us on the Play Store',
            () {
              // Once you have the app link, you can use url_launcher to open it.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App link will be available after publishing!')),
              );
            },
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Back to Menu',
            style: AppButtonStyle.secondary,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  void _showPolicyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryBtn)),
          ),
        ],
      ),
    );
  }

  static const String _privacyPolicyText = '''
Privacy Policy

Last Updated: 29 june 2026

1. Information Collection
SmartQuiz App is designed to respect your privacy. We do not collect personally identifiable information from our users.

2. Usage Data
The app may collect non-personal data such as quiz scores and progress, which are stored locally on your device to improve your experience.

3. Third-Party Services
We do not use third-party analytics or advertising services that track your behavior across different apps.

4. Data Security
We prioritize the security of any data stored locally on your device.

5. Changes to This Policy
We may update our Privacy Policy from time to time. You are advised to review this page periodically for any changes.

6. Contact Us
If you have any questions about this Privacy Policy, please contact us.
''';

  static const String _termsAndConditionsText = '''
Terms & Conditions

1. Acceptance of Terms
By using SmartQuiz App, you agree to these terms.

2. Intellectual Property
All content included in the app, such as text, graphics, and logos, is the property of SmartQuiz or its content suppliers.

3. Use License
Permission is granted to use the app for personal, non-commercial use only.

4. Disclaimer
The materials in the app are provided "as is". SmartQuiz makes no warranties, expressed or implied.

5. Limitations
In no event shall SmartQuiz be liable for any damages arising out of the use or inability to use the app.

6. Governing Law
These terms are governed by the laws of your jurisdiction.
''';
}
