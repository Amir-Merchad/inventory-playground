import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/network/api_error.dart';
import 'package:frontend/features/product/bloc/product_bloc.dart';
import 'package:frontend/features/product/data/product.dart';
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

/// Create/edit product dialog.
///
/// Passing [product] == null puts the form in "create" mode; otherwise "edit".
///
/// Unlike a fire-and-forget dialog, this one stays open while the request is in
/// flight and only closes on success. Server errors are rendered where they
/// belong: field-level errors inline under each input, everything else as a toast.
class ProductFormDialog extends StatefulWidget {
  const ProductFormDialog({super.key, this.product});

  final Product? product;

  bool get isEdit => product != null;

  /// Opens the dialog. Captures the [ProductBloc] from [context] and re-provides
  /// it below the dialog route (dialogs are pushed on a separate subtree that
  /// can't see the bloc otherwise).
  static Future<void> show(BuildContext context, {Product? product}) {
    final bloc = context.read<ProductBloc>();

    return AppDialog.show<void>(
      context,
      title: product == null ? 'Add Product' : 'Update Product',
      content: BlocProvider.value(
        value: bloc,
        child: ProductFormDialog(product: product),
      ),
    );
  }

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  /// field name ("name" / "sku" / "price" / "stock") -> message to show inline.
  Map<String, String> _fieldErrors = {};

  /// A form-level error (network, concurrent edit, 500...) shown as a banner
  /// at the top of the dialog. Persists until the next submit.
  String? _formError;

  /// Set true when we dispatch a submit, so the state listener knows the next
  /// `isSubmitting: true -> false` transition belongs to *this* dialog.
  bool _awaitingResult = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _nameController.text = product.name;
      _skuController.text = product.sku;
      _priceController.text = product.price.toString();
      _stockController.text = product.stock.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    // 1. Client-side validation first — no point hitting the server for a
    //    price that isn't even a number.
    final price = Decimal.tryParse(
      _priceController.text.trim().replaceAll(',', '.'),
    );
    final stock = int.tryParse(_stockController.text.trim());

    final clientErrors = <String, String>{};
    if (price == null) clientErrors['price'] = 'Enter a valid number.';
    if (stock == null) clientErrors['stock'] = 'Enter a whole number.';

    if (clientErrors.isNotEmpty) {
      setState(() {
        _fieldErrors = clientErrors;
        _formError = null;
      });
      return;
    }

    // 2. Clear old errors and dispatch. We'll react to the result in the listener.
    setState(() {
      _fieldErrors = {};
      _formError = null;
      _awaitingResult = true;
    });

    final bloc = context.read<ProductBloc>();
    final product = widget.product;

    if (product == null) {
      bloc.add(
        ProductCreated(
          CreateProductRequest(
            name: _nameController.text.trim(),
            sku: _skuController.text.trim(),
            price: price!,
            stock: stock!,
          ),
        ),
      );
    } else {
      bloc.add(
        ProductUpdated(
          UpdateProductRequest(
            id: product.id,
            name: _nameController.text.trim(),
            sku: _skuController.text.trim(),
            price: price!,
            stock: stock!,
            version: product.version,
          ),
        ),
      );
    }
  }

  Future<void> _delete(BuildContext context) async {
    final product = widget.product!;

    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete product?',
      message: 'This will permanently delete ${product.name}.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;

    setState(() => _awaitingResult = true);
    context.read<ProductBloc>().add(ProductDeleted(product.id));
  }

  /// Turns a server [ApiError] into inline field errors or a form-level banner.
  void _handleServerError(ApiError error) {
    // Validation errors carry a per-field list; a duplicate SKU maps onto
    // the SKU field. Anything else is "form-level" and shown as a banner.
    if (error.fieldErrors.isNotEmpty) {
      setState(() {
        _formError = null;
        _fieldErrors = {
          for (final fe in error.fieldErrors) fe.field: fe.message,
        };
      });
    } else if (error.code == 'DUPLICATE_SKU') {
      setState(() {
        _formError = null;
        _fieldErrors = {'sku': error.message};
      });
    } else {
      setState(() {
        _fieldErrors = {};
        _formError = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      // Only care about the moment a submit finishes (isSubmitting true -> false).
      listenWhen: (prev, curr) =>
          _awaitingResult && prev.isSubmitting && !curr.isSubmitting,
      listener: (context, state) {
        _awaitingResult = false;
        if (state.error == null) {
          Navigator.of(context, rootNavigator: true).pop();
        } else {
          _handleServerError(state.error!);
        }
      },
      builder: (context, state) {
        final submitting = state.isSubmitting;

        return SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_formError != null) ...[
                AppAlert(
                  kind: AppAlertKind.danger,
                  title: 'Could not save',
                  message: _formError,
                ),
                const AppGap.v(AppTokens.s3),
              ],
              AppFormField(
                label: 'Name',
                required: true,
                error: _fieldErrors['name'],
                child: AppTextField(
                  controller: _nameController,
                  placeholder: 'Product name',
                  autofocus: true,
                  enabled: !submitting,
                ),
              ),
              const AppGap.v(AppTokens.s3),
              AppFormField(
                label: 'SKU',
                required: true,
                error: _fieldErrors['sku'],
                child: AppTextField(
                  controller: _skuController,
                  placeholder: 'SKU',
                  enabled: !submitting,
                ),
              ),
              const AppGap.v(AppTokens.s3),
              AppFormField(
                label: 'Price',
                required: true,
                error: _fieldErrors['price'],
                child: AppNumberField(
                  controller: _priceController,
                  placeholder: '0.00',
                  enabled: !submitting,
                ),
              ),
              const AppGap.v(AppTokens.s3),
              AppFormField(
                label: 'Stock',
                required: true,
                error: _fieldErrors['stock'],
                child: AppNumberField(
                  controller: _stockController,
                  placeholder: '0',
                  decimal: false,
                  stepButtons: true,
                  enabled: !submitting,
                ),
              ),
              const AppGap.v(AppTokens.s4),
              Row(
                children: [
                  if (widget.isEdit)
                    AppButton.destructive(
                      enabled: !submitting,
                      onPressed: () => _delete(context),
                      child: const Text('Delete'),
                    ),
                  const Spacer(),
                  AppButton.outline(
                    enabled: !submitting,
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text('Cancel'),
                  ),
                  const AppGap.h(AppTokens.s2),
                  AppButton(
                    enabled: !submitting,
                    onPressed: () => _submit(context),
                    child: Text(
                      submitting
                          ? 'Saving…'
                          : (widget.isEdit ? 'Update' : 'Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
