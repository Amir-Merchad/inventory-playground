import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

class AppColumn {
  const AppColumn({required this.label, this.numeric = false, this.flex = 1});
  final String label;
  final bool numeric; // money/qty: end-aligned + tabular figures
  final int flex;
}

class AppRow {
  const AppRow({required this.cells, this.onTap, this.selected = false});
  final List<Widget> cells;
  final VoidCallback? onTap;
  final bool selected;
}

/// Lightweight list-table for POS lists (items, customers, movements).
/// Money columns: pass numeric: true so RTL keeps numbers end-aligned.
/// For very large datasets pair with paged blocs — this renders what you give it.
class AppDataTable extends StatelessWidget {
  const AppDataTable({super.key, required this.columns, required this.rows, this.emptyState});
  final List<AppColumn> columns;
  final List<AppRow> rows;
  final Widget? emptyState;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    final border = theme.colorScheme.border;
    if (rows.isEmpty && emptyState != null) return emptyState!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3, vertical: AppTokens.s2),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: border))),
          child: Row(children: [
            for (final c in columns)
              Expanded(
                flex: c.flex,
                child: Align(
                  alignment: c.numeric ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                  child: Text(c.label).muted().semiBold(),
                ),
              ),
          ]),
        ),
        for (final r in rows)
          shad.Clickable(
            onPressed: r.onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: AppTokens.hitTarget),
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3, vertical: AppTokens.s2),
              decoration: BoxDecoration(
                color: r.selected ? theme.colorScheme.muted : null,
                border: Border(bottom: BorderSide(color: border.withValues(alpha: 0.5))),
              ),
              child: Row(children: [
                for (var i = 0; i < columns.length; i++)
                  Expanded(
                    flex: columns[i].flex,
                    child: Align(
                      alignment: columns[i].numeric ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
                      child: r.cells[i],
                    ),
                  ),
              ]),
            ),
          ),
      ],
    );
  }
}
