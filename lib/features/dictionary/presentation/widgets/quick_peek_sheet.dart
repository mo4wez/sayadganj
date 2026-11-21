import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../bookmarks/providers/bookmarks_provider.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../providers/dictionary_providers.dart';
import '../word_detail_screen.dart';

class QuickPeekSheet extends ConsumerWidget {
  final String targetWord;

  const QuickPeekSheet({super.key, required this.targetWord});

  static Future<void> show(BuildContext context, String targetWord) {
    HapticFeedback.lightImpact();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuickPeekSheet(targetWord: targetWord),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordAsync = ref.watch(crossReferenceWordProvider(targetWord));
    final fontScale = ref.watch(fontScaleProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.68,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: colorScheme.outline, width: 1.2)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
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

            // Header badge + Close button
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
                        LucideIcons.eye,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'زوتیں چارگ',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(LucideIcons.x, size: 18),
                  style: IconButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Body content
            Flexible(
              child: wordAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('ردی یے بوت: $err')),
                ),
                data: (word) {
                  if (word == null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.searchX,
                            size: 28,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'لبز «$targetWord» دست نہ کپت',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final isSaved = ref.watch(isBookmarkedProvider(word.id));
                  final displayHeadword = word.fullWordWithSymbols.isNotEmpty
                      ? word.fullWordWithSymbols
                      : word.fullWord;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                displayHeadword,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: isSaved ? 'نشان دور کنگ' : 'نشان کنگ',
                              onPressed: () async {
                                HapticFeedback.selectionClick();
                                await ref
                                    .read(bookmarkControllerProvider.notifier)
                                    .toggle(word);
                              },
                              icon: Icon(
                                isSaved
                                    ? LucideIcons.bookmarkCheck
                                    : LucideIcons.bookmark,
                                size: 20,
                                color: isSaved
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 12),
                        SelectableText(
                          word.definition,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 15.5 * fontScale,
                          ),
                        ),
                        const SizedBox(height: 18),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    WordDetailScreen(wordId: word.id),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(LucideIcons.arrowUpLeft, size: 18),
                          label: const Text(
                            'سرجمیں تاکدیم ءَ پچ کن',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 160.ms);
  }
}
