import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sushishop/view/welcome/model/welcome_model.dart';
import 'package:sushishop/view/welcome/viewmodel/welcome_viewmodel.dart';
import 'package:sushishop/view/welcome/view/welcome_screen.dart';
import 'package:sushishop/core/constant/color.dart';
import 'package:sushishop/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('WelcomeModel Tests', () {
    test('WelcomeModel should have default backgroundImage path', () {
      // Arrange & Act
      final model = WelcomeModel();

      // Assert
      expect(model.backgroundImage, 'assets/images/sushi_background.png');
    });

    test('WelcomeModel should accept custom backgroundImage', () {
      // Arrange & Act
      final model = WelcomeModel(backgroundImage: 'assets/images/custom.jpg');

      // Assert
      expect(model.backgroundImage, 'assets/images/custom.jpg');
    });
  });

  group('WelcomeViewModel Tests', () {
    test('WelcomeViewModel should provide access to model', () {
      // Arrange
      final viewModel = WelcomeViewModel();

      // Act & Assert
      expect(viewModel.model, isA<WelcomeModel>());
      expect(
        viewModel.model.backgroundImage,
        'assets/images/sushi_background.png',
      );
    });

    testWidgets('navigateToNextScreen should show SnackBar', (
      WidgetTester tester,
    ) async {
      // Arrange
      final viewModel = WelcomeViewModel();
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => viewModel.navigateToNextScreen(context),
                    child: const Text('Test Button'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Test Button'));
      await tester.pump();

      // Assert
      expect(find.text('Navigation à implémenter'), findsOneWidget);
    });
  });

  group('WelcomeScreen Widget Tests', () {
    Widget createTestWidget({Locale locale = const Locale('fr')}) {
      return MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr'), Locale('en')],
        home: const WelcomeScreen(),
      );
    }

    testWidgets('WelcomeScreen should build without errors', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets(
      'WelcomeScreen should display touch_to_start button in French',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(locale: const Locale('fr')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Toucher pour commencer'), findsOneWidget);
      },
    );

    testWidgets(
      'WelcomeScreen should display touch_to_start button in English',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(createTestWidget(locale: const Locale('en')));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Touch to start'), findsOneWidget);
      },
    );

    testWidgets('WelcomeScreen button should use AppColor.primaryColor', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      // Assert
      expect(
        elevatedButton.style?.backgroundColor?.resolve({}),
        AppColor.primaryColor,
      );
    });

    testWidgets('WelcomeScreen button should be full width', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final sizedBoxes = tester.widgetList<SizedBox>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(SizedBox),
        ),
      );

      final buttonSizedBox = sizedBoxes.firstWhere(
        (box) => box.width == double.infinity,
        orElse: () => sizedBoxes.first,
      );

      // Assert
      expect(buttonSizedBox.width, double.infinity);
      expect(buttonSizedBox.height, greaterThanOrEqualTo(60));
    });

    testWidgets('Tapping button should show SnackBar', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(find.text('Navigation à implémenter'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('WelcomeScreen should have Stack with StackFit.expand', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      final mainStack = stacks.firstWhere(
        (stack) => stack.fit == StackFit.expand,
        orElse: () => stacks.first,
      );

      // Assert
      expect(mainStack.fit, StackFit.expand);
    });

    testWidgets('WelcomeScreen should display Image.asset as background', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('WelcomeScreen should have gradient overlay at bottom', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final positioned = tester.widgetList<Positioned>(find.byType(Positioned));

      // Assert - Should have at least 2 Positioned widgets (overlay and button)
      expect(positioned.length, greaterThanOrEqualTo(2));
    });

    testWidgets('Button should be positioned at bottom', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Act
      final positionedWidgets = tester.widgetList<Positioned>(
        find.ancestor(
          of: find.byType(ElevatedButton),
          matching: find.byType(Positioned),
        ),
      );

      final buttonPositioned = positionedWidgets.firstWhere(
        (p) => p.bottom == 0.0,
        orElse: () => positionedWidgets.first,
      );

      // Assert
      expect(buttonPositioned.bottom, 0);
      expect(buttonPositioned.left, 0);
      expect(buttonPositioned.right, 0);
    });
  });

  group('Integration Tests', () {
    testWidgets('Complete user flow - view button and tap', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('fr'), Locale('en')],
          home: const WelcomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Assert initial state
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('Toucher pour commencer'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Act - Tap button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert - SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Navigation à implémenter'), findsOneWidget);

      // Wait for SnackBar to disappear
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
    });
  });
}
