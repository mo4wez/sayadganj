import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/app_update_info.dart';
import '../providers/app_update_provider.dart';

Future<void> launchUpdateDownload(AppUpdateInfo info) async {
  final uri = Uri.parse(info.downloadUrl);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    await launchUrl(
      Uri.parse(info.releasePageUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}

Future<void> showAppUpdateDialog(BuildContext context, AppUpdateInfo info) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(LucideIcons.sparkles, color: colorScheme.primary, size: 28),
      title: Text('نوکیں ورژن دست کپت (v${info.latestVersion})'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تئی انّوگیں ورژن: v${info.currentVersion}',
              style: theme.textTheme.bodySmall,
            ),
            if (info.releaseNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('نوکیں بدلی:', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(info.releaseNotes, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('پدا'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(ctx).pop();
            launchUpdateDownload(info);
          },
          icon: const Icon(LucideIcons.download, size: 18),
          label: const Text('اِیرگیج کن'),
        ),
      ],
    ),
  );
}

/// Compact banner shown at the top of the home screen when an update is ready.
class UpdateAvailableBanner extends ConsumerWidget {
  const UpdateAvailableBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateState = ref.watch(appUpdateProvider);
    final info = updateState.availableUpdate;
    if (!updateState.shouldShowBanner || info == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showAppUpdateDialog(context, info),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(
                LucideIcons.arrowUpCircle,
                color: colorScheme.onPrimaryContainer,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سیدگنج ءِ نوکیں ورژن (v${info.latestVersion})',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'اِیرگیج کنگ ءِ ھاترا ٹپّ بہ جن',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.85,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'بند کن',
                icon: Icon(
                  LucideIcons.x,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                onPressed: () =>
                    ref.read(appUpdateProvider.notifier).dismissBanner(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
