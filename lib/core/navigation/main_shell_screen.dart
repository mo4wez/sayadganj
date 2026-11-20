import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/bookmarks/presentation/bookmarks_screen.dart';
import '../../features/dictionary/presentation/dictionary_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

class SelectedTabNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setTab(int index) {
    if (state == index) return;
    state = index;
  }
}

final selectedTabProvider = NotifierProvider<SelectedTabNotifier, int>(
  SelectedTabNotifier.new,
);

class MainShellScreen extends ConsumerWidget {
  const MainShellScreen({super.key});

  static const List<Widget> _screens = [
    DictionaryScreen(),
    BookmarksScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedTabProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // IndexedStack keeps search text and scroll position alive across tab switches
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outline, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: GNav(
              selectedIndex: currentIndex,
              onTabChange: (index) =>
                  ref.read(selectedTabProvider.notifier).setTab(index),
              gap: 8,
              iconSize: 21,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              color: colorScheme.onSurfaceVariant,
              activeColor: colorScheme.primary,
              tabBackgroundColor: colorScheme.secondary,
              tabBorderRadius: 100, // Full pill/bubble shape
              textStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
              tabs: const [
                GButton(icon: LucideIcons.bookOpen, text: 'لبزبلد'),
                GButton(icon: LucideIcons.bookmark, text: 'نشان کتگیں'),
                GButton(icon: LucideIcons.settings, text: 'تنظیمات'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
