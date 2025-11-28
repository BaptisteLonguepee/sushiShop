import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sushishop/view/order_type/model/order_type_model.dart';
import 'package:sushishop/view/order_type/viewmodel/order_type_viewmodel.dart';

void main() {
  group('OrderTypeModel Tests', () {
    test('OrderTypeModel should initialize with null values', () {
      // Arrange & Act
      final model = OrderTypeModel();

      // Assert
      expect(model.selectedOrderType, isNull);
      expect(model.tableNumber, isNull);
    });

    test('OrderTypeModel should accept initial values', () {
      // Arrange & Act
      final model = OrderTypeModel(
        selectedOrderType: OrderType.dineIn,
        tableNumber: 5,
      );

      // Assert
      expect(model.selectedOrderType, OrderType.dineIn);
      expect(model.tableNumber, 5);
    });

    test('isValid should return false when no order type is selected', () {
      // Arrange
      final model = OrderTypeModel();

      // Act & Assert
      expect(model.isValid, false);
    });

    test('isValid should return true for takeaway without table number', () {
      // Arrange
      final model = OrderTypeModel(selectedOrderType: OrderType.takeaway);

      // Act & Assert
      expect(model.isValid, true);
    });

    test('isValid should return false for dineIn without table number', () {
      // Arrange
      final model = OrderTypeModel(selectedOrderType: OrderType.dineIn);

      // Act & Assert
      expect(model.isValid, false);
    });

    test('isValid should return true for dineIn with table number', () {
      // Arrange
      final model = OrderTypeModel(
        selectedOrderType: OrderType.dineIn,
        tableNumber: 3,
      );

      // Act & Assert
      expect(model.isValid, true);
    });

    test('reset should clear all values', () {
      // Arrange
      final model = OrderTypeModel(
        selectedOrderType: OrderType.dineIn,
        tableNumber: 10,
      );

      // Act
      model.reset();

      // Assert
      expect(model.selectedOrderType, isNull);
      expect(model.tableNumber, isNull);
    });
  });

  group('OrderTypeViewModel Tests', () {
    test('OrderTypeViewModel should initialize with empty model', () {
      // Arrange & Act
      final viewModel = OrderTypeViewModel();

      // Assert
      expect(viewModel.model, isA<OrderTypeModel>());
      expect(viewModel.selectedOrderType, isNull);
      expect(viewModel.tableNumber, isNull);
      expect(viewModel.isValid, false);
    });

    test('selectOrderType should update selected order type for takeaway', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      bool notified = false;
      viewModel.addListener(() => notified = true);

      // Act
      viewModel.selectOrderType(OrderType.takeaway);

      // Assert
      expect(viewModel.selectedOrderType, OrderType.takeaway);
      expect(notified, true);
    });

    test('selectOrderType should update selected order type for dineIn', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      bool notified = false;
      viewModel.addListener(() => notified = true);

      // Act
      viewModel.selectOrderType(OrderType.dineIn);

      // Assert
      expect(viewModel.selectedOrderType, OrderType.dineIn);
      expect(notified, true);
    });

    test(
      'selectOrderType should clear table number when switching to takeaway',
      () {
        // Arrange
        final viewModel = OrderTypeViewModel();
        viewModel.selectOrderType(OrderType.dineIn);
        viewModel.setTableNumber(5);

        // Act
        viewModel.selectOrderType(OrderType.takeaway);

        // Assert
        expect(viewModel.selectedOrderType, OrderType.takeaway);
        expect(viewModel.tableNumber, isNull);
      },
    );

    test('setTableNumber should update table number', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      bool notified = false;
      viewModel.addListener(() => notified = true);

      // Act
      viewModel.setTableNumber(7);

      // Assert
      expect(viewModel.tableNumber, 7);
      expect(notified, true);
    });

    test('setTableNumber should accept null value', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      viewModel.setTableNumber(5);

      // Act
      viewModel.setTableNumber(null);

      // Assert
      expect(viewModel.tableNumber, isNull);
    });

    test('isValid should return false without order type selection', () {
      // Arrange
      final viewModel = OrderTypeViewModel();

      // Act & Assert
      expect(viewModel.isValid, false);
    });

    test('isValid should return true for complete takeaway order', () {
      // Arrange
      final viewModel = OrderTypeViewModel();

      // Act
      viewModel.selectOrderType(OrderType.takeaway);

      // Assert
      expect(viewModel.isValid, true);
    });

    test('isValid should return false for dineIn without table number', () {
      // Arrange
      final viewModel = OrderTypeViewModel();

      // Act
      viewModel.selectOrderType(OrderType.dineIn);

      // Assert
      expect(viewModel.isValid, false);
    });

    test('isValid should return true for complete dineIn order', () {
      // Arrange
      final viewModel = OrderTypeViewModel();

      // Act
      viewModel.selectOrderType(OrderType.dineIn);
      viewModel.setTableNumber(8);

      // Assert
      expect(viewModel.isValid, true);
    });

    testWidgets('validateAndNavigate should show error for invalid selection', (
      WidgetTester tester,
    ) async {
      // Arrange
      final viewModel = OrderTypeViewModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () => viewModel.validateAndNavigate(context),
                  child: const Text('Validate'),
                ),
              );
            },
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Validate'));
      await tester.pump();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Veuillez sélectionner un type de commande'),
        findsOneWidget,
      );
    });

    testWidgets(
      'validateAndNavigate should show error for dineIn without table number',
      (WidgetTester tester) async {
        // Arrange
        final viewModel = OrderTypeViewModel();
        viewModel.selectOrderType(OrderType.dineIn);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => viewModel.validateAndNavigate(context),
                    child: const Text('Validate'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Validate'));
        await tester.pump();

        // Assert
        expect(find.byType(SnackBar), findsOneWidget);
        expect(
          find.text('Veuillez entrer un numéro de chevalet'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'validateAndNavigate should navigate to HomeScreen for valid takeaway order',
      (WidgetTester tester) async {
        // Arrange
        final viewModel = OrderTypeViewModel();
        viewModel.selectOrderType(OrderType.takeaway);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => viewModel.validateAndNavigate(context),
                    child: const Text('Validate'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Validate'));
        await tester.pumpAndSettle();

        // Assert - Should have navigated away from the original screen
        expect(find.text('Validate'), findsNothing);
      },
    );

    testWidgets(
      'validateAndNavigate should navigate to HomeScreen for valid dineIn order',
      (WidgetTester tester) async {
        // Arrange
        final viewModel = OrderTypeViewModel();
        viewModel.selectOrderType(OrderType.dineIn);
        viewModel.setTableNumber(12);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () => viewModel.validateAndNavigate(context),
                    child: const Text('Validate'),
                  ),
                );
              },
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Validate'));
        await tester.pumpAndSettle();

        // Assert - Should have navigated away from the original screen
        expect(find.text('Validate'), findsNothing);
      },
    );

    test('dispose should reset model', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      viewModel.selectOrderType(OrderType.dineIn);
      viewModel.setTableNumber(5);

      // Act
      viewModel.dispose();

      // Assert
      expect(viewModel.selectedOrderType, isNull);
      expect(viewModel.tableNumber, isNull);
    });

    test('multiple listeners should be notified on changes', () {
      // Arrange
      final viewModel = OrderTypeViewModel();
      int listener1Count = 0;
      int listener2Count = 0;

      viewModel.addListener(() => listener1Count++);
      viewModel.addListener(() => listener2Count++);

      // Act
      viewModel.selectOrderType(OrderType.dineIn);
      viewModel.setTableNumber(3);

      // Assert
      expect(listener1Count, 2);
      expect(listener2Count, 2);
    });
  });

  group('OrderType Enum Tests', () {
    test('OrderType enum should have two values', () {
      // Act & Assert
      expect(OrderType.values.length, 2);
      expect(OrderType.values, contains(OrderType.dineIn));
      expect(OrderType.values, contains(OrderType.takeaway));
    });

    test('OrderType enum values should have correct names', () {
      // Act & Assert
      expect(OrderType.dineIn.name, 'dineIn');
      expect(OrderType.takeaway.name, 'takeaway');
    });
  });
}
