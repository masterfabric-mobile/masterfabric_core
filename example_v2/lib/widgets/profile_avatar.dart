import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initials,
    this.size = 34,
    this.onTap,
  });

  final String initials;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AuraTheme.paper,
        border: Border.all(color: AuraTheme.ink, width: 1.5),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: AuraTheme.fontFamily,
          fontSize: size * 0.34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: AuraTheme.ink,
        ),
      ),
    );

    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: child,
      ),
    );
  }
}
