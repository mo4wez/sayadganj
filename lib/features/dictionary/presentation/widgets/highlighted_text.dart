import 'package:material_ui/material_ui.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final Color highlightColor;
  final Color highlightBackgroundColor;
  final int? maxLines;
  final TextOverflow overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    required this.highlightColor,
    required this.highlightBackgroundColor,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  });

  static final RegExp _diacriticsRegex = RegExp(r'[\u064B-\u065F\u0670]');

  static String _normalizeChar(String ch) {
    return switch (ch) {
      'آ' || 'أ' || 'إ' => 'ا',
      'ي' => 'ی',
      'ك' => 'ک',
      _ => ch,
    };
  }

  static String _normalizeQuery(String input) {
    final stripped = input.trim().replaceAll(_diacriticsRegex, '');
    final buffer = StringBuffer();
    for (int i = 0; i < stripped.length; i++) {
      buffer.write(_normalizeChar(stripped[i]));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cleanQuery = _normalizeQuery(query);
    if (cleanQuery.isEmpty || text.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final normBuffer = StringBuffer();
    final indexMap = <int>[];

    for (int i = 0; i < text.length; i++) {
      final ch = text[i];
      if (_diacriticsRegex.hasMatch(ch)) continue;
      normBuffer.write(_normalizeChar(ch));
      indexMap.add(i);
    }

    final normalizedText = normBuffer.toString();
    if (normalizedText.isEmpty || !normalizedText.contains(cleanQuery)) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final matchStyle = baseStyle.copyWith(
      color: highlightColor,
      backgroundColor: highlightBackgroundColor,
    );

    final spans = <TextSpan>[];
    int normCursor = 0;
    int rawCursor = 0;

    while (normCursor <= normalizedText.length - cleanQuery.length) {
      final matchNormStart = normalizedText.indexOf(cleanQuery, normCursor);
      if (matchNormStart == -1) break;

      final matchNormEnd = matchNormStart + cleanQuery.length - 1;
      final rawStart = indexMap[matchNormStart];

      int rawEnd = indexMap[matchNormEnd] + 1;
      while (rawEnd < text.length && _diacriticsRegex.hasMatch(text[rawEnd])) {
        rawEnd++;
      }

      if (rawStart > rawCursor) {
        spans.add(
          TextSpan(text: text.substring(rawCursor, rawStart), style: baseStyle),
        );
      }

      spans.add(
        TextSpan(text: text.substring(rawStart, rawEnd), style: matchStyle),
      );

      rawCursor = rawEnd;
      normCursor = matchNormEnd + 1;
    }

    if (rawCursor < text.length) {
      spans.add(TextSpan(text: text.substring(rawCursor), style: baseStyle));
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(children: spans),
    );
  }
}
