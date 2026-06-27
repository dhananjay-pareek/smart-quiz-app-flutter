import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_button.dart';

/// Glass-styled confirmation dialog, matching `#confirm-modal` in bg.css
/// (dark blurred overlay + a slightly more opaque glass card with a
/// Cancel / OK button pair).
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmDialog({
    super.key,
    this.title = 'Confirmation',
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            width: 360,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937).withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: 'Cancel',
                      style: AppButtonStyle.secondary,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    const SizedBox(width: 16),
                    AppButton(
                      label: 'OK',
                      style: AppButtonStyle.primary,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the confirm dialog and runs [onConfirm] if the user taps OK.
/// Mirrors the original `showConfirmModal(message, onConfirmCallback)`.
Future<void> showConfirmModal(
  BuildContext context,
  String message,
  VoidCallback onConfirm, {
  String title = 'Confirmation',
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierColor: const Color(0x80111827),
    builder: (_) => ConfirmDialog(title: title, message: message),
  );
  if (confirmed == true) onConfirm();
}
