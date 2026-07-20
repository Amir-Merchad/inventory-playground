import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'app_theme.dart';

enum AppBadgeVariant { primary, secondary, outline, destructive, success, warning }

class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label, this.variant = AppBadgeVariant.secondary});
  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): shadcn badges; success/warning built on outline + semantic color.
    final colors = AppTheme.semanticOf(context);
    return switch (variant) {
      AppBadgeVariant.primary => shad.PrimaryBadge(child: Text(label)),
      AppBadgeVariant.secondary => shad.SecondaryBadge(child: Text(label)),
      AppBadgeVariant.outline => shad.OutlineBadge(child: Text(label)),
      AppBadgeVariant.destructive => shad.DestructiveBadge(child: Text(label)),
      AppBadgeVariant.success => shad.OutlineBadge(child: Text(label, style: TextStyle(color: colors.success))),
      AppBadgeVariant.warning => shad.OutlineBadge(child: Text(label, style: TextStyle(color: colors.warning))),
    };
  }
}

/// Count bubble to overlay on icons (cart items, pending sync, alerts).
class AppCountBadge extends StatelessWidget {
  const AppCountBadge({super.key, required this.count, required this.child, this.max = 99});
  final int count;
  final Widget child;
  final int max;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    if (count <= 0) return child;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: -6,
          end: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            constraints: const BoxConstraints(minWidth: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              count > max ? '$max+' : '$count',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.primaryForeground, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

/// Status dot + label (connection state, shift open/closed).
class AppStatusDot extends StatelessWidget {
  const AppStatusDot({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label).muted().small(),
      ]);
}
