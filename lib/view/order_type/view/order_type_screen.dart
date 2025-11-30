import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../model/order_type_model.dart';
import '../viewmodel/order_type_viewmodel.dart';

class OrderTypeScreen extends StatefulWidget {
  const OrderTypeScreen({super.key});

  @override
  State<OrderTypeScreen> createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen>
    with SingleTickerProviderStateMixin {
  late final OrderTypeViewModel _viewModel;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderTypeViewModel();
    _viewModel.addListener(_onViewModelChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec style japonais
            _buildHeader(localizations),

            // Corps principal avec scroll
            Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Question principale
                      _buildQuestionText(localizations),

                      const SizedBox(height: 30),

                      // Boutons de sélection (style borne)
                      SizedBox(
                        height: 300,
                        child: Row(
                          children: [
                            // Bouton Sur Place
                            Expanded(
                              child: _buildLargeOrderTypeButton(
                                context,
                                type: OrderType.dineIn,
                                icon: Icons.restaurant_menu,
                                label: localizations?.order_type_dine_in ?? 'Sur Place',
                                isSelected: _viewModel.selectedOrderType == OrderType.dineIn,
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Bouton À Emporter
                            Expanded(
                              child: _buildLargeOrderTypeButton(
                                context,
                                type: OrderType.takeaway,
                                icon: Icons.shopping_bag_outlined,
                                label: localizations?.order_type_takeaway ?? 'À Emporter',
                                isSelected: _viewModel.selectedOrderType == OrderType.takeaway,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Bouton Continuer
                      _buildContinueButton(localizations, size),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations? localizations) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: AppColor.primaryColor, size: 28),
          ),
          Expanded(
            child: Text(
              localizations?.order_type_title ?? 'Type de commande',
              style: GoogleFonts.kaiseiOpti(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Pour équilibrer avec le bouton retour
        ],
      ),
    );
  }

  Widget _buildQuestionText(AppLocalizations? localizations) {
    return Text(
      localizations?.order_type_question ?? 'Comment souhaitez-vous commander ?',
      style: GoogleFonts.kaiseiOpti(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColor.cardColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLargeOrderTypeButton(
    BuildContext context, {
    required OrderType type,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        _viewModel.selectOrderType(type);
        _animationController.forward(from: 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : AppColor.cardColor,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône circulaire
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white.withOpacity(0.2) : AppColor.secondaryColor,
                border: Border.all(
                  color: isSelected ? Colors.white : AppColor.primaryColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 45,
                color: isSelected ? Colors.white : AppColor.primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            // Label
            Text(
              label,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            if (isSelected) ...[
              const SizedBox(height: 8),
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 28,
              ),
            ],
          ],
        ),
      ),
    );
  }



  Widget _buildContinueButton(AppLocalizations? localizations, Size size) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: _viewModel.isValid ? AppColor.primaryColor : AppColor.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _viewModel.isValid
            ? [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _viewModel.isValid
              ? () => _viewModel.validateAndNavigate(context)
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations?.order_type_continue ?? 'Continuer',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
