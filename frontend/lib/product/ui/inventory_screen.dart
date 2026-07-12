import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/product/bloc/product_bloc.dart';
import 'package:frontend/product/data/product.dart';
import 'package:frontend/product/ui/widgets/product_browser_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _clearControllers() {
    _nameController.clear();
    _skuController.clear();
    _priceController.clear();
    _stockController.clear();
  }

  void _populateControllers(Product product) {
    _nameController.text = product.name;
    _skuController.text = product.sku;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
  }

  CreateProductRequest? _buildCreateRequest() {
    final price = Decimal.tryParse(
      _priceController.text.trim().replaceAll(',', '.'),
    );

    final stock = int.tryParse(
      _stockController.text.trim(),
    );

    if (price == null || stock == null) {
      return null;
    }

    return CreateProductRequest(
      name: _nameController.text,
      sku: _skuController.text,
      price: price,
      stock: stock,
    );
  }

  UpdateProductRequest? _buildUpdateRequest(Product product) {
    final price = Decimal.tryParse(
      _priceController.text.trim().replaceAll(',', '.'),
    );

    final stock = int.tryParse(
      _stockController.text.trim(),
    );

    if (price == null || stock == null) {
      return null;
    }

    return UpdateProductRequest(
      id: product.id,
      name: _nameController.text,
      sku: _skuController.text,
      price: price,
      stock: stock,
      version: product.version,
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final productBloc = context.read<ProductBloc>();

    _clearControllers();

    await AppDialog.show<void>(
      context,
      title: 'Add Product',
      dismissible: true,
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFormField(
              label: 'Name',
              required: true,
              child: AppTextField(
                controller: _nameController,
                placeholder: 'Product name',
                autofocus: true,
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'SKU',
              required: true,
              child: AppTextField(
                controller: _skuController,
                placeholder: 'SKU',
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'Price',
              required: true,
              child: AppNumberField(
                controller: _priceController,
                placeholder: '0.00',
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'Stock',
              required: true,
              child: AppNumberField(
                controller: _stockController,
                placeholder: '0',
                decimal: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        AppButton(
          onPressed: () {
            final request = _buildCreateRequest();

            if (request == null) {
              return;
            }

            productBloc.add(
              ProductCreated(request),
            );

            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _showUpdateDialog(BuildContext context, Product product) async {
    final productBloc = context.read<ProductBloc>();

    _populateControllers(product);

    await AppDialog.show<void>(
      context,
      title: 'Update Product',
      dismissible: true,
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFormField(
              label: 'Name',
              required: true,
              child: AppTextField(
                controller: _nameController,
                placeholder: 'Product name',
                autofocus: true,
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'SKU',
              required: true,
              child: AppTextField(
                controller: _skuController,
                placeholder: 'SKU',
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'Price',
              required: true,
              child: AppNumberField(
                controller: _priceController,
                placeholder: '0.00',
              ),
            ),
            const AppGap.v(AppTokens.s3),
            AppFormField(
              label: 'Stock',
              required: true,
              child: AppNumberField(
                controller: _stockController,
                placeholder: '0',
                decimal: false,
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        AppButton(
          onPressed: () {
            final request = _buildUpdateRequest(product);

            if (request == null) {
              return;
            }

            productBloc.add(
              ProductUpdated(request),
            );

            Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return shad.Scaffold(
      headers: [
        shad.AppBar(
          title: const Text('Inventory Playground'),
          trailing: [
            BlocBuilder<ProductBloc, ProductState>(
              buildWhen: (previous, current) {
                return previous.status != current.status;
              },
              builder: (context, state) {
                final loading = state.status == ProductStatus.loading;

                return AppIconButton(
                  icon: Icon(
                    loading ? shad.LucideIcons.loaderCircle : shad.LucideIcons.refreshCw,
                  ),
                  variant: AppButtonVariant.secondary,
                  onPressed: loading
                      ? null
                      : () {
                          context.read<ProductBloc>().add(
                                const ProductsRequested(),
                              );
                        },
                );
              },
            ),
            const AppGap.h(AppTokens.s1),
            AppIconButton(
              icon: const Icon(shad.LucideIcons.plus),
              variant: AppButtonVariant.primary,
              onPressed: () {
                _showCreateDialog(context);
              },
            ),
          ],
        ),
      ],
      child: ProductBrowserWidget(
        onAddProduct: () {
          _showCreateDialog(context);
        },
        onProductPressed: (product) {
          _showUpdateDialog(
            context,
            product,
          );
        },
      ),
    );
  }
}
