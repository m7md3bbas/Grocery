import 'package:groceryapp/core/service/category/category_service.dart';
import 'package:groceryapp/features/home/model/category_model.dart';

class CategoryRepo {
  final CategoryService categoryService;
  CategoryRepo({required this.categoryService});
  Future<List<CategoryModel>> getCategories() async {
    return await categoryService.getCategory();
  }
}
