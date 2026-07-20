import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class AppTab {
  const AppTab({required this.label, required this.child});
  final String label;
  final Widget child;
}

/// Header-only underlined tab strip — use when the body is routed elsewhere
/// (e.g. nested navigator per tab, or tabs above an AppTable).
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.labels, required this.index, required this.onChanged});
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): TabList underline style.
    return shad.TabList(
      index: index,
      onChanged: onChanged,
      children: [for (final l in labels) shad.TabItem(child: Text(l))],
    );
  }
}

/// Controlled tabs (state lives in the caller's bloc/cubit).
class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.tabs, required this.index, required this.onChanged});
  final List<AppTab> tabs;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): Tabs renders the header row; body is ours.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shad.Tabs(
          index: index,
          onChanged: onChanged,
          children: [for (final t in tabs) shad.TabItem(child: Text(t.label))],
        ),
        const SizedBox(height: 12),
        IndexedStack(index: index, children: [for (final t in tabs) t.child]),
      ],
    );
  }
}
