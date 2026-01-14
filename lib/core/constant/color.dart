import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xFFB1464A);
  static const Color secondaryColor = Color(0xFFDFDFDF);
  static const Color cardColor = Color(0xFFB6B2B2);

  static const Color darkRed = Color(0xFF8B1F23);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color black = Color(0xFF1A1A1A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color lightGold = Color(0xFFFFF4E0);

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

  static BoxShadow cardShadow = BoxShadow(
    color: black.withValues(alpha: 0.1),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static BoxShadow elevatedShadow = BoxShadow(
    color: primaryColor.withValues(alpha: 0.3),
    blurRadius: 15,
    offset: const Offset(0, 8),
  );
}
