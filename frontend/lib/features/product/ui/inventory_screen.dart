import 'package:flutter/widgets.dart';
import 'package:frontend/features/product/ui/widgets/product_browser_widget.dart';
import 'package:frontend/features/product/ui/widgets/product_form_dialog.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return shad.Scaffold(
      child: ProductBrowserWidget(
        onAddProduct: () => ProductFormDialog.show(context),
        onProductPressed: (product) =>
            ProductFormDialog.show(context, product: product),
      ),
    );
  }
}
