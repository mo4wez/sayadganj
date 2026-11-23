import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/theme_appearance_provider.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/theme/theme_settings.dart';
import '../../../../l10n/app_localizations.dart';
import 'widgets/accent_color_picker_card.dart';
import 'widgets/theme_mini_preview.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeAccent = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appearanceSectionTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // 1. Theme Mode (Auto / Light / Dark)
          _SectionLabel(
            icon: LucideIcons.sunMedium,
            title: l10n.themeModeSectionTitle,
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ThemePreviewOptionTile(
                  title: l10n.themeModeAutoOption,
                  previewKind: MiniPreviewKind.autoSplit,
                  accentColor: activeAccent,
                  selected: themeMode == ThemeMode.system,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system);
                  },
                ),
                const Divider(),
                ThemePreviewOptionTile(
                  title: l10n.themeModeLightOption,
                  previewKind: MiniPreviewKind.light,
                  accentColor: activeAccent,
                  selected: themeMode == ThemeMode.light,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.light);
                  },
                ),
                const Divider(),
                ThemePreviewOptionTile(
                  title: l10n.themeModeDarkOption,
                  previewKind: MiniPreviewKind.standardDark,
                  accentColor: activeAccent,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.dark);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 2. Pure Black Mode (Standard / Pure Black AMOLED)
          _SectionLabel(
            icon: LucideIcons.monitor,
            title: l10n.pureBlackSectionTitle,
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ThemePreviewOptionTile(
                  title: l10n.standardDarkOption,
                  subtitle: l10n.standardDarkSubtitle,
                  previewKind: MiniPreviewKind.standardDark,
                  accentColor: activeAccent,
                  selected: !appearance.isPureBlack,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(themeAppearanceProvider.notifier)
                        .setPureBlack(false);
                  },
                ),
                const Divider(),
                ThemePreviewOptionTile(
                  title: l10n.pureBlackOption,
                  subtitle: l10n.pureBlackSubtitle,
                  previewKind: MiniPreviewKind.pureBlack,
                  accentColor: activeAccent,
                  selected: appearance.isPureBlack,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref
                        .read(themeAppearanceProvider.notifier)
                        .setPureBlack(true);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // 3. Theme Color & Color Style
          _SectionLabel(
            icon: LucideIcons.palette,
            title: l10n.themeColorSectionTitle,
          ),
          const SizedBox(height: 10),
          AccentColorPickerCard(
            selectedColor: appearance.accentColor,
            selectedStyle: appearance.colorStyle,
            onSelectColor: (color) => ref
                .read(themeAppearanceProvider.notifier)
                .setAccentColor(color),
            onSelectStyle: (style) =>
                ref.read(themeAppearanceProvider.notifier).setColorStyle(style),
          ),
          const SizedBox(height: 22),

          // 4. Bottom Bar Style (Docked / Floating)
          _SectionLabel(
            icon: LucideIcons.panelBottom,
            title: l10n.bottomBarSectionTitle,
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (int i = 0; i < BottomBarStyle.values.length; i++) ...[
                  if (i > 0) const Divider(),
                  ListTile(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref
                          .read(themeAppearanceProvider.notifier)
                          .setBottomBarStyle(BottomBarStyle.values[i]);
                    },
                    leading: Icon(
                      BottomBarStyle.values[i] == BottomBarStyle.docked
                          ? LucideIcons.panelBottom
                          : LucideIcons.rectangleHorizontal,
                      color:
                          appearance.bottomBarStyle == BottomBarStyle.values[i]
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    title: Text(BottomBarStyle.values[i].localizedTitle(l10n)),
                    subtitle: Text(
                      BottomBarStyle.values[i].localizedSubtitle(l10n),
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    trailing:
                        appearance.bottomBarStyle == BottomBarStyle.values[i]
                        ? Icon(
                            LucideIcons.check,
                            color: colorScheme.primary,
                            size: 20,
                          )
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionLabel({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 17, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
