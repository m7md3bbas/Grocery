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
    getProduct(loadMore: true);
    getCategories();
  }

  // ================== GLOBAL PRODUCTS (unchanged) ==================
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
  List<ProductModel> get products => _products;

  // ================== Carousel ==================
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

  // ================== Fetch Categories ==================
  Future<void> getCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await categoryRepos.getCategories();
      _categories.addAll(data);

      for (var category in _categories) {
        _categoryProducts[category.id] = [];
        _categoryPage[category.id] = 1;
        _categoryHasMore[category.id] = true;
        _categoryLoading[category.id] = false;

        fetchNextPageForCategory(category.id);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // ================== Fetch All Products (global) ==================
  Future<void> getProduct({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final nextPage = loadMore ? _page + 1 : 1;
      final data = await productRepos.getProducts(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (loadMore) {
        _products.addAll(data);
      } else {
        _products = data;
      }

      _page = nextPage;
      _hasMore = data.length == _pageSize;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // ================== Increase / Decrease Count ==================
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

  // ================== Categorized Products (static) ==================
  Map<String, List<ProductModel>> get categorizedProducts {
    final Map<String, List<ProductModel>> map = {};
    for (var category in _categories) {
      map[category.title] = _products
          .where((product) => product.categoryId == category.id)
          .toList();
    }
    return map;
  }

  // ================== Pagination per Category ==================
  final Map<String, List<ProductModel>> _categoryProducts = {};
  final Map<String, int> _categoryPage = {};
  final Map<String, bool> _categoryHasMore = {};
  final Map<String, bool> _categoryLoading = {};

  List<ProductModel> getCategoryProducts(String categoryId) =>
      _categoryProducts[categoryId] ?? [];

  bool categoryHasMore(String categoryId) =>
      _categoryHasMore[categoryId] ?? true;
  bool categoryLoading(String categoryId) =>
      _categoryLoading[categoryId] ?? false;

  Future<void> fetchNextPageForCategory(
    String categoryId, {
    bool loadMore = false,
  }) async {
    if (_categoryLoading[categoryId] == true ||
        (_categoryHasMore[categoryId] == false && loadMore))
      return;

    _categoryLoading[categoryId] = true;
    notifyListeners();

    try {
      final nextPage = loadMore ? (_categoryPage[categoryId]! + 1) : 1;
      final data = await productRepos.getProductsByCategory(
        categoryId: categoryId,
        page: nextPage,
        pageSize: _pageSize,
      );

      if (loadMore) {
        _categoryProducts[categoryId]!.addAll(data);
      } else {
        _categoryProducts[categoryId] = data;
      }

      _categoryPage[categoryId] = nextPage;
      _categoryHasMore[categoryId] = data.length == _pageSize;

      _categoryLoading[categoryId] = false;
      notifyListeners();
    } catch (e) {
      _categoryLoading[categoryId] = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
