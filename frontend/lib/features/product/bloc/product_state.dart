part of 'product_bloc.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
}

final class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.query = '',
    this.page = 0,
    this.size = 20,
    this.totalItems = 0,
    this.totalPages = 0,
    this.hasNext = false,
    this.isSubmitting = false,
    this.error,
  });

  final ProductStatus status;
  final List<Product> products;
  final String query;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool isSubmitting;
  final ApiError? error;
  bool get hasPrevious => page > 0;

  ProductState copyWith({
    ProductStatus? status,
    List<Product>? products,
    String? query,
    int? page,
    int? size,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? isSubmitting,
    ApiError? error,
    bool clearError = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      query: query ?? this.query,
      page: page ?? this.page,
      size: size ?? this.size,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        query,
        page,
        size,
        totalItems,
        totalPages,
        hasNext,
        isSubmitting,
        error,
      ];
}
