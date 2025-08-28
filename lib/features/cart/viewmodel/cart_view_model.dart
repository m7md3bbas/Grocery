import 'package:flutter/material.dart';
import 'package:groceryapp/core/repos/cart/cart_repo.dart';
import 'package:groceryapp/core/utils/dependancy_injection.dart';
import 'package:groceryapp/features/auth/viewmodel/auth_view_model.dart';
import 'package:groceryapp/features/cart/model/cart_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepo _cartRepo;

  CartViewModel(this._cartRepo) {
    final user = locator<AuthViewModel>().getCurrentUser();
    if (user != null) {
      fetchCartItems(user.id);
    }
  }

  bool _isLoading = false;
  String _error = '';
  List<CartModel> _cartItems = [];

  /// عشان نعرف انهي منتج بيتعمله update / add / remove دلوقتي
  final Map<String, bool> _itemLoading = {};

  bool get isLoading => _isLoading;
  String get error => _error;
  List<CartModel> get cartItems => _cartItems;

  bool isItemLoading(String productId) {
    return _itemLoading[productId] ?? false;
  }

  Future<void> fetchCartItems(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _cartItems = await _cartRepo.getUserCart(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addToCart({
    required String userId,
    required String productId,
    required int quantity,
    required double price,
  }) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.addToCart(
        userId: userId,
        productId: productId,
        quantity: quantity,
        price: price,
      );

      await fetchCartItems(userId);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setItemLoading(productId, false);
    }
  }

  Future<void> updateQuantity({
    required String userId,
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.updateQuantity(
        userId: userId,
        cartId: cartId,
        quantity: quantity,
      );
      await fetchCartItems(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setItemLoading(productId, false);
    }
  }

  int getQuantity(ProductModel product) {
    int quantity = 0;
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    if (index != -1) {
      quantity = _cartItems[index].quantity;
    }
    return quantity;
  }

  String getCartId(ProductModel product) {
    String cartId = '';
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    if (index != -1) {
      cartId = _cartItems[index].id;
    }
    return cartId;
  }

  bool isInCart(ProductModel product) {
    final index = _cartItems.indexWhere((p) => p.productId == product.id);
    return index != -1;
  }

  Future<void> removeFromCart(
    String userId,
    String cartId,
    String productId,
  ) async {
    _setItemLoading(productId, true);
    try {
      await _cartRepo.removeFromCart(userId, cartId);
      _cartItems.removeWhere((item) => item.id == cartId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setItemLoading(productId, false);
    }
  }

  void removeLocal(String cartId) {
    _cartItems.removeWhere((item) => item.id == cartId);
    notifyListeners();
  }

  Future<void> clearCart(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _cartRepo.clearCart(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setItemLoading(String productId, bool value) {
    _itemLoading[productId] = value;
    notifyListeners();
  }
}
