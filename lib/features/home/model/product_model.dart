import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String image;
  final String title;
  final String description;
  final int quantity;
  final double price;
  final String category;
  final int discount;
  final bool isFavorite;
  final String status;
  final double weight;
  final bool isNew;

  const ProductModel({
    required this.status,
    required this.category,
    required this.id,
    this.discount = 0,
    required this.image,
    required this.title,
    required this.description,
    this.isFavorite = false,
    required this.quantity,
    required this.price,
    this.weight = 0,
    this.isNew = false,
  });

  ProductModel copyWith({
    String? id,
    String? image,
    String? title,
    String? description,
    int? quantity,
    double? price,
    String? category,
    int? discount,
    bool? isFavorite,
    String? status,
    double? weight,
    bool? isNew,
  }) {
    return ProductModel(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      discount: discount ?? this.discount,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      weight: weight ?? this.weight,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props => [
    image,
    title,
    description,
    quantity,
    price,
    category,
    status,
    id,
    weight,
    discount,
    isFavorite,
    isNew,
  ];
}
