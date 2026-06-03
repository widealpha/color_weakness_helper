import 'package:flutter/material.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF0F766E);

  static ThemeData build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF081015)
          : const Color(0xFFF4F0E7),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.90)
            : Colors.white.withValues(alpha: 0.92),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF111A1F) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerLow
            : Colors.white.withValues(alpha: 0.92),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static LinearGradient pageBackgroundGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark
          ? const <Color>[
              Color(0xFF081015),
              Color(0xFF0F1A21),
              Color(0xFF171721),
            ]
          : const <Color>[
              Color(0xFFF7F3EA),
              Color(0xFFDDEFE7),
              Color(0xFFF1E8DD),
            ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient heroGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LinearGradient(
      colors: isDark
          ? const <Color>[
              Color(0xFF0F4C5C),
              Color(0xFF143A54),
              Color(0xFF1B1F35),
            ]
          : const <Color>[
              Color(0xFF155E63),
              Color(0xFF1E4D72),
              Color(0xFF2B2D42),
            ],
    );
  }

  static Color panelBackground(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.84)
        : Colors.white.withValues(alpha: 0.78);
  }

  static Color panelBorder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.outlineVariant.withValues(alpha: 0.45);
  }

  static List<BoxShadow> panelShadows(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return <BoxShadow>[
      BoxShadow(
        color: (isDark ? Colors.black : const Color(0xFF10252A)).withValues(
          alpha: isDark ? 0.24 : 0.08,
        ),
        blurRadius: isDark ? 28 : 22,
        offset: const Offset(0, 10),
      ),
    ];
  }

  static Color mutedSurface(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.76)
        : const Color(0xFFFCFBF8);
  }

  static Color tintSurface(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return colorScheme.primary.withValues(alpha: isDark ? 0.16 : 0.08);
  }

  static Color heroBadgeBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.white.withValues(alpha: isDark ? 0.10 : 0.12);
  }

  static Color previewBadgeBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Colors.black.withValues(alpha: isDark ? 0.62 : 0.56);
  }

  static Color errorSurface(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return colorScheme.error.withValues(alpha: 0.12);
  }

  static Color previewDialogBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF0B1014) : const Color(0xFF101418);
  }
}
