import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/utils/error/failure.dart';
import 'package:groceryapp/features/order/model/order_items_model.dart';
import 'package:groceryapp/features/order/model/order_model.dart';

class OrderService {
  final DioBaseClient dioClient;

  String orders = "orders";
  String orderItem = "order_items";
  OrderService({required this.dioClient});

  /// Create new order
  Future<OrderModel> createOrder({
    required String userId,
    required double totalAmount,
    String status = "pending",
  }) async {
    try {
      final response = await dioClient.post(
        url: orders,
        data: {
          "user_id": userId,
          "total_amount": totalAmount,
          "status": status,
        },
      );

      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw Failure("Failed to create order: $e");
    }
  }

  /// Add item to order
  Future<OrderItemModel> addOrderItem({
    required String orderId,
    required String productId,
    required int quantity,
    required double price,
  }) async {
    try {
      final response = await dioClient.post(
        url: orderItem,
        data: {
          "order_id": orderId,
          "product_id": productId,
          "quantity": quantity,
          "price": price,
        },
      );

      return OrderItemModel.fromJson(response.data);
    } catch (e) {
      throw Failure("Failed to add order item: $e");
    }
  }

  /// Get all orders for a user
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final response = await dioClient.get(
        url: orders,
        queryParameters: {"user_id": "eq.$userId"},
      );

      return (response.data as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Failure("Failed to fetch orders: $e");
    }
  }

  /// Get specific order with items
  Future<Map<String, dynamic>> getOrderWithItems(String orderId) async {
    try {
      // Get order
      final orderResponse = await dioClient.get(
        url: orders,
        queryParameters: {"id": "eq.$orderId"},
      );

      final order = OrderModel.fromJson(orderResponse.data[0]);

      // Get items
      final itemsResponse = await dioClient.get(
        url: "/order_items",
        queryParameters: {"order_id": "eq.$orderId"},
      );

      final items = (itemsResponse.data as List)
          .map((json) => OrderItemModel.fromJson(json))
          .toList();

      return {"order": order, "items": items};
    } catch (e) {
      throw Failure("Failed to fetch order with items: $e");
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await dioClient.patch(
        url: orders,
        queryParameters: {"id": "eq.$orderId"},
        data: {"status": status},
      );
    } catch (e) {
      throw Failure("Failed to update order status: $e");
    }
  }

  /// Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      await dioClient.delete(
        url: orders,
        queryParameters: {"id": "eq.$orderId"},
      );
    } catch (e) {
      throw Failure("Failed to delete order: $e");
    }
  }
}
