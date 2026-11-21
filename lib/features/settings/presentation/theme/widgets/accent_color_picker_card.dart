import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/theme_settings.dart';

class AccentColorPickerCard extends StatelessWidget {
  final AppAccentColor selectedColor;
  final AppColorStyle selectedStyle;
  final ValueChanged<AppAccentColor> onSelectColor;
  final ValueChanged<AppColorStyle> onSelectStyle;

  const AccentColorPickerCard({
    super.key,
    required this.selectedColor,
    required this.selectedStyle,
    required this.onSelectColor,
    required this.onSelectStyle,
  });

  void _openColorStyleSheet(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colorScheme = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: colorScheme.outline, width: 1.2),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outline,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'رنگ ءِ انداز (Color Style)',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...AppColorStyle.values.map((style) {
                  final isSelected = style == selectedStyle;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onSelectStyle(style);
                        Navigator.of(ctx).pop();
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.secondary
                              : theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    style.title,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontSize: 15,
                                          color: isSelected
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    style.subtitle,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                LucideIcons.check,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isMonochrome = selectedStyle == AppColorStyle.monochrome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: AppAccentColor.values.map((swatch) {
                final swatchColor = isDark
                    ? swatch.darkColor
                    : swatch.lightColor;
                final isSelected = swatch == selectedColor;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelectColor(swatch);
                  },
                  child: Tooltip(
                    message: swatch.label,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? swatchColor : Colors.transparent,
                          width: 2.2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isMonochrome
                              ? swatchColor.withValues(alpha: 0.45)
                              : swatchColor,
                          shape: BoxShape.circle,
                        ),
                        child: isSelected
                            ? Icon(
                                LucideIcons.check,
                                size: 18,
                                color: isDark
                                    ? const Color(0xFF0A0D10)
                                    : Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _openColorStyleSheet(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(
                    'رنگ ءِ انداز (Color style)',
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const Spacer(),
                  Text(
                    selectedStyle.title.split(' ').first,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    LucideIcons.chevronsUpDown,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
