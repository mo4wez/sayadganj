import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

import '../../../domain/dictionary_notation.dart';
import 'notation_info_sheet.dart';

class NotationRichText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const NotationRichText({super.key, required this.text, this.style});

  @override
  State<NotationRichText> createState() => _NotationRichTextState();
}

class _NotationRichTextState extends State<NotationRichText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final baseStyle = widget.style ?? Theme.of(context).textTheme.bodyLarge!;
    final colorScheme = Theme.of(context).colorScheme;
    final text = widget.text;

    final spans = <InlineSpan>[];
    int cursor = 0;

    for (final match in DictionaryNotationRegistry.tokenPattern.allMatches(
      text,
    )) {
      final token = match.group(0);
      if (token == null) continue;

      final notation = DictionaryNotationRegistry.matchToken(
        token,
        fullText: text,
        start: match.start,
        end: match.end,
      );
      if (notation == null) continue;

      if (match.start > cursor) {
        spans.add(
          TextSpan(text: text.substring(cursor, match.start), style: baseStyle),
        );
      }

      final recognizer = TapGestureRecognizer()
        ..onTap = () => NotationInfoSheet.show(context, notation);
      _recognizers.add(recognizer);

      spans.add(
        TextSpan(
          text: token,
          recognizer: recognizer,
          style: baseStyle.copyWith(
            color: colorScheme.primary,
            backgroundColor: colorScheme.secondary,
            decoration: TextDecoration.underline,
            decorationColor: colorScheme.primary.withValues(alpha: 0.6),
            decorationStyle: TextDecorationStyle.dotted,
          ),
        ),
      );

      cursor = match.end;
    }

    if (spans.isEmpty) {
      return SelectableText(text, style: baseStyle);
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
    }

    return SelectableText.rich(TextSpan(children: spans));
  }
}
