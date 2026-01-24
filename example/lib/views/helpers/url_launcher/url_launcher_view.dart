import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_core/masterfabric_core.dart';

import '../../../theme/theme_helper.dart';
import '../../../src/resources/resources.g.dart' as example_resources;
import 'cubit/url_launcher_cubit.dart';
import 'cubit/url_launcher_state.dart';

/// URL Launcher View - Minimalist design
class UrlLauncherView
    extends MasterViewCubit<UrlLauncherCubit, UrlLauncherState> {
  UrlLauncherView({
    super.key,
    required Function(String) goRoute,
  }) : super(
          currentView: MasterViewCubitTypes.content,
          goRoute: goRoute,
          coreAppBar: (context, viewModel) {
            return AppBar(
              title: Text(example_resources.resources.url_launcher.title),
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
  Future<void> initialContent(
      UrlLauncherCubit viewModel, BuildContext context) async {}

  @override
  Widget viewContent(BuildContext context, UrlLauncherCubit viewModel,
      UrlLauncherState state) {
    return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _LaunchSection(
              title: example_resources.resources.url_launcher.url,
              hint: 'https://pub.dev',
              onLaunch: (val) => viewModel.launchUrl(val),
            ),
            _LaunchSection(
              title: example_resources.resources.url_launcher.phone,
              hint: '+1234567890',
              onLaunch: (val) => viewModel.launchPhone(val),
            ),
            _LaunchSection(
              title: example_resources.resources.url_launcher.email,
              hint: 'example@email.com',
              onLaunch: (val) => viewModel.launchEmail(val,
                  subject: 'Test', body: 'Hello from MasterFabric'),
            ),
            _LaunchSection(
              title: example_resources.resources.url_launcher.sms,
              hint: '+1234567890',
              onLaunch: (val) =>
                  viewModel.launchSms(val, body: 'Hello from MasterFabric'),
            ),
          ],
        );
  }
}

class _LaunchSection extends StatefulWidget {
  final String title;
  final String hint;
  final Future<bool> Function(String) onLaunch;

  const _LaunchSection({
    required this.title,
    required this.hint,
    required this.onLaunch,
  });

  @override
  State<_LaunchSection> createState() => _LaunchSectionState();
}

class _LaunchSectionState extends State<_LaunchSection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.hint);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child:
                Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(hintText: widget.hint),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'SF Mono'),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_ctrl.text.isNotEmpty) {
                        final ok = await widget.onLaunch(_ctrl.text);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text(ok ? 'Launched' : 'Failed to launch')),
                          );
                        }
                      }
                    },
                    child: Text(example_resources.resources.url_launcher.launch),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
