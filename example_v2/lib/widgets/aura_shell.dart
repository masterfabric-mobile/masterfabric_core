import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/theme/aura_theme.dart';
import '../src/resources/resources.g.dart' as aura;
import 'aura_space.dart';

enum AuraTab { today, log, body, coach }

class AuraShell extends StatelessWidget {
  const AuraShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AuraTheme.paper,
      child: Column(
        children: [
          Expanded(child: navigationShell),
          _AuraTabBar(
            currentIndex: navigationShell.currentIndex,
            onSelect: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AuraTabBar extends StatelessWidget {
  const _AuraTabBar({
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final t = aura.Translations.of(context);
    final viewPadding = MediaQueryData.fromView(View.of(context)).viewPadding;
    var bottom = viewPadding.bottom;
    if (bottom <= 0) {
      bottom = defaultTargetPlatform == TargetPlatform.iOS ? 28.0 : 10.0;
    }

    final items = <(IconData, String)>[
      (Icons.wb_sunny_outlined, t.tabs.today),
      (Icons.edit_note_outlined, t.tabs.log),
      (Icons.accessibility_new_outlined, t.tabs.body),
      (Icons.chat_bubble_outline, t.tabs.coach),
    ];

    return ColoredBox(
      color: AuraTheme.paper,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ColoredBox(
            color: AuraTheme.line,
            child: SizedBox(height: 1, width: double.infinity),
          ),
          SizedBox(
            height: 56,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onSelect(i),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            items[i].$1,
                            size: 22,
                            color: i == currentIndex
                                ? AuraTheme.ink
                                : AuraTheme.mute,
                          ),
                          AuraSpace.vXs,
                          Text(
                            items[i].$2,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: i == currentIndex
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: i == currentIndex
                                  ? AuraTheme.ink
                                  : AuraTheme.mute,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: bottom > 0 ? bottom : 10),
        ],
      ),
    );
  }
}
