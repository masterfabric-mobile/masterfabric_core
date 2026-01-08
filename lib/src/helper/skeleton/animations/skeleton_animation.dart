import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../skeleton_config.dart';
import '../models/skeleton_models.dart';

/// Base class for skeleton animations
abstract class SkeletonAnimation extends StatefulWidget {
  /// Child widget to animate
  final Widget child;

  /// Skeleton configuration
  final SkeletonConfig config;

  const SkeletonAnimation({
    super.key,
    required this.child,
    required this.config,
  });

  /// Create appropriate animation based on type
  factory SkeletonAnimation.fromType({
    Key? key,
    required Widget child,
    required SkeletonConfig config,
  }) {
    switch (config.animationType) {
      case SkeletonAnimationType.shimmer:
        return ShimmerAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.pulse:
        return PulseAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.wave:
        return WaveAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.glow:
        return GlowAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.slide:
        return SlideAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.bounce:
        return BounceAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.breathe:
        return BreatheAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.gradientFlow:
        return GradientFlowAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.sparkle:
        return SparkleAnimation(key: key, child: child, config: config);
      case SkeletonAnimationType.none:
        return NoAnimation(key: key, child: child, config: config);
    }
  }
}

/// No animation - static skeleton
class NoAnimation extends SkeletonAnimation {
  const NoAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<NoAnimation> createState() => _NoAnimationState();
}

