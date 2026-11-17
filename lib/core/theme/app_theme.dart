import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  static const black = Color(0xFF000000);
  static const navyDeep = Color(0xFF040B1A);
  static const navy = Color(0xFF0A1630);
  static const navyLight = Color(0xFF12254A);
  static const neon = Color(0xFF29C5FF); // Neon-Blau (Akzent)
  static const neonSoft = Color(0xFF1B8FBF);
  static const textPrimary = Color(0xFFEAF4FF);
  static const textSecondary = Color(0xFF8FA6C4);
  static const success = Color(0xFF3DFFB0);
  static const warning = Color(0xFFFFC857);
  static const danger = Color(0xFFFF5C7A);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.neon,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.neon,
    onPrimary: AppColors.black,
    surface: AppColors.navy,
    error: AppColors.danger,
  );

  const radius = BorderRadius.all(Radius.circular(14));
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
    canvasColor: AppColors.navy,
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.textPrimary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
      enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
      focusedBorder: const OutlineInputBorder(
          borderRadius: radius, borderSide: BorderSide(color: AppColors.neon)),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.neon,
        foregroundColor: AppColors.black,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: radius),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.neon,
        side: BorderSide(color: AppColors.neon.withValues(alpha: 0.6)),
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navyDeep.withValues(alpha: 0.85),
      indicatorColor: AppColors.neon.withValues(alpha: 0.18),
      labelTextStyle: WidgetStateProperty.resolveWith((s) => TextStyle(
            fontSize: 12,
            color: s.contains(WidgetState.selected)
                ? AppColors.neon
                : AppColors.textSecondary,
          )),
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
            color: s.contains(WidgetState.selected)
                ? AppColors.neon
                : AppColors.textSecondary,
          )),
    ),
    dividerColor: Colors.white.withValues(alpha: 0.08),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.navyLight,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
