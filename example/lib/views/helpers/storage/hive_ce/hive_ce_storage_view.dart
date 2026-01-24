import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../../theme/theme_helper.dart';
import '../../../../src/resources/resources.g.dart' as example_resources;
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
              title: Text(example_resources.resources.hivece_storage.title),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: ConditionalIcon(
                        context: context,
                        icon: LucideIcons.arrowLeft,
                      ),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.refreshCw,
                    size: 18,
                  ),
                  onPressed: () => viewModel.loadAllItems(),
                ),
                IconButton(
                  icon: ConditionalIcon(
                    context: context,
                    icon: LucideIcons.trash2,
                    size: 18,
                  ),
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
    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              context,
              title: example_resources.resources.hivece_storage.string,
              keyHint: 'hivece_case_string',
              storedValue: state.storedString,
              onSave: (k, v) => viewModel.saveString(k, v),
            ),
            _buildSection(
              context,
              title: example_resources.resources.hivece_storage.int,
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
              title: example_resources.resources.hivece_storage.double,
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                          fontSize: 10, color: context.textMutedColor)),
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
                        decoration: InputDecoration(hintText: example_resources.resources.hivece_storage.key),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: valCtrl,
                        decoration: InputDecoration(hintText: example_resources.resources.hivece_storage.value),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
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
                        child: Text(example_resources.resources.common.save),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: context.codeBlockDecoration,
                    child: Text(storedValue, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')),
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Text(example_resources.resources.hivece_storage.bool, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                          fontSize: 10, color: context.textMutedColor)),
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
                        decoration: InputDecoration(hintText: example_resources.resources.hivece_storage.key),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
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
                        child: Text(example_resources.resources.hivece_storage.true_value),
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
                        child: Text(example_resources.resources.hivece_storage.false_value),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: context.codeBlockDecoration,
                    child: Text(storedValue.toString(), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')),
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Text(example_resources.resources.hivece_storage.list_string,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(keyHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                          fontSize: 10, color: context.textMutedColor)),
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
                        decoration: InputDecoration(hintText: example_resources.resources.hivece_storage.key),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: valCtrl,
                        decoration:
                            InputDecoration(hintText: example_resources.resources.hivece_storage.list_hint),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
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
                        child: Text(example_resources.resources.common.save),
                      ),
                    ),
                  ],
                ),
                if (storedValue != null && storedValue.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: context.codeBlockDecoration,
                    child: Text('[${storedValue.join(', ')}]',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')),
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Text(example_resources.resources.hivece_storage.get_by_key,
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
                            InputDecoration(hintText: example_resources.resources.hivece_storage.enter_key),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
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
                        child: Text(example_resources.resources.hivece_storage.get),
                      ),
                    ),
                  ],
                ),
                if (retrievedKey != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: context.codeBlockDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('key: $retrievedKey',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono')
                                .copyWith(color: context.textMutedColor)),
                        Text(
                          retrievedValue != null
                              ? 'value: ${_formatValue(retrievedValue)}'
                              : 'value: null',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(
                            color: retrievedValue != null
                                ? context.successColor
                                : context.warningColor,
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
      decoration: context.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Text(example_resources.resources.hivece_storage.all_items,
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(width: 8),
                Text('${items.length}',
                    style: Theme.of(context).textTheme.bodySmall),
                Expanded(child: Container()),
                SizedBox(
                  height: 28,
                  child: TextButton.icon(
                    onPressed: onRefresh,
                    icon: Icon(LucideIcons.refreshCw, size: 14),
                    label: Text(example_resources.resources.common.refresh),
                  ),
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(example_resources.resources.hivece_storage.no_items,
                  style: TextStyle(color: context.textMutedColor, fontSize: 12)),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => Divider(),
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
                            color: context.backgroundColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(entry.key,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Text(
                            _getTypeName(entry.value),
                            style: TextStyle(
                                fontSize: 10, color: context.textMutedColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _formatValue(entry.value),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono').copyWith(fontSize: 11),
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
