import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Service de vibration - Composant système natif
/// Fournit un feedback haptique pour améliorer l'expérience utilisateur
class VibrationService {
  static VibrationService? _instance;
  bool? _hasVibrator;
  bool? _hasAmplitudeControl;

  VibrationService._();

  static VibrationService get instance {
    _instance ??= VibrationService._();
    return _instance!;
  }

  /// Initialise le service et vérifie les capacités de l'appareil
  Future<void> init() async {
    try {
      _hasVibrator = await Vibration.hasVibrator();
      _hasAmplitudeControl = await Vibration.hasAmplitudeControl();
    } catch (e) {
      _hasVibrator = false;
      _hasAmplitudeControl = false;
    }
  }

  /// Vérifie si l'appareil peut vibrer
  bool get canVibrate => _hasVibrator ?? false;

  /// Vibration légère pour les clics/taps
  Future<void> lightTap() async {
    if (!canVibrate) {
      // Fallback sur HapticFeedback système
      await HapticFeedback.lightImpact();
      return;
    }

    try {
      if (_hasAmplitudeControl == true) {
        await Vibration.vibrate(duration: 10, amplitude: 64);
      } else {
        await Vibration.vibrate(duration: 10);
      }
    } catch (e) {
      await HapticFeedback.lightImpact();
    }
  }

  /// Vibration moyenne pour les actions importantes
  Future<void> mediumImpact() async {
    if (!canVibrate) {
      await HapticFeedback.mediumImpact();
      return;
    }

    try {
      if (_hasAmplitudeControl == true) {
        await Vibration.vibrate(duration: 30, amplitude: 128);
      } else {
        await Vibration.vibrate(duration: 30);
      }
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Vibration forte pour les confirmations/succès
  Future<void> heavyImpact() async {
    if (!canVibrate) {
      await HapticFeedback.heavyImpact();
      return;
    }

    try {
      if (_hasAmplitudeControl == true) {
        await Vibration.vibrate(duration: 50, amplitude: 255);
      } else {
        await Vibration.vibrate(duration: 50);
      }
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Pattern de vibration pour le succès (ajout au panier)
  Future<void> successPattern() async {
    if (!canVibrate) {
      await HapticFeedback.mediumImpact();
      return;
    }

    try {
      // Pattern: court-pause-court
      await Vibration.vibrate(pattern: [0, 50, 100, 50]);
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Pattern de vibration pour le paiement réussi
  Future<void> paymentSuccessPattern() async {
    if (!canVibrate) {
      await HapticFeedback.heavyImpact();
      return;
    }

    try {
      // Pattern: trois vibrations courtes
      await Vibration.vibrate(pattern: [0, 100, 100, 100, 100, 100]);
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Pattern d'erreur
  Future<void> errorPattern() async {
    if (!canVibrate) {
      await HapticFeedback.heavyImpact();
      return;
    }

    try {
      // Pattern: long
      await Vibration.vibrate(duration: 300);
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Annule toute vibration en cours
  Future<void> cancel() async {
    try {
      await Vibration.cancel();
    } catch (e) {
      // Ignore
    }
  }
}
