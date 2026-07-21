import 'package:flutter/material.dart';

import '../../app/theme/aura_theme.dart';
import '../../data/models/app_notification.dart';
import '../../data/notifications_catalog.dart';
import '../../widgets/aura_ui.dart';

abstract final class NotificationsSheet {
  static Future<void> open(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AuraTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: MediaQuery.sizeOf(ctx).height * 0.78,
          child: const _NotificationsSheetBody(),
        );
      },
    );
  }
}

class _NotificationsSheetBody extends StatefulWidget {
  const _NotificationsSheetBody();

  @override
  State<_NotificationsSheetBody> createState() =>
      _NotificationsSheetBodyState();
}

class _NotificationsSheetBodyState extends State<_NotificationsSheetBody> {
  late final Future<List<AppNotification>> _future = NotificationsCatalog.load();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AuraTheme.line,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      'Product cues from AURA — loaded from local JSON.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AuraTheme.mute,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AuraTheme.line),
        Expanded(
          child: FutureBuilder<List<AppNotification>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: AuraTheme.ink),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Could not load notifications.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AuraTheme.mute,
                      ),
                    ),
                  ),
                );
              }

              final items = snapshot.data ?? const <AppNotification>[];
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications yet.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AuraTheme.mute,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _NotificationTile(item: items[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AuraUi.appleCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: item.unread ? AuraTheme.ink : AuraTheme.line,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AuraTheme.paper,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AuraTheme.line),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AuraTheme.mute,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AuraTheme.mute,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AuraTheme.mute,
                    height: 1.35,
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
