import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider pour gérer la langue de l'application
/// Composant natif : Stockage local (SharedPreferences)
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  Locale _locale = const Locale('fr');
  bool _isInitialized = false;

  Locale get locale => _locale;
  bool get isInitialized => _isInitialized;

  /// Langues supportées
  static const List<Locale> supportedLocales = [Locale('fr'), Locale('en')];

  /// Initialise la locale depuis le stockage local
  Future<void> initLocale() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);

      if (savedLocale != null) {
        _locale = Locale(savedLocale);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement de la locale: $e');
      _isInitialized = true;
    }
  }

  /// Change la langue et la persiste
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      debugPrint('Locale non supportée: $locale');
      return;
    }

    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde de la locale: $e');
    }
  }

  /// Toggle entre français et anglais
  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr');
    await setLocale(newLocale);
  }

  /// Obtient le nom de la langue actuelle
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      default:
        return 'Français';
    }
  }

  /// Obtient le code de la langue opposée pour l'affichage du toggle
  String get oppositeLanguageCode {
    return _locale.languageCode == 'fr' ? 'EN' : 'FR';
  }
}
