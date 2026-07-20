import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// One pane of an AppSplitView. Give EITHER [initialSize] (px) OR [flex].
class AppSplitPane {
  const AppSplitPane({
    required this.child,
    this.initialSize,
    this.flex,
    this.minSize,
    this.maxSize,
  }) : assert(initialSize == null || flex == null, 'Use initialSize OR flex');
  final Widget child;
  final double? initialSize;
  final double? flex;
  final double? minSize;
  final double? maxSize;
}

/// Drag-to-resize split layout — THE desktop ERP workhorse:
/// products list | detail editor, orders | receipt preview,
/// tree | table. Sizes are session-local; persist them yourself if needed.
class AppSplitView extends StatelessWidget {
  const AppSplitView.horizontal({super.key, required this.panes, this.showDragger = false}) : horizontal = true;
  const AppSplitView.vertical({super.key, required this.panes, this.showDragger = false}) : horizontal = false;

  final List<AppSplitPane> panes;
  final bool horizontal;

  /// Show a grab-handle dot on dividers (more discoverable, slightly busier).
  final bool showDragger;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): ResizablePanel/ResizablePane(.flex).
    final children = [
      for (final p in panes)
        if (p.initialSize != null)
          shad.ResizablePane(
            initialSize: p.initialSize!,
            minSize: p.minSize,
            maxSize: p.maxSize,
            child: p.child,
          )
        else
          shad.ResizablePane.flex(
            initialFlex: p.flex ?? 1,
            minSize: p.minSize,
            maxSize: p.maxSize,
            child: p.child,
          ),
    ];
    return horizontal
        ? shad.ResizablePanel.horizontal(
            draggerBuilder: showDragger ? shad.ResizablePanel.defaultDraggerBuilder : null,
            children: children,
          )
        : shad.ResizablePanel.vertical(
            draggerBuilder: showDragger ? shad.ResizablePanel.defaultDraggerBuilder : null,
            children: children,
          );
  }
}
