import 'package:groceryapp/core/service/dio/base_class.dart';
import 'package:groceryapp/core/utils/error/failure.dart';

class PaymentService {
  final DioBaseClient dioClient;

  String payments = "payments";
  PaymentService({required this.dioClient});

  /// Create a payment record
  Future<Map<String, dynamic>> createPayment({
    required String orderId,
    required String userId,
    required double amount,
    String method = "cash_on_delivery",
    String status = "pending",
    String? transactionId,
  }) async {
    try {
      final response = await dioClient.post(
        url: payments,
        data: {
          "order_id": orderId,
          "user_id": userId,
          "amount": amount,
          "method": method,
          "status": status,
          if (transactionId != null) "transaction_id": transactionId,
        },
      );

      return response.data;
    } catch (e) {
      throw Failure("Failed to create payment: $e");
    }
  }

  /// Get payment by order
  Future<Map<String, dynamic>?> getPaymentByOrder(String orderId) async {
    try {
      final response = await dioClient.get(
        url: payments,
        queryParameters: {"order_id": "eq.$orderId"},
      );

      final data = response.data as List;
      if (data.isEmpty) return null;
      return data.first;
    } catch (e) {
      throw Failure("Failed to fetch payment: $e");
    }
  }

  /// Update payment status (e.g. success, failed, refunded)
  Future<void> updatePaymentStatus(
    String paymentId,
    String status, {
    String? transactionId,
  }) async {
    try {
      await dioClient.patch(
        url: payments,
        queryParameters: {"id": "eq.$paymentId"},
        data: {
          "status": status,
          if (transactionId != null) "transaction_id": transactionId,
        },
      );
    } catch (e) {
      throw Failure("Failed to update payment: $e");
    }
  }

  /// Delete a payment record (if needed)
  Future<void> deletePayment(String paymentId) async {
    try {
      await dioClient.delete(
        url: payments,
        queryParameters: {"id": "eq.$paymentId"},
      );
    } catch (e) {
      throw Failure("Failed to delete payment: $e");
    }
  }
}
