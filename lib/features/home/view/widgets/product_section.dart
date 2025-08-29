import 'package:flutter/material.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/cart/viewmodel/cart_view_model.dart';
import 'package:groceryapp/features/home/view/widgets/product_item.dart';
import 'package:groceryapp/features/home/viewmodel/home_view_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class CategoryProductSection extends StatelessWidget {
  const CategoryProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        final categories = viewModel.categories;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final category = categories[index];
            final products = viewModel.getCategoryProducts(
              category.id,
            ); // ✅ المنتجات الخاصة بالكاتيجوري
            final isLoading = viewModel.categoryLoading(category.id);
            final hasMore = viewModel.categoryHasMore(category.id);

            return _buildCategorySection(
              context,
              category.id,
              category.title,
              products,
              isLoading,
              hasMore,
              viewModel,
            );
          }, childCount: categories.length),
        );
      },
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String categoryId,
    String categoryName,
    List<ProductModel> products,
    bool isLoading,
    bool hasMore,
    HomeViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== Category Header =====
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    "${products.length} items",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to category page
                },
                child: Text(
                  "See All",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ===== Horizontal Product List with Pagination =====
        SizedBox(
          height: 280,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (!isLoading &&
                  hasMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                viewModel.fetchNextPageForCategory(categoryId, loadMore: true);
              }
              return false;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < products.length) {
                  final product = products[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: ProductItem(
                      product: product,
                      onAddToCart: () async =>
                          await _handleAddToCart(context, product),
                      onIncrease: () => _handleIncrease(context, product),
                      onDecrease: () => _handleDecrease(context, product),
                      onToggleFavorite: () => _handleToggleFavorite(product),
                    ),
                  );
                } else {
                  return const LoadingGridItem();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAddToCart(
    BuildContext context,
    ProductModel product,
  ) async {
    await context
        .read<CartViewModel>()
        .addToCart(
          userId: context.read<AuthViewModel>().getCurrentUser()!.id,
          productId: product.id,
          quantity: context.read<CartViewModel>().getQuantity(product) + 1,
          price: product.price,
        )
        .then(
          (value) => value
              ? ShowToast.showSuccess("${product.title} Added to cart")
              : ShowToast.showError("${product.title} Failed to add to cart"),
        );
  }

  void _handleIncrease(BuildContext context, ProductModel product) {
    final userId = context.read<AuthViewModel>().getCurrentUser()!.id;
    final cartVm = context.read<CartViewModel>();
    final currentQuantity = cartVm.getQuantity(product);

    if (currentQuantity < product.quantity) {
      cartVm.updateQuantity(
        productId: product.id,
        userId: userId,
        cartId: cartVm.getCartId(product),
        quantity: currentQuantity + 1,
      );
    } else {
      ShowToast.showError("We have only ${product.quantity} of this product");
    }
  }

  void _handleDecrease(BuildContext context, ProductModel product) {
    final userId = context.read<AuthViewModel>().getCurrentUser()!.id;
    final cartVm = context.read<CartViewModel>();
    final currentQuantity = cartVm.getQuantity(product);

    if (currentQuantity > 1) {
      cartVm.updateQuantity(
        productId: product.id,
        userId: userId,
        cartId: cartVm.getCartId(product),
        quantity: currentQuantity - 1,
      );
    } else if (currentQuantity == 1) {
      cartVm.removeFromCart(userId, cartVm.getCartId(product), product.id).then(
        (_) {
          ShowToast.showError("${product.title} removed from cart");
        },
      );
    }
  }

  void _handleToggleFavorite(ProductModel product) {}
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
        width: 160,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
