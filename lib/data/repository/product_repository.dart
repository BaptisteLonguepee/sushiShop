import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_model.dart';

class ProductRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  final String table = 'product'; // <-- nom de table Supabase

  // 🔹 Récupérer tous les produits
  Future<List<Product>> getAllProducts() async {
    final response = await supabase
        .from(table)
        .select()
        .order('id', ascending: true);

    return (response as List).map((e) => Product.fromMap(e)).toList();
  }

  // 🔹 Récupérer un produit par ID
  Future<Product?> getProduct(int id) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return Product.fromMap(response);
  }
}
