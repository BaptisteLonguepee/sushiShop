import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  String? notes;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.notes,
  });

  double get total => product.prix * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}
