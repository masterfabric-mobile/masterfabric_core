import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import 'cubit/skeleton_demo_cubit.dart';
import 'cubit/skeleton_demo_state.dart';

/// Skeleton Helper Demo View
class SkeletonView extends MasterViewCubit<SkeletonDemoCubit, SkeletonDemoState> {
  SkeletonView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Skeleton Helper'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
            );
          },
        );

  @override
  Future<void> initialContent(
      SkeletonDemoCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(BuildContext context, SkeletonDemoCubit viewModel,
      SkeletonDemoState state) {
    return BlocBuilder<SkeletonDemoCubit, SkeletonDemoState>(
      bloc: viewModel,
      builder: (context, state) {
        return Column(
          children: [
            _buildTabBar(context, viewModel, state),
            _buildControls(context, viewModel, state),
            const Divider(height: 1),
            Expanded(
              child: SkeletonTheme(
                config: _getConfig(state),
                child: _buildTabContent(state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabBar(
      BuildContext context, SkeletonDemoCubit cubit, SkeletonDemoState state) {
    final tabs = ['Shapes', 'Animations', 'Presets', 'Colors'];

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = state.tabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.setTabIndex(index),
              child: Container(
                margin: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildControls(
      BuildContext context, SkeletonDemoCubit cubit, SkeletonDemoState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Animation:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SkeletonAnimationType.values.map((type) {
                      final isSelected = state.animationType == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => cubit.setAnimationType(type),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1)
                                  : null,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                              ),
                            ),
                            child: Text(
                              type.toJson(),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Theme:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: cubit.toggleDarkTheme,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        state.isDarkTheme ? LucideIcons.moon : LucideIcons.sun,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        state.isDarkTheme ? 'Dark' : 'Light',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(SkeletonDemoState state) {
    final bgColor =
        state.isDarkTheme ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

    return Container(
      color: bgColor,
      child: switch (state.tabIndex) {
        0 => _buildShapesTab(),
        1 => _buildAnimationsTab(),
        2 => _buildPresetsTab(),
        3 => _buildColorsTab(),
        _ => const SizedBox(),
      },
    );
  }

  Widget _buildShapesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection('Basic Shapes', [
          _buildShapeDemo('Rectangle', SkeletonHelper.rectangle(width: 200, height: 40)),
          _buildShapeDemo('Circle', SkeletonHelper.circle(size: 60)),
          _buildShapeDemo('Rounded', SkeletonHelper.rounded(width: 150, height: 50, radius: 16)),
        ]),
        const SizedBox(height: 24),
        _buildSection('Text Shapes', [
          _buildShapeDemo('Text Line', SkeletonHelper.text(width: 180, height: 14)),
          _buildShapeDemo('Paragraph', SkeletonHelper.paragraph(lines: 3)),
        ]),
        const SizedBox(height: 24),
        _buildSection('Avatar Shapes', [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [const SkeletonAvatar.small(), const SizedBox(height: 4), const Text('Small', style: TextStyle(fontSize: 10))]),
              Column(children: [const SkeletonAvatar.medium(), const SizedBox(height: 4), const Text('Medium', style: TextStyle(fontSize: 10))]),
              Column(children: [const SkeletonAvatar.large(), const SizedBox(height: 4), const Text('Large', style: TextStyle(fontSize: 10))]),
              Column(children: [const SkeletonAvatar(size: 48, style: SkeletonAvatarStyle.rounded), const SizedBox(height: 4), const Text('Rounded', style: TextStyle(fontSize: 10))]),
            ],
          ),
        ]),
        const SizedBox(height: 24),
        _buildSection('Custom Shapes', [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SkeletonCustom(width: 60, height: 60, clipper: DiamondClipper()),
              SkeletonCustom(width: 60, height: 60, clipper: HexagonClipper()),
              SkeletonCustom(width: 60, height: 60, clipper: StarClipper()),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Diamond', style: TextStyle(fontSize: 10)),
              Text('Hexagon', style: TextStyle(fontSize: 10)),
              Text('Star', style: TextStyle(fontSize: 10)),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _buildAnimationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: SkeletonAnimationType.values.map((type) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(type.name[0].toUpperCase() + type.name.substring(1), style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(type.description, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              const SizedBox(height: 12),
              SkeletonTheme(
                config: SkeletonConfig(animationType: type),
                child: SkeletonHelper.listItem(lines: 2),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPresetsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection('List Items', [
          SkeletonHelper.listItem(),
          const Divider(),
          const SkeletonListItem.simple(),
          const Divider(),
          const SkeletonListItem.dense(),
        ]),
        const SizedBox(height: 24),
        _buildSection('Cards', [
          SkeletonHelper.card(imageHeight: 120, lines: 2),
          const SizedBox(height: 16),
          SkeletonHelper.cardHorizontal(imageWidth: 100),
        ]),
        const SizedBox(height: 24),
        _buildSection('Profile', [const SkeletonProfile.centered()]),
        const SizedBox(height: 24),
        _buildSection('Social Post', [SkeletonHelper.socialPost(imageHeight: 200)]),
        const SizedBox(height: 24),
        _buildSection('Stories', [SkeletonHelper.storyRow(count: 4)]),
        const SizedBox(height: 24),
        _buildSection('Product Cards', [SkeletonHelper.productGrid(itemCount: 2, crossAxisCount: 2)]),
        const SizedBox(height: 24),
        _buildSection('Article', [const SkeletonArticle.compact()]),
      ],
    );
  }

  Widget _buildColorsTab() {
    final colors = [
      ('Grey', const Color(0xFFE0E0E0), const Color(0xFFF5F5F5)),
      ('Blue', const Color(0xFFBBDEFB), const Color(0xFFE3F2FD)),
      ('Green', const Color(0xFFC8E6C9), const Color(0xFFE8F5E9)),
      ('Purple', const Color(0xFFE1BEE7), const Color(0xFFF3E5F5)),
      ('Orange', const Color(0xFFFFE0B2), const Color(0xFFFFF3E0)),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Color Themes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        ...colors.map((color) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(width: 20, height: 20, decoration: BoxDecoration(color: color.$2, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 8),
                    Text(color.$1, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                SkeletonTheme(
                  config: SkeletonConfig(baseColor: color.$2, highlightColor: color.$3),
                  child: SkeletonHelper.listItem(lines: 2),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 24),
        const Text('Dark Theme', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
          child: SkeletonTheme(
            config: SkeletonConfig.dark(),
            child: Column(
              children: [
                SkeletonHelper.listItem(),
                const SizedBox(height: 12),
                SkeletonHelper.paragraph(lines: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildShapeDemo(String label, Widget skeleton) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 11))),
          Expanded(child: skeleton),
        ],
      ),
    );
  }

  SkeletonConfig _getConfig(SkeletonDemoState state) {
    return state.isDarkTheme
        ? SkeletonConfig.dark(animationType: state.animationType)
        : SkeletonConfig.light(animationType: state.animationType);
  }
}
