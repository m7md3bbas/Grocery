import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/core/routes/app_router.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/features/cart/viewmodel/cart_view_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToCart;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onToggleFavorite;

  const ProductItem({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(
        context,
      ).push(AppRouteName.productDetails, extra: product),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (product.isNew) _statusItem(),
                const Spacer(),
                _wishListItem(),
              ],
            ),
            CachedNetworkImage(
              imageUrl:
                  "https://scontent.fcai21-3.fna.fbcdn.net/v/t39.30808-6/532405691_794686036419253_5715095751347851658_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=rWs8dp3mVusQ7kNvwFw61sk&_nc_oc=AdlOY3sHa5bH7s7Am8o91krzIRefyN-evu61rGHXEXrT80yoUO9YdWnOiK9Ln8XteJ4&_nc_zt=23&_nc_ht=scontent.fcai21-3.fna&_nc_gid=O7_sRwUxTcr9VIJQEZb67g&oh=00_AfUPptZfZ2nuCt_7LwXPHBxHmUUsevNQm7MQwQ_7ig9ljA&oe=68B7E7EA",
              height: 90,
            ),
            const SizedBox(height: 8),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: AppStyles.textBold15.copyWith(color: AppColors.primary),
            ),
            Text(
              product.title,
              style: AppStyles.textBold15.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "${product.weight} ${product.unit}",
              style: AppStyles.textMedium12.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 8),

            context.watch<CartViewModel>().isInCart(product)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _circleButton(Icons.remove, onDecrease),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            context.watch<CartViewModel>().isItemLoading(
                              product.id,
                            )
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: const CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "${context.watch<CartViewModel>().getQuantity(product)}",
                                style: AppStyles.textBold20.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                      ),
                      context.watch<CartViewModel>().getQuantity(product) <
                              product.quantity
                          ? _circleButton(Icons.add, onIncrease)
                          : _circleButton(Icons.done, () {}),
                    ],
                  )
                : TextButton(
                    onPressed: onAddToCart,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          "Add to cart",
                          style: AppStyles.textMedium15.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _statusItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffFDEFD5),
      ),
      child: Text("New", style: AppStyles.textMedium12),
    );
  }

  Widget _wishListItem() {
    return GestureDetector(
      onTap: onToggleFavorite,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.7),
        ),
        child: Icon(Icons.favorite_border, color: AppColors.primary),
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
