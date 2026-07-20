import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// One searchable action for the command palette.
class AppCommandAction {
  const AppCommandAction({
    required this.label,
    required this.run,
    this.icon,
    this.keywords = const [],
    this.shortcutLabel,
  });
  final String label;
  final VoidCallback run;
  final Widget? icon;

  /// Extra search terms ("invoice" also matched by "bill", Arabic aliases…).
  final List<String> keywords;

  /// Display-only hint (e.g. "F10", "Ctrl+K").
  final String? shortcutLabel;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (label.toLowerCase().contains(q)) return true;
    return keywords.any((k) => k.toLowerCase().contains(q));
  }
}

class AppCommandGroup {
  const AppCommandGroup({required this.title, required this.actions});
  final String title;
  final List<AppCommandAction> actions;
}

/// Ctrl+K command palette — the fastest desktop path to any ERP screen or
/// action ("new sale", "close shift", "find product"). Wire the shortcut in
/// the app shell; this only renders + filters.
abstract final class AppCommandPalette {
  /// ADAPTER (shadcn ^0.0.52): showCommandDialog + async-generator builder.
  static Future<void> show(
    BuildContext context, {
    required List<AppCommandGroup> groups,
    String? searchPlaceholder,
    String? emptyMessage,
  }) {
    return shad.showCommandDialog<void>(
      context: context,
      emptyBuilder: emptyMessage == null ? null : (context) => Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(emptyMessage).muted())),
      builder: (context, query) async* {
        final q = query ?? '';
        yield [
          for (final g in groups)
            if (g.actions.any((a) => a.matches(q)))
              shad.CommandCategory(
                title: Text(g.title),
                children: [
                  for (final a in g.actions)
                    if (a.matches(q))
                      shad.CommandItem(
                        leading: a.icon,
                        trailing: a.shortcutLabel == null ? null : Text(a.shortcutLabel!).muted().mono().xSmall(),
                        title: Text(a.label),
                        onTap: () {
                          shad.closeOverlay(context);
                          a.run();
                        },
                      ),
                ],
              ),
        ];
      },
    );
  }
}
