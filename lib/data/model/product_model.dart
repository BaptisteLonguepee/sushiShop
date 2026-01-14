class Product {
  final int id;
  final int categoryId;
  final String nom;
  final String name; // Alias pour compatibilité
  final String? description;
  final double prix;
  final double price; // Alias pour compatibilité
  final String? imageUrl;
  final String? allergens;
  final bool vegetarien;
  final bool vegan;
  final bool actif;
  final int? stock;
  final int ordre;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.categoryId,
    required this.nom,
    this.description,
    required this.prix,
    this.imageUrl,
    this.allergens,
    this.vegetarien = false,
    this.vegan = false,
    this.actif = true,
    this.stock,
    this.ordre = 0,
    this.createdAt,
    this.updatedAt,
  }) : name = nom,
       price = prix;

  // Convert Supabase JSON → Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      categoryId: map['category_id'] ?? map['categorie_id'] ?? 0,
      nom:
          map['nom']?.toString() ??
          map['name']?.toString() ??
          'Produit sans nom',
      description: map['description']?.toString(),
      prix: ((map['prix'] ?? map['price']) as num?)?.toDouble() ?? 0.0,
      imageUrl: map['image_url']?.toString(),
      allergens: map['allergens']?.toString(),
      vegetarien: map['vegetarien'] ?? map['vegetarian'] ?? false,
      vegan: map['vegan'] ?? false,
      actif: map['actif'] ?? map['active'] ?? true,
      stock: map['stock'] as int?,
      ordre: map['ordre'] ?? map['order'] ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'].toString())
          : null,
    );
  }

  // Convert Product → Supabase JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'nom': nom,
      'description': description,
      'prix': prix,
      'image_url': imageUrl,
      'allergens': allergens,
      'vegetarien': vegetarien,
      'vegan': vegan,
      'actif': actif,
      'stock': stock,
      'ordre': ordre,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Copie avec modifications
  Product copyWith({
    int? id,
    int? categoryId,
    String? nom,
    String? description,
    double? prix,
    String? imageUrl,
    String? allergens,
    bool? vegetarien,
    bool? vegan,
    bool? actif,
    int? stock,
    int? ordre,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      nom: nom ?? this.nom,
      description: description ?? this.description,
      prix: prix ?? this.prix,
      imageUrl: imageUrl ?? this.imageUrl,
      allergens: allergens ?? this.allergens,
      vegetarien: vegetarien ?? this.vegetarien,
      vegan: vegan ?? this.vegan,
      actif: actif ?? this.actif,
      stock: stock ?? this.stock,
      ordre: ordre ?? this.ordre,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Méthodes utilitaires
  bool get isVegetarian => vegetarien;
  bool get isVegan => vegan;
  bool get isActive => actif;
  bool get isInStock => stock == null || stock! > 0;
  bool get hasAllergens => allergens != null && allergens!.isNotEmpty;

  List<String> get allergensList {
    if (allergens == null || allergens!.isEmpty) return [];
    return allergens!.split(',').map((e) => e.trim()).toList();
  }
}
