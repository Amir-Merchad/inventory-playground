// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: const DecimalJsonConverter().fromJson(json['price'] as Object),
      stock: (json['stock'] as num).toInt(),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'price': const DecimalJsonConverter().toJson(instance.price),
      'stock': instance.stock,
      'version': instance.version,
    };

_ProductPage _$ProductPageFromJson(Map<String, dynamic> json) => _ProductPage(
      items: (json['items'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$ProductPageToJson(_ProductPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'page': instance.page,
      'size': instance.size,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
    };

_CreateProductRequest _$CreateProductRequestFromJson(
        Map<String, dynamic> json) =>
    _CreateProductRequest(
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: const DecimalJsonConverter().fromJson(json['price'] as Object),
      stock: (json['stock'] as num).toInt(),
    );

Map<String, dynamic> _$CreateProductRequestToJson(
        _CreateProductRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sku': instance.sku,
      'price': const DecimalJsonConverter().toJson(instance.price),
      'stock': instance.stock,
    };

_UpdateProductRequest _$UpdateProductRequestFromJson(
        Map<String, dynamic> json) =>
    _UpdateProductRequest(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      price: const DecimalJsonConverter().fromJson(json['price'] as Object),
      stock: (json['stock'] as num).toInt(),
      version: (json['version'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateProductRequestToJson(
        _UpdateProductRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'price': const DecimalJsonConverter().toJson(instance.price),
      'stock': instance.stock,
      'version': instance.version,
    };
