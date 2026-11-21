import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/font_family_provider.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../dictionary/providers/dictionary_providers.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final wordCountAsync = ref.watch(totalWordCountProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
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

          // --- Font Family Selector with Live Specimen Preview ---
          Text(
            'خط ءُ نبشتانک ءِ دروشم (Font)',
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 10),
          ...AppFont.values.map((font) {
            final isSelected = selectedFont == font;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _FontPreviewCard(
                font: font,
                fontScale: fontScale,
                selected: isSelected,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref.read(fontFamilyProvider.notifier).setFont(font);
                },
              ),
            );
          }),
          const SizedBox(height: 12),

          // --- Reading Font Size Slider ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نبشتانک ءِ کساس (Font Size)',
                style: theme.textTheme.labelMedium,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (fontScale != 1.0)
                    TextButton(
                      onPressed: () =>
                          ref.read(fontScaleProvider.notifier).reset(),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text('پدا ۱۰۰٪'),
                    ),
                  Text(
                    '${(fontScale * 100).round()}%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
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

          // --- Data & Search History ---
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
          const SizedBox(height: 22),

          // --- About App Card ---
          Text('بابت ءِ ایپ', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          LucideIcons.bookOpenText,
                          size: 22,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سیدگنج — بلوچی لبزبلد',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'نسخہ ۱.۰.۰ • ۱۰۰٪ آفلاین',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(),
                  const SizedBox(height: 14),
                  Text(
                    'بلوچی ءَ پہ بلوچی سرجمیں لبزبلد کہ بید ء انٹرنیٹ ءَ کار کنت ءُ لبزانی مانا، اعراب ءُ تشریح ءَ پیش داریت۔',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.database,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          wordCountAsync.when(
                            data: (count) => 'کل لبز: $count',
                            loading: () => 'کل لبز: ...',
                            error: (_, __) => 'کل لبز: —',
                          ),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontPreviewCard extends StatelessWidget {
  final AppFont font;
  final double fontScale;
  final bool selected;
  final VoidCallback onTap;

  const _FontPreviewCard({
    required this.font,
    required this.fontScale,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? colorScheme.primary : colorScheme.outline,
          width: selected ? 1.8 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.type,
                      size: 18,
                      color: selected
                          ? colorScheme.onPrimary
                          : colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          font.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            color: selected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          font.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    selected ? LucideIcons.circleCheck : LucideIcons.circle,
                    size: 20,
                    color: selected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Live Balochi Specimen Box rendered in this exact font
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? colorScheme.secondary.withValues(alpha: 0.65)
                      : theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? colorScheme.primary.withValues(alpha: 0.28)
                        : colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سَیّدگَنج — گُل، ڑ، ٹ، ڈ، ژ، ء',
                      style: TextStyle(
                        fontFamily: font.fontFamily,
                        fontSize: 17 * fontScale,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'بلوچی زبان مئے پجّار اِنت؛ هر لبزے وتی جتائیں مانا ءُ دروشمے داریت۔',
                      style: TextStyle(
                        fontFamily: font.fontFamily,
                        fontSize: 14.5 * fontScale,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface,
                        height: 1.75,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
