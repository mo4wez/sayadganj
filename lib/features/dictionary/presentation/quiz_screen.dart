import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../domain/quiz_question.dart';
import '../providers/quiz_provider.dart';
import 'widgets/quiz/quiz_option_tile.dart';
import 'widgets/quiz/quiz_summary_view.dart';
import 'word_detail_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  static const int _totalQuestions = 5;

  int _questionIndex = 0;
  int _roundCorrect = 0;
  int? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.invalidate(quizQuestionProvider);
    });
  }

  void _handleSelect(QuizQuestion question, int optionId) {
    if (_selectedOptionId != null) return;

    final isCorrect = optionId == question.targetWord.id;
    if (isCorrect) {
      HapticFeedback.mediumImpact();
      ref.read(quizScoreProvider.notifier).increment();
      _roundCorrect++;
    } else {
      HapticFeedback.lightImpact();
    }

    setState(() => _selectedOptionId = optionId);
  }

  void _advanceQuestion() {
    HapticFeedback.selectionClick();
    final nextIndex = _questionIndex + 1;

    setState(() {
      _selectedOptionId = null;
      _questionIndex = nextIndex;
    });

    if (nextIndex < _totalQuestions) {
      ref.invalidate(quizQuestionProvider);
    }
  }

  void _restartRound() {
    HapticFeedback.selectionClick();
    setState(() {
      _questionIndex = 0;
      _roundCorrect = 0;
      _selectedOptionId = null;
    });
    ref.invalidate(quizQuestionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizQuestionProvider);
    final lifetimeScore = ref.watch(quizScoreProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRoundComplete = _questionIndex >= _totalQuestions;

    final progress = isRoundComplete
        ? 1.0
        : (_questionIndex + (_selectedOptionId != null ? 1 : 0)) /
              _totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('گال چکّاس'),
        actions: [
          if (!isRoundComplete)
            Container(
              margin: const EdgeInsetsDirectional.only(end: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '${_questionIndex + 1} / $_totalQuestions',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.trophy, size: 14, color: colorScheme.primary),
                const SizedBox(width: 5),
                Text(
                  '$lifetimeScore',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Smooth round progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: colorScheme.secondary,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
            ),

            Expanded(
              child: isRoundComplete
                  ? QuizSummaryView(
                      roundCorrect: _roundCorrect,
                      totalQuestions: _totalQuestions,
                      lifetimeScore: lifetimeScore,
                      onPlayAgain: _restartRound,
                      onFinish: () => Navigator.of(context).pop(),
                    )
                  : quizAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, _) =>
                          Center(child: Text('ردی یے بوت: $err')),
                      data: (question) {
                        if (question == null) {
                          return const Center(
                            child: Text('پہ چکّاس ءَ گال دست نہ کپت'),
                          );
                        }

                        final target = question.targetWord;
                        final headword = target.fullWordWithSymbols.isNotEmpty
                            ? target.fullWordWithSymbols
                            : target.fullWord;
                        final hasAnswered = _selectedOptionId != null;

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            final offsetTween = Tween<Offset>(
                              begin: const Offset(-0.06, 0),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offsetTween,
                                child: child,
                              ),
                            );
                          },
                          child: ListView(
                            key: ValueKey('q_${_questionIndex}_${target.id}'),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            children: [
                              // Hero Headword Prompt Card
                              Card(
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: AlignmentDirectional.topStart,
                                      end: AlignmentDirectional.bottomEnd,
                                      colors: [
                                        colorScheme.primary.withValues(
                                          alpha: 0.10,
                                        ),
                                        colorScheme.surface,
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'اے گال ءِ راستیں مانا کجام اِنت؟',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        headword,
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              color: colorScheme.primary,
                                              fontSize: 28,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 4 Staggered Multiple-Choice Options
                              ...List.generate(question.options.length, (i) {
                                final option = question.options[i];
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
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child:
                                      QuizOptionTile(
                                            optionNumber: i + 1,
                                            text:
                                                QuizQuestion.formatOptionDefinition(
                                                  option,
                                                ),
                                            state: tileState,
                                            onTap: hasAnswered
                                                ? null
                                                : () => _handleSelect(
                                                    question,
                                                    option.id,
                                                  ),
                                          )
                                          .animate()
                                          .fadeIn(
                                            duration: 220.ms,
                                            delay: (45 * i).ms,
                                          )
                                          .slideY(
                                            begin: 0.04,
                                            end: 0,
                                            duration: 220.ms,
                                            delay: (45 * i).ms,
                                          ),
                                );
                              }),

                              // Post-answer action bar
                              if (hasAnswered) ...[
                                const SizedBox(height: 10),
                                Row(
                                      children: [
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    WordDetailScreen(
                                                      wordId: target.id,
                                                    ),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                            side: BorderSide(
                                              color: colorScheme.outline,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                          ),
                                          icon: const Icon(
                                            LucideIcons.bookOpen,
                                            size: 16,
                                          ),
                                          label: const Text('سرجمیں بزانت'),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: FilledButton.icon(
                                            onPressed: _advanceQuestion,
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primary,
                                              foregroundColor:
                                                  colorScheme.onPrimary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                            icon: const Icon(
                                              LucideIcons.arrowLeft,
                                              size: 18,
                                            ),
                                            label: Text(
                                              _questionIndex + 1 >=
                                                      _totalQuestions
                                                  ? 'آسر ءَ بچار'
                                                  : 'دیمتر ءِ جست',
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    .animate()
                                    .fadeIn(duration: 200.ms)
                                    .slideY(begin: 0.05, end: 0),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
