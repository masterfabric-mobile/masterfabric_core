import 'package:flutter/material.dart';

import '../../skeleton_config.dart';
import '../skeleton_base.dart';

/// Custom shape skeleton widget using a custom clipper
class SkeletonCustom extends StatelessWidget {
  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double? height;

  /// Custom clipper for the shape
  final CustomClipper<Path> clipper;

  /// Custom skeleton configuration
  final SkeletonConfig? config;

  /// Margin around the skeleton
  final EdgeInsetsGeometry? margin;

  const SkeletonCustom({
    super.key,
    this.width,
    this.height,
    required this.clipper,
    this.config,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBase(
      width: width,
      height: height,
      clipper: clipper,
      config: config,
      margin: margin,
    );
  }
}

/// Star shape clipper for skeleton
class StarClipper extends CustomClipper<Path> {
  /// Number of points on the star
  final int points;

  /// Inner radius ratio (0.0 to 1.0)
  final double innerRadiusRatio;

  StarClipper({
    this.points = 5,
    this.innerRadiusRatio = 0.4,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * innerRadiusRatio;
    final angle = 3.14159 / points;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * _cos(i * angle - 3.14159 / 2);
      final y = center.dy + radius * _sin(i * angle - 3.14159 / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  double _cos(double radians) => (radians * 180 / 3.14159).abs() < 0.0001 ? 1.0 : 
    _cosApprox(radians);
  
  double _sin(double radians) => _sinApprox(radians);

  double _cosApprox(double x) {
    // Normalize to [0, 2π)
    x = x % (2 * 3.14159);
    if (x < 0) x += 2 * 3.14159;
    
    // Use built-in
    return x.abs() < 0.0001 ? 1.0 : 
      (x - 3.14159 / 2).abs() < 0.0001 ? 0.0 :
      (x - 3.14159).abs() < 0.0001 ? -1.0 :
      (x - 3 * 3.14159 / 2).abs() < 0.0001 ? 0.0 :
      _taylorCos(x);
  }

  double _sinApprox(double x) {
    return _cosApprox(x - 3.14159 / 2);
  }

  double _taylorCos(double x) {
    // Taylor series approximation for cos
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Diamond shape clipper for skeleton
class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Hexagon shape clipper for skeleton
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    
    path.moveTo(w * 0.25, 0);
    path.lineTo(w * 0.75, 0);
    path.lineTo(w, h * 0.5);
    path.lineTo(w * 0.75, h);
    path.lineTo(w * 0.25, h);
    path.lineTo(0, h * 0.5);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
