import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String title;
  final String? image;
  final String color;
  final DateTime createdAt;

  const CategoryModel({
    required this.color,
    required this.id,
    required this.title,
    this.image,
    required this.createdAt,
  });

  CategoryModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      color: color,
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      color: json['color'] as String,
      id: json['id'] as String,
      title: json['name'] as String,
      image: json['category_image'] as String?,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': title, 'category_image': image};
  }

  @override
  List<Object?> get props => [id, title, image, createdAt];
}
