import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Drag-to-reorder vertical list — receipt line order, category ordering,
/// dashboard widget arrangement, printer routing priority.
///
/// State-out like everything else: [onReorder] gives (from, to) indexes;
/// mutate your list in the bloc and rebuild.
class AppReorderableList<T> extends StatelessWidget {
  const AppReorderableList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.spacing = 4,
    this.shrinkWrap = true,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(int from, int to) onReorder;
  final double spacing;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): SortableLayer + Sortable with top/bottom
    // accept zones = vertical reordering.
    return shad.SortableLayer(
      lock: true,
      child: Column(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : spacing),
              child: shad.Sortable<int>(
                data: shad.SortableData(i),
                onAcceptTop: (incoming) {
                  final from = incoming.data;
                  onReorder(from, from < i ? i - 1 : i);
                },
                onAcceptBottom: (incoming) {
                  final from = incoming.data;
                  onReorder(from, from <= i ? i : i + 1);
                },
                child: itemBuilder(context, items[i], i),
              ),
            ),
        ],
      ),
    );
  }
}

/// Explicit grab-handle to put inside your row (keeps taps/swipes free for
/// the row itself). Desktop shows a grab cursor.
class AppDragHandle extends StatelessWidget {
  const AppDragHandle({super.key, this.enabled = true});
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.SortableDragHandle(
      enabled: enabled,
      child: const Icon(shad.LucideIcons.gripVertical, size: 16),
    );
  }
}
