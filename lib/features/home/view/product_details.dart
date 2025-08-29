import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groceryapp/core/utils/constants/styles/app_color_styles.dart';
import 'package:groceryapp/core/widgets/toast/flutter_toast.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/cart/viewmodel/cart_view_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = GoRouterState.of(context).extra as ProductModel;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 768;
    final isMobile = size.width <= 480;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (isTablet) {
              return _buildTabletLayout(product, context, size);
            } else {
              return _buildMobileLayout(product, context, size, isMobile);
            }
          },
        ),
      ),
    );
  }

  // Mobile Layout (Portrait)
  Widget _buildMobileLayout(
    ProductModel product,
    BuildContext context,
    Size size,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        _buildImageSection(product, context, size, isMobile),

        // Content Section
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: _buildProductInfo(product, context, isMobile),
            ),
          ),
        ),

        // Bottom Bar
        _buildBottomBar(product, context, isMobile),
      ],
    );
  }

  // Tablet Layout (Landscape or Large Screen)
  Widget _buildTabletLayout(
    ProductModel product,
    BuildContext context,
    Size size,
  ) {
    return Row(
      children: [
        // Image Section (Left Side)
        Expanded(
          flex: 5,
          child: _buildImageSection(product, context, size, false),
        ),

        // Content Section (Right Side)
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: _buildProductInfo(product, context, false),
                ),
              ),
              _buildBottomBar(product, context, false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(
    ProductModel product,
    BuildContext context,
    Size size,
    bool isMobile,
  ) {
    final imageHeight = isMobile ? size.height * 0.4 : size.height * 0.5;

    return Container(
      height: imageHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE9FBE5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          // Navigation Buttons
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(
                  Icons.arrow_back,
                  () => Navigator.pop(context),
                  isMobile,
                ),
                _buildIconButton(Icons.favorite_border, () {}, isMobile),
              ],
            ),
          ),

          // Product Image
          Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: imageHeight * 0.7,
                maxWidth: size.width * 0.8,
              ),
              child: Hero(
                tag: 'product_${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.image!,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    height: 100,
                    width: 100,
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(
    ProductModel product,
    BuildContext context,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "\$${product.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),

        SizedBox(height: isMobile ? 12 : 16),

        // Title
        Text(
          product.title,
          style: TextStyle(
            fontSize: isMobile ? 20 : 26,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),

        SizedBox(height: isMobile ? 6 : 8),

        // Weight
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Weight: ${product.weight} kg",
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.grey[600],
            ),
          ),
        ),

        SizedBox(height: isMobile ? 16 : 20),

        // Stock Status
        _buildStockStatus(product, isMobile),

        SizedBox(height: isMobile ? 16 : 20),

        // Description
        Text(
          "Description",
          style: TextStyle(
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),

        SizedBox(height: isMobile ? 8 : 12),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            product.description.toString(),
            style: TextStyle(
              color: Colors.black54,
              height: 1.5,
              fontSize: isMobile ? 14 : 15,
            ),
          ),
        ),

        SizedBox(height: isMobile ? 80 : 100), // Space for bottom bar
      ],
    );
  }

  Widget _buildStockStatus(ProductModel product, bool isMobile) {
    final isInStock = product.quantity > 0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: isInStock
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isInStock ? Icons.check_circle : Icons.cancel,
            color: isInStock ? Colors.green : Colors.red,
            size: isMobile ? 16 : 18,
          ),
          const SizedBox(width: 6),
          Text(
            isInStock ? "${product.quantity} in stock" : "Out of stock",
            style: TextStyle(
              color: isInStock ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.w500,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    ProductModel product,
    BuildContext context,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 20,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Consumer<CartViewModel>(
          builder: (context, cartVm, _) {
            final isInCart = cartVm.isInCart(product);

            if (isInCart) {
              return _buildQuantityControls(product, context, isMobile);
            } else {
              return _buildAddToCartButton(product, context, isMobile);
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuantityControls(
    ProductModel product,
    BuildContext context,
    bool isMobile,
  ) {
    return Consumer<CartViewModel>(
      builder: (context, cartVm, _) {
        final quantity = cartVm.getQuantity(product);
        final isLoading = cartVm.isItemLoading(product.id);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleButton(
              Icons.remove,
              () => _decrementQuantity(product, context),
              isMobile,
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoading
                  ? SizedBox(
                      height: isMobile ? 16 : 20,
                      width: isMobile ? 16 : 20,
                      child: const CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "$quantity",
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
            ),

            _circleButton(
              quantity < product.quantity ? Icons.add : Icons.check,
              quantity < product.quantity
                  ? () => _incrementQuantity(product, context)
                  : () {},
              isMobile,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddToCartButton(
    ProductModel product,
    BuildContext context,
    bool isMobile,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: product.quantity > 0
            ? () => _addToCart(product, context)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: isMobile ? 18 : 20),
            const SizedBox(width: 8),
            Text(
              product.quantity > 0 ? "Add to Cart" : "Out of Stock",
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, bool isMobile) {
    return Container(
      width: isMobile ? 40 : 44,
      height: isMobile ? 40 : 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: isMobile ? 18 : 20, color: Colors.black87),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap, bool isMobile) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: isMobile ? 36 : 40,
        height: isMobile ? 36 : 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: isMobile ? 18 : 20),
      ),
    );
  }

  void _addToCart(ProductModel product, BuildContext context) {
    final userId = context.read<AuthViewModel>().getCurrentUser()!.id;
    context.read<CartViewModel>().addToCart(
      userId: userId,
      productId: product.id,
      quantity: 1,
      price: product.price,
    );
  }

  void _incrementQuantity(ProductModel product, BuildContext context) {
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

  void _decrementQuantity(ProductModel product, BuildContext context) {
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
}
