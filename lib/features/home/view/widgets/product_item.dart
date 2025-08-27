import 'package:flutter/material.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/utils/constants/styles/app_text_style.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

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
    return Container(
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
          Image.network(product.image ?? "", height: 90),
          const SizedBox(height: 8),
          Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: AppStyles.textBold20.copyWith(color: AppColors.primary),
          ),
          Text(
            product.title,
            style: AppStyles.textBold15.copyWith(color: Colors.black),
          ),
          Text(
            product.weight.toString(),
            style: AppStyles.textMedium12.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circleButton(Icons.remove, onDecrease),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "${product.quantity}",
                  style: AppStyles.textBold20.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              _circleButton(Icons.add, onIncrease),
            ],
          ),
          TextButton(
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
