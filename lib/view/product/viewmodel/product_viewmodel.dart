import 'package:flutter/material.dart';
import '../../../data/model/product_model.dart';
import '../../../data/repository/product_repository.dart';

class ProductViewModel extends ChangeNotifier {
  final int productId;
  final ProductRepository _repository = ProductRepository();

  Product? _product;
  int _quantity = 1;
  bool _isLoading = false;
  String? _errorMessage;

  ProductViewModel({required this.productId});

  // Getters
  Product? get product => _product;
  int get quantity => _quantity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalPrice {
    if (_product == null) return 0.0;
    return _product!.price * _quantity;
  }

  // Charger le produit
  Future<void> loadProduct() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _product = await _repository.getProduct(productId);

      debugPrint("Image URL chargée: ${_product?.imageUrl}");

      if (_product == null) {
        _errorMessage = 'Produit introuvable';
      }
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement du produit';
      debugPrint('Error loading product: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void addToCart(BuildContext context) {
    if (_product == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_quantity x ${_product!.name} ajouté${_quantity > 1 ? 's' : ''} au panier',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }
}