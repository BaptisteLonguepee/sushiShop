import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sushishop/core/constant/color.dart';
import 'package:sushishop/core/providers/locale_provider.dart';
import 'package:sushishop/core/providers/order_provider.dart';
import 'package:sushishop/core/services/vibration_service.dart';
import 'package:sushishop/core/services/storage_service.dart';
import 'package:sushishop/view/welcome/view/welcome_screen.dart';
import 'package:sushishop/view/home/viewmodel/home_viewmodel.dart';
import 'package:sushishop/view/cart/viewmodel/cart_viewmodel.dart';
import 'package:sushishop/view/cart/view/cart_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using env variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize native services
  await VibrationService.instance.init();
  await StorageService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..initLocale()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Sushi Shop',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
            theme: ThemeData(
              textTheme: GoogleFonts.notoSansTextTheme().copyWith(
                displayLarge: GoogleFonts.notoSerif(
                  fontSize: 96,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1.5,
                ),
                displayMedium: GoogleFonts.notoSerif(
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                ),
                displaySmall: GoogleFonts.notoSerif(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                ),
                headlineMedium: GoogleFonts.notoSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
                headlineSmall: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
                titleLarge: GoogleFonts.notoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
                titleMedium: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
                titleSmall: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                bodyLarge: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                bodyMedium: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
              ),

              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColor.primaryColor,
                primary: AppColor.primaryColor,
                secondary: AppColor.gold,
                surface: Colors.white,
                error: AppColor.error,
                onPrimary: Colors.white,
                onSecondary: AppColor.black,
                onSurface: AppColor.black,
                onError: Colors.white,
              ),

              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                titleTextStyle: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Colors.white, size: 24),
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppColor.primaryColor.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryColor,
                  textStyle: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              cardTheme: CardThemeData(
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColor.gold.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                color: Colors.white,
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AppColor.lightGold.withValues(alpha: 0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColor.gold.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColor.gold.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColor.primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColor.error),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                labelStyle: GoogleFonts.notoSans(color: AppColor.cardColor),
                hintStyle: GoogleFonts.notoSans(
                  color: AppColor.cardColor.withValues(alpha: 0.6),
                ),
              ),

              dialogTheme: DialogThemeData(
                elevation: 10,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                titleTextStyle: GoogleFonts.notoSerif(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                ),
                contentTextStyle: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: AppColor.black,
                ),
              ),

              snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColor.primaryColor,
                contentTextStyle: GoogleFonts.notoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: AppColor.primaryColor,
              ),

              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routes: {'/cart': (context) => const CartScreen()},
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
