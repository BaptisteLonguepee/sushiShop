class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  // Convert Supabase JSON → Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
    );
  }
}
