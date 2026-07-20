import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Immutable tree node (category tree, chart of accounts, locations).
/// The tree is state-out: interactions emit a NEW node list via onChanged —
/// store it in your bloc/cubit and rebuild.
class AppTreeNode<T> {
  const AppTreeNode({
    required this.data,
    this.children = const [],
    this.expanded = false,
  });
  final T data;
  final List<AppTreeNode<T>> children;
  final bool expanded;

  AppTreeNode<T> copyWith({List<AppTreeNode<T>>? children, bool? expanded}) =>
      AppTreeNode(data: data, children: children ?? this.children, expanded: expanded ?? this.expanded);
}

List<shad.TreeNode<T>> _toShad<T>(List<AppTreeNode<T>> nodes) => [
      for (final n in nodes)
        shad.TreeItem<T>(data: n.data, expanded: n.expanded, children: _toShad(n.children)),
    ];

List<AppTreeNode<T>> _fromShad<T>(List<shad.TreeNode<T>> nodes) => [
      for (final n in nodes)
        if (n is shad.TreeItem<T>)
          AppTreeNode<T>(data: n.data, expanded: n.expanded, children: _fromShad(n.children)),
    ];

/// Hierarchy browser with indent guides and expand/collapse — the classic
/// ERP left-panel tree. Rows are 32px (desktop density); wrap in a
/// SizedBox/pane and let it scroll.
class AppTreeView<T> extends StatelessWidget {
  const AppTreeView({
    super.key,
    required this.nodes,
    required this.onChanged,
    required this.labelBuilder,
    this.leadingBuilder,
    this.onNodeTap,
    this.onNodeDoubleTap,
  });

  final List<AppTreeNode<T>> nodes;

  /// Receives the updated tree after expand/collapse — persist it.
  final ValueChanged<List<AppTreeNode<T>>> onChanged;
  final Widget Function(T data) labelBuilder;

  /// Optional icon per node, told whether the node is expanded / a leaf.
  final Widget Function(T data, {required bool expanded, required bool leaf})? leadingBuilder;
  final void Function(T data)? onNodeTap;
  final void Function(T data)? onNodeDoubleTap;

  @override
  Widget build(BuildContext context) {
    final shadNodes = _toShad(nodes);
    // ADAPTER (shadcn ^0.0.52): TreeView + TreeItemView + expand handler.
    return shad.TreeView<T>(
      nodes: shadNodes,
      shrinkWrap: true,
      branchLine: shad.BranchLine.path,
      builder: (context, node) {
        final item = node as shad.TreeItem<T>;
        return shad.TreeItemView(
          leading: leadingBuilder?.call(item.data, expanded: item.expanded, leaf: item.leaf),
          onPressed: onNodeTap == null ? null : () => onNodeTap!(item.data),
          onDoublePressed: onNodeDoubleTap == null ? null : () => onNodeDoubleTap!(item.data),
          // ADAPTER (shadcn ^0.0.52): the static helpers live on TreeView.
          // (Master moved them to a `Tree` base class — swap back on upgrade.)
          onExpand: shad.TreeView.defaultItemExpandHandler(shadNodes, node, (updated) {
            onChanged(_fromShad(updated));
          }),
          child: labelBuilder(item.data),
        );
      },
    );
  }
}

/// Helpers mirroring shadcn's static tree utilities on our node type.
abstract final class AppTree {
  static List<AppTreeNode<T>> expandAll<T>(List<AppTreeNode<T>> nodes) =>
      [for (final n in nodes) AppTreeNode(data: n.data, expanded: true, children: expandAll(n.children))];

  static List<AppTreeNode<T>> collapseAll<T>(List<AppTreeNode<T>> nodes) =>
      [for (final n in nodes) AppTreeNode(data: n.data, children: collapseAll(n.children))];
}
