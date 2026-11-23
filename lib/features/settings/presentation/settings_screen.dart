import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/font_family_provider.dart';
import '../../../core/theme/theme_appearance_provider.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../community/presentation/widgets/takband_follow_sheet.dart';
import '../../community/providers/community_prompt_provider.dart';
import '../../dictionary/providers/dictionary_providers.dart';
import '../providers/settings_provider.dart';
import '../providers/locale_provider.dart';
import 'theme/theme_settings_screen.dart';
import 'widgets/about_app_card.dart';
import 'widgets/notification_settings_card.dart';
import '../../updates/presentation/update_widgets.dart';
import '../../updates/providers/app_update_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final selectedFont = ref.watch(fontFamilyProvider);
    final fontScale = ref.watch(fontScaleProvider);
    final wordCountAsync = ref.watch(totalWordCountProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final modeLabel = switch (themeMode) {
      ThemeMode.system => l10n.themeModeSystem,
      ThemeMode.light => l10n.themeModeLight,
      ThemeMode.dark =>
        appearance.isPureBlack ? l10n.themeModePureBlack : l10n.themeModeDark,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text(l10n.appearanceSectionTitle, style: theme.textTheme.labelMedium),
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
              title: Text(l10n.appearanceSectionTitle),
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

          // --- Language Switcher ---
          Text(l10n.languageSettingTitle, style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      LucideIcons.languages,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.languageSettingTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          locale.languageCode == 'fa'
                              ? l10n.languagePersian
                              : l10n.languageBalochi,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _LanguagePill(
                          label: l10n.languageBalochi,
                          selected: locale.languageCode == 'bal',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(const Locale('bal'));
                          },
                        ),
                        _LanguagePill(
                          label: l10n.languagePersian,
                          selected: locale.languageCode == 'fa',
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(const Locale('fa'));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // --- Font Family Selector with Live Specimen Preview ---
          Text(l10n.fontSectionTitle, style: theme.textTheme.labelMedium),
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
                l10n.fontSizeSectionTitle,
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
                      child: Text(l10n.resetFontSize),
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
                    l10n.fontSizePreviewText,
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
          Text(
            l10n.notificationsSectionTitle,
            style: theme.textTheme.labelMedium,
          ),
          const SizedBox(height: 10),
          const NotificationSettingsCard(),
          const SizedBox(height: 22),

          // --- Data & Search History ---
          Text(l10n.historySectionTitle, style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(LucideIcons.trash2, color: colorScheme.error),
              title: Text(l10n.clearSearchHistoryTitle),
              subtitle: Text(l10n.clearSearchHistorySubtitle),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.clearSearchHistoryDialogTitle),
                    content: Text(l10n.clearSearchHistoryDialogBody),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l10n.cancelAction),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(
                          l10n.confirmClearAction,
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
                    SnackBar(
                      content: Text(l10n.searchHistoryClearedSnack),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 22),

          // --- About App & TakbandQandeel Card ---
          Text(l10n.aboutSectionTitle, style: theme.textTheme.labelMedium),
          const SizedBox(height: 10),
          AboutAppCard(wordCountAsync: wordCountAsync),
          const SizedBox(height: 10),
          Builder(
            builder: (context) {
              final updateState = ref.watch(appUpdateProvider);
              final update = updateState.availableUpdate;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(
                    LucideIcons.refreshCw,
                    color: colorScheme.primary,
                  ),
                  title: Text(l10n.checkForUpdatesTitle),
                  subtitle: Text(
                    update != null
                        ? l10n.updateAvailableSubtitle(update.latestVersion)
                        : l10n.checkLatestVersionSubtitle,
                  ),
                  trailing: updateState.isChecking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : update != null
                      ? Badge(label: Text('v${update.latestVersion}'))
                      : Icon(
                          LucideIcons.chevronLeft,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                  onTap: updateState.isChecking
                      ? null
                      : () async {
                          HapticFeedback.selectionClick();
                          final result = await ref
                              .read(appUpdateProvider.notifier)
                              .check(silent: false);
                          if (!context.mounted) return;

                          if (result != null) {
                            await showAppUpdateDialog(context, result);
                          } else {
                            final err = ref
                                .read(appUpdateProvider)
                                .errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err ?? l10n.appIsUpToDateSnack),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                ),
              );
            },
          ),

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
    final l10n = AppLocalizations.of(context);
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
                          font.localizedTitle(l10n),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            color: selected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          font.localizedSubtitle(l10n),
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

class _LanguagePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
