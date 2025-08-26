import 'package:flutter/material.dart';
import 'package:groceryapp/core/styles/app_text_style.dart';
import 'package:groceryapp/features/home/view/widgets/product_item.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: ListTile(
            leading: Text("Featured Products", style: AppStyles.textBold20),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
        Consumer<HomeViewModel>(
          builder: (context, viewModel, _) => GridView.builder(
            itemCount: viewModel.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.62,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: ProductItem(
                  product: viewModel.products[index],
                  onAddToCart: () {},
                  onIncrease: () =>
                      viewModel.increaseCount(viewModel.products[index]),
                  onDecrease: () =>
                      viewModel.decreaseCount(viewModel.products[index]),
                  onToggleFavorite: () =>
                      viewModel.toggleFavorite(viewModel.products[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
