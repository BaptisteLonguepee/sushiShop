class Category {
  final int id;
  final String nom;
  final String? description;
  final String? imageUrl;
  final int ordre;
  final bool actif;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.nom,
    this.description,
    this.imageUrl,
    required this.ordre,
    required this.actif,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      nom: map['nom'] as String,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      ordre: map['ordre'] as int? ?? 0,
      actif: map['actif'] as bool? ?? true,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'image_url': imageUrl,
      'ordre': ordre,
      'actif': actif,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
