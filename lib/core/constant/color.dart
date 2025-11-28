import 'package:flutter/material.dart';

class AppColor {
  // Couleurs principales
  static const Color primaryColor = Color(0xFFB1464A); // Rouge japonais
  static const Color secondaryColor = Color(0xFFDFDFDF); // Gris clair
  static const Color cardColor = Color(0xFFB6B2B2); // Gris moyen
  static const Color darkRed = Color(0xFF8B1A1F); // Rouge foncé
  
  // Couleurs pour les états
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  
  // Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB1464A), Color(0xFF8B1A1F)],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37)],
  );
  
  // Couleurs de fond
  static const Color backgroundColor = Color(0xFFF5F5F5); // Gris très clair
  static const Color surfaceColor = Colors.white;
}
