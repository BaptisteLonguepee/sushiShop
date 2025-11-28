import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/product_viewmodel.dart';

class ProductScreen extends StatefulWidget {
  final int productId;

  const ProductScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProductViewModel(productId: widget.productId);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadProduct();
  }

  void _onViewModelChanged() => setState(() {});

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          _viewModel.product?.name ?? "Chargement...",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _buildBody(localizations),
    );
  }

  Widget _buildBody(AppLocalizations? localizations) {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      );
    }

    if (_viewModel.errorMessage != null) {
      return _buildErrorView(localizations);
    }

    if (_viewModel.product == null) {
      return const Center(child: Text("Produit introuvable"));
    }

    return _buildProductView(localizations);
  }

  Widget _buildErrorView(AppLocalizations? localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 24),
          Text(
            _viewModel.errorMessage ?? 'Une erreur est survenue',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _viewModel.loadProduct(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(localizations!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildProductView(AppLocalizations? localizations) {
    final product = _viewModel.product!;

    return SafeArea(
      child: Column(
        children: [
          // IMAGE PRODUIT
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildProductImage(product.imageUrl),
          ),

          // CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Nom + prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${product.price.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Sélecteur quantité
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          localizations!.product_quantity,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildQuantityButton(
                              icon: Icons.remove,
                              onTap: _viewModel.decrementQuantity,
                              enabled: _viewModel.quantity > 1,
                            ),
                            const SizedBox(width: 32),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  '${_viewModel.quantity}',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            _buildQuantityButton(
                              icon: Icons.add,
                              onTap: _viewModel.incrementQuantity,
                              enabled: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bouton ajouter au panier
          Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            child: ElevatedButton(
              onPressed: () => _viewModel.addToCart(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 12),
                  Text(
                    '${localizations.add_to_cart} • ${_viewModel.totalPrice.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Affiche l’image correctement selon son type : URL ou asset
  Widget _buildProductImage(String path) {
    debugPrint("Image chargée : $path");

    // Si c'est un asset : commence par "assets/"
    if (path.startsWith("assets/")) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
      );
    }

    // Sinon : image réseau
    return Image.network(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColor.secondaryColor,
      child: const Icon(Icons.fastfood, size: 120, color: AppColor.cardColor),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: enabled ? AppColor.primaryColor : AppColor.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 32, color: Colors.white),
      ),
    );
  }
}