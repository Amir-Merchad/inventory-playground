import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// One menu-entry model reused by context menus, dropdown menus and the
/// desktop menubar — build your menus once, mount them anywhere.
sealed class AppMenuEntry {
  const AppMenuEntry();
}

class AppMenuAction extends AppMenuEntry {
  const AppMenuAction({
    required this.label,
    this.onSelected,
    this.icon,
    this.shortcut,
    this.enabled = true,
    this.children = const [],
  });
  final String label;
  final VoidCallback? onSelected;
  final Widget? icon;

  /// Shown at the trailing edge (e.g. Ctrl+P). Display-only — register the
  /// actual shortcut in your app's Shortcuts/Actions layer.
  final ShortcutActivator? shortcut;
  final bool enabled;

  /// Non-empty = submenu.
  final List<AppMenuEntry> children;
}

class AppMenuDivider extends AppMenuEntry {
  const AppMenuDivider();
}

class AppMenuHeader extends AppMenuEntry {
  const AppMenuHeader(this.label);
  final String label;
}

/// ADAPTER (shadcn ^0.0.52): AppMenuEntry -> shadcn MenuItem tree.
List<shad.MenuItem> _buildShadMenuItems(List<AppMenuEntry> entries) => [
      for (final e in entries)
        switch (e) {
          AppMenuDivider() => const shad.MenuDivider(),
          AppMenuHeader(:final label) => shad.MenuLabel(child: Text(label)),
          AppMenuAction() => shad.MenuButton(
              enabled: e.enabled,
              leading: e.icon,
              trailing: e.shortcut == null ? null : shad.MenuShortcut(activator: e.shortcut!),
              subMenu: e.children.isEmpty ? null : _buildShadMenuItems(e.children),
              onPressed: e.onSelected == null ? null : (_) => e.onSelected!(),
              child: Text(e.label),
            ),
        },
    ];

/// Right-click (desktop) / long-press (touch) menu on any region — row
/// actions on tables, cart-line actions, dashboard cards.
class AppContextMenuRegion extends StatelessWidget {
  const AppContextMenuRegion({super.key, required this.child, required this.entries, this.enabled = true});
  final Widget child;
  final List<AppMenuEntry> entries;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.ContextMenu(
      enabled: enabled,
      items: _buildShadMenuItems(entries),
      child: child,
    );
  }
}

/// Button that opens a dropdown menu ("⋯ more actions", bulk actions, export).
class AppDropdownMenuButton extends StatelessWidget {
  const AppDropdownMenuButton({super.key, required this.child, required this.entries, this.enabled = true});

  /// The trigger — typically an AppButton/AppIconButton child (icon or label).
  final Widget child;
  final List<AppMenuEntry> entries;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52): showDropdown anchored at the trigger.
    return Builder(
      builder: (anchorContext) => shad.OutlineButton(
        onPressed: !enabled
            ? null
            : () {
                shad.showDropdown(
                  context: anchorContext,
                  builder: (_) => shad.DropdownMenu(children: _buildShadMenuItems(entries)),
                );
              },
        child: child,
      ),
    );
  }
}

/// Desktop menubar (File / Edit / View...) for the ERP main window.
/// Hide on mobile; those actions belong in nav or overflow menus there.
class AppMenubar extends StatelessWidget {
  const AppMenubar({super.key, required this.menus, this.border = true});

  /// Top-level items; each should be an [AppMenuAction] with [children].
  final List<AppMenuEntry> menus;
  final bool border;

  @override
  Widget build(BuildContext context) {
    // ADAPTER (shadcn ^0.0.52).
    return shad.Menubar(border: border, children: _buildShadMenuItems(menus));
  }
}
