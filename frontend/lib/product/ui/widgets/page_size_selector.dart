import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/product/bloc/product_bloc.dart';
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
            const Text('Rows per page:'),
            const AppGap.h(AppTokens.s2),
            for (final size in _availableSizes) ...[
              AppButton(
                variant: state.size == size ? AppButtonVariant.secondary : AppButtonVariant.ghost,
                enabled: !loading,
                onPressed: () {
                  context.read<ProductBloc>().add(
                        ProductPageSizeChanged(size),
                      );
                },
                child: Text(size.toString()),
              ),
              if (size != _availableSizes.last) const AppGap.h(AppTokens.s1),
            ],
          ],
        );
      },
    );
  }
}
