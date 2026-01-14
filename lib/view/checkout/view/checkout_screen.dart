import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../core/providers/order_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/viewmodel/cart_viewmodel.dart';
import '../viewmodel/checkout_viewmodel.dart';
import '../../qr_scan/view/qr_scan_screen.dart';
import '../../payment/view/payment_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartViewModel, CheckoutViewModel>(
      create: (context) => CheckoutViewModel(context.read<CartViewModel>()),
      update: (context, cart, previous) => previous ?? CheckoutViewModel(cart),
      child: const _CheckoutScreenContent(),
    );
  }
}

class _CheckoutScreenContent extends StatelessWidget {
  const _CheckoutScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CheckoutViewModel>();
    final cart = context.watch<CartViewModel>();
    final orderProvider = context.watch<OrderProvider>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          localizations.checkout_title,
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
            _buildSectionTitle(localizations.checkout_order_summary),
            const SizedBox(height: 16),
            _buildOrderSummary(cart, localizations, orderProvider),
            const SizedBox(height: 32),
            _buildSubmitButton(
              context,
              cart,
              localizations,
              viewModel,
              orderProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.kaiseiOpti(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColor.primaryColor,
      ),
    );
  }

  Widget _buildOrderSummary(
    CartViewModel cart,
    AppLocalizations localizations,
    OrderProvider orderProvider,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher le type de commande et le numéro de table si dine-in
            if (orderProvider.isDineIn && orderProvider.hasTableNumber) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      color: Colors.green[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Table ${orderProvider.tableNumber}',
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else if (orderProvider.isTakeaway) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizations.order_type_takeaway,
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              localizations.checkout_order_summary,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...cart.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.product.nom}',
                        style: GoogleFonts.kaiseiOpti(fontSize: 14),
                      ),
                    ),
                    Text(
                      '${item.total.toStringAsFixed(2)} €',
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.cart_total,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${cart.totalPrice.toStringAsFixed(2)} €',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
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

  Widget _buildSubmitButton(
    BuildContext context,
    CartViewModel cart,
    AppLocalizations localizations,
    CheckoutViewModel viewModel,
    OrderProvider orderProvider,
  ) {
    // Si le numéro de table est déjà connu (dine-in) ou si c'est à emporter,
    // on va directement au paiement sans passer par le scan QR
    final skipQrScan = orderProvider.hasTableNumber || orderProvider.isTakeaway;
    final buttonText = skipQrScan
        ? localizations.checkout_proceed_payment
        : localizations.checkout_scan_qr;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: viewModel.isProcessing
            ? null
            : () => _proceedToNextStep(context, viewModel, cart, orderProvider),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: viewModel.isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                buttonText,
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _proceedToNextStep(
    BuildContext context,
    CheckoutViewModel viewModel,
    CartViewModel cart,
    OrderProvider orderProvider,
  ) {
    if (!viewModel.validateOrder()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ?? 'Erreur de validation',
            style: GoogleFonts.kaiseiOpti(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    viewModel.prepareCheckout();

    // Si on a déjà le numéro de table ou si c'est à emporter, aller directement au paiement
    if (orderProvider.hasTableNumber || orderProvider.isTakeaway) {
      final tableNumber = orderProvider.tableNumber ?? 'À emporter';
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            totalAmount: cart.totalPrice,
            tableNumber: tableNumber,
          ),
        ),
      );
    } else {
      // Sinon, passer par le scan QR (cas rare où aucun numéro n'a été saisi)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrScanScreen(totalAmount: cart.totalPrice),
        ),
      );
    }
  }
}
