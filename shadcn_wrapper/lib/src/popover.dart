import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Tooltip for hints + shortcut labels (POS is keyboard-first: show keys!).
class AppTooltip extends StatelessWidget {
  const AppTooltip({super.key, required this.message, required this.child, this.shortcut});
  final String message;
  final String? shortcut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Tooltip(
      tooltip: shad.TooltipContainer(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(message),
          if (shortcut != null) ...[
            const SizedBox(width: 8),
            Text(shortcut!).muted().mono().xSmall(),
          ],
        ]),
      ),
      child: child,
    );
  }
}

/// Anchored popover (filters, mini forms).
abstract final class AppPopover {
  static Future<T?> show<T>(BuildContext context, {required WidgetBuilder builder, AlignmentGeometry alignment = AlignmentDirectional.bottomStart}) {
    // ADAPTER (shadcn ^0.0.52): showPopover anchored to the calling context.
    return shad.showPopover<T>(context: context, alignment: alignment, builder: builder).future;
  }
}
