import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../data/model/commande_model.dart';
import '../../../data/model/commande_article_model.dart';
import '../../../data/repository/commande_repository.dart';
import '../../confirmation/view/confirmation_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final String tableNumber;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.tableNumber,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _commandeRepository = CommandeRepository();
  
  String _selectedPaymentMethod = 'card';
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Paiement',
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
            _buildSummaryCard(),
            const SizedBox(height: 24),

            // Méthode de paiement
            _buildPaymentMethodSelector(),
            const SizedBox(height: 24),

            // Formulaire de paiement mocké
            if (_selectedPaymentMethod == 'card') ...[
              _buildCardPaymentForm(),
            ] else if (_selectedPaymentMethod == 'cash') ...[
              _buildCashPaymentInfo(),
            ],

            const SizedBox(height: 32),

            // Bouton de paiement
            _buildPaymentButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Table n°${widget.tableNumber}',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    'Validé',
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
                  'Total à payer',
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

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Méthode de paiement',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        _buildPaymentMethodOption(
          value: 'card',
          icon: Icons.credit_card,
          title: 'Paiement sur la borne (Carte)',
        ),
        const SizedBox(height: 12),
        _buildPaymentMethodOption(
          value: 'cash',
          icon: Icons.store,
          title: 'Paiement au comptoir',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodOption({
    required String value,
    required IconData icon,
    required String title,
  }) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = value),
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

  Widget _buildCardPaymentForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            Icons.credit_card,
            size: 80,
            color: Colors.blue[700],
          ),
          const SizedBox(height: 20),
          Text(
            'Terminal de paiement',
            style: GoogleFonts.kaiseiOpti(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Veuillez insérer ou présenter votre carte bancaire au terminal de paiement',
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
                  'Sans contact accepté',
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

  Widget _buildCashPaymentInfo() {
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
              'Veuillez vous présenter au comptoir avec votre numéro de commande pour effectuer le paiement.',
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

  Widget _buildPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: _isProcessing
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
                    _selectedPaymentMethod == 'card' 
                        ? 'Paiement en cours...' 
                        : 'Validation...',
                    style: GoogleFonts.kaiseiOpti(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                _selectedPaymentMethod == 'card'
                    ? 'Process payment ${widget.totalAmount.toStringAsFixed(2)} €'
                    : 'Validate order',
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Get cart reference before async gap
    final cart = context.read<CartProvider>();

    // Simulate communication with payment terminal
    // Wait 3 seconds to simulate processing
    await Future.delayed(const Duration(seconds: 3));

    // Create order
    try {
      final orderNumber = await _commandeRepository.generateNumeroCommande();

      final commande = Commande(
        id: 0,
        numeroCommande: orderNumber,
        statut: 'confirmee',
        total: widget.totalAmount,
        nomClient: 'Table ${widget.tableNumber}',
        telephone: null,
        email: null,
        notesSpecial: 'Table: ${widget.tableNumber}',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdOrder = await _commandeRepository.createCommande(commande);

      final articles = cart.items.map((item) {
        return CommandeArticle(
          id: 0,
          commandeId: createdOrder.id,
          produitId: item.product.id,
          quantite: item.quantity,
          prixUnitaire: item.product.prix,
          notesArticle: item.notes,
          createdAt: DateTime.now(),
        );
      }).toList();

      await _commandeRepository.addArticles(articles);

      cart.clear();

      if (!mounted) return;
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(commande: createdOrder),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error creating order: $e',
            style: GoogleFonts.kaiseiOpti(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
