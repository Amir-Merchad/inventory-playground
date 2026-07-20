import 'package:flutter/widgets.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

/// Column sizing for AppTable.
sealed class AppTableWidth {
  const AppTableWidth();
}

class AppFlexWidth extends AppTableWidth {
  const AppFlexWidth([this.flex = 1]);
  final double flex;
}

class AppFixedWidth extends AppTableWidth {
  const AppFixedWidth(this.px);
  final double px;
}

class AppTableRowData {
  const AppTableRowData({required this.cells, this.selected = false, this.onTap});
  final List<Widget> cells;
  final bool selected;

  /// Applied per-cell under the hood (shadcn Table has no row-level tap).
  final VoidCallback? onTap;
}

/// Bordered spreadsheet-style grid (GRNs, price lists, stock counts) with
/// header/footer rows, hover highlight and fixed/flex column widths.
/// For simple tap-row lists prefer AppDataTable; for 10k+ rows paginate.
class AppTable extends StatelessWidget {
  const AppTable({
    super.key,
    required this.headers,
    required this.rows,
    this.footers,
    this.columnWidths,
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  final List<Widget> headers;
  final List<AppTableRowData> rows;
  final List<Widget>? footers;

  /// Per-column sizing by index; unlisted columns flex evenly.
  final Map<int, AppTableWidth>? columnWidths;
  final EdgeInsetsGeometry cellPadding;

  @override
  Widget build(BuildContext context) {
    shad.TableCell cell(Widget w, {VoidCallback? onTap, bool header = false}) {
      Widget child = Padding(padding: cellPadding, child: header ? w.semiBold().muted() : w);
      if (onTap != null) {
        child = GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child);
      }
      return shad.TableCell(child: child);
    }

    // ADAPTER (shadcn ^0.0.52): Table + TableHeader/TableRow/TableFooter.
    return shad.Table(
      columnWidths: columnWidths?.map(
        (i, w) => MapEntry(
          i,
          switch (w) {
            AppFlexWidth(:final flex) => shad.FlexTableSize(flex: flex),
            AppFixedWidth(:final px) => shad.FixedTableSize(px),
          },
        ),
      ),
      rows: [
        shad.TableHeader(cells: [for (final h in headers) cell(h, header: true)]),
        for (final r in rows)
          shad.TableRow(
            selected: r.selected,
            cells: [for (final c in r.cells) cell(c, onTap: r.onTap)],
          ),
        if (footers != null) shad.TableFooter(cells: [for (final f in footers!) cell(f)]),
      ],
    );
  }
}
