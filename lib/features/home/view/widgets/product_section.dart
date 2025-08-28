import 'package:flutter/material.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/cart/viewmodel/cart_view_model.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              if (index < viewModel.products.length) {
                final product = viewModel.products[index];
                return ProductItem(
                  product: product,
                  onAddToCart: () async => await context
                      .read<CartViewModel>()
                      .addToCart(
                        userId: context
                            .read<AuthViewModel>()
                            .getCurrentUser()!
                            .id,
                        productId: product.id,
                        quantity:
                            context.read<CartViewModel>().getQuantity(product) +
                            1,
                        price: product.price,
                      )
                      .then(
                        (value) => value
                            ? ShowToast.showSuccess(
                                "${product.title} Added to cart",
                              )
                            : ShowToast.showError(
                                " ${product.title} Failed to add to cart",
                              ),
                      ),

                  onIncrease: () {
                    final userId = context
                        .read<AuthViewModel>()
                        .getCurrentUser()!
                        .id;
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
                      ShowToast.showError(
                        "We have only ${product.quantity} of this product",
                      );
                    }
                  },
                  onDecrease: () {
                    final userId = context
                        .read<AuthViewModel>()
                        .getCurrentUser()!
                        .id;
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
                      cartVm
                          .removeFromCart(
                            userId,
                            cartVm.getCartId(product),
                            product.id,
                          )
                          .then((_) {
                            ShowToast.showError(
                              "${product.title} removed from cart",
                            );
                          });
                    }
                  },

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
