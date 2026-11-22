import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AstrolabeEmblem extends StatefulWidget {
  final double size;

  const AstrolabeEmblem({super.key, this.size = 168});

  @override
  State<AstrolabeEmblem> createState() => _AstrolabeEmblemState();
}

class _AstrolabeEmblemState extends State<AstrolabeEmblem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft ambient radial aura
          Container(
            width: widget.size * 0.92,
            height: widget.size * 0.92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.18),
                  colorScheme.primary.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
                stops: const [0.2, 0.65, 1.0],
              ),
            ),
          ),

          // Rotating astrolabe rings & degree ticks
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.square(widget.size),
                painter: _AstrolabeRingPainter(
                  rotation: _controller.value * 2 * math.pi,
                  primaryColor: colorScheme.primary,
                  outlineColor: colorScheme.outline,
                ),
              );
            },
          ),

          // Central manuscript medallion
          Container(
            width: widget.size * 0.46,
            height: widget.size * 0.46,
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.45),
                width: 1.6,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.22),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                LucideIcons.bookOpenText,
                size: widget.size * 0.21,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AstrolabeRingPainter extends CustomPainter {
  final double rotation;
  final Color primaryColor;
  final Color outlineColor;

  const _AstrolabeRingPainter({
    required this.rotation,
    required this.primaryColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width * 0.46;
    final innerRadius = size.width * 0.34;

    // Static subtle inner ring
    final innerCirclePaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, innerRadius, innerCirclePaint);

    // Rotating outer astrolabe dial
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final outerCirclePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset.zero, outerRadius, outerCirclePaint);

    // 36 degree ticks around outer ring
    const tickCount = 36;
    final tickPaint = Paint()..strokeCap = StrokeCap.round;

    for (int i = 0; i < tickCount; i++) {
      final angle = (2 * math.pi / tickCount) * i;
      final isCardinal = i % 9 == 0;
      final isMajor = i % 3 == 0;

      final tickLength = isCardinal
          ? 9.0
          : isMajor
          ? 6.0
          : 3.5;

      tickPaint
        ..color = isCardinal
            ? primaryColor.withValues(alpha: 0.85)
            : primaryColor.withValues(alpha: isMajor ? 0.45 : 0.22)
        ..strokeWidth = isCardinal ? 2.0 : 1.2;

      final p1 = Offset(
        math.cos(angle) * (outerRadius - tickLength),
        math.sin(angle) * (outerRadius - tickLength),
      );
      final p2 = Offset(
        math.cos(angle) * outerRadius,
        math.sin(angle) * outerRadius,
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 4 counter-rotating inner star points
    canvas.rotate(-rotation * 2);
    final dotPaint = Paint()..color = primaryColor.withValues(alpha: 0.75);
    for (int i = 0; i < 4; i++) {
      final angle = (math.pi / 2) * i + (math.pi / 4);
      final pos = Offset(
        math.cos(angle) * innerRadius,
        math.sin(angle) * innerRadius,
      );
      canvas.drawCircle(pos, 2.4, dotPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AstrolabeRingPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}
