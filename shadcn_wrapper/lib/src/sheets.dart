import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Side sheets / drawers (item editor, filters, cart on tablet).
/// RTL-aware: `end` position flips automatically with text direction.
abstract final class AppSheet {
  /// ADAPTER (shadcn ^0.0.52): openSheet.
  static Future<T?> open<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AxisDirection position = AxisDirection.right,
  }) {
    return shad.openSheet<T>(
      context: context,
      builder: builder,
      position: shad.OverlayPosition.values.byName(switch (position) {
        AxisDirection.left => 'left',
        AxisDirection.right => 'right',
        AxisDirection.up => 'top',
        AxisDirection.down => 'bottom',
      }),
    );
  }
}
