import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import 'cubit/svg_cubit.dart';
import 'cubit/svg_state.dart';

/// SVG Helper Demo View
class SvgView extends MasterViewCubit<SvgCubit, SvgState> {
  SvgView({
    super.key,
    required super.goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.svg_helper.title),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(SvgCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(BuildContext context, SvgCubit viewModel, SvgState state) {
    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionCard(
              title: example_resources.resources.svg_helper.asset_svg,
              subtitle: example_resources.resources.svg_helper.asset_svg_desc,
              child: _AssetSvgDemo(state: state, cubit: viewModel),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: example_resources.resources.svg_helper.color_tinting,
              subtitle: example_resources.resources.svg_helper.color_tinting_desc,
              child: _ColorTintingDemo(state: state, cubit: viewModel),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: example_resources.resources.svg_helper.size_variations,
              subtitle: example_resources.resources.svg_helper.size_variations_desc,
              child: _SizeVariationsDemo(state: state, cubit: viewModel),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: example_resources.resources.svg_helper.svg_from_string,
              subtitle: example_resources.resources.svg_helper.svg_from_string_desc,
              child: _SvgFromStringDemo(state: state),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: example_resources.resources.svg_helper.themed_icon,
              subtitle: example_resources.resources.svg_helper.themed_icon_desc,
              child: _ThemedIconDemo(),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: example_resources.resources.svg_helper.using_svg_config,
              subtitle: example_resources.resources.svg_helper.using_svg_config_desc,
              child: _SvgConfigDemo(state: state),
            ),
          ],
        );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                    fontSize: 10,
                    color: context.textMutedColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _AssetSvgDemo extends StatelessWidget {
  final SvgState state;
  final SvgCubit cubit;

  const _AssetSvgDemo({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final icons = [
      ('home.svg', 'Home'),
      ('settings.svg', 'Settings'),
      ('star.svg', 'Star'),
      ('heart.svg', 'Heart'),
      ('user.svg', 'User'),
      ('search.svg', 'Search'),
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: icons.map((icon) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgHelper.fromAsset(
              'assets/svg/${icon.$1}',
              width: 32,
              height: 32,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              icon.$2,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _ColorTintingDemo extends StatelessWidget {
  final SvgState state;
  final SvgCubit cubit;

  const _ColorTintingDemo({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SvgCubit.availableColors.map((color) {
            final isSelected = state.selectedColor == color;
            return GestureDetector(
              onTap: () => cubit.changeColor(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgHelper.fromAsset(
              'assets/svg/star.svg',
              width: 48,
              height: 48,
              color: state.selectedColor,
            ),
            SvgHelper.fromAsset(
              'assets/svg/heart.svg',
              width: 48,
              height: 48,
              color: state.selectedColor,
            ),
            SvgHelper.fromAsset(
              'assets/svg/settings.svg',
              width: 48,
              height: 48,
              color: state.selectedColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Selected: ${_colorName(state.selectedColor)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11, color: context.textMutedColor),
        ),
      ],
    );
  }

  String _colorName(Color color) {
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.indigo) return 'Indigo';
    return 'Custom';
  }
}

class _SizeVariationsDemo extends StatelessWidget {
  final SvgState state;
  final SvgCubit cubit;

  const _SizeVariationsDemo({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: SvgCubit.availableSizes.map((size) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgHelper.fromAsset(
              'assets/svg/home.svg',
              width: size,
              height: size,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              '${size.toInt()}px',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _SvgFromStringDemo extends StatelessWidget {
  final SvgState state;

  const _SvgFromStringDemo({required this.state});

  static const _sampleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
  <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
  <line x1="9" y1="9" x2="15" y2="15"/>
  <line x1="15" y1="9" x2="9" y2="15"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _sampleSvg.trim(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 9),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.arrowDown, size: 16, color: context.textMutedColor),
            const SizedBox(width: 8),
            Text(
              'Rendered:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11, color: context.textMutedColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgHelper.fromString(_sampleSvg, width: 48, height: 48, color: Colors.blue),
            SvgHelper.fromString(_sampleSvg, width: 48, height: 48, color: Colors.red),
            SvgHelper.fromString(_sampleSvg, width: 48, height: 48, color: Colors.green),
          ],
        ),
      ],
    );
  }
}

class _ThemedIconDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Icons automatically use IconTheme color',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11, color: context.textMutedColor),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconTheme(
              data: const IconThemeData(color: Colors.blue, size: 32),
              child: Builder(
                builder: (context) => SvgHelper.themedIcon(
                  context,
                  'assets/svg/home.svg',
                ),
              ),
            ),
            IconTheme(
              data: const IconThemeData(color: Colors.orange, size: 32),
              child: Builder(
                builder: (context) => SvgHelper.themedIcon(
                  context,
                  'assets/svg/star.svg',
                ),
              ),
            ),
            IconTheme(
              data: const IconThemeData(color: Colors.purple, size: 32),
              child: Builder(
                builder: (context) => SvgHelper.themedIcon(
                  context,
                  'assets/svg/heart.svg',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SvgConfigDemo extends StatelessWidget {
  final SvgState state;

  const _SvgConfigDemo({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ConfigRow(
          label: 'SvgConfig.smallIcon',
          description: '24x24',
          child: SvgHelper.fromAsset(
            'assets/svg/settings.svg',
            config: SvgConfig.smallIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 12),
        _ConfigRow(
          label: 'SvgConfig.mediumIcon',
          description: '32x32',
          child: SvgHelper.fromAsset(
            'assets/svg/settings.svg',
            config: SvgConfig.mediumIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 12),
        _ConfigRow(
          label: 'SvgConfig.largeIcon',
          description: '48x48',
          child: SvgHelper.fromAsset(
            'assets/svg/settings.svg',
            config: SvgConfig.largeIcon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '''// Custom config
final myConfig = SvgConfig(
  width: 64,
  height: 64,
  color: Colors.purple,
  fit: BoxFit.contain,
);

SvgHelper.fromAsset(
  'assets/icon.svg',
  config: myConfig,
)''',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

class _ConfigRow extends StatelessWidget {
  final String label;
  final String description;
  final Widget child;

  const _ConfigRow({
    required this.label,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        child,
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11)),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 10, color: context.textMutedColor),
            ),
          ],
        ),
      ],
    );
  }
}
