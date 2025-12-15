import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @touch_to_start.
  ///
  /// In en, this message translates to:
  /// **'Touch to start'**
  String get touch_to_start;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sushi Shop'**
  String get homeTitle;

  /// No description provided for @ourProducts.
  ///
  /// In en, this message translates to:
  /// **'Our products'**
  String get ourProducts;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProducts;

  /// No description provided for @errorLoadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Error loading products'**
  String get errorLoadingProducts;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

  /// No description provided for @order_type_title.
  ///
  /// In en, this message translates to:
  /// **'Order Type'**
  String get order_type_title;

  /// No description provided for @order_type_question.
  ///
  /// In en, this message translates to:
  /// **'How would you like to order?'**
  String get order_type_question;

  /// No description provided for @order_type_dine_in.
  ///
  /// In en, this message translates to:
  /// **'Dine In'**
  String get order_type_dine_in;

  /// No description provided for @order_type_takeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get order_type_takeaway;

  /// No description provided for @order_type_table_number.
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get order_type_table_number;

  /// No description provided for @order_type_enter_table_number.
  ///
  /// In en, this message translates to:
  /// **'Enter the number'**
  String get order_type_enter_table_number;

  /// No description provided for @order_type_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get order_type_continue;

  /// No description provided for @cart_title.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cart_title;

  /// No description provided for @cart_empty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cart_empty;

  /// No description provided for @cart_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add products to get started'**
  String get cart_empty_subtitle;

  /// No description provided for @cart_browse_menu.
  ///
  /// In en, this message translates to:
  /// **'Browse menu'**
  String get cart_browse_menu;

  /// No description provided for @cart_note.
  ///
  /// In en, this message translates to:
  /// **'Note: {note}'**
  String cart_note(String note);

  /// No description provided for @cart_articles.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String cart_articles(int count);

  /// No description provided for @cart_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cart_total;

  /// No description provided for @cart_order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get cart_order;

  /// No description provided for @cart_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get cart_delete_title;

  /// No description provided for @cart_delete_message.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove \"{productName}\" from the cart?'**
  String cart_delete_message(String productName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed!'**
  String get confirmation_title;

  /// No description provided for @confirmation_thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you {clientName} for your order'**
  String confirmation_thank_you(String clientName);

  /// No description provided for @confirmation_order_number.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get confirmation_order_number;

  /// No description provided for @confirmation_total_amount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get confirmation_total_amount;

  /// No description provided for @confirmation_estimated_time.
  ///
  /// In en, this message translates to:
  /// **'Estimated preparation time: 15-20 min'**
  String get confirmation_estimated_time;

  /// No description provided for @confirmation_notification_info.
  ///
  /// In en, this message translates to:
  /// **'You will receive a notification when your order is ready'**
  String get confirmation_notification_info;

  /// No description provided for @confirmation_back_home.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get confirmation_back_home;

  /// No description provided for @checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Review order'**
  String get checkout_title;

  /// No description provided for @checkout_order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get checkout_order_summary;

  /// No description provided for @checkout_scan_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan the table QR code'**
  String get checkout_scan_qr;

  /// No description provided for @payment_title.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment_title;

  /// No description provided for @payment_table_number.
  ///
  /// In en, this message translates to:
  /// **'Table n°{tableNumber}'**
  String payment_table_number(String tableNumber);

  /// No description provided for @payment_validated.
  ///
  /// In en, this message translates to:
  /// **'Validated'**
  String get payment_validated;

  /// No description provided for @payment_total_to_pay.
  ///
  /// In en, this message translates to:
  /// **'Total to pay'**
  String get payment_total_to_pay;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get payment_method;

  /// No description provided for @payment_card.
  ///
  /// In en, this message translates to:
  /// **'Pay at the terminal (Card)'**
  String get payment_card;

  /// No description provided for @payment_counter.
  ///
  /// In en, this message translates to:
  /// **'Pay at the counter'**
  String get payment_counter;

  /// No description provided for @payment_terminal_title.
  ///
  /// In en, this message translates to:
  /// **'Payment terminal'**
  String get payment_terminal_title;

  /// No description provided for @payment_terminal_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please insert or present your bank card to the payment terminal'**
  String get payment_terminal_instruction;

  /// No description provided for @payment_contactless.
  ///
  /// In en, this message translates to:
  /// **'Contactless accepted'**
  String get payment_contactless;

  /// No description provided for @payment_counter_info.
  ///
  /// In en, this message translates to:
  /// **'Please go to the counter with your order number to make the payment.'**
  String get payment_counter_info;

  /// No description provided for @payment_processing.
  ///
  /// In en, this message translates to:
  /// **'Payment in progress...'**
  String get payment_processing;

  /// No description provided for @payment_validating.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get payment_validating;

  /// No description provided for @payment_process_card.
  ///
  /// In en, this message translates to:
  /// **'Process payment {amount} €'**
  String payment_process_card(String amount);

  /// No description provided for @payment_validate_order.
  ///
  /// In en, this message translates to:
  /// **'Validate order'**
  String get payment_validate_order;

  /// No description provided for @payment_error.
  ///
  /// In en, this message translates to:
  /// **'Error creating order: {error}'**
  String payment_error(String error);

  /// No description provided for @qr_scan_title.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get qr_scan_title;

  /// No description provided for @qr_scan_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please scan the QR code of your table'**
  String get qr_scan_instruction;

  /// No description provided for @qr_scan_required.
  ///
  /// In en, this message translates to:
  /// **'The table number is required to validate your order'**
  String get qr_scan_required;

  /// No description provided for @qr_scan_table.
  ///
  /// In en, this message translates to:
  /// **'Table n°{tableNumber}'**
  String qr_scan_table(String tableNumber);

  /// No description provided for @qr_scan_scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get qr_scan_scanning;

  /// No description provided for @qr_scan_button.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get qr_scan_button;

  /// No description provided for @qr_scan_continue_payment.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get qr_scan_continue_payment;

  /// No description provided for @qr_scan_manual_input.
  ///
  /// In en, this message translates to:
  /// **'Enter number manually'**
  String get qr_scan_manual_input;

  /// No description provided for @qr_scan_manual_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Table number'**
  String get qr_scan_manual_dialog_title;

  /// No description provided for @qr_scan_manual_dialog_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the table number'**
  String get qr_scan_manual_dialog_hint;

  /// No description provided for @validate.
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// No description provided for @product_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get product_description;

  /// No description provided for @product_allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get product_allergens;

  /// No description provided for @product_vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get product_vegetarian;

  /// No description provided for @product_vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get product_vegan;

  /// No description provided for @product_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get product_size;

  /// No description provided for @product_size_small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get product_size_small;

  /// No description provided for @product_size_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get product_size_medium;

  /// No description provided for @product_size_large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get product_size_large;

  /// No description provided for @product_extras.
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get product_extras;

  /// No description provided for @product_extra_soy_sauce.
  ///
  /// In en, this message translates to:
  /// **'Extra soy sauce'**
  String get product_extra_soy_sauce;

  /// No description provided for @product_extra_ginger.
  ///
  /// In en, this message translates to:
  /// **'Marinated ginger'**
  String get product_extra_ginger;

  /// No description provided for @product_extra_wasabi.
  ///
  /// In en, this message translates to:
  /// **'Extra wasabi'**
  String get product_extra_wasabi;

  /// No description provided for @product_extra_spicy_sauce.
  ///
  /// In en, this message translates to:
  /// **'Spicy sauce'**
  String get product_extra_spicy_sauce;

  /// No description provided for @product_extra_sesame.
  ///
  /// In en, this message translates to:
  /// **'Sesame'**
  String get product_extra_sesame;

  /// No description provided for @product_special_notes.
  ///
  /// In en, this message translates to:
  /// **'Special notes'**
  String get product_special_notes;

  /// No description provided for @product_notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Ex: No onions, well done...'**
  String get product_notes_hint;

  /// No description provided for @product_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get product_quantity;

  /// No description provided for @product_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart'**
  String product_added_to_cart(String productName);

  /// No description provided for @home_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get home_loading;

  /// No description provided for @home_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get home_all;

  /// No description provided for @home_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get home_search;

  /// No description provided for @home_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Product name...'**
  String get home_search_hint;

  /// No description provided for @home_products_found.
  ///
  /// In en, this message translates to:
  /// **'{count} product(s) found'**
  String home_products_found(int count);

  /// No description provided for @home_your_order.
  ///
  /// In en, this message translates to:
  /// **'Your order'**
  String get home_your_order;

  /// No description provided for @home_order_button.
  ///
  /// In en, this message translates to:
  /// **'ORDER'**
  String get home_order_button;

  /// No description provided for @home_new.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get home_new;

  /// No description provided for @home_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get home_price;

  /// No description provided for @home_vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get home_vegetarian;

  /// No description provided for @home_vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get home_vegan;

  /// No description provided for @home_out_of_stock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get home_out_of_stock;

  /// No description provided for @home_allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens:'**
  String get home_allergens;

  /// No description provided for @home_added_to_cart.
  ///
  /// In en, this message translates to:
  /// **'{productName} added to cart'**
  String home_added_to_cart(String productName);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
