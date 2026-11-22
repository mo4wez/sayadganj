import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/bookmarks/presentation/bookmarks_screen.dart';
import '../../features/dictionary/presentation/dictionary_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../theme/font_family_provider.dart';
import '../theme/theme_appearance_provider.dart';
import '../theme/theme_settings.dart';

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
    final selectedFont = ref.watch(fontFamilyProvider);
    final appearance = ref.watch(themeAppearanceProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isFloating = appearance.bottomBarStyle == BottomBarStyle.floating;

    final navBar = GNav(
      selectedIndex: currentIndex,
      onTabChange: (index) =>
          ref.read(selectedTabProvider.notifier).setTab(index),
      gap: 8,
      iconSize: 21,
      padding: EdgeInsets.symmetric(
        horizontal: isFloating ? 16 : 18,
        vertical: isFloating ? 10 : 12,
      ),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      color: colorScheme.onSurfaceVariant,
      activeColor: colorScheme.primary,
      tabBackgroundColor: colorScheme.secondary,
      tabBorderRadius: 100,
      textStyle: TextStyle(
        fontFamily: selectedFont.fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: colorScheme.primary,
      ),
      tabs: const [
        GButton(icon: LucideIcons.bookOpen, text: 'بزانت‌بلد'),
        GButton(icon: LucideIcons.bookmark, text: 'نشان کتگیں'),
        GButton(icon: LucideIcons.settings, text: 'کاربوج'),
      ],
    );

    return Scaffold(
      extendBody: isFloating,
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: isFloating
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: colorScheme.outline, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: navBar,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(color: colorScheme.outline, width: 1),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: navBar,
                ),
              ),
            ),
    );
  }
}
