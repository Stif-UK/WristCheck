// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get watchBox => 'Boîte à montres';

  @override
  String get settings => 'Paramètres';

  @override
  String get languageLink => 'Langue';

  @override
  String get reminderLink => 'Rappel quotidien';

  @override
  String get currencyLink => 'Options de devise';

  @override
  String get chartOptionsLink => 'Options de graphique';

  @override
  String get appPreferencesLink => 'Préférences de l\'application';

  @override
  String get showArchiveLink => 'Afficher les montres archivées';

  @override
  String get showDemoLink => 'Afficher la démo de première utilisation';

  @override
  String get appVersion => 'Version de l\'app : ';

  @override
  String get unknownAppVersionText => 'Indéterminé';

  @override
  String get wearStatsButton => 'Statistiques d\'usure';

  @override
  String get collectionStatsButton => 'Statistiques de collecte';

  @override
  String get wristRecap => 'Wrist Recap';
}
