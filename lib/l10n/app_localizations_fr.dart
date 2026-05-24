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
  String get collection => 'Collection';

  @override
  String get stats => 'Stats';

  @override
  String get calendar => 'Calendrier';

  @override
  String get time => 'Heure';

  @override
  String get more => 'Plus';

  @override
  String get settings => 'Réglages';

  @override
  String get appData => 'Données de l\'app';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get support => 'Soutenir WristTrack';

  @override
  String get review => 'Laisser un avis';

  @override
  String get about => 'À propos';

  @override
  String get follow => 'Suivre WristTrack';

  @override
  String get email => 'Commentaires par e-mail';

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

  @override
  String get lastSync => 'Dernière synchro :';

  @override
  String get deviation => 'Écart de l\'heure système :';

  @override
  String get inProgress =>
      'Synchronisation en cours – affichage de l\'heure système...';

  @override
  String get beepCountdown => 'Compte à rebours sonore';

  @override
  String get timeFormat => 'Format 24 heures';

  @override
  String get moonPhase => 'Phase lunaire actuelle';

  @override
  String get gallery => 'Galerie';

  @override
  String get timeline => 'Chronologie';

  @override
  String get all => 'tout';

  @override
  String get january => 'janvier';

  @override
  String get february => 'février';

  @override
  String get march => 'mars';

  @override
  String get april => 'avril';

  @override
  String get may => 'mai';

  @override
  String get june => 'juin';

  @override
  String get july => 'juillet';

  @override
  String get august => 'août';

  @override
  String get september => 'septembre';

  @override
  String get october => 'octobre';

  @override
  String get november => 'novembre';

  @override
  String get december => 'décembre';

  @override
  String get day => 'Jour';

  @override
  String get month => 'Mois';

  @override
  String get year => 'Année';

  @override
  String get filter => 'Filtrer :';

  @override
  String get wearsByDay => 'Portées par jour';

  @override
  String get wearsByMonth => 'Portées par mois';

  @override
  String get wearsByYear => 'Portées par an';

  @override
  String get thisYear => 'Cette année';

  @override
  String get lastYear => 'L\'année dernière';

  @override
  String get last12Months => '12 derniers mois';

  @override
  String get last90days => '90 derniers jours';

  @override
  String get emptyWearListWatchCharts =>
      'Vous n\'avez pas encore enregistré de dates de portée pour cette montre.\n\nEnregistrez des données en cliquant sur « Portée aujourd\'hui » sur la fiche de la montre, ou ajoutez des dates via la vue calendrier.\n\nUne fois enregistrés, des graphiques s\'afficheront ici pour détailler vos statistiques par mois et par jour de la semaine.';

  @override
  String get wearChartFiltersSheetTitle => 'Filtres du graphique de porter';

  @override
  String get showAll => 'Tout afficher';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get lastMonth => 'Le mois dernier';

  @override
  String get last30days => 'Les 30 derniers jours';

  @override
  String get last365days => 'Les 365 derniers jours';

  @override
  String get sinceLastPurchase => 'Depuis le dernier achat';

  @override
  String get selectMonthYear => 'Sélectionner Mois/Année';

  @override
  String get betweenSelectedDates => 'Entre les dates sélectionnées';

  @override
  String get monthColon => 'Mois :';

  @override
  String get yearColon => 'Année :';

  @override
  String get startDate => 'Date de début :';

  @override
  String get endDate => 'Date de fin :';

  @override
  String get resetToDefaults => 'Rétablir les paramètres par défaut';

  @override
  String get chartGrouping => 'Groupement des graphiques';

  @override
  String get includeCurrentCollection => 'Inclure la collection actuelle';

  @override
  String get includeSoldWatches => 'Inclure les montres vendues';

  @override
  String get includeRetiredWatches => 'Inclure les montres retirées';

  @override
  String get includeArchivedWatches => 'Inclure les montres archivées';

  @override
  String get filterByCategory => 'Filtrer par catégorie';

  @override
  String get filterByMovement => 'Filtrer par mouvement';

  @override
  String get allData => 'Toutes les données';

  @override
  String get wornThisYear => 'Portées cette année';

  @override
  String get wornThisMonth => 'Portées ce mois-ci';

  @override
  String get wornLastMonth => 'Portées le mois dernier';

  @override
  String get wornLastYear => 'Portées l\'année dernière';

  @override
  String get wornInLast30Days => 'Portées les 30 derniers jours';

  @override
  String get wornInLast90Days => 'Portées les 90 derniers jours';

  @override
  String get wornInLast365Days => 'Portées les 365 derniers jours';

  @override
  String wornBetweenDates(Object shortDate, Object shortDate2) {
    return 'Portées entre le $shortDate et le $shortDate2';
  }

  @override
  String yearSelected(Object yearValue) {
    return 'Année : $yearValue';
  }

  @override
  String monthSelected(Object monthValue) {
    return 'Mois : $monthValue';
  }

  @override
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate) {
    return '$returnText Dernier achat : $shortDate, ';
  }

  @override
  String advancedFilterHeaderGrouping(Object filterText, Object returnText) {
    return '$returnText Grouper par $filterText, ';
  }

  @override
  String advancedFilterHeaderCategories(Object filterText, Object returnText) {
    return '$returnText Catégories ($filterText), ';
  }

  @override
  String advancedFilterHeaderMovements(Object filterText, Object returnText) {
    return '$returnText Mouvements ($filterText), ';
  }

  @override
  String advancedFilterHeaderHideCollection(Object returnText) {
    return '$returnText masquer la collection, ';
  }

  @override
  String advancedFilterHeaderIncSold(Object returnText) {
    return '$returnText avec vendus, ';
  }

  @override
  String advancedFilterHeaderIncRetired(Object returnText) {
    return '$returnText avec retirés, ';
  }

  @override
  String advancedFilterHeaderIncArchived(Object returnText) {
    return '$returnText avec archivés, ';
  }

  @override
  String get watch => 'Montre';

  @override
  String get movement => 'Mouvement';

  @override
  String get category => 'Catégorie';

  @override
  String get manufacturer => 'Fabricant';

  @override
  String get caseMaterial => 'Matériau du boîtier';

  @override
  String get dateComplication => 'Complication date';

  @override
  String get pageTitleCollectionStats => 'Stats de la collection';

  @override
  String get labelCharts => 'Graphiques';

  @override
  String get labelInfo => 'Infos';

  @override
  String get labelValue => 'Valeur';

  @override
  String get collectionCost => 'Coût actuel de la collection';

  @override
  String get noValue => 'Aucune valeur saisie';

  @override
  String get totalSpend => 'Dépense totale de la collection';

  @override
  String get totalSold => 'Valeur totale vendue';

  @override
  String get averageResale => '% moyen de revente';

  @override
  String get noDataTracked => 'Aucune donnée suivie';

  @override
  String get resaleRatio => 'Ratio de revente =';

  @override
  String get sizeOfCollection => 'Taille de la collection';

  @override
  String get oldestWatch => 'Montre la plus ancienne';

  @override
  String get newestWatch => 'Montre la plus récente';

  @override
  String get mostWorn => 'La plus portée';

  @override
  String get leastWorn => 'La moins portée';

  @override
  String get wishListCount => 'Montres en liste de souhaits';

  @override
  String get soldWatches => 'Montres vendues';

  @override
  String get noPurchaseDatesTracked => 'Aucune date d\'achat enregistrée';

  @override
  String get upgradeToProForMoreCharts =>
      'Passez à WristTrack Pro pour plus de graphiques ici...';

  @override
  String get movements => 'Mouvements';

  @override
  String get categories => 'Catégories';

  @override
  String get dateComplications => 'Complications de date';

  @override
  String get caseDiameter => 'Diamètre du boîtier';

  @override
  String get lugWidth => 'Entre-corne';

  @override
  String get lugToLug => 'Corne à corne';

  @override
  String get caseThickness => 'Épaisseur du boîtier';

  @override
  String get waterResistance => 'Étanchéité';

  @override
  String get caseMaterials => 'Matériaux du boîtier';

  @override
  String get costPerWear => 'Coût par portée';

  @override
  String get showPaymentOptions => 'Afficher les options de paiement';

  @override
  String get donateAgain => 'Faire un nouveau don';

  @override
  String get removeAdsMainCopy =>
      'Les fonctionnalités de base de **WristTrack** sont gratuites, financées par de petites publicités dans l\'application.\n\nCependant, vous pouvez supprimer ces publicités en choisissant un prix pour l\'application ci-dessous — toutes les options débloquent la version **WristTrack Pro**.\n\n**WristTrack Pro** débloque également :\n\n* L\'option de définir un deuxième rappel quotidien\n* Des graphiques individuels par montre affichant les statistiques de portée par mois et par jour de la semaine\n* Des champs de données et des graphiques supplémentaires pour vos montres';

  @override
  String get supporterCopy =>
      'Merci de soutenir WristTrack !\n\nVotre soutien compte énormément et me permet de continuer à développer WristTrack ainsi que d\'autres applications de ce type.\n\nSi vous appréciez l\'application, n\'hésitez pas à en parler à vos amis ou à laisser un avis pour me dire ce qui vous plaît et quelles fonctionnalités vous aimeriez voir ajoutées !\n\nSi vous souhaitez continuer à soutenir WristTrack, des dons supplémentaires peuvent être effectués à tout moment.';

  @override
  String get purchaseRestored => 'Achat restauré';

  @override
  String get youreAdFree => 'Les publicités sont maintenant supprimées !';

  @override
  String get restoreFailed => 'Échec de la restauration';

  @override
  String get noPurchaseFound =>
      'Aucun achat précédent ou actif trouvé pour cet utilisateur';

  @override
  String get restorePurchase => 'Restaurer le statut de l\'achat';

  @override
  String get noOptionsFound => 'Aucune option trouvée, réessayez plus tard';

  @override
  String get supportWristTrack => 'Soutenir WristTrack';

  @override
  String get payWhatYouLike =>
      'Payez ce que vous voulez ! Choisissez n\'importe quelle option pour passer à WristTrack Pro';

  @override
  String get noDataRecorded => 'Aucune donnée';

  @override
  String get warning => 'Attention';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get noThanks => 'Non merci';

  @override
  String get cancel => 'Annuler';

  @override
  String get tellMeMore => 'En savoir plus';

  @override
  String get soldSuffix => '(Vendu)';

  @override
  String get retiredSuffix => '(Retirée)';

  @override
  String get archivedSuffix => '(Archivée)';

  @override
  String get watchColon => 'Montre : ';

  @override
  String get deleting => 'Suppression en cours';

  @override
  String get errorHeader => 'Erreur';

  @override
  String get dontShowThisMessageAgain => 'Ne plus afficher ce message';

  @override
  String get success => 'Succès !';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get notWornYet => 'Pas encore portée';

  @override
  String lastWornDate(Object shortDate) {
    return 'Dernière portée : $shortDate';
  }

  @override
  String wearCount(Object count) {
    return 'Portée $count fois';
  }

  @override
  String get notRecorded => 'Non enregistrée';

  @override
  String soldDetails(Object price, Object shortDate) {
    return 'Vendue le $shortDate \npour $price';
  }

  @override
  String get countDownNA => 'Compte à rebours : N/A';

  @override
  String dueInXDays(Object nDays) {
    return 'Échéance : $nDays';
  }

  @override
  String overdueXDays(Object nDays) {
    return 'En retard : $nDays';
  }

  @override
  String get basic => 'Basique';

  @override
  String get advanced => 'Avancé';

  @override
  String get backupRestore => 'Sauvegarde / Restauration';

  @override
  String get altExports => 'Exports alternatifs';

  @override
  String get dataImport => 'Importation de données';

  @override
  String get deleteCollection => 'Supprimer la collection';

  @override
  String get backupRestoreHeader => 'Sauvegarde / Restauration';

  @override
  String get backup => 'Sauvegarder';

  @override
  String get restore => 'Restaurer';

  @override
  String get backupDatabase => 'Sauvegarder la base de données';

  @override
  String get restoreDatabase => 'Restaurer la base de données';

  @override
  String get pleaseSelectFile =>
      'Veuillez sélectionner le fichier de sauvegarde';

  @override
  String get selectFile => 'Sélectionner le fichier de sauvegarde';

  @override
  String get fileSelected => 'Fichier sélectionné : ';

  @override
  String get readyToLoad => 'Prêt à charger';

  @override
  String get restoreFromBackup => 'Restaurer depuis la sauvegarde';

  @override
  String get backupWatchImages => 'Sauvegarder les images des montres';

  @override
  String get simpleExtractButton => 'Extraction simple (CSV)';

  @override
  String get detailedExtractButton => 'Extraction détaillée (CSV)';

  @override
  String get wristTrackProFeature => 'Fonctionnalité WristTrack Pro';

  @override
  String get proFeature => 'Fonctionnalité Pro';

  @override
  String get track => 'Suivre';

  @override
  String get trackWear => 'Enregistrer une portée';

  @override
  String get removeWear => 'Supprimer la portée';

  @override
  String get removeDate => 'Supprimer la date';

  @override
  String get date => 'Date :';

  @override
  String get pickWatch => 'Choisir une montre';

  @override
  String get pleaseSelectAWatch => 'Veuillez sélectionner une montre';

  @override
  String get searchByName => 'Rechercher par nom de montre';

  @override
  String get deleteWear => 'Supprimer l\'enregistrement de portée';

  @override
  String get deleteFromCalendar => 'Supprimer la portée du calendrier';

  @override
  String get addWearToCalendar => 'Ajouter la portée au calendrier';

  @override
  String get serviceDue => 'Révision nécessaire';

  @override
  String get warrantyExpires => 'Expiration de la garantie';

  @override
  String get deliveryExpected => 'livraison prévue';

  @override
  String get longPressToAddRemove =>
      'Appui long pour ajouter/supprimer des dates de portée';

  @override
  String get tapToAddMultipleDates =>
      'Appuyez ici pour ajouter plusieurs dates';

  @override
  String get deleteDate => 'Supprimer la date';

  @override
  String watchWorn(Object watchName) {
    return '$watchName portée';
  }

  @override
  String get noDatesForWatch => 'Aucune date enregistrée pour cette montre.';

  @override
  String get allDatesWorn => 'Toutes les dates de portée';

  @override
  String get selectDatesToAdd => 'Sélectionner les dates à ajouter';

  @override
  String get selectionMode => 'Mode de sélection';

  @override
  String get rangeDefinition => 'Période (sélectionner le début et la fin)';

  @override
  String get individualSelectionDefinition =>
      'Individuelle (choisir plusieurs dates)';

  @override
  String get thereWasAProblemWithSomeDates =>
      'Un problème est survenu avec certaines dates';

  @override
  String get dateAlreadyExists => 'La date existe déjà';

  @override
  String get dateIsInTheFuture => 'La date est dans le futur';

  @override
  String get watchAccuracy => 'Précision de la montre';

  @override
  String get accuracyTracker => 'Suivi de précision';

  @override
  String timeSynced(Object timeStamp) {
    return 'Heure synchronisée avec le serveur : \n$timeStamp';
  }

  @override
  String get showAccuracyResultsOptions =>
      'Afficher les résultats en secondes par :';

  @override
  String get baseLineMeasurement => 'Mesure de référence :';

  @override
  String get setBaseLineGuide =>
      'Définissez une nouvelle référence si vous venez de régler l\'heure de votre montre';

  @override
  String lastBaseLine(Object timeStamp) {
    return 'Dernière référence : $timeStamp';
  }

  @override
  String get addCheckPoint => 'Ajouter un point de contrôle :';

  @override
  String get seconds => 'Secondes :';

  @override
  String get saved => 'Enregistré !';

  @override
  String get record => 'Enregistrement';

  @override
  String get records => 'Enregistrements';

  @override
  String get baseLine => 'Référence';

  @override
  String get result => 'Result';

  @override
  String get systemTimeInUse => '... heure système utilisée';

  @override
  String get accuracyHelpTextIntro =>
      'Suivez la précision de vos montres en créant des points de contrôle. WristTrack compare ensuite l\'évolution de l\'heure de votre montre à celle de l\'horloge atomique pour calculer si elle avance ou s\'arrête (retarde).\n\n';

  @override
  String get accuracyHelpTextBaselines =>
      '**Références**\n\nLorsque vous définissez un point de contrôle comme référence, toutes les mesures suivantes y seront comparées. Vous devriez définir une nouvelle référence chaque fois que vous réglez l\'heure de votre montre manuellement depuis la dernière mesure de référence.\n\nSi vous n\'avez aucun enregistrement sauvegardé, le premier résultat sera toujours marqué comme étant la référence.\n\n';

  @override
  String get accuracyHelpTextAddAMeasurement =>
      '**Saisir une mesure**\n\nPour enregistrer une donnée, réglez la valeur sous « Ajouter un point de contrôle » pour qu\'elle corresponde à l\'heure qu\'il sera sur votre montre (par défaut, l\'app propose une minute d\'avance), puis appuyez sur le bouton « 00 secondes » au moment où l\'aiguille des secondes atteint midi. Vous pouvez également régler l\'heure pour qu\'elle corresponde à votre montre et utiliser les boutons « 15/30/45 secondes » lorsque l\'aiguille passe devant ces marqueurs pour enregistrer l\'horodatage.\n\nLes heures saisies apparaîtront ensuite dans la section « Enregistrements » ci-dessous, accompagnées de la précision calculée depuis la dernière référence (aucune valeur de précision ne s\'affiche pour les références).\n\n';

  @override
  String get accuracyHelpTextDeletingARecord =>
      '**Supprimer un enregistrement**\n\nSi vous enregistrez une mesure par erreur, elle peut être supprimée en la faisant glisser de droite à gauche dans la liste des « Enregistrements ».\n\n';

  @override
  String get accuracyHelpTextWhenToCapture =>
      '**Quand enregistrer des mesures**\n\nPlus le délai entre la mesure de référence et le point de contrôle est long, plus les résultats seront précis (car les légers retards lors de l\'appui sur les boutons deviennent moins significatifs). À titre indicatif, il est utile de laisser s\'écouler 12 à 24 heures entre les mesures.\n\n';

  @override
  String get accuracyHelpTextOutro =>
      '_*Vous pouvez rouvrir cette fenêtre d\'information à tout moment en appuyant sur le point d\'interrogation en haut à droite de la page.*_\n\n ';

  @override
  String get servicingTab => 'Entretien';

  @override
  String get warrantyTab => 'Garantie';

  @override
  String get helpTab => 'Aide';

  @override
  String nextServiceBy(Object timeStamp) {
    return 'Prochaine révision d\'ici le : $timeStamp';
  }

  @override
  String warrantyExpiresOn(Object timeStamp) {
    return 'La garantie expire le : $timeStamp';
  }

  @override
  String get emptyServiceText =>
      'Aucune donnée d\'entretien à afficher\n\nPour remplir un calendrier d\'entretien, ajoutez des dates d\'achat, des dates de révision et des intervalles d\'entretien à vos montres.\n\n';

  @override
  String get emptyWarrantyText =>
      'Aucune donnée de garantie à afficher\n\nPour remplir un calendrier d\'expiration de garantie, ajoutez des dates de fin de garantie à vos montres.\n';

  @override
  String get serviceScheduleHelpText =>
      'Calendrier d\'entretien et de garantie\n\nCette page vous permet de consulter un calendrier des dates de révision prévues (calculées selon les dates et fréquences enregistrées dans votre collection) ainsi que les dates de fin de garantie, basées sur les champs saisis manuellement pour chaque montre.\n';

  @override
  String get emptyWatchboxCopy =>
      'Votre boîte à montres est actuellement vide.\n\nAppuyez sur le bouton rouge pour ajouter des montres à votre collection.\n\nDéfinissez vos préférences, comme le format de devise, en appuyant sur l\'icône d\'engrenage en haut à droite.';

  @override
  String get emptySoldCopy =>
      'Vous n\'avez aucune montre vendue dans votre collection.\n\nVous pouvez marquer une montre comme vendue en modifiant son statut.\n';

  @override
  String get emptyWishlistCopy =>
      'Votre liste de souhaits est vide.\n\nPour ajouter une montre à votre liste de souhaits, créez une nouvelle fiche et réglez son statut sur « Liste de souhaits ».\n';

  @override
  String get emptyFavouritesCopy =>
      'Vous n\'avez pas encore de montres marquées comme « favorite ».\n\nPour marquer une montre comme favorite, activez le bouton bascule sur l\'écran de détails de la montre.\n';

  @override
  String get emptyPreOrderCopy =>
      'Vous n\'avez aucune précommande en cours.\n\nPour suivre le compte à rebours d\'une montre précommandée, créez une nouvelle fiche avec le statut « précommandée ».';

  @override
  String get listViewTitle => 'Liste';

  @override
  String get gridViewTitle => 'Grille';

  @override
  String get displayOrderTitle => 'Ordre d\'affichage :';

  @override
  String get inOrderOfEntry => 'Par ordre d\'ajout';

  @override
  String get inReverseOrderOfEntry => 'Par ordre d\'ajout inverse';

  @override
  String get azByManufacturer => 'A-Z par fabricant';

  @override
  String get zaByManufacturer => 'Z-A par fabricant';

  @override
  String get orderByMostWorn => 'Trier par les plus portées';

  @override
  String get orderByLastWornDate => 'Trier par date de dernier porter';

  @override
  String watchNamePurchased(Object watchName) {
    return '$watchName achetée';
  }

  @override
  String watchNameSold(Object watchName) {
    return '$watchName vendue';
  }

  @override
  String watchNamePreOrderDue(Object watchName) {
    return 'Livraison prévue : $watchName';
  }

  @override
  String watchNameLastServiced(Object watchName) {
    return 'Dernière révision : $watchName';
  }

  @override
  String watchNameNextService(Object watchName) {
    return 'Prochaine révision : $watchName';
  }

  @override
  String watchNameWarrantyExpires(Object watchName) {
    return 'Expiration de la garantie : $watchName';
  }

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get privacySettingsUpdated =>
      'Vos choix de confidentialité ont été mis à jour';

  @override
  String get privacyError =>
      'Une erreur est survenue lors de la mise à jour des paramètres de confidentialité - veuillez réessayer';

  @override
  String get anAppForEnthusiasts =>
      'Une application pour les passionnés de montres. \nBalayez pour découvrir ce que WristTrack peut faire...';

  @override
  String get yourDigitalWatchbox => 'Votre boîte à montres numérique';

  @override
  String get recordAllYourWatches =>
      'Enregistrez toutes vos montres : recherchez, réorganisez ou obtenez un choix aléatoire rapidement';

  @override
  String get trackTheDetail => 'Suivez chaque détail';

  @override
  String get categoriseAndCaptureTheDetails =>
      'Catégorisez et saisissez les spécificités de vos montres, ou ajoutez vos propres notes';

  @override
  String get analyseTheData => 'Analysez les données';

  @override
  String get getInsightsWithDataAndCharts =>
      'Obtenez un aperçu de votre collection grâce aux données et aux graphiques';

  @override
  String get letsGo => 'C\'est parti !';

  @override
  String get skip => 'PASSER';

  @override
  String get next => 'SUIVANT';

  @override
  String get primaryImage => 'Image principale';

  @override
  String get updateImage => 'Modifier l\'image';

  @override
  String get deleteImage => 'Supprimer l\'image';

  @override
  String imageBottomSheetTitle(Object count, Object watchName) {
    return '$watchName\nImage $count';
  }

  @override
  String get enableDailyWearReminder => 'Activer le rappel quotidien';

  @override
  String get morning => 'Matin (8h00)';

  @override
  String get afternoon => 'Après-midi (12h00)';

  @override
  String get evening => 'Soir (18h00)';

  @override
  String get customTime => 'Heure personnalisée';

  @override
  String yourReminderIsSetForTime(Object hourTimeStamp) {
    return 'Votre rappel quotidien est programmé pour $hourTimeStamp';
  }

  @override
  String yourSecondReminderIsSetFor(Object hourTimeStamp) {
    return 'Votre second rappel est programmé pour $hourTimeStamp';
  }

  @override
  String get notificationTitle => 'Rappel WristTrack';

  @override
  String get notificationOneBody =>
      'N\'oubliez pas d\'enregistrer la montre que vous portez aujourd\'hui !';

  @override
  String notificationConfirmationBody(Object hourTimeStamp) {
    return 'Vos notifications sont maintenant programmées pour $hourTimeStamp chaque jour !';
  }

  @override
  String get notificationTwoBody =>
      'C\'est l\'heure d\'enregistrer ce que vous portez au poignet !';

  @override
  String notificationTwoConfirmationBody(Object hourTimeStamp) {
    return 'Votre seconde notification est programmée pour $hourTimeStamp chaque jour !';
  }

  @override
  String get enableSecondDailyWearReminder =>
      'Activer un second rappel quotidien';

  @override
  String get search => 'Rechercher';

  @override
  String get noResultsFound => 'Aucun résultat trouvé';

  @override
  String nWears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Portée $countString fois',
      one: 'Portée 1 fois',
      zero: 'Aucune portée enregistrée',
    );
    return '$_temp0';
  }

  @override
  String nWatches(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString montres',
      one: '1 montre',
      zero: 'Aucune montre',
    );
    return '$_temp0';
  }

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString jours',
      one: '1 jour',
      zero: '0 jour',
    );
    return '$_temp0';
  }

  @override
  String get deleteWarning =>
      'En appuyant sur OK, vous supprimerez toutes les données des montres, y compris votre liste de souhaits et toutes les images enregistrées\n \n CETTE ACTION EST IRRÉVERSIBLE';

  @override
  String get backupInstruction =>
      'Press the button below to create a copy of the app database (this can take a few seconds!). \n\nOnce created a \'share\' pop-up should appear, allowing you to choose where to send the backup file.  ';

  @override
  String get imageBackupInstructions =>
      'Les images des montres peuvent être exportées séparément.';

  @override
  String get altExtractsGuidance =>
      '**Extractions de données alternatives**\n\nCes options permettent d\'extraire vos données de montres et de portées depuis **WristTrack**.\n\nElles sont conçues pour libérer vos données plutôt que de servir de sauvegarde _(consultez les options Sauvegarde/Restauration si vous souhaitez simplement transférer vos données d\'un appareil à un autre)._\n\nL\'extraction simple fournit une liste de toutes les données de vos montres, incluant le nombre de portées et les notes **(une ligne par montre)**.\n\nL\'extraction détaillée fournit une ligne de données pour chaque **date de portée enregistrée** et inclut uniquement les montres ayant été marquées comme portées. **(plusieurs lignes par montre)**.\n\nCes données brutes sont exportées au format CSV, permettant une importation facile dans votre tableur préféré.';

  @override
  String get watchChartsUpgradeCopy =>
      '**Graphiques de portée**\n\nLes graphiques de montre sont une fonctionnalité **WristTrack Pro**.\n\nIls vous permettent de visualiser des graphiques détaillant les mois et les jours où cette montre a été portée.\n\nVous voulez en savoir plus sur **WristTrack Pro** ? Cliquez sur le bouton ci-dessous...';

  @override
  String get serviceIntervalTitle => 'Intervalle d\'entretien';

  @override
  String get serviceIntervalText =>
      'En définissant un intervalle d\'entretien, une « date de révision prévue » sera calculée et affichée sur l\'écran Entretien de l\'application (à condition qu\'une date d\'achat ou une date de dernière révision soit renseignée).\n\nLa valeur de ce champ peut être laissée à zéro pour désactiver cette fonction pour cette montre.';

  @override
  String get duplicateWearTitle => 'Avertissement : Date en double';

  @override
  String get duplicateWearText =>
      'Il semble que vous ayez déjà porté cette montre à la date indiquée !\n\nSi vous souhaitez enregistrer une portée supplémentaire, sélectionnez « Ajouter à nouveau ».\n\nSinon, annulez pour revenir en arrière.';

  @override
  String get duplicateWearConfirm => 'Ajouter à nouveau';

  @override
  String get collectionStatsDialogTitle => 'Statistiques de la collection';

  @override
  String get collectionStatsDialogText =>
      'Toutes les valeurs sont basées sur les données figurant dans votre collection de montres.\n\nLorsque les calculs reposent sur des dates (comme pour la « montre la plus ancienne »), la précision des résultats dépend des informations saisies dans l\'application.\n\nVous pouvez modifier les données de chaque montre en y accédant via les écrans de votre boîte à montres principale.';

  @override
  String get archivedHelpDialogTitle => 'Archives des montres';

  @override
  String get archivedHelpDialogText =>
      'Lorsqu\'une montre est marquée comme « Archivée », elle est retirée de la collection principale et stockée ici.\n\nLes montres présentes dans les archives peuvent être supprimées définitivement en faisant glisser vers la gauche, ou restaurées dans votre boîte à montres en faisant glisser vers la droite.';

  @override
  String get backupHelpDialogTitle =>
      'Aide à la sauvegarde de la base de données';

  @override
  String get backupHelpDialogText =>
      'Vous changez de téléphone ou vous voulez simplement une sauvegarde au cas où ?\nVous êtes au bon endroit !\n\nCréez une sauvegarde de votre boîte à montres ou restaurez une copie existante.\n\nNote : La restauration de la base de données effacera toutes les données actuelles et les REMPLACERA par la sauvegarde.\n\nSi des problèmes surviennent lors du processus de sauvegarde ou de restauration, ils peuvent souvent être résolus en fermant et en redémarrant l\'application.';

  @override
  String get incorrectFilenameDialogTitle => 'Fichier incorrect';

  @override
  String incorrectFilenameDialogText(Object fileName) {
    return 'Le fichier $fileName ne correspond pas au fichier attendu « watchbox.hive ».\n\nVeuillez sélectionner un fichier nommé « watchbox.hive ».';
  }

  @override
  String get confirmRestoreDialogTitle => 'Restaurer depuis une sauvegarde';

  @override
  String get confirmRestoreDialogText =>
      'La restauration de cette sauvegarde écrasera votre boîte à montres actuelle.\n\nVoulez-vous continuer ?';

  @override
  String get restoreFailedTitle => 'Échec de la restauration';

  @override
  String restoreFailedText(Object error) {
    return 'Impossible de restaurer la sauvegarde, une erreur est survenue :\n\n$error\n\nVeuillez réessayer — si le problème persiste, veuillez contacter le développeur de l\'application.';
  }

  @override
  String get restoreSuccessDialogTitle => 'Restauration réussie';

  @override
  String get restoreSuccessDialogText =>
      'La base de données a été restaurée avec succès !\n\nSi les montres ne s\'affichent pas immédiatement, essayez de naviguer entre les onglets principaux.';

  @override
  String get backupLocationNullDialogText =>
      'Aucun emplacement de sauvegarde n\'est spécifié. Veuillez d\'abord sélectionner l\'endroit où stocker le fichier de sauvegarde.';

  @override
  String backupFailedDialogText(Object error) {
    return 'Échec de la sauvegarde\n\n$error\n\nIl est possible que l\'emplacement sélectionné ne soit pas accessible par l\'application. Essayez avec un autre emplacement.\n\nSi cela ne fonctionne pas, merci de faire part de vos commentaires au développeur via l\'App Store.';
  }

  @override
  String watchboxFailedErrorDialog(Object error) {
    return 'Échec de la réouverture de la boîte à montres\n\n$error\n\nCertaines erreurs peuvent être résolues en fermant et en redémarrant l\'application.\n\nSi cela ne fonctionne pas, merci de faire part de vos commentaires au développeur via l\'App Store.';
  }

  @override
  String get backupCompleteDialogTitle => 'Backup Complete';

  @override
  String get backupCompleteDialogText => 'WatchBox Data has been saved.';

  @override
  String get wristTrackUpdatedBottomSheetTitle =>
      'WristTrack vient d\'être mis à jour...';

  @override
  String get futureDateErrorDialogText =>
      'Les dates de portée doivent être passées, veuillez sélectionner une autre date.';

  @override
  String get notificationSettingsHelpDialogTitle =>
      'Paramètres de notification';

  @override
  String get notificationsSettingsHelpDialogText =>
      'Lorsqu\'elles sont activées, une notification se déclenchera quotidiennement à l\'heure sélectionnée.';

  @override
  String get notificationSettingsHelpDialogTextAndroid =>
      '\n\nNote : Certains fabricants d\'appareils utilisent des versions personnalisées d\'Android qui peuvent affecter la capacité de l\'application à générer des notifications lorsqu\'elle est en arrière-plan.\n\nMalheureusement, en tant que développeur, il n\'y a pas grand-chose à faire pour empêcher cela.\n\nCe problème est connu pour affecter les téléphones Huawei et Xiaomi, mais peut également en concerner d\'autres.';

  @override
  String get wearDatesHelpDialogTitle => 'Historique de portée';

  @override
  String get wearDatesHelpDialogText =>
      'Ce calendrier affiche les dates auxquelles cette montre a été portée, ainsi que les autres dates suivies pour celle-ci.\n\nPour ajouter ou supprimer des dates de portée directement, effectuez un appui long sur une date précise.';

  @override
  String get deleteImageDialogTitle => 'Supprimer l\'image';

  @override
  String get deleteImageDialogText =>
      'Voulez-vous supprimer cette image ?\nCette action est irréversible.';

  @override
  String get deleteWatchTitle => 'Supprimer la montre';

  @override
  String get deleteWatchDialogText =>
      'Voulez-vous retirer cette montre de votre collection ?\n\n(Les montres supprimées par erreur peuvent être restaurées depuis les Archives, accessibles dans les Paramètres)';

  @override
  String get deleteWatchSnackbarConfirmation => 'Montre supprimée';

  @override
  String deleteWatchSnackbarText(Object watchName) {
    return '$watchName a été déplacée vers les Archives';
  }

  @override
  String get failedToPickImageDialogTitle =>
      'Échec de la sélection de l\'image';

  @override
  String failedToPickImageDialogText(Object error) {
    return 'La plateforme a rencontré une erreur :\n\n$error';
  }

  @override
  String get setupDailyReminderDialogTitle =>
      'Configurer les rappels quotidiens';

  @override
  String get setupDailyRemindersDialogText =>
      'WristTrack peut vous envoyer un rappel quotidien pour enregistrer la montre que vous portez.\n\nSouhaitez-vous en configurer un ?\n\n(Vous pouvez retrouver ce réglage à tout moment dans le menu des paramètres)';

  @override
  String get soldStatusPopupDialogText =>
      'Vous marquez cette montre comme vendue :\n\nVous pouvez maintenant ajouter une date de vente, un prix de vente et des informations sur l\'acheteur dans les onglets « Calendrier » et « Valeur ».';

  @override
  String get preorderStatusPopupDialogTitle => 'Montres en précommande';

  @override
  String get preorderStatusPopupDialogText =>
      'Vous marquez cette montre comme précommandée :\n\nVous pouvez maintenant ajouter une date d\'échéance dans l\'onglet « Calendrier ».\nCela activera un compte à rebours jusqu\'à la date prévue.';

  @override
  String get noImagesFoundPopupTitle => 'Aucune image trouvée';

  @override
  String get noImagesFoundPopupText =>
      'Aucune sauvegarde n\'a été générée car aucune image de montre n\'a été identifiée.';

  @override
  String get failedToBackupImagesDialogTitle =>
      'Échec de la sauvegarde des images';

  @override
  String failedToBackupImagesDialogText(Object error) {
    return 'Impossible de sauvegarder les images, l\'erreur suivante a été renvoyée :\n$error';
  }

  @override
  String imageBackupSuccessDialogText(Object count) {
    return '$count images sauvegardées avec succès';
  }

  @override
  String get watchboxSuccessfullyBackedUpText =>
      'Boîte à montres sauvegardée avec succès';

  @override
  String get extractSuccessfullyCreatedDialogText =>
      'Extraction créée avec succès';

  @override
  String get generalErrorDialogTitle => 'Une erreur est survenue !';

  @override
  String generalErrorDialogText(Object error) {
    return 'Une erreur inattendue s\'est produite avec le message : $error';
  }

  @override
  String get proDialogText =>
      'Ceci est une fonctionnalité WristTrack Pro.\n\nPour en savoir plus et passer à la version supérieure, cliquez ci-dessous.';
}
