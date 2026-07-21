import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';

/// Apple-style wheel picker presented as a modal sheet.
abstract final class AppleRollerSheet {
  static Future<int?> pickInt({
    required BuildContext context,
    required String title,
    required String unit,
    required int min,
    required int max,
    required int value,
  }) {
    final items = List<int>.generate(max - min + 1, (i) => min + i);
    final initial = value.clamp(min, max);
    return _open<int>(
      context: context,
      title: title,
      unit: unit,
      itemCount: items.length,
      initialIndex: initial - min,
      labelFor: (i) => '${items[i]}',
      valueFor: (i) => items[i],
    );
  }

  /// One decimal place (e.g. weight kg).
  static Future<double?> pickDecimal({
    required BuildContext context,
    required String title,
    required String unit,
    required double min,
    required double max,
    required double value,
    double step = 0.1,
  }) {
    final count = ((max - min) / step).round() + 1;
    final items = List<double>.generate(
      count,
      (i) => double.parse((min + i * step).toStringAsFixed(1)),
    );
    final clamped = value.clamp(min, max);
    var initialIndex =
        ((clamped - min) / step).round().clamp(0, items.length - 1);

    return _open<double>(
      context: context,
      title: title,
      unit: unit,
      itemCount: items.length,
      initialIndex: initialIndex,
      labelFor: (i) => items[i].toStringAsFixed(1),
      valueFor: (i) => items[i],
    );
  }

  static Future<T?> _open<T>({
    required BuildContext context,
    required String title,
    required String unit,
    required int itemCount,
    required int initialIndex,
    required String Function(int index) labelFor,
    required T Function(int index) valueFor,
  }) {
    var selected = initialIndex.clamp(0, itemCount - 1);

    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: 312,
            decoration: const BoxDecoration(
              color: AuraTheme.paper,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: AuraTheme.fontFamily,
                            fontSize: 17,
                            color: AuraTheme.mute,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AuraTheme.fontDisplay,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onPressed: () =>
                            Navigator.of(ctx).pop(valueFor(selected)),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: AuraTheme.fontFamily,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AuraTheme.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selected,
                        ),
                        itemExtent: 36,
                        magnification: 1.12,
                        useMagnifier: true,
                        squeeze: 1.1,
                        onSelectedItemChanged: (i) => selected = i,
                        children: List.generate(itemCount, (i) {
                          return Center(
                            child: Text(
                              labelFor(i),
                              style: const TextStyle(
                                fontFamily: AuraTheme.fontDisplay,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: AuraTheme.ink,
                              ),
                            ),
                          );
                        }),
                      ),
                      IgnorePointer(
                        child: Align(
                          alignment: const Alignment(0.42, 0),
                          child: Text(
                            unit,
                            style: const TextStyle(
                              fontFamily: AuraTheme.fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AuraTheme.mute,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
