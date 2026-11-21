import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../domain/quiz_question.dart';
import '../../../domain/word_entry.dart';
import '../../word_detail_screen.dart';

class FlipWordCard extends StatefulWidget {
  final WordEntry word;

  const FlipWordCard({super.key, required this.word});

  @override
  State<FlipWordCard> createState() => _FlipWordCardState();
}

class _FlipWordCardState extends State<FlipWordCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _flipAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant FlipWordCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id && !_isFront) {
      _controller.reset();
      _isFront = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    HapticFeedback.selectionClick();
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, _) {
          final angle = _flipAnimation.value * math.pi;
          final showFront = angle <= (math.pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..rotateY(showFront ? angle : angle - math.pi),
            child: showFront
                ? _FrontFace(word: widget.word)
                : _BackFace(word: widget.word),
          );
        },
      ),
    );
  }
}

class _FrontFace extends StatelessWidget {
  final WordEntry word;

  const _FrontFace({required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final headword = word.fullWordWithSymbols.isNotEmpty
        ? word.fullWordWithSymbols
        : word.fullWord;
    final hasPlainForm =
        word.fullWordWithSymbols.isNotEmpty &&
        word.fullWordWithSymbols != word.fullWord;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [colorScheme.secondary, theme.scaffoldBackgroundColor],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            headword,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontSize: 28,
            ),
          ),
          if (hasPlainForm) ...[
            const SizedBox(height: 6),
            Text(word.fullWord, style: theme.textTheme.bodyMedium),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.rotateCw, size: 14, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'بزانت ءِ چارگ ءَ بہ ٹپّ',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackFace extends StatelessWidget {
  final WordEntry word;

  const _BackFace({required this.word});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final meaning = QuizQuestion.formatOptionDefinition(word);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.primary, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word.fullWord,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              Icon(
                LucideIcons.rotateCcw,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Text(
                meaning,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15,
                  height: 1.65,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => WordDetailScreen(wordId: word.id),
                  ),
                );
              },
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: colorScheme.primary,
              ),
              icon: const Icon(LucideIcons.arrowUpLeft, size: 15),
              label: const Text('سرجمیں مانا'),
            ),
          ),
        ],
      ),
    );
  }
}
