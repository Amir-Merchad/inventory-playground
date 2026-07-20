import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'data/product.dart';

part 'product_api.g.dart';

@RestApi()
abstract class ProductApi {
  factory ProductApi(
    Dio dio, {
    String? baseUrl,
  }) = _ProductApi;

  // @GET('/products')
  // Future<List<Product>> getProducts();

  @GET('/products')
  Future<ProductPage> getProducts({
    @Query('q') String? query,
    @Query('page') int page = 0,
    @Query('size') int size = 20,
  });

  @POST('/products')
  Future<Product> createProduct(
    @Body() CreateProductRequest request,
  );

  @PATCH('/products')
  Future<Product> updateProduct(
    @Body() UpdateProductRequest request,
  );

  @DELETE('/products/{id}')
  Future<void> deleteProduct(
    @Path('id') String id,
  );
}
