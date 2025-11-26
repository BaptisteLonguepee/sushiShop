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
  String get order_type_enter_table_number => 'Enter number';

  @override
  String get order_type_continue => 'Continue';
}
