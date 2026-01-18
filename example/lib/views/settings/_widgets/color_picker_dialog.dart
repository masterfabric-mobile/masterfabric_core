import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../theme/theme_helper.dart';

/// Color Picker Dialog Widget - Platform-adaptive color picker
class ColorPickerDialog {
  /// Show color picker dialog
  static void show({
    required BuildContext context,
    required Color currentColor,
    required Function(Color) onColorSelected,
  }) {
    final themeState = context.themeState;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    
    final colors = [
      themeState.primaryColor,
      themeState.secondaryColor,
      themeState.accentColor,
      themeState.successColor,
      themeState.warningColor,
      themeState.errorColor,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];

    if (isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text(
            'Select Color',
            style: TextStyle(
              fontSize: context.scaledFontSize(13),
              fontWeight: FontWeight.w600,
            ),
          ),
          message: Container(
            padding: const EdgeInsets.only(top: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: colors.map((color) {
                final isSelected = color.toARGB32() == currentColor.toARGB32();
                return GestureDetector(
                  onTap: () {
                    onColorSelected(color);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? context.accentColor : context.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Color',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: colors.map((color) {
                  final isSelected = color.toARGB32() == currentColor.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      onColorSelected(color);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? context.accentColor : context.borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    }
  }
}
