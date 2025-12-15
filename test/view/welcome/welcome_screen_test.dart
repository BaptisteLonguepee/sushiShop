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

    testWidgets('navigateToNextScreen should navigate to OrderTypeScreen', (
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
      await tester.pumpAndSettle();

      // Assert - Should have navigated to a new screen
      expect(find.text('Test Button'), findsNothing);
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('WelcomeScreen should have Stack with StackFit.expand', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Act
      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      final mainStack = stacks.firstWhere(
        (stack) => stack.fit == StackFit.expand,
        orElse: () => stacks.first,
      );

      // Assert
      expect(mainStack.fit, StackFit.expand);
    });

    testWidgets('WelcomeScreen should have gradient overlay at bottom', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Act
      final positioned = tester.widgetList<Positioned>(find.byType(Positioned));

      // Assert - Should have at least 2 Positioned widgets (overlay and button)
      expect(positioned.length, greaterThanOrEqualTo(2));
    });
  });

  group('Integration Tests', () {
    // Tests d'intégration simplifiés - WelcomeScreen utilise InkWell custom
    testWidgets('Complete user flow - Welcome screen structure', (
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
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert initial state
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets);
    });
  });
}
