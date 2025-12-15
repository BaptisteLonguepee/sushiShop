class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  // Convert Supabase JSON → Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      name: map['name']?.toString() ?? map['nom']?.toString() ?? 'Produit sans nom',
      price: ((map['price'] ?? map['prix']) as num?)?.toDouble() ?? 0.0,
    );
  }
}
