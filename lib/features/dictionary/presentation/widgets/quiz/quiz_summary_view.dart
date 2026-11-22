import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class QuizSummaryView extends StatelessWidget {
  final int roundCorrect;
  final int totalQuestions;
  final int lifetimeScore;
  final VoidCallback onPlayAgain;
  final VoidCallback onFinish;

  const QuizSummaryView({
    super.key,
    required this.roundCorrect,
    required this.totalQuestions,
    required this.lifetimeScore,
    required this.onPlayAgain,
    required this.onFinish,
  });

  String get _feedbackTitle {
    final ratio = roundCorrect / totalQuestions;
    if (ratio >= 0.8) return 'باز وش! تئی بلوچی زانت مزن اِنت';
    if (ratio >= 0.5) return 'شاباش! دیمتر ءَ انگت گهتر بئے';
    return 'جهد ءَ برجاہ بدار، هر جستے نوکیں لبزے';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.trophy,
                        size: 32,
                        color: colorScheme.primary,
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 320.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(duration: 220.ms),
                const SizedBox(height: 18),
                Text(
                  'آزمائی سرجم بوت!',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  _feedbackTitle,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),

                // Score pill row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$roundCorrect / $totalQuestions',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'اے دور ءِ راستیں پسّو',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$lifetimeScore',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'کل امتیاز',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Primary CTA: Play another round
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onPlayAgain,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(LucideIcons.rotateCcw, size: 18),
                    label: const Text('نوکیں دورے بندات کن'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onFinish,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: BorderSide(color: colorScheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('پدا پہ لبزبلد ءَ'),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.04, end: 0),
      ),
    );
  }
}
