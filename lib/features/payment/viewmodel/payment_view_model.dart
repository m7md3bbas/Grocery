import 'package:flutter/material.dart';
import 'package:groceryapp/core/service/payment/payment_service.dart';
import 'package:groceryapp/core/utils/error/failure.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService paymentService;

  PaymentViewModel({required this.paymentService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _payment;
  Map<String, dynamic>? get payment => _payment;

  Future<void> createPayment({
    required String orderId,
    required String userId,
    required double amount,
    String method = "cash_on_delivery",
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _payment = await paymentService.createPayment(
        orderId: orderId,
        userId: userId,
        amount: amount,
        method: method,
      );
    } catch (e) {
      throw Failure("Payment failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPaymentByOrder(String orderId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _payment = await paymentService.getPaymentByOrder(orderId);
    } catch (e) {
      throw Failure("Failed to fetch payment: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
