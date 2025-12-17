import 'package:flutter/material.dart';
import '../../cart/viewmodel/cart_viewmodel.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CartViewModel cartViewModel;

  bool _isProcessing = false;
  String? _errorMessage;

  CheckoutViewModel(this.cartViewModel);

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  // Accès aux données du panier
  double get totalAmount => cartViewModel.totalPrice;
  int get itemCount => cartViewModel.itemCount;
  bool get hasItems => !cartViewModel.isEmpty;

  // Valider la commande avant de passer au paiement
  bool validateOrder() {
    if (cartViewModel.isEmpty) {
      _errorMessage = 'Le panier est vide';
      notifyListeners();
      return false;
    }

    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // Préparer la commande pour le paiement
  void prepareCheckout() {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();
  }

  // Réinitialiser l'état
  void reset() {
    _isProcessing = false;
    _errorMessage = null;
    notifyListeners();
  }
}
