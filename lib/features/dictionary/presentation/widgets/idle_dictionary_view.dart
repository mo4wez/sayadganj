import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'quiz/daily_quiz_card.dart';
import 'word_of_the_day_card.dart';
import 'activity/reading_streak_card.dart';

class IdleDictionaryView extends StatelessWidget {
  final AsyncValue<List<String>> recentAsync;
  final ValueChanged<String> onSelectTerm;
  final ValueChanged<String> onRemoveTerm;
  final VoidCallback onClearAll;

  const IdleDictionaryView({
    super.key,
    required this.recentAsync,
    required this.onSelectTerm,
    required this.onRemoveTerm,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final recents = recentAsync.maybeWhen(
      data: (list) => list,
      orElse: () => const <String>[],
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        const WordOfTheDayCard(),
        const SizedBox(height: 16),
        const ReadingStreakCard(),
        if (recents.isNotEmpty) ...[
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.history,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text('تازگیں شوهاز', style: theme.textTheme.labelMedium),
                ],
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text('پاک کنگ'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recents.map((term) {
              return InputChip(
                label: Text(term),
                onPressed: () => onSelectTerm(term),
                onDeleted: () => onRemoveTerm(term),
                deleteIcon: const Icon(LucideIcons.x, size: 14),
                backgroundColor: colorScheme.surface,
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 18),
        const DailyQuizCard(),
      ],
    );
  }
}
