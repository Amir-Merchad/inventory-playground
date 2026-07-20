import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'tokens.dart';

class AppColumn {
  const AppColumn({required this.label, this.numeric = false, this.flex = 1, this.sortable = false});
  final String label;
  final bool numeric; // money/qty: end-aligned + tabular figures
  final int flex;
  final bool sortable;
}

class AppRow {
  const AppRow({required this.cells, this.onTap, this.onSecondaryTap, this.selected = false});
  final List<Widget> cells;
  final VoidCallback? onTap;

  /// Desktop: right-click → hook your AppContextMenuRegion instead if you
  /// need a full menu; this is for quick "open in new tab"-style actions.
  final VoidCallback? onSecondaryTap;
  final bool selected;
}

/// Lightweight list-table for POS lists (items, customers, movements).
/// Money columns: pass numeric: true so RTL keeps numbers end-aligned.
/// Sorting is caller-owned: set [sortColumn]/[ascending], resort your list in
/// [onSort]. For very large datasets pair with paged blocs — this renders
/// what you give it. Need frozen headers/cell spans? Use AppTable instead.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.emptyState,
    this.sortColumn,
    this.ascending = true,
    this.onSort,
    this.dense = false,
    this.striped = false,
  });
  final List<AppColumn> columns;
  final List<AppRow> rows;
  final Widget? emptyState;
  final int? sortColumn;
  final bool ascending;
  final void Function(int column, bool ascending)? onSort;

  /// Dense = back-office ERP grids; default = touch-safe POS rows.
  final bool dense;

  /// Zebra striping: subtly shade alternating rows for easier row tracking.
  final bool striped;

  @override
  Widget build(BuildContext context) {
    final theme = shad.Theme.of(context);
    final border = theme.colorScheme.border;
    if (rows.isEmpty && emptyState != null) return emptyState!;
    final minRowHeight = dense ? 32.0 : AppTokens.hitTarget;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3, vertical: AppTokens.s2),
          decoration: BoxDecoration(
            color: theme.colorScheme.muted.withValues(alpha: 0.4),
            border: Border(bottom: BorderSide(color: border)),
          ),
          child: Row(children: [
            for (var i = 0; i < columns.length; i++)
              Expanded(
                flex: columns[i].flex,
                child: _HeaderCell(
                  column: columns[i],
                  sorted: sortColumn == i,
                  ascending: ascending,
                  onSort: (columns[i].sortable && onSort != null)
                      ? () => onSort!(i, sortColumn == i ? !ascending : true)
                      : null,
                ),
              ),
          ]),
        ),
        ...rows.asMap().entries.map((entry) {
          final index = entry.key;
          final r = entry.value;
          final Color? rowColor = r.selected
              ? theme.colorScheme.muted
              : (striped && index.isOdd
                  ? theme.colorScheme.muted.withValues(alpha: 0.25)
                  : null);
          return shad.Clickable(
            onPressed: r.onTap,
            child: GestureDetector(
              onSecondaryTap: r.onSecondaryTap,
              child: Container(
                constraints: BoxConstraints(minHeight: minRowHeight),
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.s3, vertical: AppTokens.s2),
                decoration: BoxDecoration(
                  color: rowColor,
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
          );
        }),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.column, required this.sorted, required this.ascending, this.onSort});
  final AppColumn column;
  final bool sorted;
  final bool ascending;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    final label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(column.label).muted().semiBold()),
        if (sorted) ...[
          const SizedBox(width: 4),
          // ADAPTER (shadcn ^0.0.52): LucideIcons ships with shadcn_flutter.
          Icon(ascending ? shad.LucideIcons.chevronUp : shad.LucideIcons.chevronDown, size: 12),
        ],
      ],
    );
    final aligned = Align(
      alignment: column.numeric ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: label,
    );
    if (onSort == null) return aligned;
    return shad.Clickable(onPressed: onSort, child: aligned);
  }
}
