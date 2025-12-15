import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/color.dart';
import '../../../core/widgets/japanese_pattern.dart';
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
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _viewModel = WelcomeViewModel();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.cream,
              Colors.white,
              AppColor.lightGold,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Motif japonais en arrière-plan
            const Positioned.fill(
              child: JapanesePattern(opacity: 0.03),
            ),

            // Particules flottantes
            const Positioned.fill(
              child: FloatingParticles(
                numberOfParticles: 20,
                particleColor: AppColor.gold,
              ),
            ),

            // Contenu principal
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo et titre avec effet de pulsation
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Column(
                          children: [
                            // Conteneur pour le logo avec bordure dorée
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColor.primaryGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.primaryColor.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                                border: Border.all(
                                  color: AppColor.gold,
                                  width: 3,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Titre principal
                            Text(
                              'SUSHI SHOP',
                              style: GoogleFonts.notoSerif(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppColor.primaryColor,
                                letterSpacing: 4,
                                shadows: [
                                  Shadow(
                                    color: AppColor.gold.withOpacity(0.3),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Sous-titre en japonais
                            Text(
                              '寿司ショップ',
                              style: GoogleFonts.notoSansJp(
                                fontSize: 24,
                                color: AppColor.darkRed,
                                letterSpacing: 8,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),

                  // Message de bienvenue
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Bienvenue chez Sushi Shop',
                      style: GoogleFonts.notoSans(
                        fontSize: 22,
                        color: AppColor.black,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Bouton tactile style borne
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _viewModel.navigateToNextScreen(context),
                                borderRadius: BorderRadius.circular(20),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: AppColor.primaryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColor.gold,
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.touch_app,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          localizations?.touch_to_start.toUpperCase() ?? 'TOUCH TO START',
                                          style: GoogleFonts.notoSans(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Indicateur tactile
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.lightGold.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 18,
                          color: AppColor.darkRed,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Touchez l\'écran pour commencer',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            color: AppColor.darkRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
