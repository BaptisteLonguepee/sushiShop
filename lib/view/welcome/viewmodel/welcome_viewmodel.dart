import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/welcome_model.dart';
import '../../order_type/view/order_type_screen.dart';

class WelcomeViewModel extends ChangeNotifier {
  final WelcomeModel _model = WelcomeModel();

  WelcomeModel get model => _model;

  void navigateToNextScreen(BuildContext context) {
    HapticFeedback.mediumImpact();
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const OrderTypeScreen()));
  }
}
