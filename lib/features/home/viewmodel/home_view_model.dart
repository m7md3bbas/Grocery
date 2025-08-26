import 'package:flutter/material.dart';
import 'package:groceryapp/core/constants/images.dart';
import 'package:groceryapp/features/home/model/category_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';

  String get error => _error;
  bool get isLoading => _isLoading;

  final List<String> _carosualImages = [
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
  ];

  final List<CategoryModel> _categoryImages = [
    CategoryModel(
      name: 'Vegetables',
      image: AppImages.vegetables,
      color: Color(0xffE6F2EA),
    ),
    CategoryModel(
      name: 'Fruits',
      image: AppImages.fruits,
      color: Color(0xffFFE9E5),
    ),
    CategoryModel(
      name: 'Beverages',
      image: AppImages.beverages,
      color: Color(0xffFFF6E3),
    ),
    CategoryModel(
      name: 'Grocery',
      image: AppImages.grocery,
      color: Color(0xffDCF4F5),
    ),
    CategoryModel(
      name: 'Household',
      image: AppImages.household,
      color: Color(0xffFFE8F2),
    ),
  ];

  List<CategoryModel> get categoryImages => _categoryImages;
  List<String> get carosualImages => _carosualImages;

  void getCarosualImages() {}

  // pageView
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void setCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  //featured product

  final List<ProductModel> _products = [
    ProductModel(
      id: '7',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
    ProductModel(
      id: '6',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
    ProductModel(
      id: '5',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
    ProductModel(
      id: '4',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
    ProductModel(
      id: '3',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
    ProductModel(
      id: '2',
      title: 'Onion',
      price: 20,
      image: "assets/images/home/aocado-2 1.png",
      quantity: 1,
      category: 'Vegetables',
      description:
          'Onions are a type of bulbous plant in the family Allium. They are a common vegetable in the English cuisine, as well as in other cuisines.',
      isNew: true,
      status: 'Available',
      discount: 10,
      isFavorite: false,
      weight: 1.5,
    ),
  ];

  List<ProductModel> get products => _products;
  void increaseCount(ProductModel product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(quantity: product.quantity + 1);
      notifyListeners();
    }
  }

  void decreaseCount(ProductModel product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1 && product.quantity > 0) {
      _products[index] = product.copyWith(quantity: product.quantity - 1);
      notifyListeners();
    }
  }

  void toggleFavorite(ProductModel product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(isFavorite: !product.isFavorite);
      notifyListeners();
    }
  }

  List<ProductModel> getProduct() {
    _isLoading = true;
    notifyListeners();
    try {
      _isLoading = false;
      _error = '';
      notifyListeners();
      return _products;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }
}
