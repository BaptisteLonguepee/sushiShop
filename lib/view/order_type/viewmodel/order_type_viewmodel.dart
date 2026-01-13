import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/order_provider.dart';
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
    if (_model.selectedOrderType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un type de commande'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_model.selectedOrderType == OrderType.dineIn &&
        _model.tableNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un numéro de chevalet'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Stocker les informations dans le provider global
    final orderProvider = context.read<OrderProvider>();
    orderProvider.setOrderInfo(
      type: _model.selectedOrderType!,
      tableNumber: _model.tableNumber?.toString(),
    );

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
