import 'package:material_ui/material_ui.dart';

import 'search_tools_bar.dart';

class AnimatedSearchTools extends StatefulWidget {
  final bool visible;
  final ValueChanged<String> onInsertChar;

  const AnimatedSearchTools({
    super.key,
    required this.visible,
    required this.onInsertChar,
  });

  @override
  State<AnimatedSearchTools> createState() => _AnimatedSearchToolsState();
}

class _AnimatedSearchToolsState extends State<AnimatedSearchTools>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 220),
      value: widget.visible ? 1.0 : 0.0,
    );

    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.85, curve: Curves.easeIn),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedSearchTools oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.visible,
      child: SizeTransition(
        sizeFactor: _sizeAnimation,
        axisAlignment: -1.0,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SearchToolsBar(onInsertChar: widget.onInsertChar),
        ),
      ),
    );
  }
}
