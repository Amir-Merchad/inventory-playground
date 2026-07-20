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

  /// RTL-aware side sheet: opens from the trailing edge (`end`) by default.
  static Future<T?> openEnd<T>(BuildContext context, {required WidgetBuilder builder}) {
    // ADAPTER (shadcn ^0.0.52): OverlayPosition.end flips with direction.
    return shad.openSheet<T>(context: context, builder: builder, position: shad.OverlayPosition.end);
  }
}

/// Drawer = sheet with backdrop transform + drag handle. Mobile-first surface
/// (cart on phone POS, filters on tablet). On desktop prefer AppSheet.
abstract final class AppDrawer {
  /// ADAPTER (shadcn ^0.0.52): openDrawerOverlay -> future.
  static Future<T?> open<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    AxisDirection position = AxisDirection.down,
    bool expands = false,
    bool draggable = true,
    bool dismissible = true,
    bool showDragHandle = true,
  }) {
    return shad
        .openDrawerOverlay<T>(
          context: context,
          builder: builder,
          expands: expands,
          draggable: draggable,
          barrierDismissible: dismissible,
          showDragHandle: showDragHandle,
          position: shad.OverlayPosition.values.byName(switch (position) {
            AxisDirection.left => 'left',
            AxisDirection.right => 'right',
            AxisDirection.up => 'top',
            AxisDirection.down => 'bottom',
          }),
        )
        .future;
  }

  /// Close the nearest open drawer/sheet from inside its builder.
  static void close<T>(BuildContext context, [T? result]) =>
      shad.closeDrawer<T>(context, result);
}
