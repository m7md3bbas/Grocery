import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/features/cart/model/cart_model.dart';

class CartService {
  final DioBaseClient dioClient;
  final String table = 'user_cart';

  CartService({required this.dioClient});

  /// ✅ جلب كل العناصر في الكارت لليوزر
  Future<List<CartModel>> getUserCart(String userId) async {
    try {
      final response = await dioClient.get(
        url: '/$table',
        queryParameters: {
          'user_id': 'eq.$userId',
          'select': '*, product:product_id(*)', // join مع جدول المنتجات
        },
      );

      final data = response.data as List<dynamic>;
      return data.map((json) => CartModel.fromJson(json)).toList();
    } catch (e) {
      throw Failure("Failed to get user cart: $e");
    }
  }

  /// ✅ إضافة منتج للكارت
  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    required double price,
  }) async {
    try {
      await dioClient.post(
        url: '/$table',
        data: {
          "user_id": userId,
          "product_id": productId,
          "quantity": quantity,
          "price": price,
        },
      );
    } catch (e) {
      throw Failure("Failed to add to cart: $e");
    }
  }

  /// ✅ تعديل الكمية
  Future<void> updateQuantity({
    required String cartId,
    required int quantity,
  }) async {
    try {
      await dioClient.patch(
        url: '/$table',
        data: {
          "quantity": quantity,
          "updated_at": DateTime.now().toIso8601String(),
        },
        queryParameters: {"id": "eq.$cartId"},
      );
    } catch (e) {
      throw Failure("Failed to update quantity: $e");
    }
  }

  /// ✅ حذف عنصر من الكارت
  Future<void> removeFromCart(String cartId) async {
    try {
      await dioClient.delete(
        url: '/$table',
        queryParameters: {"id": "eq.$cartId"},
      );
    } catch (e) {
      throw Failure("Failed to remove from cart: $e");
    }
  }

  /// ✅ إفراغ الكارت بالكامل
  Future<void> clearCart(String userId) async {
    try {
      await dioClient.delete(
        url: '/$table',
        queryParameters: {"user_id": "eq.$userId"},
      );
    } catch (e) {
      throw Failure("Failed to clear cart: $e");
    }
  }
}
