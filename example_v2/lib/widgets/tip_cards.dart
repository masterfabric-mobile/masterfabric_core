import 'package:flutter/material.dart';

import '../app/theme/aura_theme.dart';
import '../data/tip_cards.dart';
import 'aura_space.dart';

/// Horizontal illustrated tip cards — light blog / guide hero style.
class TipCardStrip extends StatelessWidget {
  const TipCardStrip({
    super.key,
    required this.cards,
    this.height = 268,
  });

  final List<TipCardData> cards;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: cards.length,
        separatorBuilder: (context, index) => AuraSpace.hLg,
        itemBuilder: (context, index) => TipStoryCard(
          data: cards[index],
          index: index,
        ),
      ),
    );
  }
}

class TipStoryCard extends StatelessWidget {
  const TipStoryCard({
    super.key,
    required this.data,
    this.index = 0,
  });

  final TipCardData data;
  final int index;

  BorderRadius get _radius {
    return switch (index % 3) {
      0 => const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(14),
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(28),
        ),
      1 => const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(16),
        ),
      _ => const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
    };
  }

  Color get _surface =>
      data.accent == TipCardAccent.mist ? AuraTheme.mist : AuraTheme.paper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 248,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: _radius,
          border: Border.all(color: AuraTheme.line),
        ),
        child: ClipRRect(
          borderRadius: _radius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 132,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: AuraTheme.paper),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Image.asset(
                        data.heroAsset,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stack) => const Center(
                          child: Text(
                            'AURA',
                            style: TextStyle(
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AuraTheme.mist,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AuraTheme.line),
                        ),
                        child: Text(
                          data.tag,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            color: AuraTheme.mute,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.3,
                          color: AuraTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          data.body,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AuraTheme.mute,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
