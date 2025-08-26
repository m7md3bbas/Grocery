import 'package:flutter/material.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/features/home/view/widgets/item_section.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class CaregorySection extends StatelessWidget {
  const CaregorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text("Categories", style: AppStyles.textBold20),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
        SizedBox(
          height: 80,
          child: Consumer<HomeViewModel>(
            builder: (context, viewModel, _) => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.categoryImages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ItemSection(
                  categoryModel: viewModel.categoryImages[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
