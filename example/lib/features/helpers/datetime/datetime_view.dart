import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/datetime/cubit/datetime_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/datetime/cubit/datetime_state.dart';
import 'package:masterfabric_core_example/theme/app_theme.dart';

/// DateTime Helper View - Minimalist design
class DateTimeView extends MasterViewCubit<DateTimeCubit, DateTimeState> {
  DateTimeView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('DateTime'),
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
      DateTimeCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, DateTimeCubit viewModel, DateTimeState state) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final lastWeek = now.subtract(const Duration(days: 7));
    final lastMonth = now.subtract(const Duration(days: 30));
    final lastYear = now.subtract(const Duration(days: 365));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          context,
          title: 'formatDate()',
          items: [
            _Item('yyyy-MM-dd', DateTimeHelper.formatDate(now)),
            _Item('dd/MM/yyyy',
                DateTimeHelper.formatDate(now, pattern: 'dd/MM/yyyy')),
            _Item('MMMM dd, yyyy',
                DateTimeHelper.formatDate(now, pattern: 'MMMM dd, yyyy')),
            _Item('MMM dd', DateTimeHelper.formatDate(now, pattern: 'MMM dd')),
          ],
        ),
        _buildSection(
          context,
          title: 'formatTime()',
          items: [
            _Item('HH:mm', DateTimeHelper.formatTime(now)),
            _Item('hh:mm a',
                DateTimeHelper.formatTime(now, pattern: 'hh:mm a')),
            _Item('HH:mm:ss',
                DateTimeHelper.formatTime(now, pattern: 'HH:mm:ss')),
          ],
        ),
        _buildSection(
          context,
          title: 'formatDateTime()',
          items: [
            _Item('yyyy-MM-dd HH:mm', DateTimeHelper.formatDateTime(now)),
            _Item(
                'EEEE, MMMM dd',
                DateTimeHelper.formatDateTime(now,
                    pattern: 'EEEE, MMMM dd, yyyy')),
          ],
        ),
        _buildSection(
          context,
          title: 'getRelativeTime()',
          items: [
            _Item('30s ago',
                DateTimeHelper.getRelativeTime(now.subtract(const Duration(seconds: 30)))),
            _Item('yesterday', DateTimeHelper.getRelativeTime(yesterday)),
            _Item('7 days ago', DateTimeHelper.getRelativeTime(lastWeek)),
            _Item('30 days ago', DateTimeHelper.getRelativeTime(lastMonth)),
            _Item('365 days ago', DateTimeHelper.getRelativeTime(lastYear)),
          ],
        ),
        _buildSection(
          context,
          title: 'parseDate()',
          items: [
            _Item('2024-12-23',
                DateTimeHelper.parseDate('2024-12-23')?.toString() ?? 'null'),
            _Item(
                '23/12/2024',
                DateTimeHelper.parseDate('23/12/2024', pattern: 'dd/MM/yyyy')
                        ?.toString() ??
                    'null'),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<_Item> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Text(title, style: AppTheme.mono.copyWith(fontSize: 12)),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(item.pattern,
                            style: AppTheme.mono.copyWith(
                                fontSize: 10, color: AppTheme.textMuted)),
                      ),
                      Expanded(
                        child: Text(item.result,
                            style: AppTheme.mono.copyWith(fontSize: 11),
                            textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ),
                if (index < items.length - 1)
                  const Divider(indent: 12, endIndent: 12),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _Item {
  final String pattern;
  final String result;

  _Item(this.pattern, this.result);
}
