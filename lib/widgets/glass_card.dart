import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The frosted-glass "card" container used for every screen, matching:
///
/// ```css
/// .card {
///   background-color: rgba(31, 41, 55, 0.5);
///   backdrop-filter: blur(20px);
///   border: 1px solid rgba(255, 255, 255, 0.2);
///   border-radius: 1.5rem;
///   padding: 2rem;
///   box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
///   color: #f9fafb;
/// }
/// ```
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.cardBase.withOpacity(AppColors.cardOpacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.cardBorder
                  .withOpacity(AppColors.cardBorderOpacity),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.37),
                blurRadius: 32,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(color: Color(0xFFF9FAFB)),
            child: child,
          ),
        ),
      ),
    );
  }
}
