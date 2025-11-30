class Commande {
  final int id;
  final String numeroCommande;
  final String statut;
  final double total;
  final String nomClient;
  final String? telephone;
  final String? email;
  final String? notesSpecial;
  final DateTime? heureRetrait;
  final DateTime createdAt;
  final DateTime updatedAt;

  Commande({
    required this.id,
    required this.numeroCommande,
    required this.statut,
    required this.total,
    required this.nomClient,
    this.telephone,
    this.email,
    this.notesSpecial,
    this.heureRetrait,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Commande.fromMap(Map<String, dynamic> map) {
    return Commande(
      id: map['id'] as int,
      numeroCommande: map['numero_commande'] as String,
      statut: map['statut'] as String? ?? 'en_attente',
      total: (map['total'] as num).toDouble(),
      nomClient: map['nom_client'] as String,
      telephone: map['telephone'] as String?,
      email: map['email'] as String?,
      notesSpecial: map['notes_special'] as String?,
      heureRetrait: map['heure_retrait'] != null
          ? DateTime.parse(map['heure_retrait'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero_commande': numeroCommande,
      'statut': statut,
      'total': total,
      'nom_client': nomClient,
      'telephone': telephone,
      'email': email,
      'notes_special': notesSpecial,
      'heure_retrait': heureRetrait?.toIso8601String(),
    };
  }

  Commande copyWith({
    int? id,
    String? numeroCommande,
    String? statut,
    double? total,
    String? nomClient,
    String? telephone,
    String? email,
    String? notesSpecial,
    DateTime? heureRetrait,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Commande(
      id: id ?? this.id,
      numeroCommande: numeroCommande ?? this.numeroCommande,
      statut: statut ?? this.statut,
      total: total ?? this.total,
      nomClient: nomClient ?? this.nomClient,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      notesSpecial: notesSpecial ?? this.notesSpecial,
      heureRetrait: heureRetrait ?? this.heureRetrait,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
