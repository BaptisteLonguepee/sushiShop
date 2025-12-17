// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get touch_to_start => 'Touch to start';

  @override
  String get homeTitle => 'Sushi Shop';

  @override
  String get ourProducts => 'Our products';

  @override
  String get noProducts => 'No products available';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get order_type_title => 'Order Type';

  @override
  String get order_type_question => 'How would you like to order?';

  @override
  String get order_type_dine_in => 'Dine In';

  @override
  String get order_type_takeaway => 'Takeaway';

  @override
  String get order_type_table_number => 'Table Number';

  @override
  String get order_type_enter_table_number => 'Enter the number';

  @override
  String get order_type_continue => 'Continue';

  @override
  String get cart_title => 'My Cart';

  @override
  String get cart_empty => 'Your cart is empty';

  @override
  String get cart_empty_subtitle => 'Add products to get started';

  @override
  String get cart_browse_menu => 'Browse menu';

  @override
  String cart_note(String note) {
    return 'Note: $note';
  }

  @override
  String cart_articles(int count) {
    return 'Items ($count)';
  }

  @override
  String get cart_total => 'Total';

  @override
  String get cart_order => 'Order';

  @override
  String get cart_delete_title => 'Delete item';

  @override
  String cart_delete_message(String productName) {
    return 'Do you want to remove \"$productName\" from the cart?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmation_title => 'Order confirmed!';

  @override
  String confirmation_thank_you(String clientName) {
    return 'Thank you $clientName for your order';
  }

  @override
  String get confirmation_order_number => 'Order number';

  @override
  String get confirmation_total_amount => 'Total amount';

  @override
  String get confirmation_estimated_time =>
      'Estimated preparation time: 15-20 min';

  @override
  String get confirmation_notification_info =>
      'You will receive a notification when your order is ready';

  @override
  String get confirmation_back_home => 'Back to home';

  @override
  String get checkout_title => 'Review order';

  @override
  String get checkout_order_summary => 'Order summary';

  @override
  String get checkout_scan_qr => 'Scan the table QR code';

  @override
  String get payment_title => 'Payment';

  @override
  String payment_table_number(String tableNumber) {
    return 'Table n°$tableNumber';
  }

  @override
  String get payment_validated => 'Validated';

  @override
  String get payment_total_to_pay => 'Total to pay';

  @override
  String get payment_method => 'Payment method';

  @override
  String get payment_card => 'Pay at the terminal (Card)';

  @override
  String get payment_counter => 'Pay at the counter';

  @override
  String get payment_terminal_title => 'Payment terminal';

  @override
  String get payment_terminal_instruction =>
      'Please insert or present your bank card to the payment terminal';

  @override
  String get payment_contactless => 'Contactless accepted';

  @override
  String get payment_counter_info =>
      'Please go to the counter with your order number to make the payment.';

  @override
  String get payment_processing => 'Payment in progress...';

  @override
  String get payment_validating => 'Validating...';

  @override
  String payment_process_card(String amount) {
    return 'Process payment $amount €';
  }

  @override
  String get payment_validate_order => 'Validate order';

  @override
  String payment_error(String error) {
    return 'Error creating order: $error';
  }

  @override
  String get qr_scan_title => 'Scan QR Code';

  @override
  String get qr_scan_instruction => 'Please scan the QR code of your table';

  @override
  String get qr_scan_required =>
      'The table number is required to validate your order';

  @override
  String qr_scan_table(String tableNumber) {
    return 'Table n°$tableNumber';
  }

  @override
  String get qr_scan_scanning => 'Scanning...';

  @override
  String get qr_scan_button => 'Scan QR Code';

  @override
  String get qr_scan_continue_payment => 'Continue to payment';

  @override
  String get qr_scan_manual_input => 'Enter number manually';

  @override
  String get qr_scan_manual_dialog_title => 'Table number';

  @override
  String get qr_scan_manual_dialog_hint => 'Enter the table number';

  @override
  String get validate => 'Validate';

  @override
  String get product_description => 'Description';

  @override
  String get product_allergens => 'Allergens';

  @override
  String get product_vegetarian => 'Vegetarian';

  @override
  String get product_vegan => 'Vegan';

  @override
  String get product_size => 'Size';

  @override
  String get product_size_small => 'Small';

  @override
  String get product_size_medium => 'Medium';

  @override
  String get product_size_large => 'Large';

  @override
  String get product_extras => 'Extras';

  @override
  String get product_extra_soy_sauce => 'Extra soy sauce';

  @override
  String get product_extra_ginger => 'Marinated ginger';

  @override
  String get product_extra_wasabi => 'Extra wasabi';

  @override
  String get product_extra_spicy_sauce => 'Spicy sauce';

  @override
  String get product_extra_sesame => 'Sesame';

  @override
  String get product_special_notes => 'Special notes';

  @override
  String get product_notes_hint => 'Ex: No onions, well done...';

  @override
  String get product_quantity => 'Quantity';

  @override
  String product_added_to_cart(String productName) {
    return '$productName added to cart';
  }

  @override
  String get home_loading => 'Loading products...';

  @override
  String get home_all => 'All';

  @override
  String get home_search => 'Search';

  @override
  String get home_search_hint => 'Product name...';

  @override
  String home_products_found(int count) {
    return '$count product(s) found';
  }

  @override
  String get home_your_order => 'Your order';

  @override
  String get home_order_button => 'ORDER';

  @override
  String get home_new => 'NEW';

  @override
  String get home_price => 'Price';

  @override
  String get home_vegetarian => 'Vegetarian';

  @override
  String get home_vegan => 'Vegan';

  @override
  String get home_out_of_stock => 'Out of stock';

  @override
  String get home_allergens => 'Allergens:';

  @override
  String home_added_to_cart(String productName) {
    return '$productName added to cart';
  }
}
