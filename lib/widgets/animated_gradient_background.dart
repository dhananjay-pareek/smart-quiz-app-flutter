import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Slowly shifting diagonal gradient, the Flutter equivalent of:
///
/// ```css
/// body::before {
///   background: linear-gradient(-45deg, #ee7752, #e73c7e, #23a6d5, #23d5ab);
///   background-size: 400% 400%;
///   animation: gradient 12s ease infinite;
///   filter: blur(60px);
/// }
/// ```
///
/// Flutter has no equivalent of an oversized, panning CSS gradient, so this
/// recreates the same *visual effect* (four colors slowly drifting past one
/// another behind a blur) using an [AnimationController] that animates the
/// gradient's alignment back and forth, combined with a blur filter.
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({super.key, required this.child});

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Matches the 12s CSS keyframe duration.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid fallback color, in case the gradient hasn't rendered yet.
        Container(color: AppColors.backgroundFallback),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value; // 0 -> 1 -> 0 (reverse: true)
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.0 + (t * 1.4), -1.0 - (t * 0.6)),
                  end: Alignment(1.0 - (t * 1.4), 1.0 + (t * 0.6)),
                  colors: const [
                    AppColors.gradient1,
                    AppColors.gradient2,
                    AppColors.gradient3,
                    AppColors.gradient4,
                  ],
                ),
              ),
            );
          },
        ),
        // Approximates the CSS `filter: blur(60px)` softness.
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(color: Colors.transparent),
        ),
        widget.child,
      ],
    );
  }
}
