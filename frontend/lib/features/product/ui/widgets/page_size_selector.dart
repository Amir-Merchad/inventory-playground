import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/product/bloc/product_bloc.dart';
import 'package:shadcn_wrapper/shadcn_wrapper.dart';

class PageSizeSelector extends StatelessWidget {
  const PageSizeSelector({
    super.key,
  });

  static const _availableSizes = [
    1,
    5,
    10,
    20,
    50,
    100,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) {
        return previous.size != current.size || previous.status != current.status;
      },
      builder: (context, state) {
        final loading = state.status == ProductStatus.loading;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Text('Rows per page:'),
            // const AppGap.h(AppTokens.s2),
            AppSelect<int>(
              value: state.size,
              enabled: !loading,
              constraints: const BoxConstraints(
                minWidth: 80,
              ),
              searchable: true,
              items: [
                for (final size in _availableSizes)
                  AppSelectItem<int>(
                    value: size,
                    label: size.toString(),
                  ),
              ],
              onChanged: (size) {
                if (size == null) {
                  return;
                }

                context.read<ProductBloc>().add(
                      ProductPageSizeChanged(size),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
