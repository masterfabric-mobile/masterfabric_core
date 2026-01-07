import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';
import 'package:masterfabric_core_example/features/helpers/storage/hive_ce/cubit/hive_ce_storage_cubit.dart';
import 'package:masterfabric_core_example/features/helpers/storage/hive_ce/cubit/hive_ce_storage_state.dart';

/// HiveCE Storage Demo View
class HiveCeStorageView extends MasterViewCubit<HiveCeStorageCubit, HiveCeStorageState> {
  HiveCeStorageView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: const Text('HiveCE Storage Demo'),
              leading: GoRouter.of(context).canPop()
                  ? IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () {
                        if (GoRouter.of(context).canPop()) {
                          GoRouter.of(context).pop();
                        }
                      },
                      tooltip: 'Back',
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw),
                  onPressed: () => viewModel.loadAllItems(),
                  tooltip: 'Refresh All Items',
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2),
                  onPressed: () => viewModel.clearStorage(),
                  tooltip: 'Clear Storage',
                ),
              ],
            );
          },
        );

  @override
  Future<void> initialContent(HiveCeStorageCubit viewModel, BuildContext context) async {
    // State is loaded in constructor
  }

  @override
  Widget viewContent(BuildContext context, HiveCeStorageCubit viewModel, HiveCeStorageState state) {
    return BlocBuilder<HiveCeStorageCubit, HiveCeStorageState>(
      bloc: viewModel,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This demo uses HiveCE storage backend',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue[900],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _StorageSection(
                title: 'String Storage',
                icon: LucideIcons.type,
                keyHint: 'hivece_demo_string',
                onSave: (key, value) => viewModel.saveString(key, value),
                storedValue: state.storedString,
              ),
              const SizedBox(height: 24),
              _StorageSection(
                title: 'Integer Storage',
                icon: LucideIcons.hash,
                keyHint: 'hivece_demo_int',
                onSave: (key, value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null) {
                    viewModel.saveInt(key, intValue);
                  }
                },
                storedValue: state.storedInt?.toString(),
                isInt: true,
              ),
              const SizedBox(height: 24),
              _BooleanSection(
                keyHint: 'hivece_demo_bool',
                onSave: (key, value) => viewModel.saveBool(key, value),
                storedValue: state.storedBool,
              ),
              const SizedBox(height: 24),
              _StorageSection(
                title: 'Double Storage',
                icon: LucideIcons.hash,
                keyHint: 'hivece_demo_double',
                onSave: (key, value) {
                  final doubleValue = double.tryParse(value);
                  if (doubleValue != null) {
                    viewModel.saveDouble(key, doubleValue);
                  }
                },
                storedValue: state.storedDouble?.toString(),
                isDouble: true,
              ),
              const SizedBox(height: 24),
              _StringListSection(
                keyHint: 'hivece_demo_string_list',
                onSave: (key, value) => viewModel.saveStringList(key, value),
                storedValue: state.storedStringList,
              ),
              const SizedBox(height: 24),
              _AllItemsSection(
                allItems: state.allItems,
                onRefresh: () => viewModel.loadAllItems(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StorageSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final String keyHint;
  final Function(String key, String value) onSave;
  final String? storedValue;
  final bool isInt;
  final bool isDouble;

  const _StorageSection({
    required this.title,
    required this.icon,
    required this.keyHint,
    required this.onSave,
    this.storedValue,
    this.isInt = false,
    this.isDouble = false,
  });

  @override
  State<_StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends State<_StorageSection> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_keyController.text.isEmpty || _valueController.text.isEmpty) {
      return;
    }
    widget.onSave(_keyController.text, _valueController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.title} saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                labelText: 'Key',
                hintText: widget.keyHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
              ),
              keyboardType: widget.isInt || widget.isDouble
                  ? TextInputType.number
                  : TextInputType.text,
            ),
            const SizedBox(height: 12),
            if (widget.storedValue != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.database, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Stored: ${widget.storedValue}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleSave,
                icon: const Icon(LucideIcons.save, size: 18),
                label: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BooleanSection extends StatefulWidget {
  final String keyHint;
  final Function(String key, bool value) onSave;
  final bool? storedValue;

  const _BooleanSection({
    required this.keyHint,
    required this.onSave,
    this.storedValue,
  });

  @override
  State<_BooleanSection> createState() => _BooleanSectionState();
}

class _BooleanSectionState extends State<_BooleanSection> {
  final TextEditingController _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _handleSave(bool value) {
    if (_keyController.text.isEmpty) {
      return;
    }
    widget.onSave(_keyController.text, value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Boolean saved: $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.toggleLeft, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Boolean Storage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                labelText: 'Key',
                hintText: widget.keyHint,
              ),
            ),
            const SizedBox(height: 12),
            if (widget.storedValue != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.database, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Stored: ${widget.storedValue}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleSave(true),
                    icon: const Icon(LucideIcons.check, size: 18),
                    label: const Text('Save True'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleSave(false),
                    icon: const Icon(LucideIcons.x, size: 18),
                    label: const Text('Save False'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StringListSection extends StatefulWidget {
  final String keyHint;
  final Function(String key, List<String> value) onSave;
  final List<String>? storedValue;

  const _StringListSection({
    required this.keyHint,
    required this.onSave,
    this.storedValue,
  });

  @override
  State<_StringListSection> createState() => _StringListSectionState();
}

class _StringListSectionState extends State<_StringListSection> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_keyController.text.isEmpty || _valueController.text.isEmpty) {
      return;
    }
    final items = _valueController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    widget.onSave(_keyController.text, items);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('String List saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.list, size: 20),
                const SizedBox(width: 8),
                Text(
                  'String List Storage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(
                labelText: 'Key',
                hintText: widget.keyHint,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Values (comma-separated)',
                hintText: 'item1, item2, item3',
              ),
            ),
            const SizedBox(height: 12),
            if (widget.storedValue != null && widget.storedValue!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.database, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Stored:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...widget.storedValue!.map((item) => Padding(
                          padding: const EdgeInsets.only(left: 24, top: 4),
                          child: Text(
                            '• $item',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleSave,
                icon: const Icon(LucideIcons.save, size: 18),
                label: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllItemsSection extends StatelessWidget {
  final Map<String, dynamic>? allItems;
  final VoidCallback onRefresh;

  const _AllItemsSection({
    required this.allItems,
    required this.onRefresh,
  });

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is List) {
      return '[${value.join(', ')}]';
    }
    return value.toString();
  }

  String _getTypeName(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return 'String';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'bool';
    if (value is List) return 'List<String>';
    return value.runtimeType.toString();
  }

  @override
  Widget build(BuildContext context) {
    final items = allItems ?? {};
    final itemCount = items.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.database, size: 20),
                const SizedBox(width: 8),
                Text(
                  'All Items in Database',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(child: Container()),
                Text(
                  '$itemCount items',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (items.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No items stored in database',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final entry = items.entries.elementAt(index);
                    final key = entry.key;
                    final value = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[900],
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getTypeName(value),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              _formatValue(value),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          if (index < items.length - 1)
                            const Divider(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                label: const Text('Refresh All Items'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

