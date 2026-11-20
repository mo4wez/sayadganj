import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/database/dictionary_db_service.dart';
import '../../providers/dictionary_providers.dart';
import '../word_detail_screen.dart';

class AlphabetDialSheet extends ConsumerStatefulWidget {
  final List<LetterBucket> buckets;
  final String? initialLetter;
  final ValueChanged<String> onConfirmLetter;

  const AlphabetDialSheet({
    super.key,
    required this.buckets,
    required this.initialLetter,
    required this.onConfirmLetter,
  });

  static Future<void> show(
    BuildContext context, {
    required List<LetterBucket> buckets,
    required String? initialLetter,
    required ValueChanged<String> onConfirmLetter,
  }) {
    if (buckets.isEmpty) return Future.value();
    HapticFeedback.lightImpact();

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AlphabetDialSheet(
        buckets: buckets,
        initialLetter: initialLetter,
        onConfirmLetter: onConfirmLetter,
      ),
    );
  }

  @override
  ConsumerState<AlphabetDialSheet> createState() => _AlphabetDialSheetState();
}

class _AlphabetDialSheetState extends ConsumerState<AlphabetDialSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _snapController;
  Animation<double>? _snapAnimation;

  late double _virtualIndex;
  late int _activeIndex;

  static const double _pixelsPerStep = 64.0;
  static const double _angleStep = 0.25; // Radians between letters on the arc

  static const Map<String, String> _letterNames = {
    'ا': 'الف / آ',
    'ب': 'بے',
    'پ': 'پے',
    'ت': 'تے',
    'ٹ': 'ٹے',
    'ث': 'ثے',
    'ج': 'جیم',
    'چ': 'چے',
    'ح': 'حے',
    'خ': 'خے',
    'د': 'دال',
    'ڈ': 'ڈال',
    'ذ': 'ذال',
    'ر': 'رے',
    'ڑ': 'ڑے',
    'ز': 'زے',
    'ژ': 'ژے',
    'س': 'سین',
    'ش': 'شین',
    'ص': 'صاد',
    'ض': 'ضاد',
    'ط': 'طوئے',
    'ظ': 'ظوئے',
    'ع': 'عین',
    'غ': 'غین',
    'ف': 'فے',
    'ق': 'قاف',
    'ک': 'کاف',
    'گ': 'گاف',
    'ل': 'لام',
    'م': 'میم',
    'ن': 'نون',
    'و': 'واؤ',
    'ھ': 'دوچشمی ھ',
    'ه': 'گول هے',
    'ی': 'بلوچی یے',
    'ے': 'بڑی ے',
  };

  @override
  void initState() {
    super.initState();
    final foundIndex = widget.initialLetter == null
        ? 0
        : widget.buckets.indexWhere((b) => b.letter == widget.initialLetter);
    _activeIndex = foundIndex >= 0 ? foundIndex : 0;
    _virtualIndex = _activeIndex.toDouble();

    _snapController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 260),
        )..addListener(() {
          if (_snapAnimation != null) {
            setState(() {
              _virtualIndex = _snapAnimation!.value;
              _syncActiveIndex();
            });
          }
        });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _syncActiveIndex() {
    final rounded = _virtualIndex.round().clamp(0, widget.buckets.length - 1);
    if (rounded != _activeIndex) {
      _activeIndex = rounded;
      HapticFeedback.selectionClick();
    }
  }

  void _animateToIndex(int targetIndex) {
    final clamped = targetIndex.clamp(0, widget.buckets.length - 1);
    _snapController.stop();
    _snapAnimation =
        Tween<double>(begin: _virtualIndex, end: clamped.toDouble()).animate(
          CurvedAnimation(parent: _snapController, curve: Curves.easeOutBack),
        );
    _snapController.forward(from: 0);
  }

  String _glyph(String letter) => letter == 'ا' ? 'ا / آ' : letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentBucket = widget.buckets[_activeIndex];
    final samplesAsync = ref.watch(
      letterSampleWordsProvider(currentBucket.letter),
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: colorScheme.outline, width: 1.2)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Top handle bar
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 16),

            // Header bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.compass,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text('چرخِ آب ءُ ب', style: theme.textTheme.titleLarge),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.x, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Center Calligraphic Hero Medallion
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
                widget.onConfirmLetter(currentBucket.letter);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer decorative astrolabe ring
                  SizedBox(
                    width: 148,
                    height: 148,
                    child: CustomPaint(
                      painter: _MedallionRingPainter(
                        primaryColor: colorScheme.primary,
                        borderColor: colorScheme.outline,
                      ),
                    ),
                  ),
                  // Inner glowing circle
                  Container(
                    width: 122,
                    height: 122,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          colorScheme.primary.withValues(alpha: 0.22),
                          colorScheme.secondary,
                        ],
                      ),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 150),
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: Text(
                            _glyph(currentBucket.letter),
                            key: ValueKey(currentBucket.letter),
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.primary,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${currentBucket.count} لبز',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Letter traditional name pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                _letterNames[currentBucket.letter] ?? currentBucket.letter,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Live 3-Word Sample Preview Strip
            SizedBox(
              height: 36,
              child: samplesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (samples) {
                  if (samples.isEmpty) return const SizedBox.shrink();
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: samples.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final sample = samples[index];
                      return ActionChip(
                        label: Text(
                          sample.fullWordWithSymbols.isNotEmpty
                              ? sample.fullWordWithSymbols
                              : sample.fullWord,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        backgroundColor: theme.scaffoldBackgroundColor,
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordDetailScreen(wordId: sample.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Curved Rotary Arc Dial
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragStart: (_) => _snapController.stop(),
              onHorizontalDragUpdate: (details) {
                setState(() {
                  // Dragging right advances RTL index (ا -> ب -> پ)
                  _virtualIndex =
                      (_virtualIndex + details.delta.dx / _pixelsPerStep).clamp(
                        0.0,
                        (widget.buckets.length - 1).toDouble(),
                      );
                  _syncActiveIndex();
                });
              },
              onHorizontalDragEnd: (_) {
                _animateToIndex(_virtualIndex.round());
              },
              child: SizedBox(
                height: 148,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final radius = width * 0.82;
                    final cx = width / 2;
                    final cy = radius + 44;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Arc track & degree tick marks
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ArcTrackPainter(
                              radius: radius,
                              centerY: cy,
                              virtualIndex: _virtualIndex,
                              angleStep: _angleStep,
                              primaryColor: colorScheme.primary,
                              borderColor: colorScheme.outline,
                            ),
                          ),
                        ),

                        // Positioned letters along the curve
                        for (int i = 0; i < widget.buckets.length; i++)
                          if ((i - _virtualIndex).abs() <= 4.3)
                            _buildDialLetter(
                              index: i,
                              bucket: widget.buckets[i],
                              cx: cx,
                              cy: cy,
                              radius: radius,
                              colorScheme: colorScheme,
                            ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Bottom Action Bar (Prev / Confirm CTA / Next)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'پێشتر',
                    onPressed: _activeIndex > 0
                        ? () => _animateToIndex(_activeIndex - 1)
                        : null,
                    icon: const Icon(LucideIcons.chevronRight, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.of(context).pop();
                        widget.onConfirmLetter(currentBucket.letter);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(LucideIcons.bookOpenCheck, size: 18),
                      label: Text(
                        'حرف «${_glyph(currentBucket.letter)}» ءِ لبزاں بچار',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.outlined(
                    tooltip: 'دیمتر',
                    onPressed: _activeIndex < widget.buckets.length - 1
                        ? () => _animateToIndex(_activeIndex + 1)
                        : null,
                    icon: const Icon(LucideIcons.chevronLeft, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 180.ms);
  }

  Widget _buildDialLetter({
    required int index,
    required LetterBucket bucket,
    required double cx,
    required double cy,
    required double radius,
    required ColorScheme colorScheme,
  }) {
    final diff = index - _virtualIndex;
    final theta = diff * _angleStep;

    // RTL curve placement: index 0 starts center, increasing index flows left
    final x = cx - radius * math.sin(theta);
    final y = cy - radius * math.cos(theta);

    final dist = diff.abs();
    final scale = (1.16 - dist * 0.14).clamp(0.64, 1.16);
    final opacity = (1.0 - dist * 0.21).clamp(0.0, 1.0);
    final isCentered = dist < 0.45;

    const double itemSize = 54;

    return Positioned(
      left: x - itemSize / 2,
      top: y - itemSize / 2,
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: -theta * 0.65,
          child: Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: () => _animateToIndex(index),
              child: Container(
                width: itemSize,
                height: itemSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCentered
                      ? colorScheme.primary
                      : colorScheme.secondary,
                  border: Border.all(
                    color: isCentered
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: isCentered ? 2 : 1,
                  ),
                  boxShadow: isCentered
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  _glyph(bucket.letter),
                  style: TextStyle(
                    fontSize: bucket.letter == 'ا' ? 16 : 21,
                    fontWeight: FontWeight.w800,
                    color: isCentered
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcTrackPainter extends CustomPainter {
  final double radius;
  final double centerY;
  final double virtualIndex;
  final double angleStep;
  final Color primaryColor;
  final Color borderColor;

  _ArcTrackPainter({
    required this.radius,
    required this.centerY,
    required this.virtualIndex,
    required this.angleStep,
    required this.primaryColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, centerY);

    // Outer & inner concentric wheel rings
    final outerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final innerPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius + 34, outerPaint);
    canvas.drawCircle(center, radius - 34, innerPaint);

    // Degree tick marks rotating with the dial
    final tickPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final subStep = angleStep / 3;
    final fractionalOffset = (virtualIndex % 1.0) * angleStep;

    for (double a = -1.2; a <= 1.2; a += subStep) {
      final theta = a + fractionalOffset;
      final p1 = Offset(
        center.dx - (radius + 34) * math.sin(theta),
        center.dy - (radius + 34) * math.cos(theta),
      );
      final p2 = Offset(
        center.dx - (radius + 27) * math.sin(theta),
        center.dy - (radius + 27) * math.cos(theta),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Top-center pointer indicator notch
    final topY = centerY - radius - 42;
    final pointerPath = Path()
      ..moveTo(size.width / 2, topY + 7)
      ..lineTo(size.width / 2 - 6, topY)
      ..lineTo(size.width / 2 + 6, topY)
      ..close();

    canvas.drawPath(pointerPath, Paint()..color = primaryColor);
  }

  @override
  bool shouldRepaint(covariant _ArcTrackPainter oldDelegate) {
    return oldDelegate.virtualIndex != virtualIndex ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.borderColor != borderColor;
  }
}

class _MedallionRingPainter extends CustomPainter {
  final Color primaryColor;
  final Color borderColor;

  _MedallionRingPainter({
    required this.primaryColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final dotPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    const int dots = 24;
    for (int i = 0; i < dots; i++) {
      final angle = (2 * math.pi / dots) * i;
      final pos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawCircle(pos, i % 2 == 0 ? 2.0 : 1.1, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MedallionRingPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor;
}
