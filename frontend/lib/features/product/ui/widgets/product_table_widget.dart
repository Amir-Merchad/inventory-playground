import 'package:frontend/features/product/data/product.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

/// Products rendered as a data table (via the shadcn wrapper's [AppDataTable]).
///
/// Each row has explicit Edit / Delete actions (no row-tap-to-edit — wrong for a
/// table). Supports multi-select, client-side column sorting, zebra striping,
/// and a colour-coded stock badge.
class ProductTableWidget extends StatefulWidget {
  const ProductTableWidget({
    required this.products,
    required this.onEditProduct,
    required this.onDeleteProduct,
    super.key,
  });

  final List<Product> products;
  final ValueChanged<Product> onEditProduct;
  final ValueChanged<Product> onDeleteProduct;

  @override
  State<ProductTableWidget> createState() => _ProductTableWidgetState();
}

// Column indices (col 0 is the checkbox; last is actions).
const _colName = 1;
const _colSku = 2;
const _colPrice = 3;
const _colStock = 4;

class _ProductTableWidgetState extends State<ProductTableWidget> {
  final Set<String> _selected = {};
  int? _sortColumn;
  bool _ascending = true;

  @override
  void didUpdateWidget(covariant ProductTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ids = widget.products.map((p) => p.id).toSet();
    _selected.retainAll(ids);
  }

  void _onSort(int column, bool ascending) {
    setState(() {
      _sortColumn = column;
      _ascending = ascending;
    });
  }

  void _toggleOne(String id, bool selected) {
    setState(() => selected ? _selected.add(id) : _selected.remove(id));
  }

  void _toggleAll(bool selected) {
    setState(() {
      _selected.clear();
      if (selected) _selected.addAll(widget.products.map((p) => p.id));
    });
  }

  List<Product> get _sortedProducts {
    final list = [...widget.products];
    final col = _sortColumn;
    if (col == null) return list;
    list.sort((a, b) {
      final cmp = switch (col) {
        _colName => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        _colSku => a.sku.toLowerCase().compareTo(b.sku.toLowerCase()),
        _colPrice => a.price.compareTo(b.price),
        _colStock => a.stock.compareTo(b.stock),
        _ => 0,
      };
      return _ascending ? cmp : -cmp;
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final products = _sortedProducts;
    final allSelected = products.isNotEmpty && _selected.length == products.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelectionToolbar(
          allSelected: allSelected,
          selectedCount: _selected.length,
          onToggleAll: _toggleAll,
          onClear: () => _toggleAll(false),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppTokens.s2),
            physics: const BouncingScrollPhysics(),
            child: AppDataTable(
              sortColumn: _sortColumn,
              ascending: _ascending,
              onSort: _onSort,
              columns: const [
                AppColumn(label: '', flex: 1),
                AppColumn(label: 'Name', flex: 4, sortable: true),
                AppColumn(label: 'SKU', flex: 3, sortable: true),
                AppColumn(label: 'Price', numeric: true, flex: 2, sortable: true),
                AppColumn(label: 'Stock', numeric: true, flex: 2, sortable: true),
                AppColumn(label: 'Actions', numeric: true, flex: 3),
              ],
              rows: [
                for (final product in products)
                  AppRow(
                    selected: _selected.contains(product.id),
                    cells: [
                      AppCheckbox(
                        checked: _selected.contains(product.id),
                        onChanged: (v) => _toggleOne(product.id, v),
                      ),
                      Text(product.name),
                      Text(product.sku).muted(),
                      Text(product.price.toString()),
                      _StockBadge(stock: product.stock),
                      _RowActions(
                        onEdit: () => widget.onEditProduct(product),
                        onDelete: () => widget.onDeleteProduct(product),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions({required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final destructive = Theme.of(context).colorScheme.destructive;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: const Icon(LucideIcons.pencil, size: 16),
          tooltip: 'Edit',
          variant: AppButtonVariant.ghost,
          onPressed: onEdit,
        ),
        const AppGap.h(AppTokens.s1),
        AppIconButton(
          icon: Icon(LucideIcons.trash2, size: 16, color: destructive),
          tooltip: 'Delete',
          variant: AppButtonVariant.ghost,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _SelectionToolbar extends StatelessWidget {
  const _SelectionToolbar({
    required this.allSelected,
    required this.selectedCount,
    required this.onToggleAll,
    required this.onClear,
  });

  final bool allSelected;
  final int selectedCount;
  final ValueChanged<bool> onToggleAll;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.s3,
        vertical: AppTokens.s2,
      ),
      child: Row(
        children: [
          AppCheckbox(
            checked: allSelected,
            onChanged: onToggleAll,
            label: 'Select all',
          ),
          const Spacer(),
          if (selectedCount > 0) ...[
            AppBadge(
              label: '$selectedCount selected',
              variant: AppBadgeVariant.primary,
            ),
            const AppGap.h(AppTokens.s2),
            AppButton.ghost(
              onPressed: onClear,
              child: const Text('Clear'),
            ),
          ],
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.stock});

  final int stock;

  @override
  Widget build(BuildContext context) {
    final (label, variant) = switch (stock) {
      0 => ('Out', AppBadgeVariant.destructive),
      <= 5 => ('$stock left', AppBadgeVariant.warning),
      _ => ('$stock', AppBadgeVariant.success),
    };
    return AppBadge(label: label, variant: variant);
  }
}
