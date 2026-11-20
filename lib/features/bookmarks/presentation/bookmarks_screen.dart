import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../dictionary/presentation/widgets/word_card.dart';
import '../../dictionary/presentation/word_detail_screen.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('نشان کتگیں لبز')),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('ردی یے بوت: $err')),
        data: (words) {
          if (words.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.bookmark,
                        size: 30,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'انگت هچ لبزے نشان نہ بوتگ',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'وتی دوست داشتگیں لبزاں پہ زوت دست گرگ ءَ نشان بہ کن',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: words.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final word = words[index];

              return Dismissible(
                key: ValueKey(word.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(LucideIcons.trash2, color: colorScheme.error),
                ),
                onDismissed: (_) {
                  ref.read(bookmarkControllerProvider.notifier).remove(word.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('«${word.fullWord}» چہ نشاناں دور کنگ بوت'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'پدا بیار',
                        onPressed: () {
                          ref
                              .read(bookmarkControllerProvider.notifier)
                              .toggle(word);
                        },
                      ),
                    ),
                  );
                },
                child: WordCard(
                  word: word,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WordDetailScreen(wordId: word.id),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(duration: 180.ms);
            },
          );
        },
      ),
    );
  }
}
