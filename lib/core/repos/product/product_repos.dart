import 'package:groceryapp/core/service/product/product_service.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class ProductRepos {
  final ProductService productService;

  ProductRepos({required this.productService});

  Future<List<ProductModel>> getProduct({
    required int page,
    required int pageSize,
  }) => productService.getProduct(page: page, pageSize: pageSize);
}
