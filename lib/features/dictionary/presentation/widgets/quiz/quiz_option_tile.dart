import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum QuizOptionState { idle, correct, wrong, dimmed }

class QuizOptionTile extends StatelessWidget {
  final String text;
  final QuizOptionState state;
  final VoidCallback? onTap;

  const QuizOptionTile({
    super.key,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const successColor = Color(0xFF16A34A);

    final (
      Color bg,
      Color border,
      IconData? icon,
      Color iconColor,
    ) = switch (state) {
      QuizOptionState.correct => (
        successColor.withValues(alpha: 0.14),
        successColor,
        LucideIcons.circleCheck,
        successColor,
      ),
      QuizOptionState.wrong => (
        colorScheme.error.withValues(alpha: 0.14),
        colorScheme.error,
        LucideIcons.circleX,
        colorScheme.error,
      ),
      QuizOptionState.dimmed => (
        theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
        colorScheme.outline.withValues(alpha: 0.5),
        null,
        colorScheme.onSurfaceVariant,
      ),
      QuizOptionState.idle => (
        theme.scaffoldBackgroundColor,
        colorScheme.outline,
        null,
        colorScheme.onSurfaceVariant,
      ),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
          width: state == QuizOptionState.idle ? 1 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: state == QuizOptionState.dimmed
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
                          : colorScheme.onSurface,
                      fontWeight: state == QuizOptionState.correct
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, size: 18, color: iconColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
