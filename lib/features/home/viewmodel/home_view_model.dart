import 'package:flutter/material.dart';
import 'package:groceryapp/core/repos/category/category_repo.dart';
import 'package:groceryapp/core/repos/product/product_repos.dart';
import 'package:groceryapp/core/utils/constants/images.dart';
import 'package:groceryapp/features/home/model/category_model.dart';
import 'package:groceryapp/features/home/model/product_model.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepos productRepos;
  final CategoryRepo categoryRepos;
  HomeViewModel({required this.productRepos, required this.categoryRepos}) {
    getProduct();
    getCategories();
  }
  bool _isLoading = false;
  String _error = '';
  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  List<ProductModel> _products = [];
  final List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool get hasMore => _hasMore;
  int get page => _page;
  int get pageSize => _pageSize;
  String get error => _error;
  bool get isLoading => _isLoading;
  List<String> get carosualImages => _carosualImages;

  final List<String> _carosualImages = [
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
    AppImages.carousel1,
  ];

  void getCarosualImages() {}

  // pageView
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void setCurrentPage({required int page}) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> getCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await categoryRepos.getCategories();
      _categories.addAll(data);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getProduct({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nextPage = loadMore ? _page + 1 : 1;
      final data = await productRepos.getProduct(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (loadMore) {
        _isLoading = true;
        _products.addAll(data);
      } else {
        _products = data;
      }

      _page = nextPage;
      _hasMore =
          data.length == _pageSize; // if less than pageSize, no more data

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

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
}
