import 'package:flutter/widgets.dart';

/// Design tokens — the single restyling point for any project using this
/// package. POS defaults: compact density but fat touch targets.
abstract final class AppTokens {
  // Spacing scale (4px grid)
  static const double s1 = 4, s2 = 8, s3 = 12, s4 = 16, s5 = 20, s6 = 24, s8 = 32, s10 = 40, s12 = 48;

  // Radii (shadcn default feel)
  static const double radiusSm = 6, radius = 8, radiusLg = 12, radiusFull = 999;

  // Hit targets: anything a cashier touches >= 44px (touchscreens in shops).
  static const double hitTarget = 44;
  static const double hitTargetLarge = 56; // payment / quick-cash buttons

  // Motion
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);

  // Layout
  static const double sidebarWidth = 280;
  static const double searchPanelWidth = 360;

  static const EdgeInsets pagePadding = EdgeInsets.all(s4);
  static const EdgeInsets cardPadding = EdgeInsets.all(s4);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(horizontal: s3, vertical: s2);
}
