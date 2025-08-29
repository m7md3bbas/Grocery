class OrderModel {
  final String id;
  final String userId;
  final double totalPrice;
  final String status; // pending / confirmed / shipped / delivered / cancelled
  final String paymentStatus; // unpaid / paid / failed / refunded
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      paymentStatus: json['payment_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
