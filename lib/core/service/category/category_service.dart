import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/features/home/model/category_model.dart';

class CategoryService {
  final DioBaseClient dio;

  CategoryService({required this.dio});
  Future<List<CategoryModel>> getCategory() async {
    try {
      final response = await dio.get(
        url: "categories",
        queryParameters: {"select": "*"},
      );

      final data = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
