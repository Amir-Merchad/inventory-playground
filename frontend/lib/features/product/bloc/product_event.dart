part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsRequested extends ProductEvent {
  const ProductsRequested();
}

final class ProductSearchChanged extends ProductEvent {
  const ProductSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ProductPageRequested extends ProductEvent {
  const ProductPageRequested(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

final class ProductPageSizeChanged extends ProductEvent {
  const ProductPageSizeChanged(this.size);

  final int size;

  @override
  List<Object?> get props => [size];
}

final class ProductCreated extends ProductEvent {
  const ProductCreated(this.request);

  final CreateProductRequest request;

  @override
  List<Object?> get props => [request];
}

final class ProductUpdated extends ProductEvent {
  const ProductUpdated(this.request);

  final UpdateProductRequest request;

  @override
  List<Object?> get props => [request];
}

final class ProductDeleted extends ProductEvent {
  const ProductDeleted(this.id);

  final id;

  @override
  List<Object?> get props => [id];
}
