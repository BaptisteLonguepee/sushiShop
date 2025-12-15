import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../../payment/view/payment_screen.dart';

class QrScanScreen extends StatefulWidget {
  final double totalAmount;

  const QrScanScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  String? _scannedTableNumber;
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
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
            if (_scannedTableNumber != null) ...[
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
                    const Icon(Icons.check_circle, color: Colors.green, size: 30),
                    const SizedBox(width: 12),
                    Text(
                      localizations.qr_scan_table(tableNumber: _scannedTableNumber!),
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
                onPressed: _isScanning ? null : _simulateScan,
                icon: _isScanning
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
                  _isScanning ? localizations.qr_scan_scanning : localizations.qr_scan_button,
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

            if (_scannedTableNumber != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
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
              onPressed: () => _showManualInputDialog(localizations),
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
  Future<void> _simulateScan() async {
    setState(() {
      _isScanning = true;
    });

    // Simuler un délai de scan
    await Future.delayed(const Duration(seconds: 2));

    // Générer un numéro de table aléatoire entre 1 et 20
    final tableNumber = (DateTime.now().millisecondsSinceEpoch % 20) + 1;

    setState(() {
      _scannedTableNumber = tableNumber.toString();
      _isScanning = false;
    });

    // Feedback haptique (composant système)
    // HapticFeedback.mediumImpact(); // Décommenter si nécessaire
  }

  void _showManualInputDialog(AppLocalizations localizations) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          style: GoogleFonts.kaiseiOpti(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.cancel, style: GoogleFonts.kaiseiOpti()),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _scannedTableNumber = controller.text;
                });
                Navigator.pop(context);
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

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalAmount: widget.totalAmount,
          tableNumber: _scannedTableNumber!,
        ),
      ),
    );
  }
}
