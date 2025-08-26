import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:groceryapp/core/utils/sharedpreference.dart';

class DioBaseClient {
  final Dio dio;

  DioBaseClient({required this.dio}) {
    setupDio(token: getToken().toString());
  }
  Future<String?> getToken() async {
    final token = await SharedpreferenceHelper().getString("token");
    return token;
  }

  void setupDio({required String token}) {
    dio.options.baseUrl = dotenv.env['baseUrl']!;
    dio.options.headers['apikey'] = dotenv.env['SUPABASE_KEY']!;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${dotenv.env['SUPABASE_KEY']}';
    dio.options.headers['Prefer'] = 'return=minimal';

    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);
  }

  Future<Response> get({
    required String url,
    required Map<String, dynamic> data,
  }) async => await dio.get(url, queryParameters: data);
  Future<Response> post({required String url, data}) async =>
      await dio.post(url, data: data);
  Future<Response> put({required String url, data}) async =>
      await dio.put(url, data: data);
  Future<Response> delete({required String url}) async => await dio.delete(url);
  Future<Response> patch({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async =>
      await dio.patch(url, data: data, queryParameters: queryParameters);
}
