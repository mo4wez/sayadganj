import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const SayadGanjApp());
}

class SayadGanjApp extends StatelessWidget {
  const SayadGanjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: Scaffold(appBar: AppBar(title: Text("SayadGanj"))),
    );
  }
}
