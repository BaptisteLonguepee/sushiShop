import 'package:flutter/material.dart';
import '../../../data/model/product_model.dart';
import '../../../data/model/category_model.dart';
import '../../../data/repository/product_repository.dart';
import '../../../data/repository/category_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();
  final CategoryRepository _categoryRepository = CategoryRepository();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Category> _categories = [];
  Category? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _filteredProducts;
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Charger les catégories et produits
  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.wait([_loadCategories(), _loadProducts()]);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadCategories() async {
    _categories = await _categoryRepository.getActiveCategories();
  }

  Future<void> _loadProducts() async {
    _products = await _productRepository.getActiveProducts();
    _applyFilters();
  }

  // Récupérer tous les produits
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getActiveProducts();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sélectionner une catégorie
  void selectCategory(Category? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Rechercher des produits
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Appliquer les filtres
  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      // Filtre par catégorie
      bool matchesCategory =
          _selectedCategory == null ||
          product.categoryId == _selectedCategory!.id;

      // Filtre par recherche
      bool matchesSearch =
          _searchQuery.isEmpty ||
          product.nom.toLowerCase().contains(_searchQuery) ||
          (product.description?.toLowerCase().contains(_searchQuery) ?? false);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Réinitialiser les filtres
  void resetFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
}
