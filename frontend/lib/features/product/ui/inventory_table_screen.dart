import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/product/bloc/product_bloc.dart';
import 'package:frontend/features/product/data/product.dart';
import 'package:frontend/features/product/ui/widgets/product_browser_widget.dart';
import 'package:frontend/features/product/ui/widgets/product_form_dialog.dart';
import 'package:frontend/features/product/ui/widgets/product_table_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

/// Same search + pagination browser as InventoryScreen, but the loaded products
/// are shown as a data table with per-row Edit / Delete actions.
class InventoryTableScreen extends StatelessWidget {
  const InventoryTableScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final bloc = context.read<ProductBloc>();
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete product?',
      message: 'This will permanently delete ${product.name}.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      destructive: true,
    );
    if (confirmed) {
      bloc.add(ProductDeleted(product.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return shad.Scaffold(
      child: ProductBrowserWidget(
        onAddProduct: () => ProductFormDialog.show(context),
        onProductPressed: (product) =>
            ProductFormDialog.show(context, product: product),
        resultsBuilder: (context, state) => ProductTableWidget(
          products: state.products,
          onEditProduct: (product) =>
              ProductFormDialog.show(context, product: product),
          onDeleteProduct: (product) => _confirmDelete(context, product),
        ),
      ),
    );
  }
}
