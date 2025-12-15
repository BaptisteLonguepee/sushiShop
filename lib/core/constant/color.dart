import 'package:flutter/material.dart';

class AppColor {
  // Couleurs principales (conservées)
  static const Color primaryColor = Color(0xFFB1464A); // Rouge japonais
  static const Color secondaryColor = Color(0xFFDFDFDF); // Gris clair
  static const Color cardColor = Color(0xFFB6B2B2); // Gris moyen
  
  // Palette étendue pour le thème japonais moderne
  static const Color darkRed = Color(0xFF8B1F23); // Rouge foncé pour accents
  static const Color cream = Color(0xFFFFF8F0); // Crème japonais (washi)
  static const Color black = Color(0xFF1A1A1A); // Noir japonais (sumi)
  static const Color gold = Color(0xFFD4AF37); // Or pour détails premium
  static const Color lightGold = Color(0xFFFFF4E0); // Or très clair
  
  // Couleurs fonctionnelles
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, darkRed],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lightGold, cream],
  );
  
  // Ombres et effets
  static BoxShadow cardShadow = BoxShadow(
    color: black.withOpacity(0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow elevatedShadow = BoxShadow(
    color: primaryColor.withOpacity(0.3),
    blurRadius: 15,
    offset: const Offset(0, 8),
  );
}
