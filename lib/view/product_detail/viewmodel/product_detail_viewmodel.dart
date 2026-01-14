import 'package:flutter/material.dart';
import '../../../data/model/product_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final Product product;

  int _quantity = 1;
  String? _selectedSize;
  final List<String> _selectedExtras = [];
  String _notes = '';

  ProductDetailViewModel(this.product);

  // Getters
  int get quantity => _quantity;
  String? get selectedSize => _selectedSize;
  List<String> get selectedExtras => List.unmodifiable(_selectedExtras);
  String get notes => _notes;

  // Setters avec notification
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

  void setQuantity(int value) {
    if (value > 0) {
      _quantity = value;
      notifyListeners();
    }
  }

  void selectSize(String? size) {
    _selectedSize = size;
    notifyListeners();
  }

  void toggleExtra(String extra) {
    if (_selectedExtras.contains(extra)) {
      _selectedExtras.remove(extra);
    } else {
      _selectedExtras.add(extra);
    }
    notifyListeners();
  }

  void setNotes(String value) {
    _notes = value;
    notifyListeners();
  }

  // Calcul du prix total
  double calculateTotalPrice(
    Map<String, double> sizes,
    Map<String, double> extras,
  ) {
    double basePrice = product.prix;
    double sizeExtra = _selectedSize != null
        ? (sizes[_selectedSize] ?? 0.0)
        : 0.0;
    double extrasTotal = _selectedExtras.fold(
      0.0,
      (sum, extra) => sum + (extras[extra] ?? 0.0),
    );
    return (basePrice + sizeExtra + extrasTotal) * _quantity;
  }

  // Réinitialiser
  void reset() {
    _quantity = 1;
    _selectedSize = null;
    _selectedExtras.clear();
    _notes = '';
    notifyListeners();
  }
}
