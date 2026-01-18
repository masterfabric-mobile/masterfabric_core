import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../theme/theme_helper.dart';

/// Color Picker Item Widget - Displays a color option in the color picker list
class ColorPickerItem extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ColorPickerItem({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: context.borderColor),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ConditionalIcon(
                context: context,
                icon: LucideIcons.chevronRight,
                size: 14,
                color: context.textMutedColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
