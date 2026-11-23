import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../domain/definition_parser.dart';
import '../../../../../l10n/app_localizations.dart';
import '../notations/notation_rich_text.dart';
import 'sub_definition_tile.dart';

class StructuredDefinitionCard extends StatefulWidget {
  final String headword;
  final String definition;
  final double fontScale;

  const StructuredDefinitionCard({
    super.key,
    required this.headword,
    required this.definition,
    required this.fontScale,
  });

  @override
  State<StructuredDefinitionCard> createState() =>
      _StructuredDefinitionCardState();
}

class _StructuredDefinitionCardState extends State<StructuredDefinitionCard> {
  bool _showRawText = false;
  int? _selectedSubIndex;

  @override
  void didUpdateWidget(covariant StructuredDefinitionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.definition != widget.definition) {
      _showRawText = false;
      _selectedSubIndex = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsed = DefinitionParser.parse(
      headword: widget.headword,
      definition: widget.definition,
    );
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: 16 * widget.fontScale,
      height: 1.85,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header row + Structured/Raw view toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.definitionHeaderTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
                if (parsed.isStructured)
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _showRawText = !_showRawText);
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _showRawText
                                ? LucideIcons.layoutList
                                : LucideIcons.alignRight,
                            size: 13,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _showRawText
                                ? l10n.structuredViewLabel
                                : l10n.rawTextViewLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 11.5,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 12),

            // Raw continuous text fallback or short entries
            if (_showRawText || !parsed.isStructured)
              NotationRichText(text: widget.definition, style: bodyStyle)
            else ...[
              // 1. Phonetic / letter-by-letter vocalization pill
              if (parsed.phoneticSpelling != null) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.letterSequenceLabel(parsed.phoneticSpelling!),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 2. Core Meaning (بُنی بزانت)
              if (parsed.primaryMeaning.isNotEmpty) ...[
                if (parsed.subEntries.isNotEmpty) ...[
                  Text(
                    l10n.coreMeaningLabel,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 11.5,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                if (parsed.narrativeParagraphs.isNotEmpty)
                  ...List.generate(parsed.narrativeParagraphs.length, (i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: i == parsed.narrativeParagraphs.length - 1
                            ? 0
                            : 12,
                      ),
                      child: NotationRichText(
                        text: parsed.narrativeParagraphs[i],
                        style: bodyStyle,
                      ),
                    );
                  })
                else
                  Container(
                    padding: parsed.subEntries.isNotEmpty
                        ? const EdgeInsets.all(14)
                        : EdgeInsets.zero,
                    decoration: parsed.subEntries.isNotEmpty
                        ? BoxDecoration(
                            color: colorScheme.secondary.withValues(
                              alpha: 0.45,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          )
                        : null,
                    child: NotationRichText(
                      text: parsed.primaryMeaning,
                      style: bodyStyle,
                    ),
                  ),
              ],

              // 3. Compound Idioms & Sub-entries (گالرد ءُ بن‌تہر)
              if (parsed.subEntries.isNotEmpty) ...[
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(
                      LucideIcons.listTree,
                      size: 15,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.compoundsAndSubEntriesCount(
                        parsed.subEntries.length,
                      ),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // Quick filter chips when there are 4 or more compounds
                if (parsed.subEntries.length >= 4) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: parsed.subEntries.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, idx) {
                        final isAll = idx == 0;
                        final subIdx = idx - 1;
                        final isSelected = isAll
                            ? _selectedSubIndex == null
                            : _selectedSubIndex == subIdx;

                        return ChoiceChip(
                          label: Text(
                            isAll
                                ? l10n.allItemsCount(parsed.subEntries.length)
                                : parsed.subEntries[subIdx].title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: colorScheme.primary,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                          visualDensity: VisualDensity.compact,
                          onSelected: (_) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedSubIndex = isAll ? null : subIdx;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                ...List.generate(parsed.subEntries.length, (index) {
                  if (_selectedSubIndex != null && _selectedSubIndex != index) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SubDefinitionTile(
                      entry: parsed.subEntries[index],
                      index: index,
                      fontScale: widget.fontScale,
                    ),
                  );
                }),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
