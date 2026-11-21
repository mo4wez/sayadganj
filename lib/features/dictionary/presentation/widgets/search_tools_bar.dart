import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/search_scope.dart';
import '../../providers/dictionary_providers.dart';

class SearchToolsBar extends ConsumerWidget {
  final ValueChanged<String> onInsertChar;

  const SearchToolsBar({super.key, required this.onInsertChar});

  static const List<String> _balochiKeys = [
    'ٹ',
    'ڈ',
    'ڑ',
    'ژ',
    'ء',
    'ے',
    'ھ',
    'گ',
    'پ',
    'چ',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeScope = ref.watch(searchScopeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Search Scope Segmented Pills
          Row(
            children: SearchScope.values.map((scope) {
              final selected = activeScope == scope;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: scope == SearchScope.values.last ? 0 : 6,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(searchScopeProvider.notifier).setScope(scope);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ),
                      child: Text(
                        scope.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: selected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // 2. Balochi Special Characters Strip
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _balochiKeys.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final char = _balochiKeys[index];
                return Material(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onInsertChar(char);
                    },
                    child: Container(
                      width: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        char,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
