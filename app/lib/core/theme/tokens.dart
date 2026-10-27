// Generated from design/tokens.json. Keep both in sync; widgets must use these, never raw hex.
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const bg = Color(0xFF0D1015);
  static const sidebarBg = Color(0xFF10141A);
  static const surface = Color(0xFF141922);
  static const surfaceRaised = Color(0xFF1A2029);
  static const inputBg = Color(0xFF0F1318);
  static const border = Color(0xFF262E3A);
  static const borderStrong = Color(0xFF2C3542);
  static const divider = Color(0xFF1F2630);
  static const textPrimary = Color(0xFFE7EBF1);
  static const textSecondary = Color(0xFFC9D0DA);
  static const textMuted = Color(0xFF9AA3B1);
  static const accent = Color(0xFF6FA8FF);
  static const onAccent = Color(0xFF0D1015);
  static const accentSoftBg = Color(0xFF1B2A40);
  static const accentStrongBg = Color(0xFF16223A);
  static const accentBorder = Color(0xFF2F4E80);
  static const link = Color(0xFF8DB8FF);
  static const positive = Color(0xFF3ECFAE);
  static const positiveBorder = Color(0xFF2A4A43);
  static const negative = Color(0xFFFF8F5E);
  static const negativeText = Color(0xFFFFB08A);
  static const negativeBorder = Color(0xFF5A3424);
  static const warning = Color(0xFFF0C24B);
  static const warningText = Color(0xFFF3D98A);
  static const warningBg = Color(0xFF2A2416);
  static const warningBorder = Color(0xFF5A4A22);
  static const navActiveBg = Color(0xFF1F2836);
  static const sidebarBorder = Color(0xFF222A35);
  static const statusPanelBg = Color(0xFF151A22);
  static const series = [Color(0xFF6FA8FF), Color(0xFFF0C24B), Color(0xFFC8A4FF)];
}

/// Motion timing. Widgets read these instead of literal durations; reduced-motion
/// users get Duration.zero via [AppMotion.of].
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 400);
  static const stagger = Duration(milliseconds: 40);
  static const curve = Curves.easeOutCubic;

  /// [d], or zero when the platform asks for reduced motion.
  static Duration of(BuildContext context, Duration d) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false ? Duration.zero : d;
}

abstract final class AppSpace {
  static const xs = 4.0, sm = 8.0, md = 12.0, lg = 16.0, xl = 20.0, xxl = 28.0, page = 32.0;
}

abstract final class AppRadius {
  static const sm = 6.0, md = 8.0, lg = 10.0;
}

abstract final class AppSize {
  static const minTouch = 44.0;
  static const sidebarWidth = 232.0;
  static const mobileBreakpoint = 600.0;
  static const desktopBreakpoint = 1200.0;
  static const pageMaxWidth = 1440.0;
}

abstract final class AppFonts {
  static const ui = 'Vazirmatn';
  static const mono = 'JetBrainsMono';
}

abstract final class AppText {
  static const pageTitle = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const stepTitle = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const sectionTitle = TextStyle(
    fontFamily: AppFonts.ui,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(fontFamily: AppFonts.ui, fontSize: 14, height: 1.8, color: AppColors.textPrimary);
  static const label = TextStyle(fontFamily: AppFonts.ui, fontSize: 13, color: AppColors.textMuted);
  static const caption = TextStyle(fontFamily: AppFonts.ui, fontSize: 12, height: 1.7, color: AppColors.textMuted);

  /// Numbers, prices, symbols, hashes. Always render inside an LTR Directionality.
  static const mono = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 13,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const statValue = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(brightness: Brightness.dark, useMaterial3: true, fontFamily: AppFonts.ui);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.accent,
      onPrimary: AppColors.onAccent,
      error: AppColors.negative,
      outline: AppColors.borderStrong,
    ),
    dividerColor: AppColors.border,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpace.md, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.borderStrong),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.accent, width: 2),
      ),
      labelStyle: AppText.label,
      helperStyle: AppText.caption,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        minimumSize: const Size(AppSize.minTouch, AppSize.minTouch),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        textStyle: const TextStyle(fontFamily: AppFonts.ui, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceRaised,
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderStrong),
        minimumSize: const Size(AppSize.minTouch, AppSize.minTouch),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
  );
}
