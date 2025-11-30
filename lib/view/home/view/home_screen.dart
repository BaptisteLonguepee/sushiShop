import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sushishop/core/constant/color.dart';
import 'package:sushishop/data/model/product_model.dart';
import 'package:sushishop/core/providers/cart_provider.dart';
import 'package:sushishop/view/cart/view/cart_screen.dart';
import 'package:sushishop/view/product_detail/view/product_detail_screen.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les produits et catégories au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Column(
          children: [
            // Header personnalisé style japonais
            _buildCustomHeader(localizations),

            // Corps avec les produits
            Expanded(
              child: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  // État de chargement
                  if (viewModel.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColor.primaryColor,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Chargement...',
                            style: GoogleFonts.kaiseiOpti(
                              fontSize: 18,
                              color: AppColor.cardColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // État d'erreur
                  if (viewModel.errorMessage != null) {
                    return _buildErrorState(localizations, viewModel);
                  }

                  // Liste vide
                  if (viewModel.products.isEmpty) {
                    return _buildEmptyState(localizations);
                  }

                  // Liste des produits
                  return _buildProductGrid(viewModel, localizations);
                },
              ),
            ),

          // Footer avec panier et total
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Bouton retour
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, color: AppColor.primaryColor, size: 28),
                  ),

                  Expanded(
                    child: Text(
                      localizations.homeTitle,
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Bouton panier
                  Consumer<CartProvider>(
                    builder: (context, cart, _) => Container(
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartScreen()),
                          );
                        },
                        icon: Stack(
                          children: [
                            const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                            if (cart.itemCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    '${cart.itemCount}',
                                    style: GoogleFonts.kaiseiOpti(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Barre de catégories
            _buildCategoryBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.categories.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 55,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: AppColor.secondaryColor,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: viewModel.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Bouton "Tous"
                final isSelected = viewModel.selectedCategory == null;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => viewModel.selectCategory(null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.primaryColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColor.primaryColor : AppColor.cardColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Tous',
                          style: GoogleFonts.kaiseiOpti(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColor.cardColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              final category = viewModel.categories[index - 1];
              final isSelected = viewModel.selectedCategory?.id == category.id;

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => viewModel.selectCategory(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColor.primaryColor : AppColor.cardColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category.nom,
                        style: GoogleFonts.kaiseiOpti(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColor.cardColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(HomeViewModel viewModel, AppLocalizations localizations) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: viewModel.products.length,
      itemBuilder: (context, index) {
        final product = viewModel.products[index];
        return _ProductCard(
          product: product,
          onTap: () => _showProductDetails(context, product),
        );
      },
    );
  }

  Widget _buildErrorState(AppLocalizations localizations, HomeViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColor.error,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              localizations.errorLoadingProducts,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              viewModel.errorMessage!,
              style: GoogleFonts.kaiseiOpti(
                fontSize: 14,
                color: AppColor.cardColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.fetchProducts(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.retry,
                style: GoogleFonts.kaiseiOpti(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            color: AppColor.cardColor,
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            localizations.noProducts,
            style: GoogleFonts.kaiseiOpti(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColor.cardColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Consumer<CartProvider>(
      builder: (context, cart, _) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 14,
                        color: AppColor.cardColor,
                      ),
                    ),
                    Text(
                      '${cart.total.toStringAsFixed(2)} €',
                      style: GoogleFonts.kaiseiOpti(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: cart.isEmpty ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  'Commander',
                  style: GoogleFonts.kaiseiOpti(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    // Naviguer vers la page de détails du produit
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
    
    /* Ancien dialog - remplacé par la page complète
    final localizations = AppLocalizations.of(context)!;
    int quantity = 1;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header avec image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: product.imageUrl != null
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(
                                          Icons.restaurant_menu,
                                          size: 80,
                                          color: AppColor.primaryColor,
                                        ),
                                  )
                                : Icon(
                                    Icons.restaurant_menu,
                                    size: 80,
                                    color: AppColor.primaryColor,
                                  ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: AppColor.primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Détails du produit
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nom du produit
                          Text(
                            product.nom,
                            style: GoogleFonts.kaiseiOpti(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.darkRed,
                            ),
                          ),
                          if (product.description != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              product.description!,
                              style: GoogleFonts.kaiseiOpti(
                                fontSize: 14,
                                color: AppColor.cardColor,
                              ),
                            ),
                          ],
                          if (product.allergens != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.warning_amber, size: 16, color: Colors.orange[700]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Allergènes: ${product.allergens}',
                                    style: GoogleFonts.kaiseiOpti(
                                      fontSize: 12,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (product.vegetarien || product.vegan) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (product.vegan)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Vegan',
                                      style: GoogleFonts.kaiseiOpti(
                                        fontSize: 12,
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (product.vegetarien && !product.vegan) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Végétarien',
                                      style: GoogleFonts.kaiseiOpti(
                                        fontSize: 12,
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                          const SizedBox(height: 24),

                          // Prix
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${product.prix.toStringAsFixed(2)} €',
                                style: GoogleFonts.kaiseiOpti(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sélecteur de quantité
                          Row(
                            children: [
                              Text(
                                'Quantité:',
                                style: GoogleFonts.kaiseiOpti(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColor.secondaryColor,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setState(() => quantity--);
                                        }
                                      },
                                      icon: const Icon(Icons.remove),
                                      color: AppColor.primaryColor,
                                      iconSize: 20,
                                    ),
                                    Container(
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$quantity',
                                        style: GoogleFonts.kaiseiOpti(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() => quantity++);
                                      },
                                      icon: const Icon(Icons.add),
                                      color: AppColor.primaryColor,
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Bouton Ajouter au panier
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                // Ajouter au panier
                                context.read<CartProvider>().addItem(product, quantity: quantity);
                                Navigator.of(context).pop();
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '$quantity x ${product.nom} ajouté au panier',
                                            style: GoogleFonts.kaiseiOpti(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: AppColor.success,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_shopping_cart, size: 20),
                                  const SizedBox(width: 12),
                                  Text(
                                    localizations.addToCart.toUpperCase(),
                                    style: GoogleFonts.kaiseiOpti(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ); */
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.cardColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image du produit
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.primaryColor,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Informations du produit
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.nom,
                        style: GoogleFonts.kaiseiOpti(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.product.prix.toStringAsFixed(2)} €',
                            style: GoogleFonts.kaiseiOpti(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
