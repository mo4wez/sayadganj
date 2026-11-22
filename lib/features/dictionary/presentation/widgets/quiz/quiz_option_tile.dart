import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum QuizOptionState { idle, correct, wrong, dimmed }

class QuizOptionTile extends StatelessWidget {
  final String text;
  final QuizOptionState state;
  final VoidCallback? onTap;
  final int? optionNumber;

  const QuizOptionTile({
    super.key,
    required this.text,
    required this.state,
    this.onTap,
    this.optionNumber,
  });

  static const List<String> _balochiDigits = ['۱', '۲', '۳', '۴'];

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
        colorScheme.surface,
        colorScheme.outline,
        null,
        colorScheme.onSurfaceVariant,
      ),
    };

    final digitLabel =
        (optionNumber != null &&
            optionNumber! >= 1 &&
            optionNumber! <= _balochiDigits.length)
        ? _balochiDigits[optionNumber! - 1]
        : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
          width: state == QuizOptionState.idle ? 1 : 1.6,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (digitLabel != null) ...[
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: state == QuizOptionState.correct
                          ? successColor.withValues(alpha: 0.2)
                          : state == QuizOptionState.wrong
                          ? colorScheme.error.withValues(alpha: 0.2)
                          : colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      digitLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: state == QuizOptionState.correct
                            ? successColor
                            : state == QuizOptionState.wrong
                            ? colorScheme.error
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.5,
                      height: 1.6,
                      color: state == QuizOptionState.dimmed
                          ? colorScheme.onSurfaceVariant.withValues(alpha: 0.55)
                          : colorScheme.onSurface,
                      fontWeight: state == QuizOptionState.correct
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, size: 20, color: iconColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
