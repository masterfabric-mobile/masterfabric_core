import 'package:flutter/material.dart';

import '../app/di/injection.dart' as di;
import '../app/theme/aura_theme.dart';
import '../data/fitness_repository.dart';
import '../data/models/app_icon_style.dart';
import '../data/models/body_profile.dart';
import '../services/app_icon_service.dart';
import '../src/resources/resources.g.dart' as aura;
import 'app_icon_picker.dart';
import 'aura_kit.dart';
import 'aura_toast.dart';

abstract final class AppIconSheet {
  static Future<void> open(BuildContext context, BodyProfile profile) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => _AppIconSheetBody(profile: profile),
    );
  }
}

class _AppIconSheetBody extends StatefulWidget {
  const _AppIconSheetBody({required this.profile});

  final BodyProfile profile;

  @override
  State<_AppIconSheetBody> createState() => _AppIconSheetBodyState();
}

class _AppIconSheetBodyState extends State<_AppIconSheetBody> {
  late AppIconStyle _selected = widget.profile.appIcon;
  var _saving = false;

  Future<void> _apply() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final repo = di.getIt<FitnessRepository>();
      final next = widget.profile.copyWith(appIcon: _selected);
      await repo.saveProfile(next);
      await AppIconService.apply(_selected);
      if (!mounted) return;
      final t = aura.Translations.of(context);
      await AuraToast.show(
        context,
        title: t.app_icon.applied_title,
        message: t.app_icon.applied_body,
        tone: AuraToastTone.success,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = aura.Translations.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AuraSpace.sheetH,
        0,
        AuraSpace.sheetH,
        bottom + AuraSpace.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            t.app_icon.sheet_title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontFamily: AuraTheme.fontDisplay,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          AuraSpace.vXs,
          Text(
            t.app_icon.sheet_subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AuraTheme.mute,
              height: 1.4,
            ),
          ),
          AuraSpace.vLg,
          AppIconPicker(
            selected: _selected,
            onSelected: (style) => setState(() => _selected = style),
            compact: true,
          ),
          AuraSpace.vLg,
          AuraKit.primaryButton(
            label: _saving ? t.common.loading : t.app_icon.use_this_icon,
            onPressed: _saving ? null : _apply,
            height: 48,
          ),
          AuraKit.secondaryButton(
            label: t.common.cancel,
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
