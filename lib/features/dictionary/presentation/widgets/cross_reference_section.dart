import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/cross_reference_parser.dart';
import '../../../../l10n/app_localizations.dart';
import 'quick_peek_sheet.dart';

class CrossReferenceSection extends StatelessWidget {
  final String definition;

  const CrossReferenceSection({super.key, required this.definition});

  @override
  Widget build(BuildContext context) {
    final targets = CrossReferenceParser.extractTargets(definition);
    if (targets.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.cornerDownLeft,
                    size: 15,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.relatedWordsQuickPeek,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: targets.map((word) {
                  return ActionChip(
                    avatar: Icon(
                      LucideIcons.eye,
                      size: 15,
                      color: colorScheme.primary,
                    ),
                    label: Text(
                      l10n.seeWordLabel(word),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                      ),
                    ),
                    backgroundColor: colorScheme.secondary,
                    side: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () => QuickPeekSheet.show(context, word),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.03, end: 0),
    );
  }
}
