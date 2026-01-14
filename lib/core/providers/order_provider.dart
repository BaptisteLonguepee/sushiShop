import 'package:flutter/material.dart';
import '../../view/order_type/model/order_type_model.dart';

/// Provider global pour les informations de commande
/// Stocke le type de commande et le numéro de table
class OrderProvider extends ChangeNotifier {
  OrderType? _orderType;
  String? _tableNumber;
  bool _isInitialized = false;

  OrderType? get orderType => _orderType;
  String? get tableNumber => _tableNumber;
  bool get isInitialized => _isInitialized;

  /// Vérifie si c'est une commande sur place
  bool get isDineIn => _orderType == OrderType.dineIn;

  /// Vérifie si c'est une commande à emporter
  bool get isTakeaway => _orderType == OrderType.takeaway;

  /// Vérifie si le numéro de table est déjà défini
  bool get hasTableNumber => _tableNumber != null && _tableNumber!.isNotEmpty;

  /// Définit le type de commande
  void setOrderType(OrderType type) {
    _orderType = type;
    _isInitialized = true;

    // Réinitialise le numéro de table si c'est à emporter
    if (type == OrderType.takeaway) {
      _tableNumber = null;
    }
    notifyListeners();
  }

  /// Définit le numéro de table
  void setTableNumber(String? number) {
    _tableNumber = number;
    notifyListeners();
  }

  /// Définit les deux en une fois
  void setOrderInfo({required OrderType type, String? tableNumber}) {
    _orderType = type;
    _tableNumber = tableNumber;
    _isInitialized = true;
    notifyListeners();
  }

  /// Réinitialise les informations de commande
  void reset() {
    _orderType = null;
    _tableNumber = null;
    _isInitialized = false;
    notifyListeners();
  }

  /// Obtient le numéro de table formaté pour l'affichage
  String get displayTableNumber {
    if (_tableNumber == null || _tableNumber!.isEmpty) {
      return '-';
    }
    return _tableNumber!;
  }
}
