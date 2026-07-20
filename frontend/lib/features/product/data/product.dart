import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

class DecimalJsonConverter implements JsonConverter<Decimal, Object> {
  const DecimalJsonConverter();

  @override
  Decimal fromJson(Object json) {
    return Decimal.parse(json.toString());
  }

  @override
  Object toJson(Decimal value) {
    return value.toString();
  }
}

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String sku,
    @DecimalJsonConverter() required Decimal price,
    required int stock,
    required int version,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
abstract class ProductPage with _$ProductPage {
  const factory ProductPage({
    required List<Product> items,
    required int page,
    required int size,
    required int totalItems,
    required int totalPages,
    required bool hasNext,
  }) = _ProductPage;

  factory ProductPage.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProductPageFromJson(json);
}

@freezed
abstract class CreateProductRequest with _$CreateProductRequest {
  const factory CreateProductRequest({
    required String name,
    required String sku,
    @DecimalJsonConverter() required Decimal price,
    required int stock,
  }) = _CreateProductRequest;

  factory CreateProductRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreateProductRequestFromJson(json);
}

@freezed
abstract class UpdateProductRequest with _$UpdateProductRequest {
  const factory UpdateProductRequest({
    required String id,
    required String name,
    required String sku,
    @DecimalJsonConverter() required Decimal price,
    required int stock,
    required int version,
  }) = _UpdateProductRequest;

  factory UpdateProductRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateProductRequestFromJson(json);
}
