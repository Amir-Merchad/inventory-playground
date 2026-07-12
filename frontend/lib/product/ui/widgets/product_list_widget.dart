import 'package:flutter/widgets.dart';
import 'package:frontend/product/data/product.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({
    required this.products,
    required this.onProductPressed,
    super.key,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTokens.s2),
      itemCount: products.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 8);
      },
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final product = products[index];

        return AppButton.outline(
          onPressed: () {
            onProductPressed(product);
          },
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name),
                      const SizedBox(height: 4),
                      Text(product.sku).muted(),
                    ],
                  ),
                ),
                Text(product.price.toString()),
                const SizedBox(width: 24),
                Text('Stock: ${product.stock}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
