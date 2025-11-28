import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/welcome_viewmodel.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final WelcomeViewModel _viewModel;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = WelcomeViewModel();

    // Animation de pulsation pour le bouton
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo et titre
              _buildHeader(localizations),

              const Spacer(),

              // Bouton central animé
              _buildCentralButton(localizations, size),

              const SizedBox(height: 40),

              // Footer avec sélecteur de langue
              _buildFooter(localizations),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations? localizations) {
    return Column(
      children: [
        // Icône sushi stylisée
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.restaurant_menu,
            size: 100,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 40),

        // Titre avec style japonais
        Text(
          'SUSHI SHOP',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 12),

        // Sous-titre en japonais
        Text(
          '寿司屋',
          style: GoogleFonts.notoSerifJp(
            fontSize: 28,
            color: AppColor.cardColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCentralButton(AppLocalizations? localizations, Size size) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: GestureDetector(
        onTap: () => _viewModel.navigateToNextScreen(context),
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppColor.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 12),
                Text(
                  localizations?.touch_to_start.toUpperCase() ??
                      'TOUCHER POUR COMMENCER',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageButton('FR', const Locale('fr')),
          const SizedBox(width: 15),
          Container(
            height: 25,
            width: 2,
            color: AppColor.cardColor,
          ),
          const SizedBox(width: 15),
          _buildLanguageButton('EN', const Locale('en')),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String language, Locale locale) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        final isSelected = localeProvider.locale == locale;
        
        return GestureDetector(
          onTap: () {
            localeProvider.setLocale(locale);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              language,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColor.cardColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
