import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constant/color.dart';
import '../../../data/model/commande_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../welcome/view/welcome_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Commande commande;

  const ConfirmationScreen({
    super.key,
    required this.commande,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Titre
                Text(
                  localizations.confirmation_title,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  localizations.confirmation_thank_you(commande.nomClient),
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          localizations.confirmation_order_number,
                          commande.numeroCommande,
                          bold: true,
                        ),
                        const Divider(height: 24),
                        _buildDetailRow(
                          localizations.confirmation_total_amount,
                          '${commande.total.toStringAsFixed(2)} €',
                          valueColor: AppColor.primaryColor,
                        ),
                        const Divider(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.orange[700],
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  localizations.confirmation_estimated_time,
                                  style: GoogleFonts.kaiseiOpti(
                                    fontSize: 14,
                                    color: Colors.orange[900],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          localizations.confirmation_notification_info,
                          style: GoogleFonts.kaiseiOpti(
                            fontSize: 14,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      localizations.confirmation_back_home,
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool bold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
