import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_model.dart';

class ProductRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final String table = 'produits';

  // Récupérer tous les produits actifs
  Future<List<Product>> getActiveProducts() async {
    final response = await supabase
        .from(table)
        .select()
        .eq('actif', true)
        .order('ordre', ascending: true);

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  // Récupérer tous les produits
  Future<List<Product>> getAllProducts() async {
    final response = await supabase
        .from(table)
        .select()
        .order('ordre', ascending: true);

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  // Récupérer les produits par catégorie
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('category_id', categoryId)
        .eq('actif', true)
        .order('ordre', ascending: true);

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  // Récupérer un produit par ID
  Future<Product?> getProduct(int id) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Product.fromMap(response);
  }

  // Rechercher des produits
  Future<List<Product>> searchProducts(String query) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('actif', true)
        .ilike('nom', '%$query%')
        .order('ordre', ascending: true);

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }
}
