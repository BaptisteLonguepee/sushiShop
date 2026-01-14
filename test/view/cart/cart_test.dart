import 'package:flutter_test/flutter_test.dart';
import 'package:sushishop/data/model/product_model.dart';
import 'package:sushishop/data/model/cart_item_model.dart';
import 'package:sushishop/view/cart/viewmodel/cart_viewmodel.dart';

void main() {
  group('CartItem Model Tests', () {
    test('CartItem should calculate total correctly', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'Salmon Nigiri',
        prix: 5.50,
      );

      // Act
      final cartItem = CartItem(product: product, quantity: 3);

      // Assert
      expect(cartItem.total, 16.50);
    });

    test('CartItem should handle single quantity', () {
      // Arrange
      final product = Product(
        id: 2,
        categoryId: 1,
        nom: 'Tuna Maki',
        prix: 8.00,
      );

      // Act
      final cartItem = CartItem(product: product, quantity: 1);

      // Assert
      expect(cartItem.total, 8.00);
    });

    test('CartItem should store notes correctly', () {
      // Arrange
      final product = Product(
        id: 3,
        categoryId: 2,
        nom: 'Dragon Roll',
        prix: 12.00,
      );

      // Act
      final cartItem = CartItem(
        product: product,
        quantity: 2,
        notes: 'Sans wasabi',
      );

      // Assert
      expect(cartItem.notes, 'Sans wasabi');
      expect(cartItem.total, 24.00);
    });
  });

  group('CartViewModel Tests', () {
    late CartViewModel viewModel;

    setUp(() {
      viewModel = CartViewModel();
    });

    test('CartViewModel should start empty', () {
      // Assert
      expect(viewModel.isEmpty, true);
      expect(viewModel.itemCount, 0);
      expect(viewModel.totalPrice, 0.0);
    });

    test('addProduct should add item to cart', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'California Roll',
        prix: 9.50,
      );

      // Act
      viewModel.addProduct(product);

      // Assert
      expect(viewModel.isEmpty, false);
      expect(viewModel.itemCount, 1);
      expect(viewModel.items.length, 1);
      expect(viewModel.items.first.product.nom, 'California Roll');
    });

    test('addProduct with quantity should add correct amount', () {
      // Arrange
      final product = Product(id: 1, categoryId: 1, nom: 'Edamame', prix: 4.00);

      // Act
      viewModel.addProduct(product, quantity: 3);

      // Assert
      expect(viewModel.itemCount, 3);
      expect(viewModel.totalPrice, 12.00);
    });

    test('addProduct same product should increase quantity', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'Miso Soup',
        prix: 3.50,
      );

      // Act
      viewModel.addProduct(product);
      viewModel.addProduct(product, quantity: 2);

      // Assert
      expect(viewModel.items.length, 1);
      expect(viewModel.itemCount, 3);
      expect(viewModel.totalPrice, 10.50);
    });

    test('removeProduct should remove item from cart', () {
      // Arrange
      final product1 = Product(id: 1, categoryId: 1, nom: 'Gyoza', prix: 6.00);
      final product2 = Product(
        id: 2,
        categoryId: 1,
        nom: 'Tempura',
        prix: 8.00,
      );
      viewModel.addProduct(product1);
      viewModel.addProduct(product2);

      // Act
      viewModel.removeProduct(1);

      // Assert
      expect(viewModel.items.length, 1);
      expect(viewModel.items.first.product.nom, 'Tempura');
    });

    test('incrementQuantity should increase item quantity', () {
      // Arrange
      final product = Product(id: 1, categoryId: 1, nom: 'Sake', prix: 7.50);
      viewModel.addProduct(product);

      // Act
      viewModel.incrementQuantity(1);
      viewModel.incrementQuantity(1);

      // Assert
      expect(viewModel.itemCount, 3);
      expect(viewModel.totalPrice, 22.50);
    });

    test('decrementQuantity should decrease item quantity', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'Green Tea',
        prix: 2.50,
      );
      viewModel.addProduct(product, quantity: 3);

      // Act
      viewModel.decrementQuantity(1);

      // Assert
      expect(viewModel.itemCount, 2);
      expect(viewModel.totalPrice, 5.00);
    });

    test('decrementQuantity to 0 should remove item', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'Matcha Ice Cream',
        prix: 4.50,
      );
      viewModel.addProduct(product);

      // Act
      viewModel.decrementQuantity(1);

      // Assert
      expect(viewModel.isEmpty, true);
      expect(viewModel.items.length, 0);
    });

    test('clear should empty the cart', () {
      // Arrange
      final product1 = Product(
        id: 1,
        categoryId: 1,
        nom: 'Salmon Sashimi',
        prix: 12.00,
      );
      final product2 = Product(
        id: 2,
        categoryId: 1,
        nom: 'Tuna Sashimi',
        prix: 14.00,
      );
      viewModel.addProduct(product1, quantity: 2);
      viewModel.addProduct(product2);

      // Act
      viewModel.clear();

      // Assert
      expect(viewModel.isEmpty, true);
      expect(viewModel.itemCount, 0);
      expect(viewModel.totalPrice, 0.0);
    });

    test('totalPrice should calculate correct sum', () {
      // Arrange
      final product1 = Product(id: 1, categoryId: 1, nom: 'Ramen', prix: 11.50);
      final product2 = Product(
        id: 2,
        categoryId: 1,
        nom: 'Takoyaki',
        prix: 7.00,
      );
      final product3 = Product(
        id: 3,
        categoryId: 1,
        nom: 'Onigiri',
        prix: 3.50,
      );

      // Act
      viewModel.addProduct(product1, quantity: 2); // 23.00
      viewModel.addProduct(product2, quantity: 1); // 7.00
      viewModel.addProduct(product3, quantity: 4); // 14.00

      // Assert
      expect(viewModel.totalPrice, 44.00);
      expect(viewModel.itemCount, 7);
    });

    test('getProductQuantity should return correct quantity', () {
      // Arrange
      final product = Product(
        id: 42,
        categoryId: 1,
        nom: 'Special Roll',
        prix: 15.00,
      );
      viewModel.addProduct(product, quantity: 5);

      // Act
      final quantity = viewModel.getProductQuantity(42);

      // Assert
      expect(quantity, 5);
    });

    test('getProductQuantity for non-existent product should return 0', () {
      // Act
      final quantity = viewModel.getProductQuantity(999);

      // Assert
      expect(quantity, 0);
    });

    test('CartViewModel should notify listeners on changes', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 1,
        nom: 'Test Product',
        prix: 10.00,
      );
      int notifyCount = 0;
      viewModel.addListener(() => notifyCount++);

      // Act
      viewModel.addProduct(product);
      viewModel.incrementQuantity(1);
      viewModel.decrementQuantity(1);
      viewModel.removeProduct(1);

      // Assert
      expect(notifyCount, 4);
    });
  });

  group('Product Model Tests', () {
    test('Product.fromMap should parse correctly', () {
      // Arrange
      final json = {
        'id': 1,
        'category_id': 2,
        'nom': 'Dragon Roll',
        'description': 'Delicious dragon roll',
        'prix': 14.50,
        'image_url': 'https://example.com/dragon.jpg',
        'vegetarien': true,
        'vegan': false,
      };

      // Act
      final product = Product.fromMap(json);

      // Assert
      expect(product.id, 1);
      expect(product.categoryId, 2);
      expect(product.nom, 'Dragon Roll');
      expect(product.name, 'Dragon Roll'); // Alias
      expect(product.prix, 14.50);
      expect(product.price, 14.50); // Alias
      expect(product.vegetarien, true);
      expect(product.vegan, false);
    });

    test('Product.toMap should serialize correctly', () {
      // Arrange
      final product = Product(
        id: 1,
        categoryId: 2,
        nom: 'Rainbow Roll',
        description: 'Colorful sushi roll',
        prix: 16.00,
        vegetarien: false,
        vegan: false,
      );

      // Act
      final map = product.toMap();

      // Assert
      expect(map['id'], 1);
      expect(map['category_id'], 2);
      expect(map['nom'], 'Rainbow Roll');
      expect(map['prix'], 16.00);
    });
  });
}
