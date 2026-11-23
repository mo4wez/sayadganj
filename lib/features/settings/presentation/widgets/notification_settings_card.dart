import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/notifications/word_notification_service.dart';
import '../../providers/notification_settings_provider.dart';

class NotificationSettingsCard extends ConsumerWidget {
  const NotificationSettingsCard({super.key});

  String _formatBalochiTime(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifState = ref.watch(notificationSettingsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notifState.enabled ? LucideIcons.bellRing : LucideIcons.bellOff,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            title: const Text('روچ ءِ لبز ءِ جار'),
            subtitle: const Text(
              'هر روچ یک نوکیں بلوچی لبزے گوں آئی ءِ مانا ءَ دیم دیگ بیت',
            ),
            value: notifState.enabled,
            onChanged: (value) async {
              HapticFeedback.selectionClick();
              final ok = await ref
                  .read(notificationSettingsProvider.notifier)
                  .setEnabled(value);

              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'پہ جار جنگ ءَ چہ  موبائل ءِ کاربوج ءِ تہ ءَ اجازت بہ دئے',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
          if (notifState.enabled) ...[
            const Divider(height: 1),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
              leading: Icon(
                LucideIcons.clock,
                size: 19,
                color: colorScheme.primary,
              ),
              title: const Text('جار ءِ وهد'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    _formatBalochiTime(notifState.timeOfDay),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              onTap: () async {
                HapticFeedback.selectionClick();
                final picked = await showTimePicker(
                  context: context,
                  initialTime: notifState.timeOfDay,
                );
                if (picked != null) {
                  await ref
                      .read(notificationSettingsProvider.notifier)
                      .setReminderTime(picked);
                }
              },
            ),
          ],
          if (kDebugMode) ...[
            const Divider(height: 1),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
              leading: Icon(
                LucideIcons.flaskConical,
                size: 19,
                color: colorScheme.primary,
              ),
              title: const Text('جار ءِ تِست (۵ سیکنڈ)'),
              subtitle: const Text('فقط در حالت Debug نمایش داده می‌شود'),
              onTap: () async {
                HapticFeedback.selectionClick();
                final error = await WordNotificationService.instance
                    .triggerDebugWordNotification();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error ?? '۵ سیکنڈ ءَ جار کیت...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
