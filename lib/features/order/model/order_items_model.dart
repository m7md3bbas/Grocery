class OrderItemModel {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final double price;
  final DateTime createdAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
