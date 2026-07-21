import 'package:flutter/material.dart';

import '../../app/theme/aura_theme.dart';
import '../../data/models/food_entry.dart';
import '../../widgets/aura_toast.dart';
import '../../widgets/aura_ui.dart';
import '../../widgets/meal_labels.dart';
import 'cubit/log_cubit.dart';

/// Structured custom food / drink entry for Log.
abstract final class CustomFoodSheet {
  static Future<void> open(
    BuildContext context, {
    required LogCubit cubit,
    required MealKind kind,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _CustomFoodBody(cubit: cubit, kind: kind),
    );
  }
}

class _CustomFoodBody extends StatefulWidget {
  const _CustomFoodBody({
    required this.cubit,
    required this.kind,
  });

  final LogCubit cubit;
  final MealKind kind;

  @override
  State<_CustomFoodBody> createState() => _CustomFoodBodyState();
}

class _CustomFoodBodyState extends State<_CustomFoodBody> {
  final _name = TextEditingController();
  final _note = TextEditingController();
  final _cal = TextEditingController();
  final _protein = TextEditingController(text: '0');
  final _carbs = TextEditingController(text: '0');
  final _fat = TextEditingController(text: '0');
  late final TextEditingController _ml;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _ml = TextEditingController(
      text: widget.kind == MealKind.drink ? '250' : '0',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    _cal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    _ml.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty || _saving) {
      if (name.isEmpty) {
        await AuraToast.show(
          context,
          title: 'Name needed',
          message: 'Add what you ate or drank.',
          tone: AuraToastTone.note,
          actionLabel: 'OK',
        );
      }
      return;
    }

    setState(() => _saving = true);
    try {
      final note = _note.text.trim();
      final label = note.isEmpty ? name : '$name · $note';
      await widget.cubit.addCustom(
        name: label,
        calories: int.tryParse(_cal.text.trim()) ?? 0,
        kind: widget.kind,
        protein: int.tryParse(_protein.text.trim()) ?? 0,
        carbs: int.tryParse(_carbs.text.trim()) ?? 0,
        fat: int.tryParse(_fat.text.trim()) ?? 0,
        ml: int.tryParse(_ml.text.trim()) ?? 0,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      await AuraToast.pulse(
        context,
        title: MealLabels.title(widget.kind),
        loadingMessage: 'Saving entry…',
        doneMessage: 'Custom item logged.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _labeledField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AuraTheme.mute,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textInputAction:
              maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AuraTheme.line,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Custom ${MealLabels.title(widget.kind).toLowerCase()}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: AuraTheme.fontDisplay,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'Clear labels, optional note — stays on this day.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AuraTheme.mute,
                  ),
            ),
            const SizedBox(height: 16),
            _labeledField(
              label: 'Name',
              controller: _name,
              hint: widget.kind == MealKind.drink
                  ? 'e.g. Sparkling water'
                  : 'e.g. Homemade bowl',
            ),
            const SizedBox(height: 12),
            _labeledField(
              label: 'Note (optional)',
              controller: _note,
              hint: 'Portion, restaurant, how it felt…',
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            _labeledField(
              label: 'Calories',
              controller: _cal,
              hint: 'kcal',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              'Macros (g)',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AuraTheme.mute,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _protein,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Protein'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _carbs,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Carbs'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _fat,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Fat'),
                  ),
                ),
              ],
            ),
            if (widget.kind == MealKind.drink) ...[
              const SizedBox(height: 12),
              _labeledField(
                label: 'Volume',
                controller: _ml,
                hint: 'ml',
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AuraUi.radiusSm),
                  ),
                ),
                child: Text(_saving ? 'Saving…' : 'Save entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
