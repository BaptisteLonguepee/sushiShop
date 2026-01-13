import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/color.dart';
import '../../../core/widgets/japanese_pattern.dart';
import '../../../core/widgets/qr_scanner_widget.dart';
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
  final TextEditingController _tableNumberController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _viewModel = OrderTypeViewModel();
    _viewModel.addListener(_onViewModelChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _tableNumberController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.cream, Colors.white],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: JapanesePattern(opacity: 0.02)),

            SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppColor.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              localizations?.order_type_title ??
                                  'Type de commande',
                              style: GoogleFonts.notoSerif(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 48), // Balance
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'ご注文方法を選択',
                            style: GoogleFonts.notoSansJp(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          Text(
                            localizations?.order_type_question ??
                                'How would you like to order?',
                            style: GoogleFonts.notoSans(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          _buildLargeOrderTypeButton(
                            context,
                            type: OrderType.dineIn,
                            icon: Icons.restaurant,
                            iconBg: const Color(0xFFFFE5E5),
                            label:
                                localizations?.order_type_dine_in ?? 'Dine In',
                            sublabel: 'Eat here',
                            isSelected:
                                _viewModel.selectedOrderType ==
                                OrderType.dineIn,
                          ),

                          const SizedBox(height: 24),

                          _buildLargeOrderTypeButton(
                            context,
                            type: OrderType.takeaway,
                            icon: Icons.shopping_bag_outlined,
                            iconBg: const Color(0xFFFFF4E0),
                            label:
                                localizations?.order_type_takeaway ??
                                'Takeaway',
                            sublabel: 'Order to go',
                            isSelected:
                                _viewModel.selectedOrderType ==
                                OrderType.takeaway,
                          ),

                          const SizedBox(height: 40),

                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child:
                                _viewModel.selectedOrderType == OrderType.dineIn
                                ? _buildTableNumberInput(localizations)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: _buildContinueButton(localizations),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeOrderTypeButton(
    BuildContext context, {
    required OrderType type,
    required IconData icon,
    required Color iconBg,
    required String label,
    required String sublabel,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _viewModel.selectOrderType(type),
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? AppColor.gold : AppColor.secondaryColor,
              width: isSelected ? 3 : 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColor.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                )
              else
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : iconBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: isSelected ? Colors.white : AppColor.primaryColor,
                ),
              ),

              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.notoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sublabel,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.9)
                            : AppColor.cardColor,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColor.primaryColor,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableNumberInput(AppLocalizations? localizations) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColor.gold.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: AppColor.primaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                localizations?.order_type_table_number ?? 'Table number',
                style: GoogleFonts.notoSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Bouton Scanner QR Code
          _buildScanQrButton(localizations),

          const SizedBox(height: 20),

          // Séparateur "OU"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColor.cardColor.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  localizations?.order_type_or ?? 'OU',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.cardColor,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColor.cardColor.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Saisie manuelle
          Text(
            localizations?.order_type_manual_entry ?? 'Saisie manuelle',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.cardColor,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: AppColor.lightGold.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.gold.withValues(alpha: 0.3)),
            ),
            child: TextField(
              controller: _tableNumberController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
              decoration: InputDecoration(
                hintText: '00',
                hintStyle: GoogleFonts.notoSans(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColor.cardColor.withValues(alpha: 0.3),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
              ),
              onChanged: (value) {
                final number = int.tryParse(value);
                _viewModel.setTableNumber(number);
              },
            ),
          ),

          const SizedBox(height: 12),

          Text(
            localizations?.order_type_enter_table_number ??
                'Enter your table number',
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppColor.cardColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQrButton(AppLocalizations? localizations) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openQrScanner(localizations),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            gradient: AppColor.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.order_type_scan_qr ?? 'Scanner le QR code',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations?.order_type_scan_qr_hint ?? 'Rapide et facile',
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openQrScanner(AppLocalizations? localizations) {
    HapticFeedback.lightImpact();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScannerWidget(
          title: localizations?.order_type_scan_qr ?? 'Scanner le QR code',
          instruction: localizations?.order_type_scan_instruction ?? 
              'Placez le QR code de la table dans le cadre',
          onScanned: (tableNumber) {
            // Mettre à jour le numéro de table
            _tableNumberController.text = tableNumber;
            final number = int.tryParse(tableNumber);
            _viewModel.setTableNumber(number);
            
            // Feedback
            HapticFeedback.mediumImpact();
            
            // Afficher un message de succès
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      '${localizations?.order_type_table_scanned ?? "Table"} $tableNumber',
                      style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations? localizations) {
    final isValid = _viewModel.isValid;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 70,
      decoration: BoxDecoration(
        gradient: isValid ? AppColor.primaryGradient : null,
        color: isValid ? null : AppColor.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isValid ? Border.all(color: AppColor.gold, width: 2) : null,
        boxShadow: isValid
            ? [
                BoxShadow(
                  color: AppColor.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isValid ? () => _viewModel.validateAndNavigate(context) : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (localizations?.order_type_continue ?? 'Continuer')
                      .toUpperCase(),
                  style: GoogleFonts.notoSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isValid ? Colors.white : Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward,
                  color: isValid ? Colors.white : Colors.white70,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
