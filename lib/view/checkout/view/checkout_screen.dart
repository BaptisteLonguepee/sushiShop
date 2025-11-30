import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../data/model/commande_model.dart';
import '../../../data/model/commande_article_model.dart';
import '../../../data/repository/commande_repository.dart';
import '../../confirmation/view/confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _commandeRepository = CommandeRepository();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Vérifier la commande',
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
            _buildSectionTitle('Résumé de la commande'),
            const SizedBox(height: 16),
            _buildOrderSummary(cart),
            const SizedBox(height: 32),
            _buildSubmitButton(cart),
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

  Widget _buildOrderSummary(CartProvider cart) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé de la commande',
              style: GoogleFonts.kaiseiOpti(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...cart.items.map((item) => Padding(
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
            )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${cart.total.toStringAsFixed(2)} €',
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

  Widget _buildSubmitButton(CartProvider cart) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : () => _submitOrder(cart),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Valider la commande',
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _submitOrder(CartProvider cart) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Générer un numéro de commande
      final numeroCommande = await _commandeRepository.generateNumeroCommande();

      // Créer la commande sans informations client (borne de commande rapide)
      final commande = Commande(
        id: 0, // sera assigné par la base de données
        numeroCommande: numeroCommande,
        statut: 'en_attente',
        total: cart.total,
        nomClient: 'Client Borne $numeroCommande',
        telephone: null,
        email: null,
        notesSpecial: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdCommande = await _commandeRepository.createCommande(commande);

      // Ajouter les articles
      final articles = cart.items.map((item) {
        return CommandeArticle(
          id: 0,
          commandeId: createdCommande.id,
          produitId: item.product.id,
          quantite: item.quantity,
          prixUnitaire: item.product.prix,
          notesArticle: item.notes,
          createdAt: DateTime.now(),
        );
      }).toList();

      await _commandeRepository.addArticles(articles);

      // Vider le panier
      cart.clear();

      // Naviguer vers l'écran de confirmation
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationScreen(commande: createdCommande),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors de la création de la commande: $e',
              style: GoogleFonts.kaiseiOpti(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