class _NoAnimationState extends State<NoAnimation> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Shimmer animation - gradient sweep effect
class ShimmerAnimation extends SkeletonAnimation {
  const ShimmerAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.config.curve),
    );

    if (widget.config.enableAnimation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: widget.config.direction.begin,
              end: widget.config.direction.end,
              colors: [
                widget.config.baseColor,
                widget.config.highlightColor,
                widget.config.baseColor,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Pulse animation - fade in/out effect
class PulseAnimation extends SkeletonAnimation {
  const PulseAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.config.curve),
    );

    if (widget.config.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Wave animation - expanding circle wave effect
class WaveAnimation extends SkeletonAnimation {
  const WaveAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    if (widget.config.enableAnimation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            // Create multiple wave rings
            final centerX = bounds.width * (0.3 + progress * 0.4);
            final centerY = bounds.height * 0.5;
            return RadialGradient(
              center: Alignment(
                (centerX / bounds.width) * 2 - 1,
                (centerY / bounds.height) * 2 - 1,
              ),
              radius: 0.5 + progress * 0.8,
              colors: [
                widget.config.highlightColor,
                widget.config.baseColor,
                widget.config.highlightColor.withOpacity(0.5),
                widget.config.baseColor,
              ],
              stops: const [0.0, 0.3, 0.6, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Glow animation - pulsing brightness effect
class GlowAnimation extends SkeletonAnimation {
  const GlowAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<GlowAnimation> createState() => _GlowAnimationState();
}

class _GlowAnimationState extends State<GlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.config.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final intensity = _animation.value;
        // Blend between base and highlight color based on intensity
        final color = Color.lerp(
          widget.config.baseColor,
          widget.config.highlightColor,
          intensity,
        )!;
        
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [color, color],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Slide animation - sliding highlight band
class SlideAnimation extends SkeletonAnimation {
  const SlideAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<SlideAnimation> createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    if (widget.config.enableAnimation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        // Create a thin bright band that slides across
        final bandPosition = progress * 1.4 - 0.2; // -0.2 to 1.2
        
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: widget.config.direction.begin,
              end: widget.config.direction.end,
              colors: [
                widget.config.baseColor,
                widget.config.baseColor,
                widget.config.highlightColor,
                widget.config.baseColor,
                widget.config.baseColor,
              ],
              stops: [
                0.0,
                (bandPosition - 0.1).clamp(0.0, 1.0),
                bandPosition.clamp(0.0, 1.0),
                (bandPosition + 0.1).clamp(0.0, 1.0),
                1.0,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Bounce animation - subtle scale bounce effect
class BounceAnimation extends SkeletonAnimation {
  const BounceAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    // Use a more visible bounce range
    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.config.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Breathe animation - smooth breathing scale + opacity effect
class BreatheAnimation extends SkeletonAnimation {
  const BreatheAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<BreatheAnimation> createState() => _BreatheAnimationState();
}

class _BreatheAnimationState extends State<BreatheAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.config.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Gradient Flow animation - smooth flowing gradient effect
class GradientFlowAnimation extends SkeletonAnimation {
  const GradientFlowAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<GradientFlowAnimation> createState() => _GradientFlowAnimationState();
}

class _GradientFlowAnimationState extends State<GradientFlowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    if (widget.config.enableAnimation) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        // Create a smooth flowing gradient
        final shift = progress * 2 * math.pi;
        
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            // Use sine wave to create smooth color transitions
            final t1 = (math.sin(shift) + 1) / 2;
            final t2 = (math.sin(shift + math.pi / 2) + 1) / 2;
            final t3 = (math.sin(shift + math.pi) + 1) / 2;
            
            return LinearGradient(
              begin: widget.config.direction.begin,
              end: widget.config.direction.end,
              colors: [
                Color.lerp(widget.config.baseColor, widget.config.highlightColor, t1)!,
                Color.lerp(widget.config.baseColor, widget.config.highlightColor, t2)!,
                Color.lerp(widget.config.baseColor, widget.config.highlightColor, t3)!,
                Color.lerp(widget.config.baseColor, widget.config.highlightColor, t1)!,
              ],
              stops: const [0.0, 0.33, 0.66, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Sparkle animation - twinkling sparkle points effect
class SparkleAnimation extends SkeletonAnimation {
  const SparkleAnimation({
    super.key,
    required super.child,
    required super.config,
  });

  @override
  State<SparkleAnimation> createState() => _SparkleAnimationState();
}

class _SparkleAnimationState extends State<SparkleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_SparklePoint> _sparklePoints = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.config.animationDuration,
    );

    // Generate initial sparkle points
    _generateSparklePoints();

    if (widget.config.enableAnimation) {
      _controller.repeat();
    }
  }

  void _generateSparklePoints() {
    _sparklePoints.clear();
    for (int i = 0; i < 8; i++) {
      _sparklePoints.add(_SparklePoint(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        phase: _random.nextDouble() * 2 * math.pi,
        speed: 0.5 + _random.nextDouble() * 1.5,
        size: 0.015 + _random.nextDouble() * 0.025,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.config.enableAnimation) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: _SparklePainter(
            progress: _controller.value,
            sparklePoints: _sparklePoints,
            baseColor: widget.config.baseColor,
            highlightColor: widget.config.highlightColor,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SparklePoint {
  final double x;
  final double y;
  final double phase;
  final double speed;
  final double size;

  _SparklePoint({
    required this.x,
    required this.y,
    required this.phase,
    required this.speed,
    required this.size,
  });
}

class _SparklePainter extends CustomPainter {
  final double progress;
  final List<_SparklePoint> sparklePoints;
  final Color baseColor;
  final Color highlightColor;

  _SparklePainter({
    required this.progress,
    required this.sparklePoints,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final point in sparklePoints) {
      // Use sine wave for smooth twinkling
      final twinkle = (math.sin(progress * 2 * math.pi * point.speed + point.phase) + 1) / 2;
      
      if (twinkle < 0.2) continue; // Skip when too dim
      
      final opacity = twinkle * 0.9;
      final sparkleSize = point.size * size.width * (0.5 + twinkle * 0.5);

      final paint = Paint()
        ..color = highlightColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final center = Offset(
        point.x * size.width,
        point.y * size.height,
      );

      // Draw a four-pointed star sparkle
      _drawSparkle(canvas, center, sparkleSize, paint);
    }
  }

  void _drawSparkle(Canvas canvas, Offset center, double sparkleSize, Paint paint) {
    final path = Path();
    
    // Four-pointed star
    path.moveTo(center.dx, center.dy - sparkleSize);
    path.lineTo(center.dx + sparkleSize * 0.25, center.dy - sparkleSize * 0.25);
    path.lineTo(center.dx + sparkleSize, center.dy);
    path.lineTo(center.dx + sparkleSize * 0.25, center.dy + sparkleSize * 0.25);
    path.lineTo(center.dx, center.dy + sparkleSize);
    path.lineTo(center.dx - sparkleSize * 0.25, center.dy + sparkleSize * 0.25);
    path.lineTo(center.dx - sparkleSize, center.dy);
    path.lineTo(center.dx - sparkleSize * 0.25, center.dy - sparkleSize * 0.25);
    path.close();

    canvas.drawPath(path, paint);
    
    // Add a small bright center
    final centerPaint = Paint()
      ..color = paint.color.withOpacity(paint.color.opacity * 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, sparkleSize * 0.2, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
