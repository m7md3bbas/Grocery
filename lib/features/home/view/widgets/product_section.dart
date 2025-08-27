import 'package:flutter/material.dart';
import 'package:groceryapp/features/home/view/widgets/product_item.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        final totalCount =
            viewModel.products.length + (viewModel.hasMore ? 2 : 0);
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              if (index < viewModel.products.length) {
                final product = viewModel.products[index];
                return ProductItem(
                  product: product,
                  onAddToCart: () {},
                  onIncrease: () => viewModel.increaseCount(product),
                  onDecrease: () => viewModel.decreaseCount(product),
                  onToggleFavorite: () {},
                );
              } else {
                return const LoadingGridItem();
              }
            },
            itemCount: totalCount,
          ),
        );
      },
    );
  }
}

class LoadingGridItem extends StatefulWidget {
  const LoadingGridItem({super.key});

  @override
  State<LoadingGridItem> createState() => _LoadingGridItemState();
}

class _LoadingGridItemState extends State<LoadingGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(4),
      ),
    );
  }
}
