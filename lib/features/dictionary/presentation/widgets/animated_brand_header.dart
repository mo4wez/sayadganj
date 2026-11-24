import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

/// Maps [v] in [a, b] to 0..1 and applies [curve].
double _seg(double v, double a, double b, [Curve curve = Curves.linear]) =>
    curve.transform(((v - a) / (b - a)).clamp(0.0, 1.0));

class AnimatedBrandHeader extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const AnimatedBrandHeader({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  State<AnimatedBrandHeader> createState() => _AnimatedBrandHeaderState();
}

class _AnimatedBrandHeaderState extends State<AnimatedBrandHeader>
    with TickerProviderStateMixin {
  /// How often the accent replays on its own. Between plays nothing animates.
  static const Duration _accentInterval = Duration(seconds: 12);

  /// How long the description stays before returning to the title.
  /// Set to null to keep it until the next tap.
  static const Duration? _descriptionHold = Duration(seconds: 4);

  /// Point in the swap timeline where exit ends and enter begins.
  static const double _swapMid = 0.4;

  // One-shot entrance.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  // Accent: page tilt + sparkle + title sheen.
  late final AnimationController _accent = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  // Tap spring + wobble.
  late final AnimationController _tap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );

  // Title <-> description typographic swap (0..0.4 exit, 0.4..1 enter).
  late final AnimationController _swap = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  late final Animation<double> _tapScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.88), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.08), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 30),
  ]).animate(CurvedAnimation(parent: _tap, curve: Curves.easeOut));

  Timer? _accentTimer;
  Timer? _holdTimer;
  bool _started = false;
  bool _reduceMotion = false;
  bool _showDescription = false;

  List<String> _wordsOf(bool description) =>
      (description ? widget.description : widget.title).trim().split(
        RegExp(r'\s+'),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);

    if (!_started) {
      _started = true;
      if (_reduceMotion) {
        _intro.value = 1.0;
      } else {
        _playIntro();
      }
    }
  }

  Future<void> _playIntro() async {
    await _intro.forward();
    if (!mounted || _reduceMotion) return;
    _accent.forward(from: 0.0);
    _scheduleAccent();
  }

  void _scheduleAccent() {
    _accentTimer?.cancel();
    _accentTimer = Timer(_accentInterval, () {
      if (!mounted) return;
      // Skip while another route covers this screen, or with reduce-motion on.
      if (!_reduceMotion && TickerMode.of(context)) {
        _accent.forward(from: 0.0);
      }
      _scheduleAccent();
    });
  }

  void _toggleText() {
    // Ignore taps during the intro or an in-flight swap.
    if (!_intro.isCompleted || _swap.isAnimating) return;

    _holdTimer?.cancel();
    setState(() => _showDescription = !_showDescription);

    if (!_reduceMotion) {
      _swap.forward(from: 0.0);
    }

    final hold = _descriptionHold;
    if (_showDescription && hold != null) {
      _holdTimer = Timer(hold, () {
        if (mounted && _showDescription) _toggleText();
      });
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _tap.forward(from: 0.0);
    _accent.forward(from: 0.0);
    _toggleText();
    widget.onTap?.call();
  }

  @override
  void dispose() {
    _accentTimer?.cancel();
    _holdTimer?.cancel();
    _intro.dispose();
    _accent.dispose();
    _tap.dispose();
    _swap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = DefaultTextStyle.of(context).style;
    final baseColor = textStyle.color ?? colorScheme.onSurface;
    // +1 for RTL (content enters from the right), -1 for LTR.
    final dir = Directionality.of(context) == TextDirection.rtl ? 1.0 : -1.0;

    return Semantics(
      button: true,
      label: _showDescription ? widget.description : widget.title,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([_intro, _accent, _tap, _swap]),
              builder: (context, _) {
                final accent = _accent.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(colorScheme, accent),
                    const SizedBox(width: 10),
                    _buildTitle(
                      textStyle: textStyle,
                      baseColor: baseColor,
                      colorScheme: colorScheme,
                      dir: dir,
                      accent: accent,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ColorScheme cs, double accent) {
    final intro = _intro.value;

    final scaleIn = 0.4 + 0.6 * _seg(intro, 0.0, 0.55, Curves.elasticOut);
    final tiltIn = -0.35 * (1 - _seg(intro, 0.0, 0.6, Curves.easeOutCubic));
    final opacity = _seg(intro, 0.0, 0.25);

    // Accent: the book "turns a page" in 3D, with a brief glow.
    final flipP = _seg(accent, 0.0, 0.4);
    final flip = math.sin(flipP * math.pi) * 0.55;
    final accentGlow = math.sin(flipP * math.pi) * 0.25;

    // Tap wobble.
    final wobble = math.sin(_tap.value * math.pi * 3) * 0.18 * (1 - _tap.value);

    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.004) // perspective
      ..rotateY(flip)
      ..rotateZ(tiltIn + wobble)
      ..scale(scaleIn * _tapScale.value);

    return Opacity(
      opacity: opacity,
      child: Transform(
        alignment: Alignment.center,
        transform: matrix,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.secondary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: accentGlow > 0.001
                    ? [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: accentGlow),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                LucideIcons.bookOpenText,
                size: 20,
                color: cs.primary,
              ),
            ),
            PositionedDirectional(
              top: -5,
              end: -5,
              child: CustomPaint(
                size: const Size(13, 13),
                painter: _SparklePainter(
                  progress: _seg(accent, 0.1, 0.5),
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A single word with opacity, offset (fractions of its own size) and blur.
  Widget _animatedWord(
    String text, {
    required double opacity,
    Offset offset = Offset.zero,
    double blur = 0,
  }) {
    Widget w = Text(text, maxLines: 1, softWrap: false);
    if (blur > 0.05) {
      w = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
          tileMode: TileMode.decal,
        ),
        child: w,
      );
    }
    return Opacity(
      opacity: opacity,
      child: FractionalTranslation(translation: offset, child: w),
    );
  }

  Widget _buildTitle({
    required TextStyle textStyle,
    required Color baseColor,
    required ColorScheme colorScheme,
    required double dir,
    required double accent,
  }) {
    final gap = (textStyle.fontSize ?? 16) * 0.3;
    final swapping = _swap.isAnimating;
    final items = <Widget>[];

    if (swapping) {
      final t = _swap.value;

      if (t < _swapMid) {
        // EXIT: previous text lifts up and blurs away, staggered from the
        // reading-start side.
        final words = _wordsOf(!_showDescription);
        final step = words.length > 1
            ? math.min(0.06, 0.2 / (words.length - 1))
            : 0.0;
        for (var i = 0; i < words.length; i++) {
          final e = _seg(t, i * step, i * step + 0.2, Curves.easeInCubic);
          items.add(
            _animatedWord(
              words[i],
              opacity: 1 - e,
              offset: Offset(0, -0.55 * e),
              blur: e * 5,
            ),
          );
        }
      } else {
        // ENTER: new text rises from below and sharpens.
        final words = _wordsOf(_showDescription);
        final step = words.length > 1
            ? math.min(0.08, 0.24 / (words.length - 1))
            : 0.0;
        for (var i = 0; i < words.length; i++) {
          final s = _swapMid + i * step;
          final p = _seg(t, s, s + 0.36, Curves.easeOutCubic);
          items.add(
            _animatedWord(
              words[i],
              opacity: p,
              offset: Offset(0, 0.55 * (1 - p)),
              blur: (1 - p) * 5,
            ),
          );
        }
      }
    } else {
      // SETTLED (also drives the first-launch intro): words blur in and slide
      // from the reading-start side.
      final words = _wordsOf(_showDescription);
      final intro = _intro.value;
      for (var i = 0; i < words.length; i++) {
        final start = math.min(0.2 + i * 0.12, 0.7);
        final t = _seg(
          intro,
          start,
          math.min(start + 0.5, 1.0),
          Curves.easeOutCubic,
        );
        items.add(
          _animatedWord(
            words[i],
            opacity: t,
            offset: Offset(dir * 0.4 * (1 - t), 0),
            blur: (1 - t) * 6,
          ),
        );
      }
    }

    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) children.add(SizedBox(width: gap));
      children.add(items[i]);
    }

    Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );

    // During the swap, words roll out of / into a one-line "window".
    if (swapping) row = ClipRect(child: row);

    // Highlight sweep, starting at the logo side and moving across the title.
    final sweep = _seg(accent, 0.3, 1.0, Curves.easeInOut);
    if (sweep > 0.0 && sweep < 1.0) {
      final center = dir * (1.6 - sweep * 3.2);
      row = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(center - 0.6, 0),
          end: Alignment(center + 0.6, 0),
          colors: [baseColor, colorScheme.primary, baseColor],
        ).createShader(bounds),
        child: row,
      );
    }

    // Smoothly grows/shrinks between the short title and the longer description.
    return AnimatedSize(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      alignment: AlignmentDirectional.centerStart,
      clipBehavior: Clip.none,
      child: row,
    );
  }
}

/// Four-point twinkle star. [progress] 0→1 grows, rotates, then fades out.
class _SparklePainter extends CustomPainter {
  _SparklePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final k = math.sin(progress * math.pi);
    if (k <= 0.01) return;

    final r = size.width / 2 * k;
    final c = size.center(Offset.zero);

    final path = Path()
      ..moveTo(0, -r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..quadraticBezierTo(0, 0, 0, r)
      ..quadraticBezierTo(0, 0, -r, 0)
      ..quadraticBezierTo(0, 0, 0, -r)
      ..close();

    canvas
      ..save()
      ..translate(c.dx, c.dy)
      ..rotate(progress * math.pi / 2)
      ..drawPath(path, Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_SparklePainter old) =>
      old.progress != progress || old.color != color;
}
