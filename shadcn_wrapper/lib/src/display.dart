import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'app_theme.dart';

/// Animated rolling number — cart total on the POS pay panel, dashboard KPIs.
/// Pass your intl-formatted renderer via [format] (money stays app-side).
class AppNumberTicker extends StatelessWidget {
  const AppNumberTicker({super.key, required this.value, this.format, this.style});
  final num value;
  final String Function(num value)? format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final fmt = format ?? ((num v) => '$v');
    // ADAPTER (shadcn ^0.0.52).
    return shad.NumberTicker(
      number: value,
      style: style,
      formatter: (n) => fmt(n),
    );
  }
}

/// Scrolls content that doesn't fit (long product names in fixed columns,
/// ticker messages on the customer display). Static when it fits.
class AppMarquee extends StatelessWidget {
  const AppMarquee({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52).
      shad.OverflowMarquee(child: child);
}

enum AppTrackerLevel { ok, warning, critical, unknown }

class AppTrackerSlot {
  const AppTrackerSlot({required this.level, required this.tooltip});
  final AppTrackerLevel level;
  final String tooltip;
}

/// Status strip of colored slots — sync health per hour, uptime of the
/// printer/scale/kitchen display, per-branch close status.
class AppTracker extends StatelessWidget {
  const AppTracker({super.key, required this.slots});
  final List<AppTrackerSlot> slots;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Tracker + TrackerLevel constants.
    return shad.Tracker(
      data: [
        for (final s in slots)
          shad.TrackerData(
            tooltip: Text(s.tooltip),
            level: switch (s.level) {
              AppTrackerLevel.ok => shad.TrackerLevel.fine,
              AppTrackerLevel.warning => shad.TrackerLevel.warning,
              AppTrackerLevel.critical => shad.TrackerLevel.critical,
              AppTrackerLevel.unknown => shad.TrackerLevel.unknown,
            },
          ),
      ],
    );
  }
}

class AppAvatarData {
  const AppAvatarData({required this.initials, this.imageUrl});
  final String initials;
  final String? imageUrl;
}

/// Overlapping avatar stack ("3 cashiers on this shift", order followers).
class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({super.key, required this.avatars, this.size = 32, this.maxVisible = 4});
  final List<AppAvatarData> avatars;
  final double size;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visible = avatars.take(maxVisible).toList();
    final overflow = avatars.length - visible.length;
    // ADAPTER (shadcn ^0.0.52): AvatarGroup.toStart + Avatar (an AvatarWidget).
    return shad.AvatarGroup.toStart(
      children: [
        for (final a in visible)
          shad.Avatar(
            initials: shad.Avatar.getInitials(a.initials),
            size: size,
            provider: a.imageUrl == null ? null : NetworkImage(a.imageUrl!),
          ),
        if (overflow > 0)
          shad.Avatar(initials: '+$overflow', size: size),
      ],
    );
  }
}

/// Renders real key-caps for a shortcut (⌘K style) — pair with menus,
/// tooltips and the POS shortcut bar. See also AppKbd for plain chips.
class AppKeyCaps extends StatelessWidget {
  const AppKeyCaps({super.key, required this.keys});
  final List<LogicalKeyboardKey> keys;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52).
      shad.KeyboardDisplay(keys: keys);
}

/// Monospace copy-friendly block — license keys, API tokens, barcode values,
/// webhook URLs on the integrations screen.
class AppCodeBlock extends StatelessWidget {
  const AppCodeBlock({super.key, required this.code, this.actions = const []});
  final String code;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52).
      shad.CodeSnippet(actions: actions, code: Text(code).mono().small());
}

/// Colored pill for money deltas: green up / red down (dashboard KPIs).
class AppMoneyDelta extends StatelessWidget {
  const AppMoneyDelta({super.key, required this.text, required this.positive});
  final String text;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.semanticOf(context);
    final color = positive ? colors.moneyPositive : colors.moneyNegative;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(positive ? shad.LucideIcons.trendingUp : shad.LucideIcons.trendingDown, size: 14, color: color),
      const SizedBox(width: 4),
      Text(text, style: TextStyle(color: color)).small().semiBold(),
    ]);
  }
}
