import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/cart_item_model.dart';
import '../../../data/model/product_model.dart';

/// Service de stockage local - Composant système natif
/// Persiste les données importantes (panier, préférences)
class StorageService {
  static const String _cartKey = 'cart_items';
  static const String _orderTypeKey = 'order_type';
  static const String _tableNumberKey = 'table_number';
  static const String _lastOrderKey = 'last_order_number';

  static StorageService? _instance;
  SharedPreferences? _prefs;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Initialise le service
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Vérifie que le service est initialisé
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ==================== CART PERSISTENCE ====================

  /// Sauvegarde le panier localement
  Future<bool> saveCart(List<CartItem> items) async {
    try {
      final prefs = await _getPrefs();
      final cartJson = items.map((item) => {
        'product': item.product.toMap(),
        'quantity': item.quantity,
        'notes': item.notes,
      }).toList();

      return await prefs.setString(_cartKey, jsonEncode(cartJson));
    } catch (e) {
      debugPrint('Erreur sauvegarde panier: $e');
      return false;
    }
  }

  /// Récupère le panier sauvegardé
  Future<List<CartItem>> loadCart() async {
    try {
      final prefs = await _getPrefs();
      final cartString = prefs.getString(_cartKey);

      if (cartString == null || cartString.isEmpty) {
        return [];
      }

      final List<dynamic> cartJson = jsonDecode(cartString);
      return cartJson.map((item) {
        return CartItem(
          product: Product.fromMap(item['product'] as Map<String, dynamic>),
          quantity: item['quantity'] as int,
          notes: item['notes'] as String?,
        );
      }).toList();
    } catch (e) {
      debugPrint('Erreur chargement panier: $e');
      return [];
    }
  }

  /// Efface le panier sauvegardé
  Future<bool> clearCart() async {
    try {
      final prefs = await _getPrefs();
      return await prefs.remove(_cartKey);
    } catch (e) {
      debugPrint('Erreur suppression panier: $e');
      return false;
    }
  }

  // ==================== ORDER PREFERENCES ====================

  /// Sauvegarde le type de commande (sur place/à emporter)
  Future<bool> saveOrderType(String orderType) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(_orderTypeKey, orderType);
    } catch (e) {
      debugPrint('Erreur sauvegarde type commande: $e');
      return false;
    }
  }

  /// Récupère le type de commande
  Future<String?> getOrderType() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_orderTypeKey);
    } catch (e) {
      return null;
    }
  }

  /// Sauvegarde le numéro de table
  Future<bool> saveTableNumber(String tableNumber) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(_tableNumberKey, tableNumber);
    } catch (e) {
      debugPrint('Erreur sauvegarde numéro table: $e');
      return false;
    }
  }

  /// Récupère le numéro de table
  Future<String?> getTableNumber() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_tableNumberKey);
    } catch (e) {
      return null;
    }
  }

  // ==================== ORDER HISTORY ====================

  /// Sauvegarde le dernier numéro de commande
  Future<bool> saveLastOrderNumber(String orderNumber) async {
    try {
      final prefs = await _getPrefs();
      return await prefs.setString(_lastOrderKey, orderNumber);
    } catch (e) {
      return false;
    }
  }

  /// Récupère le dernier numéro de commande
  Future<String?> getLastOrderNumber() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(_lastOrderKey);
    } catch (e) {
      return null;
    }
  }

  // ==================== UTILITY ====================

  /// Efface toutes les données locales
  Future<bool> clearAll() async {
    try {
      final prefs = await _getPrefs();
      return await prefs.clear();
    } catch (e) {
      debugPrint('Erreur suppression données: $e');
      return false;
    }
  }
}
