import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum MiniPreviewKind { autoSplit, light, standardDark, pureBlack }

class ThemeMiniPreview extends StatelessWidget {
  final MiniPreviewKind kind;
  final Color accentColor;

  const ThemeMiniPreview({
    super.key,
    required this.kind,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outline;

    return Container(
      width: 54,
      height: 36,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: switch (kind) {
        MiniPreviewKind.light => _PreviewSurface(
          bg: const Color(0xFFF7F7F5),
          card: Colors.white,
          pill: accentColor,
        ),
        MiniPreviewKind.standardDark => _PreviewSurface(
          bg: const Color(0xFF0E1116),
          card: const Color(0xFF1A2029),
          pill: accentColor,
        ),
        MiniPreviewKind.pureBlack => _PreviewSurface(
          bg: const Color(0xFF000000),
          card: const Color(0xFF101318),
          pill: accentColor,
        ),
        MiniPreviewKind.autoSplit => Row(
          children: [
            Expanded(
              child: _PreviewSurface(
                bg: const Color(0xFFF7F7F5),
                card: Colors.white,
                pill: accentColor,
              ),
            ),
            Expanded(
              child: _PreviewSurface(
                bg: const Color(0xFF0E1116),
                card: const Color(0xFF1A2029),
                pill: accentColor,
              ),
            ),
          ],
        ),
      },
    );
  }
}

class _PreviewSurface extends StatelessWidget {
  final Color bg;
  final Color card;
  final Color pill;

  const _PreviewSurface({
    required this.bg,
    required this.card,
    required this.pill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 6,
            width: 18,
            decoration: BoxDecoration(
              color: pill,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemePreviewOptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final MiniPreviewKind previewKind;
  final Color accentColor;
  final bool selected;
  final VoidCallback onTap;

  const ThemePreviewOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.previewKind,
    required this.accentColor,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            ThemeMiniPreview(kind: previewKind, accentColor: accentColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(LucideIcons.check, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
