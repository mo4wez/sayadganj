import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../domain/quiz_question.dart';
import '../../../providers/quiz_provider.dart';
import '../../word_detail_screen.dart';
import 'quiz_option_tile.dart';

class DailyQuizCard extends ConsumerStatefulWidget {
  const DailyQuizCard({super.key});

  @override
  ConsumerState<DailyQuizCard> createState() => _DailyQuizCardState();
}

class _DailyQuizCardState extends ConsumerState<DailyQuizCard> {
  int? _selectedOptionId;

  void _handleSelect(QuizQuestion question, int optionId) {
    if (_selectedOptionId != null) return;

    final isCorrect = optionId == question.targetWord.id;
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      ref.read(quizScoreProvider.notifier).increment();
    } else {
      HapticFeedback.lightImpact();
    }

    setState(() => _selectedOptionId = optionId);
  }

  void _nextQuestion() {
    HapticFeedback.selectionClick();
    setState(() => _selectedOptionId = null);
    ref.invalidate(quizQuestionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizQuestionProvider);
    final score = ref.watch(quizScoreProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return quizAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (question) {
        if (question == null) return const SizedBox.shrink();

        final target = question.targetWord;
        final headword = target.fullWordWithSymbols.isNotEmpty
            ? target.fullWordWithSymbols
            : target.fullWord;
        final hasAnswered = _selectedOptionId != null;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row: Badge + Score
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.brain,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'لبز آزمائی',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.trophy,
                            size: 13,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$score',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Question prompt
                Text(
                  'اے لبز ءِ راستیں مانا کجام اِنت؟',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  headword,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 14),

                // 4 Multiple-Choice Options
                ...question.options.map((option) {
                  final QuizOptionState tileState;
                  if (!hasAnswered) {
                    tileState = QuizOptionState.idle;
                  } else if (option.id == target.id) {
                    tileState = QuizOptionState.correct;
                  } else if (option.id == _selectedOptionId) {
                    tileState = QuizOptionState.wrong;
                  } else {
                    tileState = QuizOptionState.dimmed;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: QuizOptionTile(
                      text: QuizQuestion.formatOptionDefinition(option),
                      state: tileState,
                      onTap: hasAnswered
                          ? null
                          : () => _handleSelect(question, option.id),
                    ),
                  );
                }),

                // Post-answer actions
                if (hasAnswered) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordDetailScreen(wordId: target.id),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                        icon: const Icon(LucideIcons.bookOpen, size: 15),
                        label: const Text('سرجمیں مانا'),
                      ),
                      FilledButton.icon(
                        onPressed: _nextQuestion,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(LucideIcons.arrowLeft, size: 16),
                        label: const Text('دگہ جستے'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}
