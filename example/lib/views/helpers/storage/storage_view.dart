import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/app_theme.dart';
import 'cubit/storage_cubit.dart';
import 'cubit/storage_state.dart';

/// Local Storage Helper View - Minimalist design
class StorageView extends MasterViewCubit<StorageCubit, StorageState> {
  StorageView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('Local Storage'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => GoRouter.of(context).pop(),
                    )
                  : null,
              actions: [
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
      StorageCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(
      BuildContext context, StorageCubit viewModel, StorageState state) {
    return BlocBuilder<StorageCubit, StorageState>(
      bloc: viewModel,
      builder: (context, state) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              context,
              title: 'String',
              keyHint: 'case_string',
              storedValue: state.storedString,
              onSave: (k, v) => viewModel.saveString(k, v),
            ),
            _buildSection(
              context,
              title: 'Int',
              keyHint: 'case_int',
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
              keyHint: 'case_double',
              storedValue: state.storedDouble?.toString(),
              onSave: (k, v) {
                final doubleVal = double.tryParse(v);
                if (doubleVal != null) viewModel.saveDouble(k, doubleVal);
              },
              keyboardType: TextInputType.number,
            ),
            _buildBoolSection(
              context,
              keyHint: 'case_bool',
              storedValue: state.storedBool,
              onSave: (k, v) => viewModel.saveBool(k, v),
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
                      style: AppTheme.mono
                          .copyWith(fontSize: 10, color: AppTheme.textMuted)),
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
                      style: AppTheme.mono
                          .copyWith(fontSize: 10, color: AppTheme.textMuted)),
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
}
