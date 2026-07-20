import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/core/network/api_error.dart';
import 'package:frontend/core/network/api_error_mapper.dart';
import 'package:frontend/features/product/data/product.dart';
import 'package:frontend/features/product/product_api.dart';
import 'package:stream_transform/stream_transform.dart';

part 'product_event.dart';
part 'product_state.dart';

const _searchDebounceDuration = Duration(
  milliseconds: 300,
);

EventTransformer<Event> debounceRestartable<Event>(
  Duration duration,
) {
  return (events, mapper) {
    final debouncedEvents = events.debounce(duration);

    return restartable<Event>()(
      debouncedEvents,
      mapper,
    );
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required ProductApi productApi,
  })  : _productApi = productApi,
        super(const ProductState()) {
    on<ProductsRequested>(
      _onProductsRequested,
      transformer: restartable(),
    );

    on<ProductSearchChanged>(
      _onProductSearchChanged,
      transformer: debounceRestartable(_searchDebounceDuration),
    );

    on<ProductPageRequested>(
      _onProductPageRequested,
      transformer: restartable(),
    );

    on<ProductPageSizeChanged>(
      _onProductPageSizeChanged,
      transformer: restartable(),
    );

    on<ProductCreated>(
      _onProductCreated,
      transformer: droppable(),
    );

    on<ProductUpdated>(
      _onProductUpdated,
      transformer: droppable(),
    );

    on<ProductDeleted>(
      _onProductDeleted,
      transformer: droppable(),
    );
  }

  final ProductApi _productApi;

  Future<ProductPage> _requestPage({
    required String query,
    required int page,
    required int size,
  }) {
    final normalizedQuery = query.trim();

    return _productApi.getProducts(
      query: normalizedQuery.isEmpty ? null : normalizedQuery,
      page: page,
      size: size,
    );
  }

  void _emitProductPage(
    Emitter<ProductState> emit,
    ProductPage productPage, {
    required String query,
  }) {
    emit(
      state.copyWith(
        status: ProductStatus.success,
        products: productPage.items,
        query: query,
        page: productPage.page,
        size: productPage.size,
        totalItems: productPage.totalItems,
        totalPages: productPage.totalPages,
        hasNext: productPage.hasNext,
        isSubmitting: false,
        clearError: true,
      ),
    );
  }

  Future<void> _onProductsRequested(
    ProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
      ),
    );

    try {
      final productPage = await _requestPage(
        query: state.query,
        page: state.page,
        size: state.size,
      );

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductSearchChanged(
    ProductSearchChanged event,
    Emitter<ProductState> emit,
  ) async {
    final query = event.query.trim();

    emit(
      state.copyWith(
        status: ProductStatus.loading,
        query: query,
        page: 0,
        clearError: true,
      ),
    );

    try {
      final productPage = await _requestPage(
        query: query,
        page: 0,
        size: state.size,
      );

      _emitProductPage(
        emit,
        productPage,
        query: query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          query: query,
          page: 0,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductPageRequested(
    ProductPageRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (event.page < 0 || event.page >= state.totalPages || event.page == state.page) {
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.loading,
        clearError: true,
      ),
    );

    try {
      final productPage = await _requestPage(
        query: state.query,
        page: event.page,
        size: state.size,
      );

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductPageSizeChanged(
    ProductPageSizeChanged event,
    Emitter<ProductState> emit,
  ) async {
    const allowedSizes = {1, 5, 10, 20, 50, 100};

    if (!allowedSizes.contains(event.size) || event.size == state.size) {
      return;
    }

    emit(
      state.copyWith(
        status: ProductStatus.loading,
        page: 0,
        size: event.size,
        clearError: true,
      ),
    );

    try {
      final productPage = await _requestPage(
        query: state.query,
        page: 0,
        size: event.size,
      );

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductCreated(
    ProductCreated event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      await _productApi.createProduct(event.request);

      // Return to page zero because the new product's
      // sorted position is not necessarily on the current page.
      final productPage = await _requestPage(
        query: state.query,
        page: 0,
        size: state.size,
      );

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductUpdated(
    ProductUpdated event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      await _productApi.updateProduct(event.request);

      var requestedPage = state.page;

      var productPage = await _requestPage(
        query: state.query,
        page: requestedPage,
        size: state.size,
      );

      // The updated name/SKU can move the product out
      // of the current search or remove the final page.
      if (productPage.items.isEmpty && requestedPage > 0 && requestedPage >= productPage.totalPages) {
        requestedPage = productPage.totalPages - 1;

        if (requestedPage >= 0) {
          productPage = await _requestPage(
            query: state.query,
            page: requestedPage,
            size: state.size,
          );
        }
      }

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: toApiError(error),
        ),
      );
    }
  }

  Future<void> _onProductDeleted(
    ProductDeleted event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearError: true,
      ),
    );

    try {
      await _productApi.deleteProduct(event.id);

      var requestedPage = state.page;

      var productPage = await _requestPage(
        query: state.query,
        page: requestedPage,
        size: state.size,
      );

      // The updated name/SKU can move the product out
      // of the current search or remove the final page.
      if (productPage.items.isEmpty && requestedPage > 0 && requestedPage >= productPage.totalPages) {
        requestedPage = productPage.totalPages - 1;

        if (requestedPage >= 0) {
          productPage = await _requestPage(
            query: state.query,
            page: requestedPage,
            size: state.size,
          );
        }
      }

      _emitProductPage(
        emit,
        productPage,
        query: state.query,
      );
    } catch (error) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: toApiError(error),
        ),
      );
    }
  }
}
