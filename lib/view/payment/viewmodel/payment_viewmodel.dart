import 'package:flutter/material.dart';
import '../../../data/model/commande_model.dart';
import '../../../data/model/commande_article_model.dart';
import '../../../data/repository/commande_repository.dart';
import '../../../data/model/cart_item_model.dart';

class PaymentViewModel extends ChangeNotifier {
  final CommandeRepository _commandeRepository = CommandeRepository();

  String _selectedPaymentMethod = 'card';
  bool _isProcessing = false;
  String? _errorMessage;
  Commande? _createdOrder;

  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  Commande? get createdOrder => _createdOrder;

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<bool> processPayment({
    required double totalAmount,
    required String tableNumber,
    required List<CartItem> cartItems,
  }) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simuler la communication avec le terminal de paiement
      await Future.delayed(const Duration(seconds: 3));

      // Générer le numéro de commande
      final orderNumber = await _commandeRepository.generateNumeroCommande();

      // Créer la commande
      final commande = Commande(
        id: 0,
        numeroCommande: orderNumber,
        statut: 'confirmee',
        total: totalAmount,
        nomClient: 'Table $tableNumber',
        telephone: null,
        email: null,
        notesSpecial: 'Table: $tableNumber',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _createdOrder = await _commandeRepository.createCommande(commande);

      // Créer les articles de la commande
      final articles = cartItems.map((item) {
        return CommandeArticle(
          id: 0,
          commandeId: _createdOrder!.id,
          produitId: item.product.id,
          quantite: item.quantity,
          prixUnitaire: item.product.prix,
          notesArticle: item.notes,
          createdAt: DateTime.now(),
        );
      }).toList();

      await _commandeRepository.addArticles(articles);

      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _selectedPaymentMethod = 'card';
    _isProcessing = false;
    _errorMessage = null;
    _createdOrder = null;
    notifyListeners();
  }
}
