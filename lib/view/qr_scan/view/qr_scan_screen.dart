import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/qr_scan_viewmodel.dart';
import '../../payment/view/payment_screen.dart';

class QrScanScreen extends StatelessWidget {
  final double totalAmount;

  const QrScanScreen({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrScanViewModel(),
      child: _QrScanScreenContent(totalAmount: totalAmount),
    );
  }
}

class _QrScanScreenContent extends StatelessWidget {
  final double totalAmount;

  const _QrScanScreenContent({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QrScanViewModel>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          localizations.qr_scan_title,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Scan icon
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 40),

            // Instructions
            Text(
              localizations.qr_scan_instruction,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.qr_scan_required,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Affichage du numéro scanné
            if (viewModel.hasScannedTable) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations.qr_scan_table(
                        viewModel.scannedTableNumber!,
                      ),
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 40),

            // Bouton de scan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: viewModel.isScanning
                    ? null
                    : () => _simulateScan(context, viewModel),
                icon: viewModel.isScanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.qr_code_scanner),
                label: Text(
                  viewModel.isScanning
                      ? localizations.qr_scan_scanning
                      : localizations.qr_scan_button,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
              ),
            ),

            if (viewModel.hasScannedTable) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _proceedToPayment(context, viewModel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    localizations.qr_scan_continue_payment,
                    style: GoogleFonts.kaiseiOpti(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Option de saisie manuelle
            TextButton(
              onPressed: () =>
                  _showManualInputDialog(context, localizations, viewModel),
              child: Text(
                localizations.qr_scan_manual_input,
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 16,
                  color: AppColor.primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simulation du scan QR code (composant système)
  Future<void> _simulateScan(
    BuildContext context,
    QrScanViewModel viewModel,
  ) async {
    final success = await viewModel.simulateScan();

    if (success) {
      // Feedback haptique (composant système)
      HapticFeedback.mediumImpact();
    }
  }

  void _showManualInputDialog(
    BuildContext context,
    AppLocalizations localizations,
    QrScanViewModel viewModel,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          localizations.qr_scan_manual_dialog_title,
          style: GoogleFonts.kaiseiOpti(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: localizations.qr_scan_manual_dialog_hint,
            hintStyle: GoogleFonts.kaiseiOpti(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          style: GoogleFonts.kaiseiOpti(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localizations.cancel, style: GoogleFonts.kaiseiOpti()),
          ),
          TextButton(
            onPressed: () {
              if (viewModel.validateTableNumber(controller.text)) {
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              localizations.validate,
              style: GoogleFonts.kaiseiOpti(color: AppColor.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(BuildContext context, QrScanViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalAmount: totalAmount,
          tableNumber: viewModel.scannedTableNumber!,
        ),
      ),
    );
  }
}
