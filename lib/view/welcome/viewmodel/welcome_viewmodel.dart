import 'package:flutter/material.dart';
import '../model/welcome_model.dart';

class WelcomeViewModel extends ChangeNotifier {
  final WelcomeModel _model = WelcomeModel();

  WelcomeModel get model => _model;

  void navigateToNextScreen(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation à implémenter'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
