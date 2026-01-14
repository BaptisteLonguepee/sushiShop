import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/category_model.dart';

class CategoryRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final String table = 'categories';

  // Récupérer toutes les catégories actives
  Future<List<Category>> getActiveCategories() async {
    final response = await supabase
        .from(table)
        .select()
        .eq('actif', true)
        .order('ordre', ascending: true);

    return (response as List).map((e) => Category.fromMap(e)).toList();
  }

  // Récupérer toutes les catégories
  Future<List<Category>> getAllCategories() async {
    final response = await supabase
        .from(table)
        .select()
        .order('ordre', ascending: true);

    return (response as List).map((e) => Category.fromMap(e)).toList();
  }

  // Récupérer une catégorie par ID
  Future<Category?> getCategory(int id) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Category.fromMap(response);
  }
}
