import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// App-window scaffold: sticky headers (menubar/top bar), body, sticky
/// footers (status bar / shortcut bar), plus a built-in top loading bar.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.headers = const [],
    this.footers = const [],
    this.loading = false,
  });
  final Widget body;
  final List<Widget> headers;
  final List<Widget> footers;

  /// True = indeterminate progress strip at the very top (global busy).
  final bool loading;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Scaffold(
      headers: headers,
      footers: footers,
      loadingProgressIndeterminate: loading,
      child: body,
    );
  }
}

/// Top app bar for screens: title/subtitle center or start, leading trailing
/// slots. Desktop: put global search + user menu in [trailing].
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading = const [],
    this.trailing = const [],
    this.height,
  });
  final String? title;
  final String? subtitle;
  final List<Widget> leading;
  final List<Widget> trailing;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.AppBar(
      leading: leading,
      trailing: trailing,
      height: height,
      alignment: AlignmentDirectional.centerStart,
      title: title == null ? null : Text(title!),
      subtitle: subtitle == null ? null : Text(subtitle!),
    );
  }
}

/// One nav destination shared by rail / sidebar / bottom bar.
class AppNavItem {
  const AppNavItem({required this.icon, required this.label, this.selectedIcon});
  final Widget icon;
  final Widget? selectedIcon;
  final String label;
}

/// Desktop-first left navigation. [expanded]=false → icon rail (64px);
/// true → full sidebar with labels. Persist the choice per user.
class AppSideNav extends StatelessWidget {
  const AppSideNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.expanded = true,
    this.header,
    this.footer,
  });
  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool expanded;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): NavigationRail handles both densities.
    return shad.NavigationRail(
      expanded: expanded,
      alignment: shad.NavigationRailAlignment.start,
      labelType: expanded ? shad.NavigationLabelType.expanded : shad.NavigationLabelType.tooltip,
      labelPosition: shad.NavigationLabelPosition.end,
      header: header == null ? null : [header!],
      footer: footer == null ? null : [footer!],
      children: [
        for (var i = 0; i < items.length; i++)
          shad.NavigationItem(
            selected: i == selectedIndex,
            onChanged: (sel) {
              if (sel) onSelected(i);
            },
            label: Text(items[i].label),
            child: i == selectedIndex ? (items[i].selectedIcon ?? items[i].icon) : items[i].icon,
          ),
      ],
    );
  }
}

/// Mobile bottom navigation (3–5 top destinations max).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<AppNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.NavigationBar(
      alignment: shad.NavigationBarAlignment.spaceEvenly,
      labelType: shad.NavigationLabelType.all,
      children: [
        for (var i = 0; i < items.length; i++)
          shad.NavigationItem(
            selected: i == selectedIndex,
            onChanged: (sel) {
              if (sel) onSelected(i);
            },
            label: Text(items[i].label),
            child: i == selectedIndex ? (items[i].selectedIcon ?? items[i].icon) : items[i].icon,
          ),
      ],
    );
  }
}

/// Pull-to-refresh for mobile lists (offline-first sync kick).
class AppRefreshable extends StatelessWidget {
  const AppRefreshable({super.key, required this.onRefresh, required this.child});
  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      // ADAPTER (shadcn ^0.0.52).
      shad.RefreshTrigger(onRefresh: onRefresh, child: child);
}
