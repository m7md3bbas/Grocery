import 'package:groceryapp/core/service/cart/cart_service.dart';
import 'package:groceryapp/features/cart/model/cart_model.dart';

class CartRepo {
  final CartService _cartService;

  CartRepo(this._cartService);

  Future<List<CartModel>> getUserCart(String userId) =>
      _cartService.getUserCart(userId);

  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    required double price,
  }) => _cartService.addToCart(
    userId: userId,
    productId: productId,
    quantity: quantity,
    price: price,
  );

  Future<void> updateQuantity({
    required String userId,
    required String cartId,
    required int quantity,
  }) => _cartService.updateQuantity(cartId: cartId, quantity: quantity);

  Future<void> removeFromCart(String userId, String cartId) =>
      _cartService.removeFromCart(cartId);

  Future<void> clearCart(String userId) => _cartService.clearCart(userId);
}
