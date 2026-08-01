// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get watchBox => 'Watch Box';

  @override
  String get favouriteWatches => 'Orologi Preferiti';

  @override
  String get wishlist => 'Lista dei desideri';

  @override
  String get preOrders => 'Pre-ordini';

  @override
  String get retiredWatches => 'Orologi Ritirati';

  @override
  String get onLoanWatches => 'Orologi in Prestito';

  @override
  String get randomWatch => 'Orologio Casuale';

  @override
  String get statusInCollection => 'In Collezione';

  @override
  String get statusSold => 'Venduto';

  @override
  String get statusWishlist => 'Lista dei desideri';

  @override
  String get statusPreOrder => 'Pre-ordine';

  @override
  String get statusRetired => 'Ritirato';

  @override
  String get statusArchived => 'Archiviato';

  @override
  String get statusOnLoan => 'In Prestito';

  @override
  String get collection => 'Collezione';

  @override
  String get stats => 'Statistiche';

  @override
  String get calendar => 'Calendario';

  @override
  String get time => 'Tempo';

  @override
  String get more => 'Altro';

  @override
  String get settings => 'Impostazioni';

  @override
  String get appData => 'Dati App';

  @override
  String get privacy => 'Privacy';

  @override
  String get removeAds => 'Rimuovi Pubblicità';

  @override
  String get support => 'Sostieni WristTrack';

  @override
  String get review => 'Lascia una recensione';

  @override
  String get about => 'Informazioni';

  @override
  String get follow => 'Segui WristTrack';

  @override
  String get email => 'Feedback via Email';

  @override
  String get visitWristTrackWeb => 'Visita www.wristtrack.app';

  @override
  String get aboutWristTrack => 'Su WristTrack';

  @override
  String get aboutTheDeveloper => 'Sviluppatore';

  @override
  String get acknowledgements => 'Ringraziamenti';

  @override
  String get versionHistory => 'Cronologia Versioni';

  @override
  String get viewOptionsPageTitle => 'Opzioni di Visualizzazione';

  @override
  String get collectionDisplaySectionTitle => 'Visualizzazione Collezione';

  @override
  String get collectionDisplayShowAsList => 'Mostra come lista';

  @override
  String get collectionDisplayShowAsGrid => 'Mostra come griglia';

  @override
  String get collectionOrderSectionTitle => 'Ordinamento Collezione';

  @override
  String get collectionInOrderOfEntry => 'In ordine di inserimento';

  @override
  String get collectionInReverseOrderOfEntry =>
      'In ordine inverso di inserimento';

  @override
  String get collectionOrderAZ => 'A-Z per produttore';

  @override
  String get collectionOrderZA => 'Z-A per produttore';

  @override
  String get collectionOrderMostWorn => 'Ordina per più indossati';

  @override
  String get collectionOrderLastWornDate => 'Ordina per data ultimo indosso';

  @override
  String get startPageSectionTitle => 'Pagina Iniziale';

  @override
  String get startPageWatchCollection => 'Collezione Orologi';

  @override
  String get startPageCalendarView => 'Vista Calendario';

  @override
  String get startPageTimeSetting => 'Impostazioni Orario';

  @override
  String get calendarOptionsSectionTitle => 'Opzioni Calendario';

  @override
  String get firstDayOfTheWeekText => 'Primo giorno della settimana: ';

  @override
  String get themeSectionTitle => 'Tema Chiaro / Scuro';

  @override
  String get matchSystem => 'Segui Sistema';

  @override
  String get lightTheme => 'Tema Chiaro';

  @override
  String get darkTheme => 'Tema Scuro';

  @override
  String get wrUnitsSectionTitle => 'Unità WR';

  @override
  String get languageLink => 'Lingua';

  @override
  String get reminderLink => 'Promemoria Giornaliero';

  @override
  String get currencyLink => 'Opzioni Valuta';

  @override
  String get chartOptionsLink => 'Opzioni Grafici';

  @override
  String get appPreferencesLink => 'Preferenze App';

  @override
  String get showArchiveLink => 'Mostra Orologi Archiviati';

  @override
  String get showDemoLink => 'Mostra Demo Iniziale';

  @override
  String get appUserIDTitle => 'ID Utente App';

  @override
  String get appVersion => 'Versione App: ';

  @override
  String get unknownAppVersionText => 'Non determinata';

  @override
  String get wearStatsButton => 'Statistiche Utilizzo';

  @override
  String get collectionStatsButton => 'Statistiche Collezione';

  @override
  String get wristRecap => 'Wrist Recap';

  @override
  String get recapOptionsTitle => 'Impostazioni Wrist Recap';

  @override
  String get recapMonthly => 'Mensile';

  @override
  String get recapAnnually => 'Annuale';

  @override
  String get watchesWornTitle => 'Orologi indossati:';

  @override
  String get brandChartTitle => 'Grafico Marche';

  @override
  String get categoryChartTitle => 'Grafico Categorie';

  @override
  String get wearChartTitle => 'Grafico Utilizzo';

  @override
  String get statusChartTitle => 'Grafico Stato';

  @override
  String get insightsTitle => 'Approfondimenti';

  @override
  String get watchesWornInsightTitle => 'Orologi indossati';

  @override
  String get totalWearsInsightTitle => 'Totale indossi tracciati';

  @override
  String get wearsPerDayInsightTitle => 'Indossi al giorno';

  @override
  String get topBrandInsightTitle => 'Marca Migliore';

  @override
  String get topCategoryInsightTitle => 'Categoria Migliore';

  @override
  String get topWatchMonthlyTitle => 'Miglior Orologio per Mese';

  @override
  String get topBrandMonthlyTitle => 'Miglior Marca per Mese';

  @override
  String get topCategoryMonthlyTitle => 'Miglior Categoria per Mese';

  @override
  String get collectionMovementTitle => 'Movimento Collezione';

  @override
  String nWatchesBought(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orologi acquistati',
      one: '1 orologio acquistato',
      zero: 'Nessun orologio acquistato',
    );
    return '$_temp0';
  }

  @override
  String nWatchesSold(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orologi venduti',
      one: '1 orologio venduto',
      zero: 'Nessun orologio venduto',
    );
    return '$_temp0';
  }

  @override
  String get recapNoData => 'Nessun dato tracciato per il periodo selezionato.';

  @override
  String cmPurchasedOn(Object shortDate) {
    return 'Acquistato il $shortDate';
  }

  @override
  String cmSoldOn(Object shortDate) {
    return 'Venduto il $shortDate';
  }

  @override
  String wornPercentage(Object returnText) {
    return 'Percentuale Utilizzo: $returnText';
  }

  @override
  String get recapNotificationTitle => 'Nuovo Wrist Recap disponibile!';

  @override
  String get recapNotificationSubtitle =>
      'Clicca per vedere le statistiche del mese scorso';

  @override
  String get recapNotificationSubtitleAnnual =>
      'Clicca per vedere le statistiche dell\'anno scorso';

  @override
  String get recapAdPromptTitle => 'Grazie per aver usato WristTrack';

  @override
  String get recapAdPromptSubtitle =>
      'Per favore, considera di cliccare sul pulsante play per guardare una breve pubblicità opzionale per supportare l\'app';

  @override
  String get recapAdPromptBody1 =>
      'WristTrack fa affidamento sulle donazioni e sulle entrate pubblicitarie per prosperare. Guardare un annuncio significa molto per me ed è, spero, solo un piccolo inconveniente per te.';

  @override
  String get recapAdPromptBody2 =>
      'In alternativa, perché non considerare di sbloccare WristTrack Pro con una donazione? Clicca sull\'icona per saperne di più';

  @override
  String get recapThanksSubtitle => 'Il tuo supporto è davvero apprezzato!';

  @override
  String get lastSync => 'Ultima Sincronizzazione:';

  @override
  String get deviation => 'Deviazione orario di sistema:';

  @override
  String get inProgress =>
      'Sincronizzazione in corso - visualizzazione orario di sistema...';

  @override
  String get beepCountdown => 'Conto alla rovescia sonoro';

  @override
  String get timeFormat => 'Formato 24 ore';

  @override
  String get timeSettingsTitle => 'Impostazioni Orario';

  @override
  String get realisticMoonLabel => 'Luna Realistica';

  @override
  String get timeViewMoonPhase => 'Fase Lunare';

  @override
  String get timeViewGMT => 'GMT';

  @override
  String get gmtTimeOffsetLabel => 'Fuso orario:';

  @override
  String get moonPhase => 'Fase Lunare Attuale';

  @override
  String get newMoon => 'Luna Nuova';

  @override
  String get waxingCrescent => 'Luna Crescente';

  @override
  String get firstQuarter => 'Primo Quarto';

  @override
  String get waxingGibbous => 'Gibbosa Crescente';

  @override
  String get fullMoon => 'Luna Piena';

  @override
  String get waningGibbous => 'Gibbosa Calante';

  @override
  String get lastQuarter => 'Ultimo Quarto';

  @override
  String get waningCrescent => 'Luna Calante';

  @override
  String get gallery => 'Galleria';

  @override
  String get timeline => 'Cronologia';

  @override
  String get merchStore => 'Negozio';

  @override
  String get opensInBrowser => '(si apre nel browser)';

  @override
  String lastWorn(Object shortDate) {
    return 'Ultimo indosso: $shortDate';
  }

  @override
  String get wornToday => 'Indossato oggi';

  @override
  String get wearToday => 'Indossalo oggi';

  @override
  String editTitle(Object watchName) {
    return 'Modifica: $watchName';
  }

  @override
  String get addWatch => 'Aggiungi Orologio';

  @override
  String get addOptionalDetails => 'Aggiungi dettagli opzionali?';

  @override
  String get addedToWatchbox => 'aggiunto alla scatola';

  @override
  String get favouriteLabel => 'Preferito';

  @override
  String wearFrequency(Object returnText) {
    return 'Tempo al polso: $returnText%';
  }

  @override
  String get caseDiameterRowTitle => 'Diametro Cassa (mm):';

  @override
  String get caseDiameterRowHintText => 'Diametro Cassa';

  @override
  String get caseThicknessRowTitle => 'Spessore Cassa (mm):';

  @override
  String get caseThicknessRowHintText => 'Spessore Cassa';

  @override
  String get lastServicedDateRowTitle => 'Data Ultima Revisione:';

  @override
  String get lastServicedDateRowHintText => 'Data Ultima Revisione';

  @override
  String get lug2lugRowTitle => 'Lug to Lug (mm):';

  @override
  String get lug2lugRowHintText => 'Lug to Lug';

  @override
  String get lugWidthRowTitle => 'Larghezza Ansa (mm):';

  @override
  String get lugWidthHintText => 'Larghezza Ansa';

  @override
  String get manufacturerRowTitle => 'Produttore:';

  @override
  String get manufacturerRowHintText => 'Produttore';

  @override
  String get modelRowTitle => 'Modello:';

  @override
  String get modelRowHintText => 'Modello';

  @override
  String get purchaseDateRowTitle => 'Data d\'Acquisto:';

  @override
  String get purchaseDateRowHintText => 'Data d\'Acquisto';

  @override
  String get purchasePriceRowTitle => 'Prezzo d\'Acquisto:';

  @override
  String get purchasePriceRowHintText => 'Prezzo d\'Acquisto';

  @override
  String get purchasedFromRowTitle => 'Acquistato da:';

  @override
  String get purchasedFromHintText => 'Acquistato da';

  @override
  String get referenceNumberRowTitle => 'Referenza:';

  @override
  String get referenceNumberOptionalTitle => 'Referenza (Opzionale):';

  @override
  String get referenceNumberRowHelpText => 'Numero di Referenza';

  @override
  String get serialNumberRowTitle => 'Numero di Serie:';

  @override
  String get serialNumberOptionalTitle => 'Numero di Serie (Opzionale):';

  @override
  String get serialNumberRowHintText => 'Numero di Serie';

  @override
  String get soldDateRowTitle => 'Data di Vendita:';

  @override
  String get soldDateRowHintText => 'Data di Vendita';

  @override
  String get soldPriceRowTitle => 'Prezzo di Vendita:';

  @override
  String get soldPriceRowHintText => 'Prezzo di Vendita';

  @override
  String get soldToRowTitle => 'Venduto a:';

  @override
  String get soldToRowHintText => 'Venduto a';

  @override
  String get warrantyEndRowTitle => 'Scadenza Garanzia:';

  @override
  String get warrantyEndRowHintText => 'Data Scadenza Garanzia';

  @override
  String waterResistanceRowTitle(Object units) {
    return 'Resistenza all\'Acqua $units:';
  }

  @override
  String get waterResistanceRowHintText => 'Resistenza all\'Acqua';

  @override
  String get movementRowTitle => 'Movimento:';

  @override
  String get categoryRowTitle => 'Categoria:';

  @override
  String get watchDetailsSectionTitle => 'Dettagli Orologio';

  @override
  String get caseMaterialRowTitle => 'Materiale Cassa:';

  @override
  String get winderSettingsSectionTitle => 'Impostazioni Scatola del Tempo';

  @override
  String get tpdRowTitle => 'TPD (Giri al giorno):';

  @override
  String get winderDirectionRowTitle => 'Direzione rotazione:';

  @override
  String get dateComplicationRowTitle => 'Complicazione Data:';

  @override
  String get notesRowTitle => 'Note:';

  @override
  String get notesRowHintText => 'Note';

  @override
  String get costPerWearRowTitle => 'Costo per Indosso:';

  @override
  String get accuracyRowTitle => 'Accuratezza:';

  @override
  String get preOrderDueDateRowTitle => 'Data Consegna:';

  @override
  String get preOrderDueDateRowHintText => 'Data Consegna';

  @override
  String get timeInCollectionRowTitle => 'Tempo in Collezione';

  @override
  String get serviceIntervalRowTitle => 'Intervallo Revisione:';

  @override
  String get serviceIntervalRowHintText => 'Intervallo Revisione (anni)';

  @override
  String get nextServiceDueRowTitle => 'Prossima Revisione:';

  @override
  String get nextServiceDueRowHintText => 'Prossima Revisione';

  @override
  String get mustBeNumber2decimals =>
      'Inserire solo numeri con massimo due decimali';

  @override
  String get mustBeWholeNumberLessThan99 =>
      'Inserire un numero intero inferiore a 99';

  @override
  String get manufacturerInvalidError =>
      'Produttore mancante o caratteri non validi';

  @override
  String get modelInvalidError => 'Modello mancante o caratteri non validi';

  @override
  String get digitsNoDecimalsError => 'Inserire solo cifre, senza decimali';

  @override
  String get invalidCharactersDetected => 'Caratteri non validi rilevati.';

  @override
  String get referenceNumberErrorText =>
      'Referenza mancante o caratteri non validi';

  @override
  String get serialNumberErrorText =>
      'Il numero di serie contiene caratteri non validi';

  @override
  String get mustBeAValidWholeNumber => 'Inserire un numero intero valido';

  @override
  String get mustBe099orBlank => 'Inserire un valore tra 0-99 o lasciare vuoto';

  @override
  String get infoTabLabel => 'Info';

  @override
  String get scheduleTabLabel => 'Date';

  @override
  String get valueTabLabel => 'Valore';

  @override
  String get proDataTabLabel => 'Dati Pro';

  @override
  String get notesTabLabel => 'Note';

  @override
  String get all => 'Tutti';

  @override
  String get january => 'Gennaio';

  @override
  String get february => 'Febbraio';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Aprile';

  @override
  String get may => 'Maggio';

  @override
  String get june => 'Giugno';

  @override
  String get july => 'Luglio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Settembre';

  @override
  String get october => 'Ottobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Dicembre';

  @override
  String get day => 'Giorno';

  @override
  String get month => 'Mese';

  @override
  String get year => 'Anno';

  @override
  String get monday => 'Lunedì';

  @override
  String get tuesday => 'Martedì';

  @override
  String get wednesday => 'Mercoledì';

  @override
  String get thursday => 'Giovedì';

  @override
  String get friday => 'Venerdì';

  @override
  String get saturday => 'Sabato';

  @override
  String get sunday => 'Domenica';

  @override
  String get filter => 'Filtro:';

  @override
  String get wearsByDay => 'Indossi per Giorno';

  @override
  String get wearsByMonth => 'Indossi per Mese';

  @override
  String get wearsByYear => 'Indossi per Anno';

  @override
  String get thisYear => 'Quest\'anno';

  @override
  String get lastYear => 'L\'anno scorso';

  @override
  String get last12Months => 'Ultimi 12 mesi';

  @override
  String get last90days => 'Ultimi 90 giorni';

  @override
  String get emptyWearListWatchCharts =>
      'Non hai ancora tracciato alcun indosso per questo orologio.\n\nTraccia i dati cliccando \'indossato oggi\' nella pagina dell\'orologio, o aggiungi date tramite il calendario.\n\nUna volta tracciati, qui appariranno dei grafici con il riepilogo per mese e giorno della settimana.';

  @override
  String get wearChartFiltersSheetTitle => 'Filtri Grafico Utilizzo';

  @override
  String get showAll => 'Mostra tutto';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String get lastMonth => 'Mese scorso';

  @override
  String get last30days => 'Ultimi 30 giorni';

  @override
  String get last365days => 'Ultimi 365 giorni';

  @override
  String get sinceLastPurchase => 'Dall\'ultimo acquisto';

  @override
  String get selectMonthYear => 'Seleziona Mese/Anno';

  @override
  String get betweenSelectedDates => 'Tra le date selezionate';

  @override
  String get monthColon => 'Mese:';

  @override
  String get yearColon => 'Anno:';

  @override
  String get startDate => 'Data Inizio:';

  @override
  String get endDate => 'Data Fine:';

  @override
  String get resetToDefaults => 'Ripristina Predefiniti';

  @override
  String get chartGrouping => 'Raggruppamento Grafico';

  @override
  String get includeCurrentCollection => 'Includi Collezione Attuale';

  @override
  String get includeSoldWatches => 'Includi Orologi Venduti';

  @override
  String get includeRetiredWatches => 'Includi Orologi Ritirati';

  @override
  String get includeArchivedWatches => 'Includi Orologi Archiviati';

  @override
  String get includeOnLoanWatches => 'Includi Orologi in Prestito';

  @override
  String get includeWishlistedWatches => 'Includi Lista Desideri';

  @override
  String get filterByCategory => 'Filtra per Categoria';

  @override
  String get filterByMovement => 'Filtra per Movimento';

  @override
  String get allData => 'Tutti i Dati';

  @override
  String get wornThisYear => 'Indossati quest\'anno';

  @override
  String get wornThisMonth => 'Indossati questo mese';

  @override
  String get wornLastMonth => 'Indossati il mese scorso';

  @override
  String get wornLastYear => 'Indossati l\'anno scorso';

  @override
  String get wornInLast30Days => 'Indossati negli ultimi 30 giorni';

  @override
  String get wornInLast90Days => 'Indossati negli ultimi 90 giorni';

  @override
  String get wornInLast365Days => 'Indossati negli ultimi 365 giorni';

  @override
  String wornBetweenDates(Object shortDate, Object shortDate2) {
    return 'Indossati tra il $shortDate e il $shortDate2';
  }

  @override
  String yearSelected(Object yearValue) {
    return 'Anno: $yearValue';
  }

  @override
  String monthSelected(Object monthValue) {
    return 'Mese: $monthValue';
  }

  @override
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate) {
    return '$returnText Ultimo Acquisto: $shortDate, ';
  }

  @override
  String advancedFilterHeaderGrouping(Object filterText, Object returnText) {
    return '$returnText Raggruppa per $filterText, ';
  }

  @override
  String advancedFilterHeaderCategories(Object filterText, Object returnText) {
    return '$returnText Categorie($filterText), ';
  }

  @override
  String advancedFilterHeaderMovements(Object filterText, Object returnText) {
    return '$returnText Movimenti($filterText), ';
  }

  @override
  String advancedFilterHeaderHideCollection(Object returnText) {
    return '$returnText nascondi Collezione, ';
  }

  @override
  String advancedFilterHeaderIncSold(Object returnText) {
    return '$returnText inc. Venduti, ';
  }

  @override
  String advancedFilterHeaderIncRetired(Object returnText) {
    return '$returnText inc. Ritirati, ';
  }

  @override
  String advancedFilterHeaderIncArchived(Object returnText) {
    return '$returnText inc. Archiviati, ';
  }

  @override
  String advancedFilterHeaderIncOnLoan(Object returnText) {
    return '$returnText inc. In Prestito, ';
  }

  @override
  String get chartsEmptyBackgroundText =>
      'Nessun dato disponibile per il filtro scelto';

  @override
  String get generatedWithWristTrackPro =>
      'Grafico generato con WristTrack Pro';

  @override
  String get generatedWithWristTrack => 'Grafico generato con WristTrack';

  @override
  String get pieChart => 'Grafico a torta';

  @override
  String get barChart => 'Grafico a barre';

  @override
  String get chartOptionsPageTitle => 'Opzioni Grafici';

  @override
  String get wearChartsDefaultFilterSectionTitle =>
      'Filtro predefinito statistiche indossi';

  @override
  String get wearChartsFilterGuidanceText =>
      'Imposta il filtro predefinito per la pagina delle statistiche di indosso.\nIl grafico può comunque essere aggiornato con filtri diversi, ma verrà caricato inizialmente con questo predefinito.';

  @override
  String get showAllRecordedWears => 'Mostra tutti gli indossi registrati';

  @override
  String get wearStatsResultsOrderSectionTitle =>
      'Ordine risultati statistiche indossi';

  @override
  String get wearStatsResultsOrderGuidanceText =>
      'Imposta l\'ordine predefinito dei risultati nel grafico - di base gli orologi sono elencati nello stesso ordine selezionato per la vista collezione, ma possono anche essere visualizzati in ordine crescente o decrescente.';

  @override
  String get showResultsInCollectionOrder => 'Mostra in ordine di collezione';

  @override
  String get showResultsAscendingByWearCount =>
      'Ordine crescente per numero indossi';

  @override
  String get showResultsDescendingByWearCount =>
      'Ordine decrescente per numero indossi';

  @override
  String get defaultChartTypeSectionTitle => 'Tipo di grafico predefinito';

  @override
  String get defaultChartTypeGuidanceText =>
      'Seleziona il tipo di grafico predefinito.\nPuò essere cambiato anche nella vista del grafico e verrà ricordato l\'ultimo tipo utilizzato.';

  @override
  String get watch => 'Orologio';

  @override
  String get movement => 'Movimento';

  @override
  String get category => 'Categoria';

  @override
  String get manufacturer => 'Produttore';

  @override
  String get caseMaterial => 'Materiale Cassa';

  @override
  String get dateComplication => 'Complicazione Data';

  @override
  String get pageTitleCollectionStats => 'Statistiche Collezione';

  @override
  String get labelCharts => 'Grafici';

  @override
  String get labelInfo => 'Info';

  @override
  String get labelValue => 'Dati Valore';

  @override
  String get collectionCost => 'Costo Collezione Attuale';

  @override
  String get noValue => 'Nessun valore inserito';

  @override
  String get totalSpend => 'Spesa Totale Collezione';

  @override
  String get totalSold => 'Valore Totale Venduto';

  @override
  String get averageResale => 'Media Rivendita %';

  @override
  String get noDataTracked => 'Nessun dato tracciato';

  @override
  String get resaleRatio => 'Rapporto Rivendita =';

  @override
  String get sizeOfCollection => 'Dimensione Collezione';

  @override
  String get oldestWatch => 'Orologio più vecchio';

  @override
  String get newestWatch => 'Orologio più nuovo';

  @override
  String get mostWorn => 'Più indossato';

  @override
  String get leastWorn => 'Meno indossato';

  @override
  String get wishListCount => 'Orologi nella lista desideri';

  @override
  String get soldWatches => 'Orologi venduti';

  @override
  String get noPurchaseDatesTracked => 'Nessuna data d\'acquisto tracciata';

  @override
  String get upgradeToProForMoreCharts =>
      'Passa a WristTrack Pro per altri grafici qui...';

  @override
  String get movements => 'Movimenti';

  @override
  String get categories => 'Categorie';

  @override
  String get dateComplications => 'Complicazioni Data';

  @override
  String get caseDiameter => 'Diametro Cassa';

  @override
  String get lugWidth => 'Larghezza Ansa';

  @override
  String get lugToLug => 'Lug to Lug';

  @override
  String get caseThickness => 'Spessore Cassa';

  @override
  String get waterResistance => 'Resistenza all\'Acqua';

  @override
  String get caseMaterials => 'Materiali Cassa';

  @override
  String get costPerWear => 'Costo per Indosso';

  @override
  String timeInCollectionDays(num count) {
    return '$count giorni';
  }

  @override
  String timeInCollectionYears(num count) {
    return '$count+ anni';
  }

  @override
  String get timeInCollectionThreePlusMonths => '3+ mesi';

  @override
  String get timeInCollectionSixPlusMonths => '6+ mesi';

  @override
  String get timeInCollectionNinePlusMonths => '9+ mesi';

  @override
  String get showPaymentOptions => 'Mostra Opzioni di Pagamento';

  @override
  String get donateAgain => 'Dona ancora';

  @override
  String get removeAdsMainCopy =>
      'Le funzioni principali di **WristTrack** sono gratuite, supportate da piccoli annunci pubblicitari.\n\nTuttavia, puoi rimuovere la pubblicità scegliendo un prezzo per l\'app qui sotto - tutte le opzioni aggiorneranno l\'app a **WristTrack Pro**.\n\n**WristTrack Pro** sblocca anche:\n\n* L\'opzione per impostare un secondo promemoria giornaliero\n* Grafici individuali per orologio con statistiche per mese e giorno\n* Campi dati e grafici aggiuntivi';

  @override
  String get supporterCopy =>
      'Grazie per aver sostenuto WristTrack!\n\nIl tuo supporto significa molto e mi permette di continuare a sviluppare WristTrack e altre app simili.\n\nSe ti piace l\'app, per favore dillo ai tuoi amici o lascia una recensione per farmi sapere cosa ti piace e cosa vorresti vedere aggiunto!\n\nSe desideri continuare a sostenere WristTrack, puoi fare donazioni aggiuntive in qualsiasi momento.';

  @override
  String get purchaseRestored => 'Acquisto Ripristinato';

  @override
  String get youreAdFree => 'Ora sei senza pubblicità!';

  @override
  String get restoreFailed => 'Ripristino Fallito';

  @override
  String get noPurchaseFound =>
      'Nessun acquisto precedente o attivo trovato per l\'utente';

  @override
  String get restorePurchase => 'Ripristina Stato Acquisto';

  @override
  String get noOptionsFound => 'Nessuna opzione trovata, riprova più tardi';

  @override
  String get supportWristTrack => 'Sostieni WristTrack';

  @override
  String get payWhatYouLike =>
      'Paga quanto vuoi! Scegli un\'opzione per passare a WristTrack Pro';

  @override
  String get noDataRecorded => 'Nessun dato registrato';

  @override
  String get warning => 'Attenzione';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sì';

  @override
  String get noThanks => 'No grazie';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get done => 'Fatto';

  @override
  String get tellMeMore => 'Dimmi di più';

  @override
  String get showMore => 'Mostra altro';

  @override
  String get showLess => 'Mostra meno';

  @override
  String get soldSuffix => '(Venduto)';

  @override
  String get retiredSuffix => '(Ritirato)';

  @override
  String get archivedSuffix => '(Archiviato)';

  @override
  String get onLoanSuffix => '(In Prestito)';

  @override
  String get goProTitle => 'Passa a Pro!';

  @override
  String get watchColon => 'Orologio:';

  @override
  String get deleting => 'Eliminazione in corso';

  @override
  String get errorHeader => 'Errore';

  @override
  String get dontShowThisMessageAgain => 'Non mostrare più questo messaggio';

  @override
  String get success => 'Successo!';

  @override
  String get today => 'Oggi';

  @override
  String get notWornYet => 'Non ancora indossato';

  @override
  String lastWornDate(Object shortDate) {
    return 'Ultima volta al polso: $shortDate';
  }

  @override
  String wearCount(num count) {
    return 'Indossato $count volte';
  }

  @override
  String get notRecorded => 'Non registrato';

  @override
  String soldDetails(Object price, Object shortDate) {
    return 'Venduto il $shortDate \nper $price';
  }

  @override
  String get countDownNA => 'Conto alla rovescia: N/A';

  @override
  String dueInXDays(Object nDays) {
    return 'Scadenza: $nDays';
  }

  @override
  String overdueXDays(Object nDays) {
    return 'In ritardo di: $nDays';
  }

  @override
  String get basic => 'Base';

  @override
  String get advanced => 'Avanzato';

  @override
  String get na => 'N/A';

  @override
  String schedule(Object nYears) {
    return 'Ogni $nYears';
  }

  @override
  String get meters => 'metri';

  @override
  String get feet => 'piedi';

  @override
  String get backupRestore => 'Backup / Ripristino Database';

  @override
  String get altExports => 'Esportazioni Alternative';

  @override
  String get dataImport => 'Importazione Dati';

  @override
  String get deleteCollection => 'Elimina Collezione';

  @override
  String get backupRestoreHeader => 'Backup / Ripristino';

  @override
  String get backup => 'Backup';

  @override
  String get restore => 'Ripristina';

  @override
  String get backupDatabase => 'Esegui Backup Database';

  @override
  String get restoreDatabase => 'Ripristina Database';

  @override
  String get pleaseSelectFile => 'Seleziona il file di backup';

  @override
  String get selectFile => 'Seleziona File di Backup';

  @override
  String get fileSelected => 'File selezionato: ';

  @override
  String get readyToLoad => 'Pronto per il caricamento';

  @override
  String get restoreFromBackup => 'Ripristina dal Backup';

  @override
  String get backupWatchImages => 'Backup Immagini Orologi';

  @override
  String get simpleExtractButton => 'Estrazione Semplice (CSV)';

  @override
  String get detailedExtractButton => 'Estrazione Dettagliata (CSV)';

  @override
  String get wristTrackProFeature => 'Funzione WristTrack Pro';

  @override
  String get proFeature => 'Funzione Pro';

  @override
  String get track => 'Traccia';

  @override
  String get trackWear => 'Metti al polso';

  @override
  String get removeWear => 'Rimuovi orologio';

  @override
  String get removeDate => 'Rimuovi Data';

  @override
  String get date => 'Data:';

  @override
  String get pickWatch => 'Scegli Orologio';

  @override
  String get pleaseSelectAWatch => 'Seleziona un orologio';

  @override
  String get searchByName => 'Cerca per nome';

  @override
  String get deleteWear => 'Elimina Registrazione Indosso';

  @override
  String get deleteFromCalendar => 'Elimina Indosso dal Calendario';

  @override
  String get addWearToCalendar => 'Aggiungi Indosso al Calendario';

  @override
  String get serviceDue => 'Revisione Scaduta';

  @override
  String get warrantyExpires => 'Garanzia in Scadenza';

  @override
  String get deliveryExpected => 'consegna prevista';

  @override
  String get longPressToAddRemove =>
      'Premi a lungo per aggiungere/rimuovere date di indosso';

  @override
  String get tapToAddMultipleDates => 'Tocca qui per aggiungere date multiple';

  @override
  String get deleteDate => 'Elimina Data';

  @override
  String watchWorn(Object watchName) {
    return '$watchName indossato';
  }

  @override
  String get noDatesForWatch => 'Nessuna data registrata per questo orologio.';

  @override
  String get allDatesWorn => 'Tutte le date di indosso';

  @override
  String get selectDatesToAdd => 'Seleziona Date da Aggiungere';

  @override
  String get selectionMode => 'Modalità Selezione';

  @override
  String get rangeDefinition => 'Intervallo (seleziona inizio e fine)';

  @override
  String get individualSelectionDefinition =>
      'Individuale (scegli date multiple)';

  @override
  String get thereWasAProblemWithSomeDates =>
      'C\'è stato un problema con alcune date';

  @override
  String get dateAlreadyExists => 'La data esiste già';

  @override
  String get dateIsInTheFuture => 'La data è nel futuro';

  @override
  String get watchAccuracy => 'Accuratezza Orologio';

  @override
  String get accuracyTracker => 'Tracciatore Accuratezza';

  @override
  String timeSynced(Object timeStamp) {
    return 'Tempo sincronizzato con il server: \n$timeStamp';
  }

  @override
  String get showAccuracyResultsOptions => 'Mostra risultati in secondi per:';

  @override
  String get baseLineMeasurement => 'Misurazione di riferimento:';

  @override
  String get setBaseLineGuide =>
      'Imposta un nuovo riferimento se hai appena regolato l\'ora del tuo orologio';

  @override
  String lastBaseLine(Object timeStamp) {
    return 'Ultimo Riferimento: $timeStamp';
  }

  @override
  String get addCheckPoint => 'Aggiungi Punto di Controllo:';

  @override
  String get seconds => 'Secondi:';

  @override
  String get saved => 'Salvato!';

  @override
  String get record => 'Record';

  @override
  String get records => 'Record';

  @override
  String get baseLine => 'Riferimento';

  @override
  String get result => 'Risultato';

  @override
  String get noRecordsTracked => 'Nessun record tracciato';

  @override
  String get measurementInProgress => 'Misurazione in corso...';

  @override
  String get noRateFound => 'Nessuna frequenza trovata';

  @override
  String get systemTimeInUse => '... in uso ora di sistema';

  @override
  String get accuracyHelpTextIntro =>
      'Traccia l\'accuratezza dei tuoi orologi creando dei punti di controllo - WristTrack può confrontare la variazione dell\'ora sul tuo orologio con quella dell\'orologio atomico e calcolare se guadagna o perde tempo\n\n';

  @override
  String get accuracyHelpTextBaselines =>
      '**Riferimenti**\n\nQuando imposti un punto di controllo come riferimento, tutte le misurazioni successive saranno confrontate con esso. Dovresti impostare un nuovo riferimento ogni volta che regoli manualmente l\'orologio dopo l\'ultimo riferimento.\n\nSe non hai record salvati, il primo risultato è sempre contrassegnato come record di riferimento.\n\n';

  @override
  String get accuracyHelpTextAddAMeasurement =>
      '**Acquisizione di una Misurazione**\n\nPer acquisire un dato, imposta l\'ora sotto \'aggiungi punto di controllo\' in modo che corrisponda a quella che sarà sull\'orologio (di base è un minuto avanti) e premi il pulsante \'00 secondi\' quando la lancetta dei secondi raggiunge le ore dodici. In alternativa, imposta l\'ora corrispondente all\'orologio e usa i pulsanti \'15/30/45 secondi\' quando la lancetta passa su quei valori.\n\nI tempi acquisiti appariranno nella sezione \'Record\' qui sotto, insieme all\'accuratezza calcolata dall\'ultimo record di riferimento (nessun valore di accuratezza è mostrato per i riferimenti).\n\n';

  @override
  String get accuracyHelpTextDeletingARecord =>
      '**Eliminazione di un Record**\n\nSe acquisisci un record per errore, puoi eliminarlo scorrendo verso sinistra nella lista \'Record\'.\n\n';

  @override
  String get accuracyHelpTextWhenToCapture =>
      '**Quando acquisire i record**\n\nPiù tempo passa tra il riferimento e la misurazione, più precisi saranno i risultati (poiché i piccoli ritardi nel premere i pulsanti diventano meno influenti). Come guida, è utile lasciare 12-24 ore tra le misurazioni.\n\n';

  @override
  String get accuracyHelpTextOutro =>
      '_*Puoi riaprire questo riquadro informativo in qualsiasi momento premendo il punto interrogativo in alto a destra nella pagina*_\n\n ';

  @override
  String secondsPerUnit(Object rateUnit) {
    return 'secondi/$rateUnit';
  }

  @override
  String get servicingTab => 'Revisione';

  @override
  String get warrantyTab => 'Garanzia';

  @override
  String get helpTab => 'Aiuto';

  @override
  String nextServiceBy(Object timeStamp) {
    return 'Prossima revisione entro: $timeStamp';
  }

  @override
  String warrantyExpiresOn(Object timeStamp) {
    return 'Scadenza garanzia il: $timeStamp';
  }

  @override
  String get emptyServiceText =>
      'Nessun dato di revisione da mostrare\n\nPer popolare il programma di revisione, aggiungi le date di acquisto, le date di revisione e gli intervalli di manutenzione ai tuoi orologi.\n\n';

  @override
  String get emptyWarrantyText =>
      'Nessun dato di garanzia da mostrare\n\nPer popolare la scadenza delle garanzie, aggiungi la data di fine garanzia ai tuoi orologi.\n';

  @override
  String get serviceScheduleHelpText =>
      'Programma Revisioni e Garanzie\n\n Questa pagina ti permette di visualizzare un programma delle date di revisione tracciate (calcolate in base alle date e alle frequenze inserite) e le scadenze delle garanzie inserite manualmente per i tuoi orologi.\n';

  @override
  String get pass => 'Passato';

  @override
  String get fail => 'Fallito';

  @override
  String get partialPass => 'Passato Parzialmente';

  @override
  String get duplicateFound => 'Duplicato Trovato';

  @override
  String get successSubtitle =>
      'Tutti i campi dell\'orologio validati con successo';

  @override
  String get failureSubtitle =>
      'Questo record non può essere caricato. Produttore o modello non determinabili.';

  @override
  String get partialPassSubtitle =>
      'Alcuni campi non hanno superato la validazione e saranno ignorati se non corretti';

  @override
  String get duplicateFoundSubtitle =>
      'Esiste già un record nell\'app con questa marca e modello. Assicurati che sia univoco';

  @override
  String get clockwise => 'Orario';

  @override
  String get counterClockwise => 'Antiorario';

  @override
  String get both => 'Entrambi';

  @override
  String get dateComplicationsDate => 'Data';

  @override
  String get dateComplicationsNoDate => 'Senza Data';

  @override
  String get dateComplicationsDayDate => 'Giorno-Data';

  @override
  String get dateComplicationsPointerDate => 'Lancetta Data';

  @override
  String get dateComplicationsSubDialDate => 'Sotto-quadrante Data';

  @override
  String get dateComplicationsPerpetualDate => 'Calendario Perpetuo';

  @override
  String get dateComplicationsDigitalDate => 'Data Digitale';

  @override
  String get emptyWatchboxCopy =>
      'La tua scatola degli orologi è vuota.\n\nPremi il pulsante rosso per aggiungere orologi alla tua collezione\n\nImposta le preferenze dell\'app, come il formato valuta, premendo l\'icona dell\'ingranaggio in alto a destra';

  @override
  String get emptySoldCopy =>
      'Non hai orologi venduti nella tua collezione.\n\nPuoi contrassegnare un orologio come venduto modificandone lo stato.\n';

  @override
  String get emptyWishlistCopy =>
      'Non stai tracciando orologi nella tua lista dei desideri.\n\nPer aggiungere un orologio alla lista, crea un nuovo record e imposta lo stato su \'Lista dei desideri\'.\n';

  @override
  String get emptyFavouritesCopy =>
      'Non hai ancora orologi contrassegnati come \'preferiti\'. \n\nPer farlo, usa l\'interruttore nella schermata dei dettagli dell\'orologio.\n';

  @override
  String get emptyPreOrderCopy =>
      'Non stai tracciando pre-ordini di orologi. \n\nPer tracciare un conto alla rovescia per un orologio pre-ordinato, crea un nuovo record con lo stato \'pre-ordine\'.';

  @override
  String get emptyOnLoanCopy =>
      'Al momento non hai orologi contrassegnati come \'In Prestito\'.\n\nPuoi contrassegnare un orologio come in prestito modificandone lo stato.';

  @override
  String get listViewTitle => 'Lista';

  @override
  String get gridViewTitle => 'Griglia';

  @override
  String get displayOrderTitle => 'Ordine di Visualizzazione:';

  @override
  String get inOrderOfEntry => 'In ordine di inserimento';

  @override
  String get inReverseOrderOfEntry => 'In ordine inverso di inserimento';

  @override
  String get azByManufacturer => 'A-Z per produttore';

  @override
  String get zaByManufacturer => 'Z-A per produttore';

  @override
  String get orderByMostWorn => 'Ordina per più indossati';

  @override
  String get orderByLastWornDate => 'Ordina per data ultimo indosso';

  @override
  String get showLastWornDateOption => 'Mostra date ultimo indosso';

  @override
  String get showWearCountOption => 'Mostra numero indossi';

  @override
  String get showWearFrequencyOption => 'Mostra frequenza indosso';

  @override
  String watchNamePurchased(Object watchName) {
    return '$watchName acquistato';
  }

  @override
  String watchNameSold(Object watchName) {
    return '$watchName venduto';
  }

  @override
  String watchNamePreOrderDue(Object watchName) {
    return 'consegna prevista $watchName';
  }

  @override
  String watchNameLastServiced(Object watchName) {
    return '$watchName ultima revisione';
  }

  @override
  String watchNameNextService(Object watchName) {
    return '$watchName prossima revisione';
  }

  @override
  String watchNameWarrantyExpires(Object watchName) {
    return '$watchName scadenza garanzia';
  }

  @override
  String get timelineSettings => 'Impostazioni Cronologia';

  @override
  String get orderAscending => 'Ordine: Crescente.';

  @override
  String get orderDescending => 'Ordine: Decrescente.';

  @override
  String get showWatchesPurchased => 'Mostra orologi acquistati.';

  @override
  String get showWatchesSold => 'Mostra orologi venduti.';

  @override
  String get showPreOrderDueDates => 'Mostra date di consegna pre-ordini.';

  @override
  String get showLastServicedDates => 'Mostra date ultime revisioni.';

  @override
  String get showNextServiceDates => 'Mostra date prossime revisioni.';

  @override
  String get showWarrantyEndDates => 'Mostra date scadenza garanzie.';

  @override
  String get timelineEmptyData =>
      'Nessun dato trovato da visualizzare.\n\nAggiungi le date nella scheda \'date\' dei tuoi orologi per popolare la cronologia.';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get privacySettings => 'Impostazioni Privacy';

  @override
  String get privacySettingsUpdated =>
      'Le tue scelte sulla privacy sono state aggiornate';

  @override
  String get privacyError =>
      'Si è verificato un errore durante l\'aggiornamento delle impostazioni sulla privacy - riprova';

  @override
  String get anAppForEnthusiasts =>
      'Un\'app per appassionati di orologi. \nScorri per scoprire cosa può fare WristTrack...';

  @override
  String get yourDigitalWatchbox => 'La tua Scatola Digitale';

  @override
  String get recordAllYourWatches =>
      'Registra tutti i tuoi orologi - cerca velocemente, riorganizza o ricevi un suggerimento casuale';

  @override
  String get trackTheDetail => 'Traccia i Dettagli';

  @override
  String get categoriseAndCaptureTheDetails =>
      'Categorizza e cattura i particolari dei tuoi orologi, o aggiungi le tue note';

  @override
  String get analyseTheData => 'Analizza i Dati';

  @override
  String get getInsightsWithDataAndCharts =>
      'Ottieni approfondimenti sulla tua collezione tramite dati e grafici';

  @override
  String get letsGo => 'Cominciamo!';

  @override
  String get skip => 'SALTA';

  @override
  String get next => 'AVANTI';

  @override
  String get primaryImage => 'Immagine Principale';

  @override
  String get updateImage => 'Aggiorna Immagine';

  @override
  String get deleteImage => 'Elimina Immagine';

  @override
  String imageBottomSheetTitle(Object count, Object watchName) {
    return '$watchName\nImmagine $count';
  }

  @override
  String get takeWithCamera => 'Scatta con la Fotocamera';

  @override
  String get selectFromGallery => 'Scegli dalla Galleria';

  @override
  String get cropImage => 'Ritaglia Immagine';

  @override
  String get longPressToEditOrDelete => 'Long press per modificare o eliminare';

  @override
  String watchGallery(Object watchName) {
    return 'Foto di $watchName';
  }

  @override
  String get galleryTitle => 'Galleria Orologi';

  @override
  String get galleryEmptyFilterReturn =>
      'Nessuna immagine trovata per questo filtro';

  @override
  String galleryError(Object error) {
    return 'Si è verificato un errore: $error';
  }

  @override
  String get galleryCollectionTab => 'Orologi in Collezione';

  @override
  String get galleryArchivedTab => 'Orologi Archiviati';

  @override
  String get galleryWishlistedWatchesTab => 'Orologi nella Lista Desideri';

  @override
  String get galleryEverythingTab => 'Tutto';

  @override
  String get notRecordedBrackets => '(Non registrato)';

  @override
  String gallerySubHeaderInCollection(Object returnText, Object watchStatus) {
    return '$watchStatus - $returnText';
  }

  @override
  String gallerySubHeaderSold(Object shortDate, Object watchStatus) {
    return '$watchStatus\nVenduto il: $shortDate';
  }

  @override
  String gallerySubHeaderPreOrder(Object shortDate, Object watchStatus) {
    return '$watchStatus\nScadenza: $shortDate';
  }

  @override
  String get currencyOptionsTitle => 'Opzioni Valuta';

  @override
  String get currencyOptionsGuideText =>
      'WristTrack può tracciare i valori degli orologi e delle collezioni, e li visualizzerà in un formato valuta a tua scelta.\n\nNota: Tutti i valori degli orologi dovrebbero essere salvati nella stessa valuta per permettere calcoli accurati.';

  @override
  String get currencyPleaseSelect => 'Seleziona il formato valuta preferito:';

  @override
  String get currencyExample => 'Esempio di output';

  @override
  String get currencyAdditionRequest =>
      'Manca qualcosa? Contatta lo sviluppatore per fare una richiesta!';

  @override
  String get currencySterling => 'Sterlina Britannica';

  @override
  String get currencyEuroIreland => 'Euro (Irlanda)';

  @override
  String get currencyIndianRupee => 'Rupia Indiana';

  @override
  String get currencyUSDollar => 'Dollaro Americano';

  @override
  String get currencyYen => 'Yen Giapponese';

  @override
  String get currencyEuroTrailing => 'Euro (simbolo alla fine)';

  @override
  String get currencyEuroLeading => 'Euro (simbolo all\'inizio)';

  @override
  String get currencySwissFranc => 'Franco Svizzero';

  @override
  String get currencyHungarianForint => 'Fiorino Ungherese';

  @override
  String get currencyPolishZloty => 'Zloty Polacco';

  @override
  String get currencyThaiBaht => 'Baht Thailandese';

  @override
  String get currencyNorwegianKrone => 'Corona Norvegese';

  @override
  String get currencyCzechKoruna => 'Corona Ceca';

  @override
  String get currencyMalaysianRinggit => 'Ringgit Malese';

  @override
  String get currencyPhilippinePeso => 'Peso Filippino';

  @override
  String get currencyKoreanWon => 'Won Coreano';

  @override
  String get currencyBrazilianReal => 'Real Brasiliano';

  @override
  String get currencyDanishKrone => 'Corona Danese';

  @override
  String get currencySwedishKrona => 'Corona Svedese';

  @override
  String get currencyCanadianDollar => 'Dollaro Canadese';

  @override
  String get caseMaterialNotEntered => 'Non Inserito';

  @override
  String get caseMaterialSteel => 'Acciaio';

  @override
  String get caseMaterialTitanium => 'Titanio';

  @override
  String get caseMaterialGold => 'Oro';

  @override
  String get caseMaterialTwoTone => 'Bicolore';

  @override
  String get caseMaterialPlatinum => 'Platino';

  @override
  String get caseMaterialBronze => 'Bronzo';

  @override
  String get caseMaterialCeramic => 'Ceramica';

  @override
  String get caseMaterialCarbon => 'Carbonio';

  @override
  String get caseMaterialResin => 'Resina';

  @override
  String get caseMaterialPlastic => 'Plastica';

  @override
  String get caseMaterialOther => 'Altro';

  @override
  String get caseMaterialPVDDLC => 'Acciaio PVD/DLC';

  @override
  String get caseMaterialTungsten => 'Tungsteno';

  @override
  String get notSelected => 'Non Selezionata';

  @override
  String get categoryDiver => 'Diver';

  @override
  String get categorySports => 'Sportivo';

  @override
  String get categoryFlight => 'Aviatore';

  @override
  String get categoryField => 'Field';

  @override
  String get categoryDress => 'Dress';

  @override
  String get categoryTool => 'Tool watch';

  @override
  String get categoryChronograph => 'Cronografo';

  @override
  String get categoryTravel => 'Viaggio / GMT';

  @override
  String get notEntered => 'Non Inserito';

  @override
  String get movementMechanicalManual => 'Meccanico - Manuale';

  @override
  String get movementMechanicalAutomatic => 'Meccanico - Automatico';

  @override
  String get movementAnalogueQuartz => 'Quarzo Analogico';

  @override
  String get movementDigitalQuartz => 'Quarzo Digitale';

  @override
  String get movementAnaDigiQuartz => 'Quarzo Ana-Digi';

  @override
  String get movementKinetic => 'Kinetic';

  @override
  String get movementMechaQuartz => 'Mecha-Quartz';

  @override
  String get movementSmartWatch => 'Smartwatch';

  @override
  String get movementTourbillon => 'Tourbillon';

  @override
  String get movementSolarQuartz => 'Quarzo Solare';

  @override
  String get movementTuningFork => 'Diapason';

  @override
  String get other => 'Altro';

  @override
  String get movementSpringDrive => 'Spring Drive';

  @override
  String get archiveScreenTitle => 'Orologi Archiviati';

  @override
  String get archiveEmptyMessage => 'Il tuo archivio è vuoto';

  @override
  String get archiveDeleteDialogConfirmTitle => 'Conferma Eliminazione';

  @override
  String archiveDeleteDialogConfirmText(Object watchName) {
    return 'Sei sicuro di voler eliminare $watchName? Questa azione non può essere annullata.';
  }

  @override
  String get archiveRestoreDialogTitle => 'Ripristina Orologio';

  @override
  String archiveRestoreDialogText(Object watchName) {
    return 'Vuoi ripristinare $watchName?';
  }

  @override
  String get archiveRestoreDialogStatusPicker => 'Ripristina allo stato:';

  @override
  String get archiveRestoreButtonLabel => 'Ripristina';

  @override
  String get archiveBackgroundRestoreLabel => 'Ripristino in corso...';

  @override
  String get archiveBackgroundDeleteLabel => 'Eliminazione in corso...';

  @override
  String get enableDailyWearReminder => 'Attiva Promemoria Giornaliero';

  @override
  String get morning => 'Mattina (8:00)';

  @override
  String get afternoon => 'Pomeriggio (12:00)';

  @override
  String get evening => 'Sera (18:00)';

  @override
  String get customTime => 'Ora Personalizzata';

  @override
  String yourReminderIsSetForTime(Object hourTimeStamp) {
    return 'Il tuo promemoria giornaliero è previsto per le $hourTimeStamp';
  }

  @override
  String yourSecondReminderIsSetFor(Object hourTimeStamp) {
    return 'Il tuo secondo promemoria è impostato per le $hourTimeStamp';
  }

  @override
  String get notificationTitle => 'Promemoria WristTrack';

  @override
  String get notificationOneBody =>
      'Non dimenticare di registrare cosa indossi oggi!';

  @override
  String notificationConfirmationBody(Object hourTimeStamp) {
    return 'I tuoi promemoria sono stati programmati per le $hourTimeStamp ogni giorno!';
  }

  @override
  String get notificationTwoBody => 'È ora di registrare cosa hai al polso!';

  @override
  String notificationTwoConfirmationBody(Object hourTimeStamp) {
    return 'Il tuo secondo promemoria è impostato per le $hourTimeStamp ogni giorno!';
  }

  @override
  String get enableSecondDailyWearReminder => 'Attiva Secondo Promemoria';

  @override
  String get search => 'Cerca';

  @override
  String get searchOptionsTitle => 'Opzioni di Ricerca';

  @override
  String get searchByNotesLabel => 'Cerca nelle note';

  @override
  String get searchByLugWidthLabel => 'Cerca per larghezza ansa';

  @override
  String get noResultsFound => 'Nessun Risultato Trovato';

  @override
  String nWears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Indossato $countString volte',
      one: 'Indossato 1 volta',
      zero: 'Nessuna registrazione',
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
      other: '$countString orologi',
      one: '1 orologio',
      zero: 'Nessun orologio',
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
      other: '$countString giorni',
      one: '1 giorno',
      zero: '0 giorni',
    );
    return '$_temp0';
  }

  @override
  String nYears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString anni',
      one: '1 anno',
      zero: '0 anni',
    );
    return '$_temp0';
  }

  @override
  String get deleteWarning =>
      'Premendo OK eliminerai tutti i dati degli orologi, inclusa la lista dei desideri e tutte le immagini salvate\n \n L\'AZIONE NON È ANNULLABILE';

  @override
  String get backupInstruction =>
      'Premi il pulsante qui sotto per creare una copia del database dell\'app (può richiedere alcuni secondi!). \n\nUna volta creato, apparirà un pop-up per scegliere dove inviare il file di backup.';

  @override
  String get imageBackupInstructions =>
      'Le immagini degli orologi possono essere esportate separatamente.';

  @override
  String get altExtractsGuidance =>
      '**Estrazioni Dati Alternative**\n\nQueste opzioni permettono di estrarre i dati dei tuoi orologi e degli indossi da **WristTrack**.\n\nServono per liberare i tuoi dati, non come backup _(usa le opzioni Backup/Ripristino se vuoi semplicemente spostare i dati tra dispositivi)._\n\nL\'estrazione semplice fornisce una lista di tutti i dati degli orologi, inclusi conteggio indossi e note **(una riga per orologio)**.\n\nL\'estrazione dettagliata fornisce una riga di dati per ogni **data di indosso tracciata** e include solo gli orologi registrati come indossati **(righe multiple per orologio)**.\n\nQuesti dati grezzi sono in formato CSV, facilmente importabili nel tuo foglio di calcolo preferito.';

  @override
  String get watchChartsUpgradeCopy =>
      '**Grafici di Utilizzo Orologio**\n\nI grafici sono una funzione **WristTrack Pro**.\n\nTi permettono di visualizzare grafici che analizzano in quali mesi e giorni è stato indossato l\'orologio.\n\nVuoi saperne di più su **WristTrack Pro**? Clicca il pulsante qui sotto...';

  @override
  String get addWearSnackbarTitle => 'Indosso Registrato';

  @override
  String addWearSnackbarText(Object shortDate, Object watchName) {
    return '$watchName è stato indossato il $shortDate';
  }

  @override
  String get dateDeletedSnackbarTitle => 'Data Eliminata';

  @override
  String dateDeletedSnackbarText(Object shortDate, Object watchName) {
    return '$shortDate è stata rimossa dal record di $watchName';
  }

  @override
  String get collectionDeletedSnackbarTitle => 'Collezione Svuotata';

  @override
  String get collectionDeletedSnackbarText =>
      'La tua collezione di orologi è ora vuota';

  @override
  String get deleteWatchPermanentlySnackbarTitle => 'Orologio Eliminato';

  @override
  String deleteWatchPermanentlySnackbarText(Object watchName) {
    return '$watchName è stato eliminato permanentemente';
  }

  @override
  String get restoreWatchSnackbarTitle => 'Orologio Ripristinato';

  @override
  String restoreWatchSnackbarText(Object returnText, Object watchName) {
    return '$watchName è stato ripristinato con lo stato $returnText';
  }

  @override
  String get reminderSetSnackbarTitle => 'Promemoria Impostato';

  @override
  String reminderSetSnackbarText(Object returnText) {
    return 'Riceverai un promemoria ogni giorno alle $returnText';
  }

  @override
  String get copiedSnackbarTitle => 'Copiato';

  @override
  String get appUserIDCopiedSnackbarText => 'ID Utente salvato negli appunti';

  @override
  String get serviceIntervalTitle => 'Intervallo Revisione';

  @override
  String get serviceIntervalText =>
      'Impostando un intervallo di revisione, verrà calcolata una \'data prevista revisione\' visualizzata nella schermata Revisioni dell\'app (purché sia impostata la data d\'acquisto o l\'ultima revisione).\n\nPuoi lasciare il valore a zero per disattivarlo per questo orologio.';

  @override
  String get duplicateWearTitle => 'Avviso Data Duplicata';

  @override
  String get duplicateWearText =>
      'Sembra che tu abbia già indossato questo orologio nella data indicata! \n \nSe vuoi registrare un indosso aggiuntivo, seleziona \'Aggiungi ancora\'. \n \nAltrimenti annulla per tornare indietro.';

  @override
  String get duplicateWearConfirm => 'Aggiungi ancora';

  @override
  String get collectionStatsDialogTitle => 'Statistiche Collezione';

  @override
  String get collectionStatsDialogText =>
      'Tutti i valori si basano sui dati della tua collezione.\n\nI calcoli basati sulle date (come \'orologio più vecchio\') sono precisi solo quanto i dati inseriti nell\'app.\n\nPuoi modificare i dati dei singoli orologi navigando verso di essi dalle schermate principali.';

  @override
  String get archivedHelpDialogTitle => 'Archivio Orologi';

  @override
  String get archivedHelpDialogText =>
      'Quando lo stato di un orologio è \'Archiviato\', viene rimosso dalla collezione principale e spostato qui.\n\nGli orologi in archivio possono essere eliminati permanentemente con uno scorrimento a sinistra o ripristinati nella scatola scorrendo a destra.';

  @override
  String get backupHelpDialogTitle => 'Aiuto Backup Database';

  @override
  String get backupHelpDialogText =>
      'Nuovo telefono o vuoi solo un backup di sicurezza?\n Sei nel posto giusto!\n\nCrea un backup della tua scatola o ripristina una copia esistente.\n\nNota: Il ripristino del database cancellerà tutti i dati esistenti e li SOSTITUIRÀ con il backup.\n\nIn caso di problemi durante il processo, prova a chiudere e riavviare l\'app.';

  @override
  String get incorrectFilenameDialogTitle => 'File non corretto';

  @override
  String incorrectFilenameDialogText(Object fileName) {
    return 'Il file $fileName non corrisponde al file atteso watchbox.hive\n\nSeleziona un file watchbox.hive';
  }

  @override
  String get confirmRestoreDialogTitle => 'Ripristina dal Backup';

  @override
  String get confirmRestoreDialogText =>
      'Il ripristino sovrascriverà la tua attuale collezione.\n\nVuoi continuare?';

  @override
  String get restoreFailedTitle => 'Ripristino Fallito';

  @override
  String restoreFailedText(Object error) {
    return 'Ripristino dal backup fallito, si è verificato un errore:\n\n$error\n\nRiprova - se il problema persiste contatta lo sviluppatore';
  }

  @override
  String get restoreSuccessDialogTitle => 'Ripristino Completato';

  @override
  String get restoreSuccessDialogText =>
      'Database ripristinato con successo!\n\nSe gli orologi non appaiono subito, prova a navigare tra le schede principali.';

  @override
  String get backupLocationNullDialogText =>
      'Nessuna posizione di backup specificata. Seleziona prima dove salvare il file.';

  @override
  String backupFailedDialogText(Object error) {
    return 'Backup Fallito\n\n$error\n\nPotrebbe essere che la posizione scelta non sia accessibile. Prova con una posizione diversa.\n\nSe non funziona, fornisci un feedback allo sviluppatore tramite l\'app store.';
  }

  @override
  String watchboxFailedErrorDialog(Object error) {
    return 'Impossibile riaprire la scatola\n\n$error\n\nAlcuni errori possono essere risolti riavviando l\'applicazione.\n\nSe non funziona, contatta lo sviluppatore.';
  }

  @override
  String get backupCompleteDialogTitle => 'Backup Completato';

  @override
  String get backupCompleteDialogText =>
      'I dati della scatola orologi sono stati salvati.';

  @override
  String get wristTrackUpdatedBottomSheetTitle =>
      'WristTrack è stata appena aggiornata...';

  @override
  String get futureDateErrorDialogText =>
      'Le date di indosso devono essere nel passato, seleziona una data diversa.';

  @override
  String get notificationSettingsHelpDialogTitle => 'Impostazioni Notifiche';

  @override
  String get notificationsSettingsHelpDialogText =>
      'Se abilitata, una notifica verrà attivata ogni giorno all\'ora selezionata.';

  @override
  String get notificationSettingsHelpDialogTextAndroid =>
      '\n\nNota: Alcuni produttori utilizzano versioni personalizzate di Android che potrebbero limitare la capacità dell\'app di generare notifiche in background.\n\nPurtroppo, come sviluppatore, non è possibile evitarlo. \n\nÈ noto che questo accada su telefoni Huawei e Xiaomi, ma potrebbe riguardare anche altri. ';

  @override
  String get wearDatesHelpDialogTitle => 'Cronologia Utilizzo';

  @override
  String get wearDatesHelpDialogText =>
      'Questo calendario mostra le date in cui l\'orologio è stato indossato e altre date tracciate.\n\nPer aggiungere o eliminare date di indosso, tieni premuto su una singola data.';

  @override
  String get deleteImageDialogTitle => 'Elimina Immagine';

  @override
  String get deleteImageDialogText =>
      'Vuoi eliminare questa immagine?\nL\'azione non può essere annullata';

  @override
  String get deleteWatchTitle => 'Elimina Orologio';

  @override
  String get deleteWatchDialogText =>
      'Vuoi rimuovere questo orologio dalla tua collezione?\n\n(Gli orologi eliminati per errore possono essere ripristinati dall\'Archivio nelle Impostazioni)';

  @override
  String get deleteWatchSnackbarConfirmation => 'Orologio Eliminato';

  @override
  String deleteWatchSnackbarText(Object watchName) {
    return '$watchName è stato spostato nell\'Archivio';
  }

  @override
  String get failedToPickImageDialogTitle => 'Errore Selezione Immagine';

  @override
  String failedToPickImageDialogText(Object error) {
    return 'La piattaforma ha riscontrato un errore:\n\n$error';
  }

  @override
  String get setupDailyReminderDialogTitle => 'Imposta Promemoria Giornalieri';

  @override
  String get setupDailyRemindersDialogText =>
      'WristTrack può inviarti un promemoria giornaliero per registrare cosa indossi\n\nVuoi impostarne uno?\n\n(Puoi trovarlo in qualsiasi momento nel menu impostazioni)';

  @override
  String get soldStatusPopupDialogText =>
      'Stai segnando questo orologio come venduto:\n\nOra puoi aggiungere data di vendita, prezzo e info sull\'acquirente nelle schede \'date\' e \'valore\'.';

  @override
  String get preorderStatusPopupDialogTitle => 'Orologi in Pre-ordine';

  @override
  String get preorderStatusPopupDialogText =>
      'Stai segnando questo orologio come Pre-ordinato:\n\nOra puoi aggiungere una data di consegna nella scheda \'date\'.\nQuesto attiverà un conto alla rovescia alla data indicata.';

  @override
  String get noImagesFoundPopupTitle => 'Nessuna Immagine Trovata';

  @override
  String get noImagesFoundPopupText =>
      'Nessun backup generato poiché non sono state identificate immagini di orologi';

  @override
  String get failedToBackupImagesDialogTitle => 'Backup Immagini Fallito';

  @override
  String failedToBackupImagesDialogText(Object error) {
    return 'Impossibile eseguire il backup delle immagini, errore:\n$error';
  }

  @override
  String imageBackupSuccessDialogText(Object count) {
    return '$count immagini salvate correttamente';
  }

  @override
  String get watchboxSuccessfullyBackedUpText =>
      'Backup della scatola completato';

  @override
  String get extractSuccessfullyCreatedDialogText =>
      'Estrazione creata con successo';

  @override
  String get generalErrorDialogTitle => 'Qualcosa è andato storto!';

  @override
  String generalErrorDialogText(Object error) {
    return 'An unexpected error occured with message: $error';
  }

  @override
  String get proDialogText =>
      'Questa è una funzione WristTrack Pro.\n\nPer saperne di più e passare a Pro, clicca qui sotto.';

  @override
  String get saveUpdates => 'Salva Aggiornamenti';

  @override
  String get updatesSaved => 'Aggiornamenti Salvati';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get editWatchUnsavedChangesTitle => 'Hai modifiche non salvate';

  @override
  String get editWatchUnsavedChangesCopy =>
      'Sei sicuro di voler uscire?\nLe modifiche non salvate andranno perse.';

  @override
  String get editWatchUnsavedChangesExitOption => 'Esci senza salvare';

  @override
  String get editWatchUnsavedChangesContinueEditingOption =>
      'Continua a modificare';
}
