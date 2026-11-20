import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dictionary_providers.dart';

class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('سیدگنج')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'لبزے بہ شوهاز...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (text) {
                ref.read(searchQueryProvider.notifier).update(text);
                // TODO: Tell searchQueryProvider to update with `text`
                // Hint: ref.read(searchQueryProvider.notifier).update(text);
              },
            ),
          ),
          Expanded(
            child: query.trim().isEmpty
                ? const Center(child: Text('یک لبزے نبیس ءُ شوهاز بہ کن'))
                : resultsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Center(child: Text('ردی یے بوت: $err')),
                    data: (words) {
                      if (words.isEmpty) {
                        return const Center(child: Text('هچ لبزے دست نہ کپت'));
                      }
                      return ListView.builder(
                        itemCount: words.length,
                        itemBuilder: (context, index) {
                          final word = words[index];
                          return ListTile(
                            title: Text(word.fullWordWithSymbols),
                            subtitle: Text(
                              word.definition,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
