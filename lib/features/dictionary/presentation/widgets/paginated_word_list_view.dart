import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/search_scope.dart';
import '../../domain/word_entry.dart';
import '../../providers/paginated_words_provider.dart';
import 'word_card.dart';

class PaginatedWordListView extends StatelessWidget {
  final AsyncValue<PaginatedWordsState> asyncState;
  final VoidCallback onLoadMore;
  final ValueChanged<WordEntry> onTapWord;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final String highlightQuery;
  final SearchScope scope;
  final bool useSliverOverlap;

  const PaginatedWordListView({
    super.key,
    required this.asyncState,
    required this.onLoadMore,
    required this.onTapWord,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.highlightQuery = '',
    this.scope = SearchScope.containsHeadword,
    this.useSliverOverlap = false,
  });

  bool _handleScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.pixels >= metrics.maxScrollExtent - 320) {
      onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return asyncState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _EmptyListPlaceholder(
        icon: LucideIcons.circleAlert,
        title: 'ردی یے بوت',
        subtitle: '$err',
        useSliverOverlap: useSliverOverlap,
      ),
      data: (pageState) {
        final words = pageState.items;
        if (words.isEmpty) {
          return _EmptyListPlaceholder(
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: emptySubtitle,
            useSliverOverlap: useSliverOverlap,
          );
        }

        final showFooter = pageState.isLoadingMore || !pageState.hasMore;
        final totalCount = words.length + (showFooter ? 1 : 0);

        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: Scrollbar(
            interactive: true,
            radius: const Radius.circular(100),
            child: CustomScrollView(
              slivers: [
                if (useSliverOverlap)
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 24 + bottomInset),
                  sliver: SliverList.separated(
                    addAutomaticKeepAlives: false,
                    itemCount: totalCount,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index >= words.length) {
                        if (pageState.isLoadingMore) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                ),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Center(
                            child: Text(
                              'سرجمیں ${words.length} گال پیش دارگ بوت انت',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        );
                      }

                      final word = words[index];
                      final card = WordCard(
                        word: word,
                        highlightQuery: highlightQuery,
                        scope: scope,
                        onTap: () => onTapWord(word),
                      );

                      if (index < 8) {
                        return card
                            .animate()
                            .fadeIn(duration: 180.ms)
                            .slideY(begin: 0.03, end: 0, duration: 180.ms);
                      }

                      return card;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyListPlaceholder extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool useSliverOverlap;

  const _EmptyListPlaceholder({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.useSliverOverlap = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Center(
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
              child: Icon(icon, size: 30, color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (!useSliverOverlap) return content;

    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverFillRemaining(hasScrollBody: false, child: content),
      ],
    );
  }
}
