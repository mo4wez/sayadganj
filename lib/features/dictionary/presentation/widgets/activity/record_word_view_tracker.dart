import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/word_entry.dart';
import '../../../providers/reading_activity_provider.dart';

class RecordWordViewTracker extends ConsumerStatefulWidget {
  final WordEntry word;
  final Widget child;

  const RecordWordViewTracker({
    super.key,
    required this.word,
    required this.child,
  });

  @override
  ConsumerState<RecordWordViewTracker> createState() =>
      _RecordWordViewTrackerState();
}

class _RecordWordViewTrackerState extends ConsumerState<RecordWordViewTracker> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      ref
          .read(readingActivityControllerProvider.notifier)
          .recordView(widget.word);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
