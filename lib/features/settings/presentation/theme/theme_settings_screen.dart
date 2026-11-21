import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/theme_appearance_provider.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../../core/theme/theme_settings.dart';
import 'widgets/accent_color_picker_card.dart';
import 'widgets/theme_mini_preview.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeAccent = colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('ظاهری رنگ ءُ دروشم')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // 1. Theme Mode (Auto / Light / Dark)
          _SectionLabel(
            icon: LucideIcons.sunMedium,
            title: 'شپ ءُ روچ ءِ دروشم (Theme mode)',
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ThemePreviewOptionTile(
                  title: 'سیستم ءِ حساب ءَ (Auto)',
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
                  title: 'روچ ءِ دروشم (Light)',
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
                  title: 'شپ ءِ دروشم (Dark)',
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
            title: 'تہاریں شپ ءِ دروشم (Pure black mode)',
          ),
          const SizedBox(height: 10),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ThemePreviewOptionTile(
                  title: 'سادگیں شپ (Standard)',
                  subtitle: 'نرمیں سیاہ ءُ نیلیں پشت‌در',
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
                  title: 'پُرتہاریں شپ (Pure black)',
                  subtitle: 'سرجمیں سیاہ (AMOLED) پہ شپ ءِ وانگ ءَ',
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
            title: 'رنگ ءِ گچین (Theme color)',
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
            title: 'چیردیمی بار (Bottom bar)',
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
                    title: Text(BottomBarStyle.values[i].title),
                    subtitle: Text(
                      BottomBarStyle.values[i].subtitle,
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
