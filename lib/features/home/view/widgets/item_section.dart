import 'package:flutter/material.dart';
import 'package:groceryapp/features/home/model/category_model.dart';

class ItemSection extends StatelessWidget {
  const ItemSection({super.key, required this.categoryModel});
  final CategoryModel categoryModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // CircleAvatar(
        //   backgroundColor: categoryModel.color,
        //   radius: 30,
        //   child: SvgPicture.asset(categoryModel.image),
        // ),
        // Text(categoryModel.name),
      ],
    );
  }
}
