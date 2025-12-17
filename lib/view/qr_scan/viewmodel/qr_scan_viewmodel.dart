import 'package:flutter/material.dart';

class QrScanViewModel extends ChangeNotifier {
  String? _scannedTableNumber;
  bool _isScanning = false;
  String? _errorMessage;

  String? get scannedTableNumber => _scannedTableNumber;
  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;
  bool get hasScannedTable => _scannedTableNumber != null;

  // Simuler le scan de QR code
  Future<bool> simulateScan() async {
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simuler le temps de scan
      await Future.delayed(const Duration(seconds: 2));

      // Simuler un numéro de table scanné (entre 1 et 20)
      final randomTable = (DateTime.now().millisecond % 20) + 1;
      _scannedTableNumber = randomTable.toString();

      _isScanning = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }

  // Valider un numéro de table manuellement
  bool validateTableNumber(String tableNumber) {
    if (tableNumber.isEmpty) {
      _errorMessage = 'Veuillez entrer un numéro de table';
      notifyListeners();
      return false;
    }

    final number = int.tryParse(tableNumber);
    if (number == null || number <= 0) {
      _errorMessage = 'Numéro de table invalide';
      notifyListeners();
      return false;
    }

    _scannedTableNumber = tableNumber;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  // Réinitialiser
  void reset() {
    _scannedTableNumber = null;
    _isScanning = false;
    _errorMessage = null;
    notifyListeners();
  }
}
