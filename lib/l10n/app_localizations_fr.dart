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
  String get homeTitle => 'Sushi Shop';

  @override
  String get ourProducts => 'Nos produits';

  @override
  String get noProducts => 'Aucun produit disponible';

  @override
  String get errorLoadingProducts => 'Erreur lors du chargement des produits';

  @override
  String get retry => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get addToCart => 'Ajouter au panier';

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
  String get cart_title => 'Mon Panier';

  @override
  String get cart_empty => 'Votre panier est vide';

  @override
  String get cart_empty_subtitle => 'Ajoutez des produits pour commencer';

  @override
  String get cart_browse_menu => 'Parcourir le menu';

  @override
  String cart_note(String note) {
    return 'Note: $note';
  }

  @override
  String cart_articles(int count) {
    return 'Articles ($count)';
  }

  @override
  String get cart_total => 'Total';

  @override
  String get cart_order => 'Commander';

  @override
  String get cart_delete_title => 'Supprimer l\'article';

  @override
  String cart_delete_message(String productName) {
    return 'Voulez-vous retirer \"$productName\" du panier ?';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmation_title => 'Commande confirmée !';

  @override
  String confirmation_thank_you(String clientName) {
    return 'Merci $clientName pour votre commande';
  }

  @override
  String get confirmation_order_number => 'Numéro de commande';

  @override
  String get confirmation_total_amount => 'Montant total';

  @override
  String get confirmation_estimated_time => 'Temps de préparation estimé: 15-20 min';

  @override
  String get confirmation_notification_info => 'Vous recevrez une notification lorsque votre commande sera prête';

  @override
  String get confirmation_back_home => 'Retour à l\'accueil';

  @override
  String get checkout_title => 'Vérifier la commande';

  @override
  String get checkout_order_summary => 'Résumé de la commande';

  @override
  String get checkout_scan_qr => 'Scanner le QR Code de la table';

  @override
  String get payment_title => 'Paiement';

  @override
  String payment_table_number(String tableNumber) {
    return 'Table n°$tableNumber';
  }

  @override
  String get payment_validated => 'Validé';

  @override
  String get payment_total_to_pay => 'Total à payer';

  @override
  String get payment_method => 'Méthode de paiement';

  @override
  String get payment_card => 'Paiement sur la borne (Carte)';

  @override
  String get payment_counter => 'Paiement au comptoir';

  @override
  String get payment_terminal_title => 'Terminal de paiement';

  @override
  String get payment_terminal_instruction => 'Veuillez insérer ou présenter votre carte bancaire au terminal de paiement';

  @override
  String get payment_contactless => 'Sans contact accepté';

  @override
  String get payment_counter_info => 'Veuillez vous présenter au comptoir avec votre numéro de commande pour effectuer le paiement.';

  @override
  String get payment_processing => 'Paiement en cours...';

  @override
  String get payment_validating => 'Validation...';

  @override
  String payment_process_card(String amount) {
    return 'Payer $amount €';
  }

  @override
  String get payment_validate_order => 'Valider la commande';

  @override
  String payment_error(String error) {
    return 'Erreur lors de la création de la commande: $error';
  }

  @override
  String get qr_scan_title => 'Scanner le QR Code';

  @override
  String get qr_scan_instruction => 'Veuillez scanner le QR code de votre table';

  @override
  String get qr_scan_required => 'Le numéro de table est nécessaire pour valider votre commande';

  @override
  String qr_scan_table(String tableNumber) {
    return 'Table n°$tableNumber';
  }

  @override
  String get qr_scan_scanning => 'Scan en cours...';

  @override
  String get qr_scan_button => 'Scanner le QR Code';

  @override
  String get qr_scan_continue_payment => 'Continuer vers le paiement';

  @override
  String get qr_scan_manual_input => 'Saisir le numéro manuellement';

  @override
  String get qr_scan_manual_dialog_title => 'Numéro de table';

  @override
  String get qr_scan_manual_dialog_hint => 'Entrez le numéro de table';

  @override
  String get validate => 'Valider';

  @override
  String get product_description => 'Description';

  @override
  String get product_allergens => 'Allergènes';

  @override
  String get product_vegetarian => 'Végétarien';

  @override
  String get product_vegan => 'Vegan';

  @override
  String get product_size => 'Taille';

  @override
  String get product_size_small => 'Petit';

  @override
  String get product_size_medium => 'Moyen';

  @override
  String get product_size_large => 'Grand';

  @override
  String get product_extras => 'Extras';

  @override
  String get product_extra_soy_sauce => 'Sauce soja supplémentaire';

  @override
  String get product_extra_ginger => 'Gingembre mariné';

  @override
  String get product_extra_wasabi => 'Wasabi extra';

  @override
  String get product_extra_spicy_sauce => 'Sauce piquante';

  @override
  String get product_extra_sesame => 'Sésame';

  @override
  String get product_special_notes => 'Notes spéciales';

  @override
  String get product_notes_hint => 'Ex: Sans oignons, bien cuit...';

  @override
  String get product_quantity => 'Quantité';

  @override
  String product_added_to_cart(String productName) {
    return '$productName ajouté au panier';
  }

  @override
  String get home_loading => 'Chargement des produits...';

  @override
  String get home_all => 'Tout';

  @override
  String get home_search => 'Rechercher';

  @override
  String get home_search_hint => 'Nom du produit...';

  @override
  String home_products_found(int count) {
    return '$count produit(s) trouvé(s)';
  }

  @override
  String get home_your_order => 'Votre commande';

  @override
  String get home_order_button => 'COMMANDER';

  @override
  String get home_new => 'NOUVEAU';

  @override
  String get home_price => 'Prix';

  @override
  String get home_vegetarian => 'Végétarien';

  @override
  String get home_vegan => 'Végan';

  @override
  String get home_out_of_stock => 'Rupture de stock';

  @override
  String get home_allergens => 'Allergènes :';

  @override
  String home_added_to_cart(String productName) {
    return '$productName ajouté au panier';
  }
}
