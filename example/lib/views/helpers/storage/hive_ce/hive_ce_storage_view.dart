import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../../theme/app_theme.dart';
import 'cubit/hive_ce_storage_cubit.dart';
import 'cubit/hive_ce_storage_state.dart';

/// HiveCE Storage Cases View
class HiveCeStorageView
    extends MasterViewCubit<HiveCeStorageCubit, HiveCeStorageState> {
  HiveCeStorageView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('HiveCE Storage'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw, size: 18),
                  onPressed: () => viewModel.loadAllItems(),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18),
                  onPressed: () => viewModel.clearStorage(),
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(
      HiveCeStorageCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(BuildContext context, HiveCeStorageCubit viewModel,
      HiveCeStorageState state) {
    return BlocBuilder<HiveCeStorageCubit, HiveCeStorageState>(
      bloc: viewModel,
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              context,
              title: 'String',
              keyHint: 'hivece_case_string',
              storedValue: state.storedString,
              onSave: (k, v) => viewModel.saveString(k, v),
            ),
            _buildSection(
              context,
              title: 'Int',
              keyHint: 'hivece_case_int',
              storedValue: state.storedInt?.toString(),
              onSave: (k, v) {
                final intVal = int.tryParse(v);
                if (intVal != null) viewModel.saveInt(k, intVal);
              },
              keyboardType: TextInputType.number,
            ),
            _buildSection(
              context,
              title: 'Double',
              keyHint: 'hivece_case_double',
              storedValue: state.storedDouble?.toString(),
              onSave: (k, v) {
                final doubleVal = double.tryParse(v);
                if (doubleVal != null) viewModel.saveDouble(k, doubleVal);
              },
              keyboardType: TextInputType.number,
            ),
            _buildBoolSection(
              context,
              keyHint: 'hivece_case_bool',
              storedValue: state.storedBool,
              onSave: (k, v) => viewModel.saveBool(k, v),
            ),
            _buildListSection(
              context,
              keyHint: 'hivece_case_string_list',
              storedValue: state.storedStringList,
              onSave: (k, v) => viewModel.saveStringList(k, v),
            ),
            _buildGetByKeySection(
              context,
              retrievedKey: state.retrievedKey,
              retrievedValue: state.retrievedValue,
              onGet: (k) => viewModel.getByKey(k),
            ),
            _buildAllItemsSection(
              context,
              allItems: state.allItems,
              onRefresh: () => viewModel.loadAllItems(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String keyHint,
    required String? storedValue,
    required Function(String key, String value) onSave,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final keyCtrl = TextEditingController();
    final valCtrl = TextEditingController();

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
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: AppTheme.mono.copyWith(
                          fontSize: 10, color: AppTheme.textMuted)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyCtrl,
                        decoration: const InputDecoration(hintText: 'key'),
                        style: AppTheme.mono,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: valCtrl,
                        decoration: const InputDecoration(hintText: 'value'),
                        style: AppTheme.mono,
                        keyboardType: keyboardType,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty &&
                              valCtrl.text.isNotEmpty) {
                            onSave(keyCtrl.text, valCtrl.text);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: AppTheme.codeBlock,
                    child: Text(storedValue, style: AppTheme.mono),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoolSection(
    BuildContext context, {
    required String keyHint,
    required bool? storedValue,
    required Function(String key, bool value) onSave,
  }) {
    final keyCtrl = TextEditingController();

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
            child: Row(
              children: [
                Text('Bool', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: AppTheme.mono.copyWith(
                          fontSize: 10, color: AppTheme.textMuted)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyCtrl,
                        decoration: const InputDecoration(hintText: 'key'),
                        style: AppTheme.mono,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty) {
                            onSave(keyCtrl.text, true);
                          }
                        },
                        child: const Text('true'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 36,
                      child: OutlinedButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty) {
                            onSave(keyCtrl.text, false);
                          }
                        },
                        child: const Text('false'),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: AppTheme.codeBlock,
                    child: Text(storedValue.toString(), style: AppTheme.mono),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(
    BuildContext context, {
    required String keyHint,
    required List<String>? storedValue,
    required Function(String key, List<String> value) onSave,
  }) {
    final keyCtrl = TextEditingController();
    final valCtrl = TextEditingController();

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
            child: Row(
              children: [
                Text('List<String>',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: AppTheme.mono.copyWith(
                          fontSize: 10, color: AppTheme.textMuted)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyCtrl,
                        decoration: const InputDecoration(hintText: 'key'),
                        style: AppTheme.mono,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: valCtrl,
                        decoration:
                            const InputDecoration(hintText: 'a, b, c'),
                        style: AppTheme.mono,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty &&
                              valCtrl.text.isNotEmpty) {
                            final list = valCtrl.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                            onSave(keyCtrl.text, list);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null && storedValue.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: AppTheme.codeBlock,
                    child: Text('[${storedValue.join(', ')}]',
                        style: AppTheme.mono),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetByKeySection(
    BuildContext context, {
    required String? retrievedKey,
    required dynamic retrievedValue,
    required Function(String key) onGet,
  }) {
    final keyCtrl = TextEditingController();

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
            child: Text('Get by Key',
                style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: keyCtrl,
                        decoration:
                            const InputDecoration(hintText: 'enter key'),
                        style: AppTheme.mono,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          if (keyCtrl.text.isNotEmpty) {
                            onGet(keyCtrl.text);
                          }
                        },
                        child: const Text('Get'),
                      ),
                    ),
                  ],
                ),
                if (retrievedKey != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: AppTheme.codeBlock,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('key: $retrievedKey',
                            style: AppTheme.mono
                                .copyWith(color: AppTheme.textMuted)),
                        Text(
                          retrievedValue != null
                              ? 'value: ${_formatValue(retrievedValue)}'
                              : 'value: null',
                          style: AppTheme.mono.copyWith(
                            color: retrievedValue != null
                                ? AppTheme.success
                                : AppTheme.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllItemsSection(
    BuildContext context, {
    required Map<String, dynamic>? allItems,
    required VoidCallback onRefresh,
  }) {
    final items = allItems ?? {};

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
            child: Row(
              children: [
                Text('All Items',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Text('${items.length}',
                    style: Theme.of(context).textTheme.bodySmall),
                Expanded(child: Container()),
                SizedBox(
                  height: 28,
                  child: TextButton.icon(
                    onPressed: onRefresh,
                    icon: const Icon(LucideIcons.refreshCw, size: 14),
                    label: const Text('Refresh'),
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No items',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final entry = items.entries.elementAt(index);
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.bg,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(entry.key,
                              style: AppTheme.mono.copyWith(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            _getTypeName(entry.value),
                            style: const TextStyle(
                                fontSize: 10, color: AppTheme.textMuted),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatValue(entry.value),
                            style: AppTheme.mono.copyWith(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is List) return '[${value.join(', ')}]';
    return value.toString();
  }

  String _getTypeName(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'List';
    return value.runtimeType.toString();
  }
}
