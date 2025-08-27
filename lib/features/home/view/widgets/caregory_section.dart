import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CaregorySection extends StatelessWidget {
  const CaregorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final category = viewModel.categories[index];
              final color = (int.parse(category.color));
              return Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(color),
                    radius: 50,
                    child: SvgPicture.network(
                      category.image!,
                      height: 50,
                      width: 40,
                    ),
                  ),
                  Text(category.title, style: const TextStyle(fontSize: 12)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
