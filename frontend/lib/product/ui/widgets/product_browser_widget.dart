import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/product/bloc/product_bloc.dart';
import 'package:frontend/product/data/product.dart';
import 'package:frontend/product/ui/widgets/loading_list_widget.dart';
import 'package:frontend/product/ui/widgets/page_size_selector.dart';
import 'package:frontend/product/ui/widgets/product_list_widget.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shad;
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class ProductBrowserWidget extends StatelessWidget {
  ProductBrowserWidget({
    required this.onProductPressed,
    required this.onAddProduct,
    super.key,
  });

  final ValueChanged<Product> onProductPressed;
  final VoidCallback onAddProduct;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(
                  AppTokens.s2,
                ),
                child: AppSearchField(
                  controller: _searchController,
                  placeholder: 'Search by name or SKU...',
                  leading: const Icon(
                    shad.LucideIcons.search,
                  ),
                  trailing: AppIconButton(
                    icon: const Icon(
                      shad.LucideIcons.x,
                    ),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();

                      context.read<ProductBloc>().add(
                            const ProductSearchChanged(''),
                          );
                    },
                  ),
                  onChanged: (query) {
                    context.read<ProductBloc>().add(
                          ProductSearchChanged(query),
                        );
                  },
                )),
            if (state.status == ProductStatus.loading) const AppProgressBar(),
            Expanded(
              child: _buildResults(
                context,
                state,
              ),
            ),
            if (state.totalPages > 0)
              Padding(
                padding: const EdgeInsets.all(
                  AppTokens.s2,
                ),
                child: Wrap(
                  spacing: AppTokens.s4,
                  runSpacing: AppTokens.s2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${state.totalItems} products',
                    ).muted(),
                    const PageSizeSelector(),
                    AppPagination(
                      page: state.page + 1,
                      totalPages: state.totalPages,
                      onPage: (selectedPage) {
                        context.read<ProductBloc>().add(
                              ProductPageRequested(
                                selectedPage - 1,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildResults(
    BuildContext context,
    ProductState state,
  ) {
    if (state.status == ProductStatus.loading && state.products.isEmpty) {
      return const LoadingListWidget();
    }

    if (state.status == ProductStatus.failure && state.products.isEmpty) {
      return AppErrorState(
        title: 'Failed to load products',
        message: state.errorMessage,
        retryLabel: 'Try again',
        onRetry: () {
          context.read<ProductBloc>().add(
                const ProductsRequested(),
              );
        },
      );
    }

    if (state.products.isEmpty) {
      return AppEmptyState(
        title: state.query.isEmpty ? 'No products yet' : 'No matching products',
        message: state.query.isEmpty ? 'Create your first product.' : 'Try another name or SKU.',
        actionLabel: state.query.isEmpty ? 'Add product' : null,
        onAction: state.query.isEmpty ? onAddProduct : null,
      );
    }

    return ProductListWidget(
      products: state.products,
      onProductPressed: onProductPressed,
    );
  }
}
