import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'example_ui.dart';

/// Shell for the four main tabs — owns a single bottom bar.
///
/// Uses a [Column] (not a nested [Scaffold]) so each tab's own scaffold
/// gets a correct height above the tab bar.
class ExampleShell extends StatelessWidget {
  const ExampleShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final tab = ExampleMainTab.values[navigationShell.currentIndex.clamp(
      0,
      ExampleMainTab.values.length - 1,
    )];

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Expanded(child: navigationShell),
          ExampleUi.mainBottomBar(
            context,
            current: tab,
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
