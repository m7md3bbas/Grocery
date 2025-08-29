import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class ProductService {
  final DioBaseClient dio;

  ProductService({required this.dio});

  Future<List<ProductModel>> getProducts({
    required int page,
    required int pageSize,
  }) async {
    try {
      final Dio dio = Dio();
      final start = (page - 1) * pageSize;
      final end = start + pageSize - 1;

      final response = await dio.get(
        'https://ryainsxbjgbmcfcsaklp.supabase.co/rest/v1/grocery_products',
        queryParameters: {'select': '*'},
        options: Options(
          headers: {
            'apikey': dotenv.env['SUPABASE_KEY']!,
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_KEY']}',
            'Prefer': 'return=minimal',
            'Range': '$start-$end', // pagination
          },
        ),
      );

      final data = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }

  Future<List<ProductModel>> getProductsByCategory({
    required int page,
    required int pageSize,
    required String categoryId,
  }) async {
    try {
      final Dio dio = Dio();
      final start = (page - 1) * pageSize;
      final end = start + pageSize - 1;

      final response = await dio.get(
        'https://ryainsxbjgbmcfcsaklp.supabase.co/rest/v1/grocery_products',
        queryParameters: {
          'select': '*',
          'category_id': 'eq.$categoryId', // فلترة بالكاتيجوري
        },
        options: Options(
          headers: {
            'apikey': dotenv.env['SUPABASE_KEY']!,
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_KEY']}',
            'Prefer': 'return=minimal',
            'Range': '$start-$end', // pagination
          },
        ),
      );

      final data = (response.data as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();

      return data;
    } catch (e) {
      throw Failure(e.toString());
    }
  }
}
