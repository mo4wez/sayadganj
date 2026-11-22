import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../providers/reading_activity_provider.dart';
import '../../word_detail_screen.dart';

class ReadingStreakCard extends ConsumerWidget {
  const ReadingStreakCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(readingActivityProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return activityAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final hasHistory =
            summary.recentWords.isNotEmpty ||
            summary.streakDays > 0 ||
            summary.totalUniqueCount > 0;

        if (!hasHistory) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      LucideIcons.flame,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'گالے پچ کن دانکہ تئی وانگ ءِ رِد ءُ تازگیں دیستگیں گال بنگیج بہ بنت',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final hasRecentWords = summary.recentWords.isNotEmpty;

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: hasRecentWords ? 14 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Streak & Stats Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.flame,
                              size: 14,
                              color: colorScheme.onPrimary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${summary.streakDays} روچ رِد',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _StatPill(label: 'مرچی', value: '${summary.todayCount}'),
                      const SizedBox(width: 8),
                      _StatPill(
                        label: 'کل دیستگیں',
                        value: '${summary.totalUniqueCount}',
                      ),
                    ],
                  ),
                ),

                // Recently Viewed Words Strip
                if (hasRecentWords) ...[
                  const SizedBox(height: 14),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              LucideIcons.bookOpenCheck,
                              size: 15,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'نوکیں دیستگیں گال',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            ref
                                .read(
                                  readingActivityControllerProvider.notifier,
                                )
                                .clearRecentWords();
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            child: Text(
                              'گار کنگ',
                              style: theme.textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _FadingRecentWordsStrip(words: summary.recentWords),
                ],
              ],
            ),
          ),
        ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.03, end: 0);
      },
    );
  }
}

class _FadingRecentWordsStrip extends StatefulWidget {
  final List<dynamic> words;

  const _FadingRecentWordsStrip({required this.words});

  @override
  State<_FadingRecentWordsStrip> createState() =>
      _FadingRecentWordsStripState();
}

class _FadingRecentWordsStripState extends State<_FadingRecentWordsStrip> {
  bool _fadeLeft = false;
  bool _fadeRight = false;

  void _updateEdgeFades(ScrollMetrics metrics, bool isRtl) {
    final hasStartOverflow = metrics.pixels > 2;
    final hasEndOverflow = metrics.pixels < metrics.maxScrollExtent - 2;

    final nextFadeLeft = isRtl ? hasEndOverflow : hasStartOverflow;
    final nextFadeRight = isRtl ? hasStartOverflow : hasEndOverflow;

    if (nextFadeLeft != _fadeLeft || nextFadeRight != _fadeRight) {
      setState(() {
        _fadeLeft = nextFadeLeft;
        _fadeRight = nextFadeRight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 36,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _updateEdgeFades(notification.metrics, isRtl);
          return false;
        },
        child: NotificationListener<ScrollMetricsNotification>(
          onNotification: (notification) {
            _updateEdgeFades(notification.metrics, isRtl);
            return false;
          },
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  _fadeLeft ? Colors.transparent : Colors.black,
                  Colors.black,
                  Colors.black,
                  _fadeRight ? Colors.transparent : Colors.black,
                ],
                stops: const [0.0, 0.07, 0.93, 1.0],
              ).createShader(bounds);
            },
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.words.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = widget.words[index];
                return ActionChip(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(
                    item.displayWord,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor,
                  side: BorderSide(color: colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WordDetailScreen(wordId: item.wordId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '$label: $value',
        style: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
