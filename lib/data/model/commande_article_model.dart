class CommandeArticle {
  final int id;
  final int commandeId;
  final int produitId;
  final int quantite;
  final double prixUnitaire;
  final String? notesArticle;
  final DateTime createdAt;

  CommandeArticle({
    required this.id,
    required this.commandeId,
    required this.produitId,
    required this.quantite,
    required this.prixUnitaire,
    this.notesArticle,
    required this.createdAt,
  });

  factory CommandeArticle.fromMap(Map<String, dynamic> map) {
    return CommandeArticle(
      id: map['id'] as int,
      commandeId: map['commande_id'] as int,
      produitId: map['produit_id'] as int,
      quantite: map['quantite'] as int? ?? 1,
      prixUnitaire: (map['prix_unitaire'] as num).toDouble(),
      notesArticle: map['notes_article'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commande_id': commandeId,
      'produit_id': produitId,
      'quantite': quantite,
      'prix_unitaire': prixUnitaire,
      'notes_article': notesArticle,
    };
  }

  double get total => prixUnitaire * quantite;
}
