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
