import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme/aura_theme.dart';

/// Pinned title bar in the safe area; optional hero sits *under* the bar
/// and collapses with the sliver (not behind the Dynamic Island).
class AuraSliverAppBar extends StatelessWidget {
  const AuraSliverAppBar({
    super.key,
    required this.title,
    this.actions,
    this.hero,
    this.expandedHeight = 200,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? hero;

  /// Hero band height (below the toolbar), not including status bar.
  final double expandedHeight;

  static const double _toolbar = 56;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final hasHero = hero != null;
    final toolbarBand = top + _toolbar;
    final maxExtent = hasHero ? toolbarBand + expandedHeight : toolbarBand;

    return SliverAppBar(
      primary: false,
      pinned: true,
      stretch: hasHero,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AuraTheme.paper,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: toolbarBand,
      expandedHeight: maxExtent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final current = constraints.maxHeight;
          final heroVisible = (current - toolbarBand).clamp(0.0, expandedHeight);

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Column(
              children: [
                // Status bar + pinned toolbar (always readable).
                SizedBox(
                  height: toolbarBand,
                  child: ColoredBox(
                    color: AuraTheme.paper,
                    child: Padding(
                      padding: EdgeInsets.only(top: top),
                      child: SizedBox(
                        height: _toolbar,
                        child: NavigationToolbar(
                          centerMiddle: false,
                          middleSpacing: 12,
                          middle: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontFamily: AuraTheme.fontDisplay,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.4,
                                  color: AuraTheme.ink,
                                ),
                              ),
                            ),
                          ),
                          trailing: actions == null || actions!.isEmpty
                              ? null
                              : IconTheme(
                                  data: const IconThemeData(
                                    color: AuraTheme.ink,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: actions!,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Hero only under the app bar — collapses to zero.
                if (hasHero && heroVisible > 0)
                  SizedBox(
                    height: heroVisible,
                    width: double.infinity,
                    child: ClipRect(child: hero),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
