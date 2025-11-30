import 'package:flutter/material.dart';
import '../../data/model/cart_item_model.dart';
import '../../data/model/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get total => _items.fold(0.0, (sum, item) => sum + item.total);

  // Ajouter un produit au panier
  void addItem(Product product, {int quantity = 1, String? notes}) {
    // Vérifier si le produit existe déjà
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Augmenter la quantité
      _items[existingIndex].quantity += quantity;
    } else {
      // Ajouter un nouvel article
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        notes: notes,
      ));
    }
    notifyListeners();
  }

  // Retirer un produit du panier
  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Mettre à jour la quantité d'un article
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  // Augmenter la quantité
  void incrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Diminuer la quantité
  void decrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        removeItem(productId);
      }
      notifyListeners();
    }
  }

  // Mettre à jour les notes d'un article
  void updateNotes(int productId, String notes) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].notes = notes;
      notifyListeners();
    }
  }

  // Vider le panier
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Obtenir un article par ID de produit
  CartItem? getItem(int productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  // Vérifier si le panier est vide
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
}
