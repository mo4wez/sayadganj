import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/database/dictionary_db_service.dart';
import 'widgets/astrolabe_emblem.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final Duration minDuration;

  const SplashScreen({
    super.key,
    required this.nextScreen,
    this.minDuration = const Duration(milliseconds: 1750),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrapAndNavigate();
  }

  Future<void> _bootstrapAndNavigate() async {
    await Future.wait([
      Future<void>.delayed(widget.minDuration),
      _warmUpDatabase(),
    ]);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, __, ___) => widget.nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.97, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _warmUpDatabase() async {
    try {
      await DictionaryDbService.instance.database;
    } catch (_) {
      // Fallback safely; providers handle any DB error states.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Rotating Astrolabe & Book Emblem
                  const AstrolabeEmblem(size: 176)
                      .animate()
                      .scale(
                        begin: const Offset(0.82, 0.82),
                        end: const Offset(1.0, 1.0),
                        duration: 520.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(duration: 380.ms),

                  const SizedBox(height: 28),

                  // Main Balochi App Title
                  Text(
                        'سیدگنج',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                          letterSpacing: 0.5,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 160.ms, duration: 380.ms)
                      .slideY(
                        begin: 0.18,
                        end: 0,
                        delay: 160.ms,
                        duration: 380.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 10),

                  // Subtitle Pill
                  Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Text(
                          'بلوچی ءَ پہ بلوچی بزانت‌بلد',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 13.5,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 280.ms, duration: 360.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        delay: 280.ms,
                        duration: 360.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const Spacer(flex: 2),

                  // Subtle loading bar
                  SizedBox(
                    width: 108,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        backgroundColor: colorScheme.secondary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.primary,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 360.ms, duration: 300.ms),

                  const SizedBox(height: 18),

                  // TakbandQandeel Signature Footer
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.feather,
                        size: 14,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'تاکبند کندیل',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          '•',
                          style: TextStyle(color: colorScheme.outline),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          'TakbandQandeel',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 420.ms, duration: 340.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
