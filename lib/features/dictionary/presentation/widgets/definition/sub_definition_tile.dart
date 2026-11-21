import 'package:material_ui/material_ui.dart';

import '../../../domain/definition_parser.dart';
import '../notations/notation_rich_text.dart';

class SubDefinitionTile extends StatelessWidget {
  final SubDefinitionEntry entry;
  final int index;
  final double fontScale;

  const SubDefinitionTile({
    super.key,
    required this.entry,
    required this.index,
    required this.fontScale,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  entry.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15.5 * fontScale,
                    color: colorScheme.primary,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          NotationRichText(
            text: entry.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 15.5 * fontScale,
              height: 1.85,
            ),
          ),
        ],
      ),
    );
  }
}
