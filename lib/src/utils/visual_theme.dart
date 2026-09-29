import 'package:flutter/material.dart';

/// Soft Margin: warm paper, oxblood ink, folded edges and notebook rules.
class VisualTheme {
  static const mist = Color(0xFFF5EBDD),
      bay = Color(0xFFFFFBF5),
      pewter = Color(0xFF9B806F),
      ink = Color(0xFF392B2E),
      fuchsia = Color(0xFF9B413B),
      muted = Color(0xFF786760),
      rule = Color(0xFFE0CEC0),
      sky = Color(0xFFF0DACA),
      apricot = Color(0xFFC18C42);
  static const night = Color(0xFF261E22),
      nightBay = Color(0xFF37292D),
      nightInk = Color(0xFFF8EDDF),
      nightMuted = Color(0xFFCDB8AE);
  static bool isDark(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark;
  static Color bayOf(BuildContext c) => isDark(c) ? nightBay : bay;
  static Color mistOf(BuildContext c) => isDark(c) ? night : mist;
  static Color inkOf(BuildContext c) => isDark(c) ? nightInk : ink;
  static Color mutedOf(BuildContext c) => isDark(c) ? nightMuted : muted;
  static Color accentOf(BuildContext c) =>
      isDark(c) ? const Color(0xFFE5A69D) : fuchsia;
  static TextStyle display(double s,
          {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(
          fontFamily: 'Georgia',
          fontSize: s,
          fontWeight: w,
          height: 1.12,
          letterSpacing: -.7,
          color: color);
  static TextStyle heading(double s,
          {Color? color, FontWeight w = FontWeight.w600}) =>
      TextStyle(fontSize: s, fontWeight: w, height: 1.3, color: color);
  static TextStyle body(double s,
          {Color? color, FontWeight w = FontWeight.w400}) =>
      TextStyle(fontSize: s, fontWeight: w, height: 1.5, color: color);
  static TextStyle micro(double s,
          {Color? color, FontWeight w = FontWeight.w600}) =>
      TextStyle(
          fontFamily: 'sans-serif',
          fontSize: s,
          fontWeight: w,
          letterSpacing: 1.1,
          height: 1.4,
          color: color);
  static ThemeData get lightTheme => _build(Brightness.light);
  static ThemeData get darkTheme => _build(Brightness.dark);
  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final surface = dark ? nightBay : bay;
    final text = dark ? nightInk : ink;
    final primary = dark ? const Color(0xFFE5A69D) : fuchsia;
    final scheme = ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        onPrimary: dark ? ink : Colors.white,
        surface: surface);
    const radius = BorderRadius.all(Radius.circular(8));
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark ? night : mist,
      textTheme:
          (dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme)
              .apply(bodyColor: text, displayColor: text),
      appBarTheme: AppBarTheme(
          backgroundColor: dark ? night : mist,
          foregroundColor: text,
          elevation: 0,
          scrolledUnderElevation: 0),
      dividerTheme: DividerThemeData(color: text.withValues(alpha: .15)),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: const OutlineInputBorder(
              borderRadius: radius, borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: radius, borderSide: BorderSide(color: primary)),
          contentPadding: const EdgeInsets.all(18)),
      filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              minimumSize: const Size(64, 52),
              backgroundColor: primary,
              foregroundColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              shape: const RoundedRectangleBorder(borderRadius: radius),
              textStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: dark ? night : mist,
          indicatorColor: primary.withValues(alpha: .18)),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: primary,
          contentTextStyle: body(14, color: scheme.onPrimary),
          behavior: SnackBarBehavior.floating),
    );
  }

  static const aspects = ['ease', 'sleep', 'stretch', 'sit'],
      grains = ['smooth', 'even', 'rough'],
      minuteChoices = [8, 12, 18];
  static String aspectLabel(String a) => switch (a) {
        'sleep' => 'Rest',
        'stretch' => 'Open',
        'sit' => 'Notice',
        _ => 'Settle'
      };
  static Color kindTint(String k) => switch (k) {
        'yoga' => const Color(0xFFC4A48A),
        'breath' => const Color(0xFFABBCB5),
        'sleep' => const Color(0xFFB4A3BB),
        'sit' => const Color(0xFFD3B77D),
        'mobility' => const Color(0xFFD29988),
        _ => pewter
      };
}
