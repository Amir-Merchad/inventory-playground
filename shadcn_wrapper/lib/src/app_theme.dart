import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Semantic colors the app references (never raw shadcn colors in features).
class AppSemanticColors {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.moneyPositive,
    required this.moneyNegative,
  });
  final Color success, warning, danger, info, moneyPositive, moneyNegative;

  static const light = AppSemanticColors(
    success: Color(0xFF059669), // emerald-600
    warning: Color(0xFFF59E0B), // amber-500
    danger: Color(0xFFDC2626), // red-600
    info: Color(0xFF2563EB), // blue-600
    moneyPositive: Color(0xFF059669),
    moneyNegative: Color(0xFFDC2626),
  );
  static const dark = AppSemanticColors(
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    info: Color(0xFF60A5FA),
    moneyPositive: Color(0xFF34D399),
    moneyNegative: Color(0xFFF87171),
  );
}

/// Builds the shadcn ThemeData for [shad.ShadcnApp]. ONE place to restyle
/// a whole project. Usage:
///   shad.ShadcnApp(theme: AppTheme.light(), darkTheme: AppTheme.dark(), ...)
abstract final class AppTheme {
  /// ADAPTER (shadcn ^0.0.52): color schemes come from shadcn presets.
  /// If the preset API moved, this is the only spot to fix.
  static shad.ThemeData light({double radius = 0.5}) =>
      shad.ThemeData(colorScheme: shad.ColorSchemes.lightZinc, radius: radius);

  static shad.ThemeData dark({double radius = 0.5}) =>
      shad.ThemeData(colorScheme: shad.ColorSchemes.darkZinc, radius: radius);

  static AppSemanticColors semanticOf(BuildContext context) {
    final brightness = shad.Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppSemanticColors.dark
        : AppSemanticColors.light;
  }

  /// shadcn theme accessor for adapter files (features shouldn't need it).
  static shad.ThemeData of(BuildContext context) => shad.Theme.of(context);
}
