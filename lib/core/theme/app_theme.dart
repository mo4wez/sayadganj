import 'package:material_ui/material_ui.dart';

import 'theme_settings.dart';

class AppTheme {
  AppTheme._();

  // Base Surface Tokens — Light
  static const Color _lightBackground = Color(0xFFF7F7F5); // Warm Paper
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE4E6EA);
  static const Color _lightTextPrimary = Color(0xFF14171A);
  static const Color _lightTextSecondary = Color(0xFF5C6470);

  // Base Surface Tokens — Dark (Standard)
  static const Color _darkBackground = Color(0xFF0E1116); // Obsidian Slate
  static const Color _darkSurface = Color(0xFF161B22); // Elevated Card
  static const Color _darkBorder = Color(0xFF262C36);
  static const Color _darkTextPrimary = Color(0xFFF1F3F5);
  static const Color _darkTextSecondary = Color(0xFF949CA8);

  // Base Surface Tokens — Pure Black (AMOLED)
  static const Color _amoledBackground = Color(0xFF000000);
  static const Color _amoledSurface = Color(0xFF0C0E12);
  static const Color _amoledBorder = Color(0xFF1F242D);

  static ThemeData light({
    String? fontFamily,
    ThemeAppearanceState appearance = const ThemeAppearanceState(),
  }) => _buildTheme(
    brightness: Brightness.light,
    appearance: appearance,
    fontFamily: fontFamily,
  );

  static ThemeData dark({
    String? fontFamily,
    ThemeAppearanceState appearance = const ThemeAppearanceState(),
  }) => _buildTheme(
    brightness: Brightness.dark,
    appearance: appearance,
    fontFamily: fontFamily,
  );

  static Color _resolvePrimary({
    required bool isDark,
    required AppAccentColor accent,
    required AppColorStyle style,
  }) {
    final base = isDark ? accent.darkColor : accent.lightColor;

    return switch (style) {
      AppColorStyle.vivid => base,
      AppColorStyle.soft => Color.lerp(
        base,
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
        0.32,
      )!,
      AppColorStyle.tinted => base,
      AppColorStyle.monochrome =>
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
    };
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ThemeAppearanceState appearance,
    String? fontFamily,
  }) {
    final isDark = brightness == Brightness.dark;
    final style = appearance.colorStyle;
    final primary = _resolvePrimary(
      isDark: isDark,
      accent: appearance.accentColor,
      style: style,
    );

    Color background = isDark
        ? (appearance.isPureBlack ? _amoledBackground : _darkBackground)
        : _lightBackground;
    Color surface = isDark
        ? (appearance.isPureBlack ? _amoledSurface : _darkSurface)
        : _lightSurface;
    Color border = isDark
        ? (appearance.isPureBlack ? _amoledBorder : _darkBorder)
        : _lightBorder;

    if (style == AppColorStyle.tinted) {
      if (isDark) {
        if (!appearance.isPureBlack) {
          background = Color.lerp(background, primary, 0.05)!;
        }
        surface = Color.lerp(surface, primary, 0.08)!;
        border = Color.lerp(border, primary, 0.18)!;
      } else {
        background = Color.lerp(background, primary, 0.045)!;
        surface = Color.lerp(surface, primary, 0.025)!;
        border = Color.lerp(border, primary, 0.16)!;
      }
    }

    final textPrimary = isDark ? _darkTextPrimary : _lightTextPrimary;
    final textSecondary = isDark ? _darkTextSecondary : _lightTextSecondary;

    final secondaryAlpha = switch (style) {
      AppColorStyle.vivid => 0.14,
      AppColorStyle.soft => 0.10,
      AppColorStyle.tinted => 0.17,
      AppColorStyle.monochrome => isDark ? 0.12 : 0.08,
    };

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? const Color(0xFF0A0D10) : Colors.white,
      secondary: primary.withValues(alpha: secondaryAlpha),
      onSecondary: primary,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.6),
      error: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
      onError: Colors.white,
    );

    final baseTextTheme = TextTheme(
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.5,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.75,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.65,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: baseTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(
          fontFamily: fontFamily,
          color: textSecondary,
          fontSize: 15,
        ),
        prefixIconColor: textSecondary,
        suffixIconColor: textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 1.6),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: textSecondary, size: 22),
    );
  }
}
