import 'package:flutter/material.dart';
import '../../../data/model/product_model.dart';
import '../../../data/model/cart_item_model.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.total);

  bool get isEmpty => _items.isEmpty;

  // Ajouter un produit au panier
  void addProduct(Product product, {int quantity = 1}) {
    // Vérifier si le produit existe déjà
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Augmenter la quantité
      _items[existingIndex].quantity += quantity;
    } else {
      // Ajouter un nouvel article
      _items.add(CartItem(
        product: product,
        quantity: quantity,
      ));
    }

    notifyListeners();
  }

  // Retirer un produit du panier
  void removeProduct(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Augmenter la quantité d'un produit
  void incrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Diminuer la quantité d'un produit
  void decrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // Vider le panier
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Obtenir la quantité d'un produit spécifique
  int getProductQuantity(int productId) {
    final item = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => CartItem(product: Product(id: -1, nom: '', prix: 0)),
    );
    return item.product.id == -1 ? 0 : item.quantity;
  }
}
