import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../providers/dictionary_providers.dart';

class WordDetailScreen extends ConsumerWidget {
  final int wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordAsync = ref.watch(wordDetailProvider(wordId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لبز ءِ مانا'),
        actions: [
          wordAsync.maybeWhen(
            data: (word) => word == null
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'نقل کنگ',
                    icon: const Icon(LucideIcons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text:
                              '${word.fullWordWithSymbols}\n${word.definition}',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('لبز ءُ مانا نقل بوت انت'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: wordAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('ردی یے بوت: $err')),
        data: (word) {
          if (word == null) {
            return const Center(child: Text('لبز دست نہ کپت'));
          }

          final hasSymbols =
              word.fullWordWithSymbols.isNotEmpty &&
              word.fullWordWithSymbols != word.fullWord;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.fullWordWithSymbols.isNotEmpty
                              ? word.fullWordWithSymbols
                              : word.fullWord,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                        if (hasSymbols) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'سادگیں نبشتانک: ${word.fullWord}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مانا ءُ تشریح',
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 14),
                        SelectableText(
                          word.definition,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
