// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get touch_to_start => 'Toucher pour commencer';

  @override
  String get order_type_title => 'Type de commande';

  @override
  String get order_type_question => 'Comment souhaitez-vous commander ?';

  @override
  String get order_type_dine_in => 'Sur Place';

  @override
  String get order_type_takeaway => 'À Emporter';

  @override
  String get order_type_table_number => 'Numéro de chevalet';

  @override
  String get order_type_enter_table_number => 'Entrez le numéro';

  @override
  String get order_type_continue => 'Continuer';

  @override
  String get product_quantity => 'Quantité';

  @override
  String get add_to_cart => 'Ajouter au panier';

  @override
  String get retry => 'Réessayer';
}
