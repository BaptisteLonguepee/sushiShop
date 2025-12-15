class Product {
  final int id;
  final String nom;
  final String name; // Alias pour compatibilité
  final String? description;
  final double prix;
  final double price; // Alias pour compatibilité
  final int? categoryId;
  final bool actif;
  final String? imageUrl;

  Product({
    required this.id,
    required this.nom,
    this.description,
    required this.prix,
    this.categoryId,
    this.actif = true,
    this.imageUrl,
  })  : name = nom,
        price = prix;

  // Convert Supabase JSON → Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      nom: map['nom']?.toString() ?? map['name']?.toString() ?? 'Produit sans nom',
      description: map['description']?.toString(),
      prix: ((map['prix'] ?? map['price']) as num?)?.toDouble() ?? 0.0,
      categoryId: map['categorie_id'] ?? map['category_id'],
      actif: map['actif'] ?? map['active'] ?? true,
      imageUrl: map['image_url']?.toString(),
    );
  }
}
