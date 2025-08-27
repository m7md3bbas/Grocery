import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String? categoryId;
  final String title;
  final String? description;
  final String? image;
  final int quantity;
  final double price;
  final int discount;
  final String status;
  final double weight;
  final bool isNew;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    this.categoryId,
    required this.title,
    this.description,
    this.image,
    required this.quantity,
    required this.price,
    this.discount = 0,
    required this.status,
    this.weight = 0,
    this.isNew = false,
    required this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? categoryId,
    String? title,
    String? description,
    String? image,
    int? quantity,
    double? price,
    int? discount,
    String? status,
    double? weight,
    bool? isNew,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      isNew: isNew ?? this.isNew,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toDouble(),
      discount: json['discount'] ?? 0,
      status: json['status'] as String,
      weight: (json['weight'] ?? 0).toDouble(),
      isNew: json['is_new'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'title': title,
      'description': description,
      'image': image,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'status': status,
      'weight': weight,
      'is_new': isNew,
    };
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    title,
    description,
    image,
    quantity,
    price,
    discount,
    status,
    weight,
    isNew,
    createdAt,
  ];
}
