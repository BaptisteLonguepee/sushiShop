import 'package:flutter/material.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repository/product_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductRepository _productRepository = ProductRepository();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Récupérer tous les produits
  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _productRepository.getAllProducts();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
