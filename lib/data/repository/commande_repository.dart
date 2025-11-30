import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/commande_model.dart';
import '../model/commande_article_model.dart';

class CommandeRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  final String table = 'commandes';
  final String articlesTable = 'commandes_articles';

  // Créer une nouvelle commande
  Future<Commande> createCommande(Commande commande) async {
    final response = await supabase
        .from(table)
        .insert(commande.toMap())
        .select()
        .single();

    return Commande.fromMap(response);
  }

  // Ajouter des articles à une commande
  Future<void> addArticles(List<CommandeArticle> articles) async {
    final articlesMap = articles.map((a) => a.toMap()).toList();
    await supabase.from(articlesTable).insert(articlesMap);
  }

  // Récupérer une commande par ID
  Future<Commande?> getCommande(int id) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Commande.fromMap(response);
  }

  // Récupérer une commande par numéro
  Future<Commande?> getCommandeByNumero(String numero) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('numero_commande', numero)
        .maybeSingle();

    if (response == null) return null;
    return Commande.fromMap(response);
  }

  // Récupérer les articles d'une commande
  Future<List<CommandeArticle>> getCommandeArticles(int commandeId) async {
    final response = await supabase
        .from(articlesTable)
        .select()
        .eq('commande_id', commandeId);

    return (response as List).map((e) => CommandeArticle.fromMap(e)).toList();
  }

  // Mettre à jour le statut d'une commande
  Future<void> updateStatut(int commandeId, String statut) async {
    await supabase
        .from(table)
        .update({
          'statut': statut,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', commandeId);
  }

  // Récupérer les commandes récentes
  Future<List<Commande>> getRecentCommandes({int limit = 10}) async {
    final response = await supabase
        .from(table)
        .select()
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List).map((e) => Commande.fromMap(e)).toList();
  }

  // Générer un numéro de commande unique
  Future<String> generateNumeroCommande() async {
    final now = DateTime.now();
    final prefix = 'CMD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    
    // Récupérer le dernier numéro du jour
    final response = await supabase
        .from(table)
        .select('numero_commande')
        .like('numero_commande', '$prefix%')
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isEmpty) {
      return '${prefix}001';
    }

    final lastNumero = response[0]['numero_commande'] as String;
    final lastNumber = int.parse(lastNumero.substring(prefix.length));
    final newNumber = (lastNumber + 1).toString().padLeft(3, '0');
    
    return '$prefix$newNumber';
  }
}
