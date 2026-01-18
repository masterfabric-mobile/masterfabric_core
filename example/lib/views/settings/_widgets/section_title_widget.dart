import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';

/// Section Title Widget - Reusable title for settings sections
class SectionTitleWidget extends StatelessWidget {
  final String title;

  const SectionTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: context.textMutedColor,
            letterSpacing: 0.5,
          ),
    );
  }
}
