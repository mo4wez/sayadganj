import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/font_family_provider.dart';
import '../../../core/theme/theme_appearance_provider.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../community/presentation/widgets/takband_follow_sheet.dart';
import '../../community/providers/community_prompt_provider.dart';
import '../../dictionary/providers/dictionary_providers.dart';
import '../providers/settings_provider.dart';
import 'theme/theme_settings_screen.dart';
import 'widgets/about_app_card.dart';
import 'widgets/notification_settings_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final wordCountAsync = ref.watch(totalWordCountProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modeLabel = switch (themeMode) {
      ThemeMode.system => 'سیستم',
      ThemeMode.light => 'روچ',
      ThemeMode.dark => appearance.isPureBlack ? 'پُرتہاریں شپ' : 'شپ',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('کاربوج')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text('زاهری رنگ ءُ دروشم', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.palette,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              title: const Text('زاهری رنگ ءُ دروشم'),
              subtitle: Text(
                '$modeLabel • ${appearance.accentColor.label} • ${appearance.colorStyle.title.split(' ').first}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.chevronLeft,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ThemeSettingsScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),

          // --- Font Family Selector with Live Specimen Preview ---
          Text(
            'کِشک ءُ نبشتانک ءِ دروشم (Font)',
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

          // --- Notifications ---
          Text('یات‌دھانی (Notifications)', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          const NotificationSettingsCard(),
          const SizedBox(height: 22),

          // --- Data & Search History ---
          Text('دپتر', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(LucideIcons.trash2, color: colorScheme.error),
              title: const Text('شوهازانی دپتر ءَ ساپ کن'),
              subtitle: const Text('تازگیں شوهاز چہ حافظہ ءَ دور  کنگ بنت'),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('دپتر ساپ کنگ بہ بیت؟'),
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
                          'هو، ساپ کن',
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
                      content: Text('شوهازانی دپتر ساپ بوت'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 22),

          // --- About App & TakbandQandeel Card ---
          Text('مئے بابت ءَ', style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          AboutAppCard(wordCountAsync: wordCountAsync),

          if (kDebugMode) ...[
            const SizedBox(height: 22),
            Text('Debug Tools', style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      LucideIcons.feather,
                      color: colorScheme.primary,
                    ),
                    title: const Text('تستِ تاکبندکندیل (Bottom Sheet)'),
                    subtitle: const Text('پیش‌نمایش مستقیم شیت معرفی کانال‌ها'),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      TakbandFollowSheet.show(
                        context,
                        onDismissLater: () => ref
                            .read(communityPromptProvider.notifier)
                            .dismissForNow(),
                        onDontShowAgain: () => ref
                            .read(communityPromptProvider.notifier)
                            .optOutPermanently(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      LucideIcons.rotateCcw,
                      color: colorScheme.primary,
                    ),
                    title: const Text('ریستِ شمارنده تاکبندکندیل'),
                    subtitle: const Text(
                      'پاک کردن تعداد نشست‌ها و وضعیت عدم نمایش',
                    ),
                    onTap: () async {
                      HapticFeedback.selectionClick();
                      await ref
                          .read(communityPromptProvider.notifier)
                          .debugResetState();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('شمارنده تاکبندکندیل ریست شد'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
