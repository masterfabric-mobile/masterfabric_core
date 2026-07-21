import 'dart:async';

import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';

/// Cycles three Log hero arts — edge-to-edge, no crop (fitWidth).
class LogHeroRotator extends StatefulWidget {
  const LogHeroRotator({super.key});

  static const assets = [
    'assets/illustrations/log/log_hero_1.webp',
    'assets/illustrations/log/log_hero_2.webp',
    'assets/illustrations/log/log_hero_3.webp',
  ];

  @override
  State<LogHeroRotator> createState() => _LogHeroRotatorState();
}

class _LogHeroRotatorState extends State<LogHeroRotator> {
  var _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % LogHeroRotator.assets.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AuraTheme.paper,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 900),
        reverseDuration: const Duration(milliseconds: 700),
        switchInCurve: Curves.easeInOutCubic,
        switchOutCurve: Curves.easeInOutCubic,
        transitionBuilder: (child, animation) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(opacity: fade, child: child);
        },
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              ...previousChildren,
              ?currentChild,
            ],
          );
        },
        child: Image.asset(
          LogHeroRotator.assets[_index],
          key: ValueKey(_index),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fitWidth,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
