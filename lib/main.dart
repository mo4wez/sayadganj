import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: SayadGanjApp()));
}

class SayadGanjApp extends StatelessWidget {
  const SayadGanjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: Scaffold(
        appBar: AppBar(title: const Text("SayadGanj")),
        body: Center(child: const Text("سیدگنج")),
      ),
    );
  }
}
