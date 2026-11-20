import 'package:material_ui/material_ui.dart';

class AppTheme {
  AppTheme._();

  // Brand & Surface Tokens — Light
  static const Color _lightPrimary = Color(0xFF0F766E); // Deep Jade Teal
  static const Color _lightBackground = Color(0xFFF7F7F5); // Warm Paper
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE4E6EA);
  static const Color _lightTextPrimary = Color(0xFF14171A);
  static const Color _lightTextSecondary = Color(0xFF5C6470);

  // Brand & Surface Tokens — Dark
  static const Color _darkPrimary = Color(0xFF2DD4BF); // Soft Mint Teal
  static const Color _darkBackground = Color(0xFF0E1116); // Obsidian Slate
  static const Color _darkSurface = Color(0xFF161B22); // Elevated Card
  static const Color _darkBorder = Color(0xFF262C36);
  static const Color _darkTextPrimary = Color(0xFFF1F3F5);
  static const Color _darkTextSecondary = Color(0xFF949CA8);

  static ThemeData get light => _buildTheme(
    brightness: Brightness.light,
    primary: _lightPrimary,
    background: _lightBackground,
    surface: _lightSurface,
    border: _lightBorder,
    textPrimary: _lightTextPrimary,
    textSecondary: _lightTextSecondary,
  );

  static ThemeData get dark => _buildTheme(
    brightness: Brightness.dark,
    primary: _darkPrimary,
    background: _darkBackground,
    surface: _darkSurface,
    border: _darkBorder,
    textPrimary: _darkTextPrimary,
    textSecondary: _darkTextSecondary,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color background,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: isDark ? const Color(0xFF062825) : Colors.white,
      secondary: primary.withValues(alpha: 0.14),
      onSecondary: primary,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: border.withValues(alpha: 0.6),
      error: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      // Typography tuned for Balochi RTL script & diacritics
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.5,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          height: 1.5,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.75,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.65,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textSecondary,
        ),
      ),

      // Flat, borderless minimal AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),

      // Minimal hairline cards instead of heavy shadows
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
      ),

      // Modern pill-rounded search & text inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textSecondary, fontSize: 15),
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
