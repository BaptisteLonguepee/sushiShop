import 'package:flutter/material.dart';
import '../model/order_type_model.dart';
import '../../home/view/home_screen.dart';

class OrderTypeViewModel extends ChangeNotifier {
  final OrderTypeModel _model = OrderTypeModel();

  OrderTypeModel get model => _model;

  OrderType? get selectedOrderType => _model.selectedOrderType;
  int? get tableNumber => _model.tableNumber;
  bool get isValid => _model.isValid;

  void selectOrderType(OrderType type) {
    _model.selectedOrderType = type;
    if (type == OrderType.takeaway) {
      _model.tableNumber = null;
    }
    notifyListeners();
  }

  void setTableNumber(int? number) {
    _model.tableNumber = number;
    notifyListeners();
  }

  void validateAndNavigate(BuildContext context) {
    if (!_model.isValid) {
      String message;
      if (_model.selectedOrderType == null) {
        message = 'Veuillez sélectionner un type de commande';
      } else if (_model.selectedOrderType == OrderType.dineIn &&
          _model.tableNumber == null) {
        message = 'Veuillez entrer un numéro de chevalet';
      } else {
        message = 'Données invalides';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigation vers la HomeScreen après sélection valide
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _model.reset();
    super.dispose();
  }
}
