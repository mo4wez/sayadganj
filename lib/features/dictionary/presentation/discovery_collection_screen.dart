import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../domain/discovery_category.dart';
import '../providers/discovery_provider.dart';
import 'widgets/word_card.dart';
import 'word_detail_screen.dart';

class DiscoveryCollectionScreen extends ConsumerWidget {
  final DiscoveryCategory category;

  const DiscoveryCollectionScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(discoveryWordsProvider(category));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.title),
        actions: [
          if (category.supportsRefresh)
            IconButton(
              tooltip: 'نوکیں لبز',
              icon: const Icon(LucideIcons.refreshCw, size: 19),
              onPressed: () {
                HapticFeedback.selectionClick();
                ref.invalidate(discoveryWordsProvider(category));
              },
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('ردی یے بوت: $err')),
        data: (words) {
          if (words.isEmpty) {
            return Center(
              child: Text(
                'هچ لبزے دست نہ کپت',
                style: theme.textTheme.titleMedium,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: words.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(category.icon, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${category.subtitle} (${words.length} لبز)',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final word = words[index - 1];
              return WordCard(
                    word: word,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => WordDetailScreen(wordId: word.id),
                        ),
                      );
                    },
                  )
                  .animate()
                  .fadeIn(duration: 180.ms)
                  .slideY(begin: 0.03, end: 0, duration: 180.ms);
            },
          );
        },
      ),
    );
  }
}
