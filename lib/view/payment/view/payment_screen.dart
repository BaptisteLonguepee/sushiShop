import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/viewmodel/cart_viewmodel.dart';
import '../viewmodel/payment_viewmodel.dart';
import '../../confirmation/view/confirmation_screen.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final String tableNumber;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.tableNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: _PaymentScreenContent(
        totalAmount: totalAmount,
        tableNumber: tableNumber,
      ),
    );
  }
}

class _PaymentScreenContent extends StatefulWidget {
  final double totalAmount;
  final String tableNumber;

  const _PaymentScreenContent({
    required this.totalAmount,
    required this.tableNumber,
  });

  @override
  State<_PaymentScreenContent> createState() => _PaymentScreenContentState();
}

class _PaymentScreenContentState extends State<_PaymentScreenContent> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PaymentViewModel>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          localizations.payment_title,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Récapitulatif
            _buildSummaryCard(localizations),
            const SizedBox(height: 24),

            // Méthode de paiement
            _buildPaymentMethodSelector(localizations, viewModel),
            const SizedBox(height: 24),

            // Formulaire de paiement mocké
            if (viewModel.selectedPaymentMethod == 'card') ...[
              _buildCardPaymentForm(localizations),
            ] else if (viewModel.selectedPaymentMethod == 'cash') ...[
              _buildCashPaymentInfo(localizations),
            ],

            const SizedBox(height: 32),

            // Bouton de paiement
            _buildPaymentButton(localizations, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(AppLocalizations localizations) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.payment_table_number(widget.tableNumber),
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    localizations.payment_validated,
                    style: GoogleFonts.kaiseiOpti(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.payment_total_to_pay,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.totalAmount.toStringAsFixed(2)} €',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector(
    AppLocalizations localizations,
    PaymentViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.payment_method,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodOption(
          viewModel: viewModel,
          value: 'card',
          icon: Icons.credit_card,
          title: localizations.payment_card,
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          viewModel: viewModel,
          value: 'cash',
          icon: Icons.store,
          title: localizations.payment_counter,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required PaymentViewModel viewModel,
    required String value,
    required IconData icon,
    required String title,
  }) {
    final isSelected = viewModel.selectedPaymentMethod == value;
    return InkWell(
      onTap: () => viewModel.selectPaymentMethod(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColor.primaryColor : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColor.primaryColor : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColor.primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 2),
      ),
      child: Column(
        children: [
          Icon(Icons.credit_card, size: 80, color: Colors.blue[700]),
          const SizedBox(height: 20),
          Text(
            localizations.payment_terminal_title,
            style: GoogleFonts.kaiseiOpti(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            localizations.payment_terminal_instruction,
            style: GoogleFonts.kaiseiOpti(
              fontSize: 16,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.contactless, color: Colors.blue[700], size: 24),
                const SizedBox(width: 12),
                Text(
                  localizations.payment_contactless,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCashPaymentInfo(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              localizations.payment_counter_info,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 14,
                color: Colors.blue[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(
    AppLocalizations localizations,
    PaymentViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: viewModel.isProcessing
            ? null
            : () => _processPayment(localizations, viewModel),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: viewModel.isProcessing
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.selectedPaymentMethod == 'card'
                        ? localizations.payment_processing
                        : localizations.payment_validating,
                    style: GoogleFonts.kaiseiOpti(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                viewModel.selectedPaymentMethod == 'card'
                    ? localizations.payment_process_card(
                        widget.totalAmount.toStringAsFixed(2),
                      )
                    : localizations.payment_validate_order,
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment(
    AppLocalizations localizations,
    PaymentViewModel viewModel,
  ) async {
    HapticFeedback.mediumImpact();

    // Get cart reference
    final cart = context.read<CartViewModel>();

    // Traiter le paiement via le ViewModel
    final success = await viewModel.processPayment(
      totalAmount: widget.totalAmount,
      tableNumber: widget.tableNumber,
      cartItems: cart.items,
    );

    if (success && viewModel.createdOrder != null) {
      // Vider le panier
      cart.clear();

      HapticFeedback.heavyImpact();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ConfirmationScreen(commande: viewModel.createdOrder!),
        ),
        (route) => false,
      );
    } else {
      HapticFeedback.vibrate();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.payment_error(
              viewModel.errorMessage ?? 'Erreur inconnue',
            ),
            style: GoogleFonts.kaiseiOpti(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
