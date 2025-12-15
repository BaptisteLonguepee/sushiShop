import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../data/model/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  String? _selectedSize;
  final List<String> _selectedExtras = [];
  final TextEditingController _notesController = TextEditingController();

  // Options de taille
  final Map<String, double> _sizes = {
    'Petit': 0.0,
    'Moyen': 2.0,
    'Grand': 4.0,
  };

  // Extras disponibles
  final Map<String, double> _extras = {
    'Sauce soja supplémentaire': 0.50,
    'Gingembre mariné': 0.50,
    'Wasabi extra': 0.50,
    'Sauce piquante': 0.50,
    'Sésame': 0.30,
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    double basePrice = widget.product.prix;
    double sizeExtra = _selectedSize != null ? _sizes[_selectedSize]! : 0.0;
    double extrasTotal = _selectedExtras.fold(
      0.0,
      (sum, extra) => sum + _extras[extra]!,
    );
    return (basePrice + sizeExtra + extrasTotal) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        title: Text(
          widget.product.nom,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image du produit
                  _buildProductImage(),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nom et prix
                        _buildProductHeader(),
                        const SizedBox(height: 16),

                        // Description
                        if (widget.product.description != null) ...[
                          _buildDescription(),
                          const SizedBox(height: 16),
                        ],

                        // Allergènes
                        if (widget.product.allergens != null) ...[
                          _buildAllergens(),
                          const SizedBox(height: 16),
                        ],

                        // Tags (végétarien, vegan)
                        _buildTags(),
                        const SizedBox(height: 24),

                        // Sélection de taille
                        _buildSizeSelector(),
                        const SizedBox(height: 24),

                        // Extras
                        _buildExtrasSelector(),
                        const SizedBox(height: 24),

                        // Notes personnalisées
                        _buildNotesField(),
                        const SizedBox(height: 24),

                        // Quantité
                        _buildQuantitySelector(),
                        const SizedBox(height: 100), // Espace pour le bouton fixe
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildAddToCartButton(context),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: widget.product.imageUrl != null
          ? Image.network(
              widget.product.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.restaurant,
                size: 80,
                color: Colors.grey[400],
              ),
            )
          : Icon(
              Icons.restaurant,
              size: 80,
              color: Colors.grey[400],
            ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.product.nom,
            style: GoogleFonts.kaiseiOpti(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${widget.product.prix.toStringAsFixed(2)} €',
            style: GoogleFonts.kaiseiOpti(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.product.description!,
          style: GoogleFonts.kaiseiOpti(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergens() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Allergènes',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                Text(
                  widget.product.allergens!,
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 14,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags() {
    return Row(
      children: [
        if (widget.product.vegetarien)
          _buildTag('Végétarien', Colors.green),
        if (widget.product.vegan)
          _buildTag('Vegan', Colors.lightGreen),
      ],
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: GoogleFonts.kaiseiOpti(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Taille',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: _sizes.entries.map((entry) {
            final isSelected = _selectedSize == entry.key;
            return ChoiceChip(
              label: Text(
                '${entry.key}${entry.value > 0 ? ' (+${entry.value.toStringAsFixed(2)}€)' : ''}',
                style: GoogleFonts.kaiseiOpti(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedSize = selected ? entry.key : null;
                });
              },
              selectedColor: AppColor.primaryColor,
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExtrasSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extras',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ..._extras.entries.map((entry) {
          final isSelected = _selectedExtras.contains(entry.key);
          return CheckboxListTile(
            title: Text(
              entry.key,
              style: GoogleFonts.kaiseiOpti(fontSize: 16),
            ),
            subtitle: Text(
              '+${entry.value.toStringAsFixed(2)} €',
              style: GoogleFonts.kaiseiOpti(
                fontSize: 14,
                color: AppColor.primaryColor,
              ),
            ),
            value: isSelected,
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  _selectedExtras.add(entry.key);
                } else {
                  _selectedExtras.remove(entry.key);
                }
              });
            },
            activeColor: AppColor.primaryColor,
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes spéciales',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Ex: Sans oignons, bien cuit...',
            hintStyle: GoogleFonts.kaiseiOpti(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.primaryColor, width: 2),
            ),
          ),
          style: GoogleFonts.kaiseiOpti(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantité',
          style: GoogleFonts.kaiseiOpti(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuantityButton(
              icon: Icons.remove,
              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '$_quantity',
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildQuantityButton(
              icon: Icons.add,
              onPressed: () => setState(() => _quantity++),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: onPressed != null ? AppColor.primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  '${_totalPrice.toStringAsFixed(2)} €',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Ajouter au panier',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final cart = context.read<CartProvider>();
    
    // Construire les notes avec les options sélectionnées
    String notes = '';
    if (_selectedSize != null) {
      notes += 'Taille: $_selectedSize\n';
    }
    if (_selectedExtras.isNotEmpty) {
      notes += 'Extras: ${_selectedExtras.join(', ')}\n';
    }
    if (_notesController.text.isNotEmpty) {
      notes += 'Notes: ${_notesController.text}';
    }

    cart.addItem(
      widget.product,
      quantity: _quantity,
      notes: notes.trim().isEmpty ? null : notes.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.product.nom} ajouté au panier',
          style: GoogleFonts.kaiseiOpti(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
