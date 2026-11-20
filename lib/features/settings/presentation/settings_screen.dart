import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/theme_mode_provider.dart';
import '../../dictionary/providers/dictionary_providers.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('ظاهری رنگ ءُ تھیم', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _ThemeOptionTile(
                  icon: LucideIcons.smartphone,
                  title: 'سیستم ءِ حساب ءَ',
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system),
                ),
                const Divider(),
                _ThemeOptionTile(
                  icon: LucideIcons.sun,
                  title: 'روشنیں رنگ (Light)',
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light),
                ),
                const Divider(),
                _ThemeOptionTile(
                  icon: LucideIcons.moon,
                  title: 'تاریکیں رنگ (Dark)',
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نبشتانک ءِ کساس (Font Size)',
                style: theme.textTheme.labelMedium,
              ),
              Text(
                '${(fontScale * 100).round()}%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بلوچی زبان مئے پجّار اِنت',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16 * fontScale,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(LucideIcons.aLargeSmall, size: 18),
                      Expanded(
                        child: Slider(
                          value: fontScale,
                          min: 0.85,
                          max: 1.45,
                          divisions: 6,
                          onChanged: (val) => ref
                              .read(fontScaleProvider.notifier)
                              .setScale(val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text('داتا ءُ تاریخچہ', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(LucideIcons.trash2, color: colorScheme.error),
              title: const Text('شوهازانی تاریخچہ ءَ پاک کن'),
              subtitle: const Text('تازگیں شوهاز چہ حافظہ ءَ دور بنت'),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('تاریخچہ پاک کنگ بہ بیت؟'),
                    content: const Text(
                      'تئی تازگیں شوهازانی لڑ پہ مدامی پاک کنگ بیت۔',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('نہ'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          'هو، پاک کن',
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref
                      .read(searchHistoryControllerProvider.notifier)
                      .clearAll();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('شوهازانی تاریخچہ پاک بوت'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(title),
      trailing: selected
          ? Icon(LucideIcons.check, color: colorScheme.primary, size: 20)
          : null,
    );
  }
}
