import 'package:groceryapp/core/service/product/product_service.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class ProductRepos {
  final ProductService productService;

  ProductRepos({required this.productService});

  Future<List<ProductModel>> getProductsByCategory({
    required int page,
    required int pageSize,
    required String categoryId,
  }) => productService.getProductsByCategory(
    categoryId: categoryId,
    page: page,
    pageSize: pageSize,
  );

  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
  }) => productService.getProducts(page: page, pageSize: pageSize);
}
