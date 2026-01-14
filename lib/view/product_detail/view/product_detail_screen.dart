import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constant/color.dart';
import '../../../data/model/product_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../cart/viewmodel/cart_viewmodel.dart';
import '../viewmodel/product_detail_viewmodel.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _notesController = TextEditingController();
  late ProductDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProductDetailViewModel(widget.product);
    _notesController.addListener(() {
      _viewModel.setNotes(_notesController.text);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  // Get sizes map based on localization
  Map<String, double> _getSizes(AppLocalizations localizations) {
    return {
      localizations.product_size_small: 0.0,
      localizations.product_size_medium: 2.0,
      localizations.product_size_large: 4.0,
    };
  }

  // Get extras map based on localization
  Map<String, double> _getExtras(AppLocalizations localizations) {
    return {
      localizations.product_extra_soy_sauce: 0.50,
      localizations.product_extra_ginger: 0.50,
      localizations.product_extra_wasabi: 0.50,
      localizations.product_extra_spicy_sauce: 0.50,
      localizations.product_extra_sesame: 0.30,
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ChangeNotifierProvider<ProductDetailViewModel>.value(
      value: _viewModel,
      child: Scaffold(
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
                            _buildDescription(localizations),
                            const SizedBox(height: 16),
                          ],

                          // Allergènes
                          if (widget.product.allergens != null) ...[
                            _buildAllergens(localizations),
                            const SizedBox(height: 16),
                          ],

                          // Tags (végétarien, vegan)
                          _buildTags(localizations),
                          const SizedBox(height: 24),

                          // Sélection de taille
                          _buildSizeSelector(localizations),
                          const SizedBox(height: 24),

                          // Extras
                          _buildExtrasSelector(localizations),
                          const SizedBox(height: 24),

                          // Notes personnalisées
                          _buildNotesField(localizations),
                          const SizedBox(height: 24),

                          // Quantité
                          _buildQuantitySelector(localizations),
                          const SizedBox(
                            height: 100,
                          ), // Espace pour le bouton fixe
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildAddToCartButton(context, localizations),
          ],
        ),
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
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.restaurant, size: 80, color: Colors.grey[400]),
            )
          : Icon(Icons.restaurant, size: 80, color: Colors.grey[400]),
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

  Widget _buildDescription(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.product_description,
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

  Widget _buildAllergens(AppLocalizations localizations) {
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
                  localizations.product_allergens,
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

  Widget _buildTags(AppLocalizations localizations) {
    return Row(
      children: [
        if (widget.product.vegetarien)
          _buildTag(localizations.product_vegetarian, Colors.green),
        if (widget.product.vegan)
          _buildTag(localizations.product_vegan, Colors.lightGreen),
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

  Widget _buildSizeSelector(AppLocalizations localizations) {
    final sizes = _getSizes(localizations);

    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.product_size,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: sizes.entries.map((entry) {
                final isSelected = viewModel.selectedSize == entry.key;
                return ChoiceChip(
                  label: Text(
                    '${entry.key}${entry.value > 0 ? ' (+${entry.value.toStringAsFixed(2)}€)' : ''}',
                    style: GoogleFonts.kaiseiOpti(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    viewModel.selectSize(selected ? entry.key : null);
                  },
                  selectedColor: AppColor.primaryColor,
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExtrasSelector(AppLocalizations localizations) {
    final extras = _getExtras(localizations);

    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.product_extras,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            ...extras.entries.map((entry) {
              final isSelected = viewModel.selectedExtras.contains(entry.key);
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
                  viewModel.toggleExtra(entry.key);
                },
                activeColor: AppColor.primaryColor,
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildNotesField(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.product_special_notes,
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
            hintText: localizations.product_notes_hint,
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

  Widget _buildQuantitySelector(AppLocalizations localizations) {
    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.product_quantity,
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
                  onPressed: viewModel.quantity > 1
                      ? () => viewModel.decrementQuantity()
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '${viewModel.quantity}',
                    style: GoogleFonts.kaiseiOpti(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: () => viewModel.incrementQuantity(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
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

  Widget _buildAddToCartButton(
    BuildContext context,
    AppLocalizations localizations,
  ) {
    return Consumer<ProductDetailViewModel>(
      builder: (context, viewModel, child) {
        final sizes = _getSizes(localizations);
        final extras = _getExtras(localizations);
        final totalPrice = viewModel.calculateTotalPrice(sizes, extras);

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
                      localizations.cart_total,
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(2)} €',
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
                    onPressed: () =>
                        _addToCart(context, localizations, viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      localizations.addToCart,
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
      },
    );
  }

  void _addToCart(
    BuildContext context,
    AppLocalizations localizations,
    ProductDetailViewModel viewModel,
  ) {
    final cart = context.read<CartViewModel>();

    // Construire les notes avec les options sélectionnées
    String notes = '';
    if (viewModel.selectedSize != null) {
      notes += '${localizations.product_size}: ${viewModel.selectedSize}\n';
    }
    if (viewModel.selectedExtras.isNotEmpty) {
      notes +=
          '${localizations.product_extras}: ${viewModel.selectedExtras.join(', ')}\n';
    }
    if (viewModel.notes.isNotEmpty) {
      notes += '${localizations.product_special_notes}: ${viewModel.notes}';
    }

    cart.addProduct(
      widget.product,
      quantity: viewModel.quantity,
      notes: notes.trim().isEmpty ? null : notes.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.product_added_to_cart(widget.product.nom),
          style: GoogleFonts.kaiseiOpti(),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
