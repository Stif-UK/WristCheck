// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get watchBox => 'Caja de Relojes';

  @override
  String get favouriteWatches => 'Relojes Favoritos';

  @override
  String get wishlist => 'Lista de Deseos';

  @override
  String get preOrders => 'Preventas';

  @override
  String get retiredWatches => 'Relojes Retirados';

  @override
  String get onLoanWatches => 'Relojes Prestados';

  @override
  String get randomWatch => 'Reloj Aleatorio';

  @override
  String get statusInCollection => 'En la Colección';

  @override
  String get statusSold => 'Vendido';

  @override
  String get statusWishlist => 'Lista de Deseos';

  @override
  String get statusPreOrder => 'Preventa';

  @override
  String get statusRetired => 'Retirado';

  @override
  String get statusArchived => 'Archivado';

  @override
  String get statusOnLoan => 'Prestado';

  @override
  String get collection => 'Colección';

  @override
  String get stats => 'Estadísticas';

  @override
  String get calendar => 'Calendario';

  @override
  String get time => 'Hora';

  @override
  String get more => 'Más';

  @override
  String get settings => 'Ajustes';

  @override
  String get appData => 'Datos de la App';

  @override
  String get privacy => 'Privacidad';

  @override
  String get removeAds => 'Eliminar Anuncios';

  @override
  String get support => 'Apoyar a WristTrack';

  @override
  String get review => 'Dejar una reseña de la app';

  @override
  String get about => 'Acerca de';

  @override
  String get follow => 'Seguir a WristTrack';

  @override
  String get email => 'Comentarios por Correo';

  @override
  String get visitWristTrackWeb => 'Visitar www.wristtrack.app';

  @override
  String get aboutWristTrack => 'Acerca de WristTrack';

  @override
  String get aboutTheDeveloper => 'Acerca del Desarrollador';

  @override
  String get acknowledgements => 'Agradecimientos';

  @override
  String get versionHistory => 'Historial de Versiones';

  @override
  String get viewOptionsPageTitle => 'Opciones de Vista';

  @override
  String get collectionDisplaySectionTitle => 'Visualización de la Colección';

  @override
  String get collectionDisplayShowAsList => 'Mostrar colección como lista';

  @override
  String get collectionDisplayShowAsGrid => 'Mostrar colección como cuadrícula';

  @override
  String get collectionOrderSectionTitle => 'Orden de la colección';

  @override
  String get collectionInOrderOfEntry => 'Por orden de entrada';

  @override
  String get collectionInReverseOrderOfEntry => 'Por orden inverso de entrada';

  @override
  String get collectionOrderAZ => 'A-Z por fabricante';

  @override
  String get collectionOrderZA => 'Z-A por fabricante';

  @override
  String get collectionOrderMostWorn => 'Ordenar por más usados';

  @override
  String get collectionOrderLastWornDate => 'Ordenar por fecha de último uso';

  @override
  String get startPageSectionTitle => 'Página de Inicio';

  @override
  String get startPageWatchCollection => 'Colección de Relojes';

  @override
  String get startPageCalendarView => 'Vista de Calendario';

  @override
  String get startPageTimeSetting => 'Ajustes de Hora';

  @override
  String get calendarOptionsSectionTitle => 'Opciones de Calendario';

  @override
  String get firstDayOfTheWeekText => 'Primer día de la semana: ';

  @override
  String get themeSectionTitle => 'Tema Claro / Oscuro';

  @override
  String get matchSystem => 'Igual al Sistema';

  @override
  String get lightTheme => 'Tema Claro';

  @override
  String get darkTheme => 'Tema Oscuro';

  @override
  String get wrUnitsSectionTitle => 'Unidades de WR';

  @override
  String get languageLink => 'Idioma';

  @override
  String get reminderLink => 'Recordatorio Diario';

  @override
  String get currencyLink => 'Opciones de Moneda';

  @override
  String get chartOptionsLink => 'Opciones de Gráficos';

  @override
  String get appPreferencesLink => 'Preferencias de la App';

  @override
  String get showArchiveLink => 'Mostrar Relojes Archivados';

  @override
  String get showDemoLink => 'Mostrar Demo de Primer Uso';

  @override
  String get appUserIDTitle => 'ID de Usuario de la App';

  @override
  String get appVersion => 'Versión de la App: ';

  @override
  String get unknownAppVersionText => 'No determinada';

  @override
  String get wearStatsButton => 'Estadísticas de Uso';

  @override
  String get collectionStatsButton => 'Estadísticas de la Colección';

  @override
  String get wristRecap => 'Resumen de Muñeca';

  @override
  String get recapOptionsTitle => 'Ajustes de Wrist Recap';

  @override
  String get recapMonthly => 'Mensual';

  @override
  String get recapAnnually => 'Anual';

  @override
  String get watchesWornTitle => 'Relojes usados:';

  @override
  String get brandChartTitle => 'Gráfico de marcas';

  @override
  String get categoryChartTitle => 'Gráfico de categorías';

  @override
  String get wearChartTitle => 'Gráfico de uso';

  @override
  String get statusChartTitle => 'Gráfico de estado';

  @override
  String get insightsTitle => 'Estadísticas';

  @override
  String get watchesWornInsightTitle => 'Relojes usados';

  @override
  String get totalWearsInsightTitle => 'Total de usos';

  @override
  String get wearsPerDayInsightTitle => 'Usos por día';

  @override
  String get topBrandInsightTitle => 'Marca principal';

  @override
  String get topCategoryInsightTitle => 'Categoría principal';

  @override
  String get topWatchMonthlyTitle => 'Reloj principal por mes';

  @override
  String get topBrandMonthlyTitle => 'Marca principal por mes';

  @override
  String get topCategoryMonthlyTitle => 'Categoría principal por mes';

  @override
  String get collectionMovementTitle => 'Movimiento de la colección';

  @override
  String nWatchesBought(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count relojes comprados',
      one: '1 reloj comprado',
      zero: 'Ningún reloj comprado',
    );
    return '$_temp0';
  }

  @override
  String nWatchesSold(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count relojes vendidos',
      one: '1 reloj vendido',
      zero: 'Ningún reloj vendido',
    );
    return '$_temp0';
  }

  @override
  String get recapNoData =>
      'No se registraron datos para el periodo seleccionado.';

  @override
  String cmPurchasedOn(Object shortDate) {
    return 'Comprado el $shortDate';
  }

  @override
  String cmSoldOn(Object shortDate) {
    return 'Vendido el $shortDate';
  }

  @override
  String wornPercentage(Object returnText) {
    return 'Porcentaje de uso: $returnText';
  }

  @override
  String get recapNotificationTitle => '¡Nuevo Wrist Recap disponible!';

  @override
  String get recapNotificationSubtitle =>
      'Haz clic para ver las estadísticas del mes pasado';

  @override
  String get recapNotificationSubtitleAnnual =>
      'Haz clic para ver las estadísticas del año pasado';

  @override
  String get lastSync => 'Última Sincronización:';

  @override
  String get deviation => 'Desviación de la hora del sistema:';

  @override
  String get inProgress =>
      'Sincronización en progreso - mostrando hora del sistema...';

  @override
  String get beepCountdown => 'Cuenta Atrás con Pitido';

  @override
  String get timeFormat => 'Formato de 24 horas';

  @override
  String get timeSettingsTitle => 'Ajustes de hora';

  @override
  String get realisticMoonLabel => 'Luna realista';

  @override
  String get timeViewMoonPhase => 'Fase lunar';

  @override
  String get timeViewGMT => 'GMT';

  @override
  String get gmtTimeOffsetLabel => 'Desplazamiento horario:';

  @override
  String get moonPhase => 'Fase Lunar Actual';

  @override
  String get newMoon => 'Luna nueva';

  @override
  String get waxingCrescent => 'Luna creciente';

  @override
  String get firstQuarter => 'Cuarto creciente';

  @override
  String get waxingGibbous => 'Luna gibosa creciente';

  @override
  String get fullMoon => 'Luna llena';

  @override
  String get waningGibbous => 'Luna gibosa menguante';

  @override
  String get lastQuarter => 'Cuarto menguante';

  @override
  String get waningCrescent => 'Luna menguante';

  @override
  String get gallery => 'Galería';

  @override
  String get timeline => 'Línea de Tiempo';

  @override
  String get merchStore => 'Tienda';

  @override
  String get opensInBrowser => '(se abre en el navegador)';

  @override
  String lastWorn(Object shortDate) {
    return 'Último uso: $shortDate';
  }

  @override
  String get wornToday => 'Usado Hoy';

  @override
  String get wearToday => 'Usar este reloj hoy';

  @override
  String editTitle(Object watchName) {
    return 'Editar: $watchName';
  }

  @override
  String get addWatch => 'Añadir Reloj';

  @override
  String get addOptionalDetails => '¿Añadir detalles opcionales?';

  @override
  String get addedToWatchbox => 'añadido a la caja de relojes';

  @override
  String get favouriteLabel => 'Favorito';

  @override
  String wearFrequency(Object returnText) {
    return 'Frecuencia de uso: $returnText %';
  }

  @override
  String get caseDiameterRowTitle => 'Diámetro de la Caja (mm):';

  @override
  String get caseDiameterRowHintText => 'Diámetro de la Caja';

  @override
  String get caseThicknessRowTitle => 'Grosor de la Caja (mm):';

  @override
  String get caseThicknessRowHintText => 'Grosor de la Caja';

  @override
  String get lastServicedDateRowTitle => 'Fecha del Último Mantenimiento:';

  @override
  String get lastServicedDateRowHintText => 'Fecha del Último Mantenimiento';

  @override
  String get lug2lugRowTitle => 'Distancia entre Asas (Lug to Lug) (mm):';

  @override
  String get lug2lugRowHintText => 'Distancia entre Asas (Lug to Lug)';

  @override
  String get lugWidthRowTitle => 'Ancho de Asas (mm):';

  @override
  String get lugWidthHintText => 'Ancho de Asas';

  @override
  String get manufacturerRowTitle => 'Fabricante:';

  @override
  String get manufacturerRowHintText => 'Fabricante';

  @override
  String get modelRowTitle => 'Modelo:';

  @override
  String get modelRowHintText => 'Modelo';

  @override
  String get purchaseDateRowTitle => 'Fecha de Compra:';

  @override
  String get purchaseDateRowHintText => 'Fecha de Compra';

  @override
  String get purchasePriceRowTitle => 'Precio de Compra:';

  @override
  String get purchasePriceRowHintText => 'Precio de Compra';

  @override
  String get purchasedFromRowTitle => 'Comprado a:';

  @override
  String get purchasedFromHintText => 'Comprado a';

  @override
  String get referenceNumberRowTitle => 'Número de Referencia:';

  @override
  String get referenceNumberOptionalTitle => 'Número de Referencia (Opcional):';

  @override
  String get referenceNumberRowHelpText => 'Número de Referencia';

  @override
  String get serialNumberRowTitle => 'Número de Serie:';

  @override
  String get serialNumberOptionalTitle => 'Número de Serie (Opcional):';

  @override
  String get serialNumberRowHintText => 'Número de Serie';

  @override
  String get soldDateRowTitle => 'Fecha de Venta:';

  @override
  String get soldDateRowHintText => 'Fecha de Venta';

  @override
  String get soldPriceRowTitle => 'Precio de Venta:';

  @override
  String get soldPriceRowHintText => 'Precio de Venta';

  @override
  String get soldToRowTitle => 'Vendido a:';

  @override
  String get soldToRowHintText => 'Vendido a';

  @override
  String get warrantyEndRowTitle => 'Fecha de Vencimiento de Garantía:';

  @override
  String get warrantyEndRowHintText => 'Fecha de Vencimiento de Garantía';

  @override
  String waterResistanceRowTitle(Object units) {
    return 'Resistencia al Agua $units:';
  }

  @override
  String get waterResistanceRowHintText => 'Resistencia al Agua';

  @override
  String get movementRowTitle => 'Calibre/Movimiento:';

  @override
  String get categoryRowTitle => 'Categoría:';

  @override
  String get watchDetailsSectionTitle => 'Detalles del Reloj';

  @override
  String get caseMaterialRowTitle => 'Material de la Caja:';

  @override
  String get winderSettingsSectionTitle => 'Ajustes del Watch Winder';

  @override
  String get tpdRowTitle => 'TPD (Giros por Día):';

  @override
  String get winderDirectionRowTitle => 'Dirección de Giro:';

  @override
  String get dateComplicationRowTitle => 'Complicación de Fecha:';

  @override
  String get notesRowTitle => 'Notas:';

  @override
  String get notesRowHintText => 'Notas';

  @override
  String get costPerWearRowTitle => 'Coste por Uso:';

  @override
  String get accuracyRowTitle => 'Precisión:';

  @override
  String get preOrderDueDateRowTitle => 'Fecha Estimada:';

  @override
  String get preOrderDueDateRowHintText => 'Fecha Estimada';

  @override
  String get timeInCollectionRowTitle => 'Tiempo en la Colección';

  @override
  String get serviceIntervalRowTitle => 'Intervalo de Mantenimiento:';

  @override
  String get serviceIntervalRowHintText => 'Intervalo de Mantenimiento (años)';

  @override
  String get nextServiceDueRowTitle => 'Próximo Mantenimiento:';

  @override
  String get nextServiceDueRowHintText => 'Próximo Mantenimiento:';

  @override
  String get mustBeNumber2decimals =>
      'Debe contener solo números con hasta dos decimales';

  @override
  String get mustBeWholeNumberLessThan99 =>
      'Debe ser un número entero menor que 99';

  @override
  String get manufacturerInvalidError =>
      'Falta el fabricante o incluye caracteres no válidos';

  @override
  String get modelInvalidError =>
      'Falta el modelo o incluye caracteres no válidos';

  @override
  String get digitsNoDecimalsError =>
      '¡Introduce solo dígitos sin decimales, nosotros nos encargamos del resto!';

  @override
  String get invalidCharactersDetected =>
      'Se detectaron caracteres no válidos.';

  @override
  String get referenceNumberErrorText =>
      'Falta el número de referencia o incluye caracteres no válidos';

  @override
  String get serialNumberErrorText =>
      'El número de serie contiene caracteres no válidos';

  @override
  String get mustBeAValidWholeNumber => 'Debe ser un número entero válido';

  @override
  String get mustBe099orBlank => 'Debe ser entre 0-99 o estar en blanco';

  @override
  String get infoTabLabel => 'Info';

  @override
  String get scheduleTabLabel => 'Fechas';

  @override
  String get valueTabLabel => 'Valor';

  @override
  String get proDataTabLabel => 'Datos Pro';

  @override
  String get notesTabLabel => 'Notas';

  @override
  String get all => 'Todos';

  @override
  String get january => 'Enero';

  @override
  String get february => 'Febrero';

  @override
  String get march => 'Marzo';

  @override
  String get april => 'Abril';

  @override
  String get may => 'Mayo';

  @override
  String get june => 'Junio';

  @override
  String get july => 'Julio';

  @override
  String get august => 'Agosto';

  @override
  String get september => 'Septiembre';

  @override
  String get october => 'Octubre';

  @override
  String get november => 'Noviembre';

  @override
  String get december => 'Diciembre';

  @override
  String get day => 'Día';

  @override
  String get month => 'Mes';

  @override
  String get year => 'Año';

  @override
  String get monday => 'Lunes';

  @override
  String get tuesday => 'Martes';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get thursday => 'Jueves';

  @override
  String get friday => 'Viernes';

  @override
  String get saturday => 'Sábado';

  @override
  String get sunday => 'Domingo';

  @override
  String get filter => 'Filtro:';

  @override
  String get wearsByDay => 'Usos por Día';

  @override
  String get wearsByMonth => 'Usos por Mes';

  @override
  String get wearsByYear => 'Usos por Año';

  @override
  String get thisYear => 'Este Año';

  @override
  String get lastYear => 'El Año Pasado';

  @override
  String get last12Months => 'Últimos 12 Meses';

  @override
  String get last90days => 'Últimos 90 Días';

  @override
  String get emptyWearListWatchCharts =>
      'Aún no has registrado ninguna fecha de uso para este reloj.\n\nRegistra datos haciendo clic en \'Usar este reloj hoy\' en la página del reloj, o añade fechas a través de la vista de calendario.\n\nUna vez registrados, los gráficos se mostrarán aquí desglosando tus registros por mes y día de la semana.';

  @override
  String get wearChartFiltersSheetTitle => 'Filtros de Gráficos de Uso';

  @override
  String get showAll => 'Mostrar todo';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get lastMonth => 'El Mes Pasado';

  @override
  String get last30days => 'Últimos 30 días';

  @override
  String get last365days => 'Últimos 365 días';

  @override
  String get sinceLastPurchase => 'Desde la Última Compra';

  @override
  String get selectMonthYear => 'Seleccionar Mes/Año';

  @override
  String get betweenSelectedDates => 'Entre las fechas seleccionadas';

  @override
  String get monthColon => 'Mes:';

  @override
  String get yearColon => 'Año:';

  @override
  String get startDate => 'Fecha de Inicio:';

  @override
  String get endDate => '  Fecha de Fin:';

  @override
  String get resetToDefaults => 'Restablecer Valores Predeterminados';

  @override
  String get chartGrouping => 'Agrupación del Gráfico';

  @override
  String get includeCurrentCollection => 'Incluir Colección Actual';

  @override
  String get includeSoldWatches => 'Incluir Relojes Vendidos';

  @override
  String get includeRetiredWatches => 'Incluir Relojes Retirados';

  @override
  String get includeArchivedWatches => 'Incluir Relojes Archivados';

  @override
  String get includeOnLoanWatches => 'Incluir Relojes Prestados';

  @override
  String get includeWishlistedWatches => 'Incluir Relojes en Lista de Deseos';

  @override
  String get filterByCategory => 'Filtrar por Categoría';

  @override
  String get filterByMovement => 'Filtrar por Movimiento';

  @override
  String get allData => 'Todos los Datos';

  @override
  String get wornThisYear => 'Usado Este Año';

  @override
  String get wornThisMonth => 'Usado Este Mes';

  @override
  String get wornLastMonth => 'Usado El Mes Pasado';

  @override
  String get wornLastYear => 'Usado El Año Pasado';

  @override
  String get wornInLast30Days => 'Usado en los últimos 30 días';

  @override
  String get wornInLast90Days => 'Usado en los últimos 90 días';

  @override
  String get wornInLast365Days => 'Usado en los últimos 365 días';

  @override
  String wornBetweenDates(Object shortDate, Object shortDate2) {
    return 'Usado entre $shortDate y $shortDate2';
  }

  @override
  String yearSelected(Object yearValue) {
    return 'Año: $yearValue';
  }

  @override
  String monthSelected(Object monthValue) {
    return 'Mes: $monthValue';
  }

  @override
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate) {
    return '$returnText Última Compra: $shortDate, ';
  }

  @override
  String advancedFilterHeaderGrouping(Object filterText, Object returnText) {
    return '$returnText Agrupar por $filterText, ';
  }

  @override
  String advancedFilterHeaderCategories(Object filterText, Object returnText) {
    return '$returnText Categorías($filterText), ';
  }

  @override
  String advancedFilterHeaderMovements(Object filterText, Object returnText) {
    return '$returnText Movimientos($filterText), ';
  }

  @override
  String advancedFilterHeaderHideCollection(Object returnText) {
    return '$returnText ocultar Colección, ';
  }

  @override
  String advancedFilterHeaderIncSold(Object returnText) {
    return '$returnText incl. Vendidos, ';
  }

  @override
  String advancedFilterHeaderIncRetired(Object returnText) {
    return '$returnText incl. Retirados, ';
  }

  @override
  String advancedFilterHeaderIncArchived(Object returnText) {
    return '$returnText incl. Archivados, ';
  }

  @override
  String advancedFilterHeaderIncOnLoan(Object returnText) {
    return '$returnText incl. Prestados, ';
  }

  @override
  String get chartsEmptyBackgroundText =>
      'No hay datos disponibles para el filtro elegido';

  @override
  String get generatedWithWristTrackPro =>
      'Este gráfico fue generado con WristTrack Pro';

  @override
  String get generatedWithWristTrack =>
      'Este gráfico fue generado con WristTrack';

  @override
  String get pieChart => 'Gráfico de Tarta';

  @override
  String get barChart => 'Gráfico de Barras';

  @override
  String get chartOptionsPageTitle => 'Opciones de Gráficos';

  @override
  String get wearChartsDefaultFilterSectionTitle =>
      'Filtro predeterminado de estadísticas de uso';

  @override
  String get wearChartsFilterGuidanceText =>
      'Establece el filtro predeterminado para la página de Estadísticas de Uso.\nEl gráfico se puede actualizar para mostrar diferentes filtros según sea necesario, pero siempre se cargará inicialmente con el valor predeterminado elegido.';

  @override
  String get showAllRecordedWears => 'Mostrar todos los usos registrados';

  @override
  String get wearStatsResultsOrderSectionTitle =>
      'Orden de resultados de estadísticas de uso';

  @override
  String get wearStatsResultsOrderGuidanceText =>
      'Establece el orden predeterminado en el que se muestran los resultados en el gráfico; por defecto, los relojes se enumeran en el mismo orden seleccionado para la vista de la colección, sin embargo, también se pueden mostrar en orden ascendente o descendente.';

  @override
  String get showResultsInCollectionOrder =>
      'Mostrar en el orden de la colección';

  @override
  String get showResultsAscendingByWearCount =>
      'Orden ascendente por número de usos';

  @override
  String get showResultsDescendingByWearCount =>
      'Orden descendente por número de usos';

  @override
  String get defaultChartTypeSectionTitle => 'Tipo de gráfico predeterminado';

  @override
  String get defaultChartTypeGuidanceText =>
      'Selecciona el tipo de gráfico predeterminado.\nEsto también se puede cambiar en la propia vista del gráfico y recordará el último tipo utilizado.';

  @override
  String get watch => 'Reloj';

  @override
  String get movement => 'Movimiento';

  @override
  String get category => 'Categoría';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get caseMaterial => 'Material de la Caja';

  @override
  String get dateComplication => 'Complicación de Fecha';

  @override
  String get pageTitleCollectionStats => 'Estadísticas de la Colección';

  @override
  String get labelCharts => 'Gráficos';

  @override
  String get labelInfo => 'Info';

  @override
  String get labelValue => 'Datos de Valor';

  @override
  String get collectionCost => 'Coste Actual de la Colección';

  @override
  String get noValue => 'Ningún valor registrado';

  @override
  String get totalSpend => 'Gasto Total en la Colección';

  @override
  String get totalSold => 'Valor Total de Ventas';

  @override
  String get averageResale => '% de Reventa Promedio';

  @override
  String get noDataTracked => 'Sin Datos Registrados';

  @override
  String get resaleRatio => 'Ratio de Reventa =';

  @override
  String get sizeOfCollection => 'Tamaño de la Colección';

  @override
  String get oldestWatch => 'Reloj más Antiguo';

  @override
  String get newestWatch => 'Reloj más Reciente';

  @override
  String get mostWorn => 'Más Usado';

  @override
  String get leastWorn => 'Menos Usado';

  @override
  String get wishListCount => 'Relojes en Lista de Deseos';

  @override
  String get soldWatches => 'Relojes Vendidos';

  @override
  String get noPurchaseDatesTracked => 'Sin fechas de compra registradas';

  @override
  String get upgradeToProForMoreCharts =>
      'Actualiza a WristTrack Pro para ver más gráficos aquí...';

  @override
  String get movements => 'Movimientos';

  @override
  String get categories => 'Categorías';

  @override
  String get dateComplications => 'Complicaciones de Fecha';

  @override
  String get caseDiameter => 'Diámetro de la Caja';

  @override
  String get lugWidth => 'Ancho de Asas';

  @override
  String get lugToLug => 'Distancia entre Asas (Lug to Lug)';

  @override
  String get caseThickness => 'Grosor de la Caja';

  @override
  String get waterResistance => 'Resistencia al Agua';

  @override
  String get caseMaterials => 'Materiales de la Caja';

  @override
  String get costPerWear => 'Coste por Uso';

  @override
  String timeInCollectionDays(num count) {
    return '$count días';
  }

  @override
  String timeInCollectionYears(num count) {
    return '$count+ años';
  }

  @override
  String get timeInCollectionThreePlusMonths => '3+ meses';

  @override
  String get timeInCollectionSixPlusMonths => '6+ meses';

  @override
  String get timeInCollectionNinePlusMonths => '9+ meses';

  @override
  String get showPaymentOptions => 'Mostrar Opciones de Pago';

  @override
  String get donateAgain => 'Donar de Nuevo';

  @override
  String get removeAdsMainCopy =>
      'Las funciones principales de **WristTrack** son gratuitas y se financian mediante pequeños anuncios en la aplicación.\n\nSin embargo, puedes eliminar estos anuncios eligiendo un precio para la aplicación a continuación; todas las opciones mejorarán la aplicación a **WristTrack Pro**.\n\n**WristTrack Pro** también desbloquea:\n\n* La opción de configurar un segundo recordatorio diario\n* Gráficos individuales por reloj que muestran estadísticas de uso por meses y días de la semana\n* Campos de datos y gráficos de relojes adicionales';

  @override
  String get supporterCopy =>
      '¡Gracias por apoyar a WristTrack!\n\nTu apoyo significa mucho y hace posible que continúe desarrollando WristTrack y otras aplicaciones similares.\n\nSi estás disfrutando de la aplicación, considera recomendársela a tus amigos o dejar una reseña para contarme qué te gusta de ella y qué más te gustaría que se añadiera.\n\nSi deseas seguir apoyando a WristTrack, puedes realizar donaciones adicionales en cualquier momento.';

  @override
  String get purchaseRestored => 'Compra Restaurada';

  @override
  String get youreAdFree => '¡Ahora estás libre de anuncios!';

  @override
  String get restoreFailed => 'Error al Restaurar';

  @override
  String get noPurchaseFound =>
      'No se encontró ninguna compra previa o activa para el usuario';

  @override
  String get restorePurchase => 'Restaurar Estado de Compra';

  @override
  String get noOptionsFound =>
      'No se encontraron opciones, inténtalo más tarde';

  @override
  String get supportWristTrack => 'Apoyar a WristTrack';

  @override
  String get payWhatYouLike =>
      '¡Paga lo que quieras! Elige cualquier opción para actualizar a WristTrack Pro';

  @override
  String get noDataRecorded => 'Sin Datos Registrados';

  @override
  String get warning => 'Advertencia';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get noThanks => 'No, gracias';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get done => 'Hecho';

  @override
  String get tellMeMore => 'Cuéntame más';

  @override
  String get soldSuffix => '(Vendido)';

  @override
  String get retiredSuffix => '(Retirado)';

  @override
  String get archivedSuffix => '(Archivado)';

  @override
  String get onLoanSuffix => '(Prestado)';

  @override
  String get goProTitle => '¡Pásate a Pro!';

  @override
  String get watchColon => 'Reloj:';

  @override
  String get deleting => 'Eliminando';

  @override
  String get errorHeader => 'Error';

  @override
  String get dontShowThisMessageAgain => 'No volver a mostrar este mensaje';

  @override
  String get success => '¡Éxito!';

  @override
  String get today => 'Hoy';

  @override
  String get notWornYet => 'Aún no se ha usado';

  @override
  String lastWornDate(Object shortDate) {
    return 'Último uso: $shortDate';
  }

  @override
  String wearCount(num count) {
    return 'Usado $count veces';
  }

  @override
  String get notRecorded => 'No Registrado';

  @override
  String soldDetails(Object price, Object shortDate) {
    return 'Vendido el $shortDate \npor $price';
  }

  @override
  String get countDownNA => 'Cuenta atrás: N/D';

  @override
  String dueInXDays(Object nDays) {
    return 'Plazo: $nDays';
  }

  @override
  String overdueXDays(Object nDays) {
    return 'Atrasado: $nDays';
  }

  @override
  String get basic => 'Básico';

  @override
  String get advanced => 'Avanzado';

  @override
  String get na => 'N/D';

  @override
  String schedule(Object nYears) {
    return 'Cada $nYears';
  }

  @override
  String get meters => 'metros';

  @override
  String get feet => 'pies';

  @override
  String get backupRestore => 'Copia de Seguridad / Restaurar Base de Datos';

  @override
  String get altExports => 'Exportaciones Alternativas';

  @override
  String get dataImport => 'Importación de Datos';

  @override
  String get deleteCollection => 'Eliminar Colección';

  @override
  String get backupRestoreHeader => 'Copia de Seguridad / Restaurar';

  @override
  String get backup => 'Copia de Seguridad';

  @override
  String get restore => 'Restaurar';

  @override
  String get backupDatabase => 'Respaldar Base de Datos';

  @override
  String get restoreDatabase => 'Restaurar Base de Datos';

  @override
  String get pleaseSelectFile =>
      'Por favor, selecciona el archivo de copia de seguridad';

  @override
  String get selectFile => 'Seleccionar Archivo de Copia de Seguridad';

  @override
  String get fileSelected => 'Archivo seleccionado: ';

  @override
  String get readyToLoad => 'Listo para cargar';

  @override
  String get restoreFromBackup => 'Restaurar desde Copia de Seguridad';

  @override
  String get backupWatchImages => 'Respaldar Imágenes de Relojes';

  @override
  String get simpleExtractButton => 'Extracción Simple (CSV)';

  @override
  String get detailedExtractButton => 'Extracción Detallada (CSV)';

  @override
  String get wristTrackProFeature => 'Función de WristTrack Pro';

  @override
  String get proFeature => 'Función Pro';

  @override
  String get track => 'Registrar';

  @override
  String get trackWear => 'Registrar Uso';

  @override
  String get removeWear => 'Eliminar Uso';

  @override
  String get removeDate => 'Eliminar Fecha';

  @override
  String get date => 'Fecha:';

  @override
  String get pickWatch => 'Elegir Reloj';

  @override
  String get pleaseSelectAWatch => 'Por favor, selecciona un reloj';

  @override
  String get searchByName => 'Buscar por nombre de reloj';

  @override
  String get deleteWear => 'Eliminar Registro de Uso';

  @override
  String get deleteFromCalendar => 'Eliminar Uso del Calendario';

  @override
  String get addWearToCalendar => 'Añadir Uso al Calendario';

  @override
  String get serviceDue => 'Mantenimiento Pendiente';

  @override
  String get warrantyExpires => 'La Garantía Expira';

  @override
  String get deliveryExpected => 'entrega prevista';

  @override
  String get longPressToAddRemove =>
      'Mantén pulsado para añadir/eliminar fechas de uso';

  @override
  String get tapToAddMultipleDates => 'Toca aquí para añadir varias fechas';

  @override
  String get deleteDate => 'Eliminar Fecha';

  @override
  String watchWorn(Object watchName) {
    return '$watchName usado';
  }

  @override
  String get noDatesForWatch => 'No hay fechas registradas para este reloj.';

  @override
  String get allDatesWorn => 'Todas las fechas de uso';

  @override
  String get selectDatesToAdd => 'Seleccionar Fechas para Añadir';

  @override
  String get selectionMode => 'Modo de Selección';

  @override
  String get rangeDefinition => 'Rango (selecciona inicio y fin del rango)';

  @override
  String get individualSelectionDefinition =>
      'Individual (elige múltiples fechas)';

  @override
  String get thereWasAProblemWithSomeDates =>
      'Hubo un problema con algunas de las fechas';

  @override
  String get dateAlreadyExists => 'La fecha ya existe';

  @override
  String get dateIsInTheFuture => 'La fecha está en el futuro';

  @override
  String get watchAccuracy => 'Precisión del Reloj';

  @override
  String get accuracyTracker => 'Rastreador de Precisión';

  @override
  String timeSynced(Object timeStamp) {
    return 'Hora sincronizada con el servidor: \n$timeStamp';
  }

  @override
  String get showAccuracyResultsOptions =>
      'Mostrar resultados en segundos por:';

  @override
  String get baseLineMeasurement => 'Medición de referencia (Baseline):';

  @override
  String get setBaseLineGuide =>
      'Establece una nueva referencia si acabas de ajustar la hora de tu reloj';

  @override
  String lastBaseLine(Object timeStamp) {
    return 'Última Referencia: $timeStamp';
  }

  @override
  String get addCheckPoint => 'Añadir Punto de Control:';

  @override
  String get seconds => 'Segundos:';

  @override
  String get saved => '¡Guardado!';

  @override
  String get record => 'Registro';

  @override
  String get records => 'Registros';

  @override
  String get baseLine => 'Referencia';

  @override
  String get result => 'Resultado';

  @override
  String get noRecordsTracked => 'No se han rastreado registros';

  @override
  String get measurementInProgress => 'Medición en curso...';

  @override
  String get noRateFound => 'No se encontró ninguna tasa de desviación';

  @override
  String get systemTimeInUse => '... hora del sistema en uso';

  @override
  String get accuracyHelpTextIntro =>
      'Rastrea la precisión de tus relojes creando puntos de control. WristTrack puede comparar el cambio de hora en tu reloj con el cambio de hora del reloj atómico y calcular si está adelantando o retrasando el tiempo.\n\n';

  @override
  String get accuracyHelpTextBaselines =>
      '**Referencias (Baselines)**\n\nCuando estableces un punto de control como referencia, todas las mediciones siguientes se compararán con él. Debes establecer una nueva referencia cada vez que hayas ajustado manualmente tu reloj desde la última referencia.\n\nSi no tienes registros guardados, el primer resultado siempre se etiqueta como un registro de referencia.\n\n';

  @override
  String get accuracyHelpTextAddAMeasurement =>
      '**Capturar una Medición**\n\nPara capturar un punto de datos, ajusta el valor de la hora en \'añadir punto de control\' para que coincida con la que tendrá tu reloj (por defecto se adelanta un minuto) y luego presiona el botón \'00 segundos\' cuando el segundero llegue a las doce en punto. Alternativamente, ajusta la hora para que coincida con tu reloj y usa los botones de \'15/30/45 segundos\' cuando el segundero pase por ahí para capturar la marca de tiempo.\n\nLas horas capturadas aparecerán en la sección \'Registros\' a continuación, junto con una precisión calculada desde el último registro de referencia (no se muestra ningún valor de precisión para las referencias).\n\n';

  @override
  String get accuracyHelpTextDeletingARecord =>
      '**Eliminar un Registro**\n\nSi capturas un registro por error, puedes eliminarlo deslizándolo de derecha a izquierda en la lista de \'Registros\'.\n\n';

  @override
  String get accuracyHelpTextWhenToCapture =>
      '**Cuándo capturar registros**\n\nCuanto más tiempo rastrees el reloj desde la medición de referencia, más precisos serán los resultados (ya que los pequeños retrasos al presionar los botones se vuelven menos significativos). Como guía, es útil dejar pasar entre 12 y 24 horas entre mediciones.\n\n';

  @override
  String get accuracyHelpTextOutro =>
      '_*Puedes volver a abrir este cuadro de información en cualquier momento presionando el signo de interrogación en la parte superior derecha de la página*_\n\n ';

  @override
  String secondsPerUnit(Object rateUnit) {
    return 'segundos/$rateUnit';
  }

  @override
  String get servicingTab => 'Mantenimiento';

  @override
  String get warrantyTab => 'Garantía';

  @override
  String get helpTab => 'Ayuda';

  @override
  String nextServiceBy(Object timeStamp) {
    return 'Próximo Mantenimiento para: $timeStamp';
  }

  @override
  String warrantyExpiresOn(Object timeStamp) {
    return 'La Garantía Expira el: $timeStamp';
  }

  @override
  String get emptyServiceText =>
      'No hay datos de mantenimiento que mostrar\n\nPara poblar un calendario de mantenimiento, añade fechas de compra, fechas de servicio e intervalos de mantenimiento a tus relojes.\n\n';

  @override
  String get emptyWarrantyText =>
      'No hay datos de garantía que mostrar\n\nPara poblar un calendario de vencimiento de garantías, añade valores de fecha de fin de garantía a tus relojes.\n';

  @override
  String get serviceScheduleHelpText =>
      'Calendario de Mantenimiento y Garantía\n\nEsta página te permite ver un calendario de las fechas de mantenimiento rastreadas (calculadas en función de las fechas y frecuencias registradas en tu colección de relojes) y las fechas de finalización de la garantía, basadas en el campo de fecha de finalización de la garantía introducido manualmente para los relojes.\n';

  @override
  String get pass => 'Aprobado';

  @override
  String get fail => 'Fallido';

  @override
  String get partialPass => 'Aprobado Parcial';

  @override
  String get duplicateFound => 'Duplicado Encontrado';

  @override
  String get successSubtitle =>
      'Todos los campos del reloj se han validado correctamente';

  @override
  String get failureSubtitle =>
      'Este registro de reloj no se puede subir. No se puede determinar el fabricante o el modelo del reloj.';

  @override
  String get partialPassSubtitle =>
      'Algunos campos no superan la validación y se ignorarán si no se corrigen';

  @override
  String get duplicateFoundSubtitle =>
      'Ya existe un registro en la aplicación con esta marca y modelo. Por favor, asegúrate de que sea único';

  @override
  String get clockwise => 'Sentido Horario';

  @override
  String get counterClockwise => 'Sentido Antihorario';

  @override
  String get both => 'Ambos Sentidos';

  @override
  String get dateComplicationsDate => 'Fecha sola';

  @override
  String get dateComplicationsNoDate => 'Sin Fecha';

  @override
  String get dateComplicationsDayDate => 'Día y Fecha (Day-Date)';

  @override
  String get dateComplicationsPointerDate => 'Fecha por Aguja (Pointer Date)';

  @override
  String get dateComplicationsSubDialDate => 'Fecha en Subesfera';

  @override
  String get dateComplicationsPerpetualDate => 'Calendario Perpetuo';

  @override
  String get dateComplicationsDigitalDate => 'Fecha Digital';

  @override
  String get emptyWatchboxCopy =>
      'Tu caja de relojes está actualmente vacía.\n\nPresiona el botón rojo para añadir relojes a tu colección.\n\nConfigura las preferencias de la aplicación, como el formato de moneda preferido, presionando el ícono de engranaje en la parte superior derecha.';

  @override
  String get emptySoldCopy =>
      'No tienes ningún reloj vendido en tu colección.\n\nPuedes marcar un reloj como vendido editando su estado.\n';

  @override
  String get emptyWishlistCopy =>
      'No estás realizando el seguimiento de ningún reloj en tu lista de deseos.\n\nPara añadir un reloj a tu lista de deseos, crea un nuevo registro de reloj y establece su estado en \'Lista de Deseos\'.\n';

  @override
  String get emptyFavouritesCopy =>
      'Aún no tienes ningún reloj marcado como \'favorito\'.\n\nPara marcar un reloj como favorito, activa el interruptor en la pantalla de detalles del reloj.\n';

  @override
  String get emptyPreOrderCopy =>
      'No estás rastreando ninguna preventa de relojes.\n\nPara rastrear una cuenta atrás para un reloj pedido en preventa, crea un nuevo registro de reloj con el estado de \'Preventa\'.';

  @override
  String get emptyOnLoanCopy =>
      'Actualmente no tienes ningún reloj marcado como \'Prestado\'.\n\nPuedes marcar un reloj como prestado editando su estado.';

  @override
  String get listViewTitle => 'Lista';

  @override
  String get gridViewTitle => 'Cuadrícula';

  @override
  String get displayOrderTitle => 'Orden de Visualización:';

  @override
  String get inOrderOfEntry => 'Por orden de entrada';

  @override
  String get inReverseOrderOfEntry => 'Por orden inverso de entrada';

  @override
  String get azByManufacturer => 'A-Z por fabricante';

  @override
  String get zaByManufacturer => 'Z-A por fabricante';

  @override
  String get orderByMostWorn => 'Ordenar por más usados';

  @override
  String get orderByLastWornDate => 'Ordenar por fecha de último uso';

  @override
  String get showLastWornDateOption => 'Mostrar fechas de último uso';

  @override
  String get showWearCountOption => 'Mostrar recuentos de uso';

  @override
  String get showWearFrequencyOption => 'Mostrar frecuencia de uso';

  @override
  String watchNamePurchased(Object watchName) {
    return '$watchName comprado';
  }

  @override
  String watchNameSold(Object watchName) {
    return '$watchName vendido';
  }

  @override
  String watchNamePreOrderDue(Object watchName) {
    return 'Fecha de preventa de $watchName';
  }

  @override
  String watchNameLastServiced(Object watchName) {
    return 'Último mantenimiento de $watchName';
  }

  @override
  String watchNameNextService(Object watchName) {
    return 'Próximo mantenimiento de $watchName';
  }

  @override
  String watchNameWarrantyExpires(Object watchName) {
    return 'Garantía de $watchName expira';
  }

  @override
  String get timelineSettings => 'Ajustes de la Línea de Tiempo';

  @override
  String get orderAscending => 'Orden: Ascendente.';

  @override
  String get orderDescending => 'Orden: Descendente.';

  @override
  String get showWatchesPurchased => 'Mostrar relojes comprados.';

  @override
  String get showWatchesSold => 'Mostrar relojes vendidos.';

  @override
  String get showPreOrderDueDates => 'Mostrar fechas de preventa.';

  @override
  String get showLastServicedDates => 'Mostrar fechas de último mantenimiento.';

  @override
  String get showNextServiceDates => 'Mostrar fechas de próximo mantenimiento.';

  @override
  String get showWarrantyEndDates => 'Mostrar fechas de fin de garantía.';

  @override
  String get timelineEmptyData =>
      'No se encontraron datos para mostrar.\n\nAñade fechas a la pestaña \'Fechas\' de tus relojes para completar tu línea de tiempo.';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get privacySettings => 'Ajustes de Privacidad';

  @override
  String get privacySettingsUpdated =>
      'Tus opciones de privacidad han sido actualizadas';

  @override
  String get privacyError =>
      'Ocurrió un error al intentar actualizar los ajustes de privacidad; por favor, inténtalo de nuevo';

  @override
  String get anAppForEnthusiasts =>
      'Una app para entusiastas de los relojes. \nDesliza para conocer lo que WristTrack puede hacer...';

  @override
  String get yourDigitalWatchbox => 'Tu Caja de Relojes Digital';

  @override
  String get recordAllYourWatches =>
      'Registra todos tus relojes: busca rápidamente, reorganiza o haz una elección aleatoria';

  @override
  String get trackTheDetail => 'Rastrea el Detalle';

  @override
  String get categoriseAndCaptureTheDetails =>
      'Categorise and capture the particulars of your watches, or add your own notes';

  @override
  String get analyseTheData => 'Analiza los Datos';

  @override
  String get getInsightsWithDataAndCharts =>
      'Obtén información sobre tu colección a través de datos y gráficos';

  @override
  String get letsGo => '¡Vamos allá!';

  @override
  String get skip => 'OMITIR';

  @override
  String get next => 'SIGUIENTE';

  @override
  String get primaryImage => 'Imagen Principal';

  @override
  String get updateImage => 'Actualizar Imagen';

  @override
  String get deleteImage => 'Eliminar Imagen';

  @override
  String imageBottomSheetTitle(Object count, Object watchName) {
    return '$watchName\nImagen $count';
  }

  @override
  String get takeWithCamera => 'Tomar con la Cámara';

  @override
  String get selectFromGallery => 'Seleccionar de la Galería';

  @override
  String get cropImage => 'Recortar Imagen';

  @override
  String get longPressToEditOrDelete => 'Mantén pulsado para editar o eliminar';

  @override
  String watchGallery(Object watchName) {
    return 'Fotos de $watchName';
  }

  @override
  String get galleryTitle => 'Galería de Relojes';

  @override
  String get galleryEmptyFilterReturn =>
      'No se encontraron imágenes para este filtro';

  @override
  String galleryError(Object error) {
    return 'Ocurrió un error: $error';
  }

  @override
  String get galleryCollectionTab => 'Relojes en Colección';

  @override
  String get galleryArchivedTab => 'Relojes Archivados';

  @override
  String get galleryWishlistedWatchesTab => 'Relojes en Lista de Deseos';

  @override
  String get galleryEverythingTab => 'Todo';

  @override
  String get notRecordedBrackets => '(No registrado)';

  @override
  String gallerySubHeaderInCollection(Object returnText, Object watchStatus) {
    return '$watchStatus - $returnText';
  }

  @override
  String gallerySubHeaderSold(Object shortDate, Object watchStatus) {
    return '$watchStatus\nVendido el: $shortDate';
  }

  @override
  String gallerySubHeaderPreOrder(Object shortDate, Object watchStatus) {
    return '$watchStatus\nFecha estimada: $shortDate';
  }

  @override
  String get currencyOptionsTitle => 'Opciones de Moneda';

  @override
  String get currencyOptionsGuideText =>
      'WristTrack puede rastrear los valores de los relojes y las colecciones, y en algunos lugares los mostrará en el formato de moneda de tu elección.\n\nNota: Todos los valores de los relojes deben guardarse en la misma moneda para permitir cálculos precisos.';

  @override
  String get currencyPleaseSelect =>
      'Por favor, selecciona tu formato de moneda preferido:';

  @override
  String get currencyExample => 'Resultado de ejemplo';

  @override
  String get currencyAdditionRequest =>
      '¿Falta algo? ¡Ponte en contacto con el desarrollador para hacer una solicitud!';

  @override
  String get currencySterling => 'Libra Esterlina';

  @override
  String get currencyEuroIreland => 'Euro (Irlanda)';

  @override
  String get currencyIndianRupee => 'Rupia India';

  @override
  String get currencyUSDollar => 'Dólar Estadounidense';

  @override
  String get currencyYen => 'Yen Japonés';

  @override
  String get currencyEuroTrailing => 'Euro (icono al final)';

  @override
  String get currencyEuroLeading => 'Euro (icono al inicio)';

  @override
  String get currencySwissFranc => 'Franco Suizo';

  @override
  String get currencyHungarianForint => 'Forinto Húngaro';

  @override
  String get currencyPolishZloty => 'Zloty Polaco';

  @override
  String get currencyThaiBaht => 'Baht Tailandés';

  @override
  String get currencyNorwegianKrone => 'Corona Noruega';

  @override
  String get currencyCzechKoruna => 'Corona Checa';

  @override
  String get currencyMalaysianRinggit => 'Ringgit Malayo';

  @override
  String get currencyPhilippinePeso => 'Peso Filipino';

  @override
  String get currencyKoreanWon => 'Won Surcoreano';

  @override
  String get currencyBrazilianReal => 'Real Brasileño';

  @override
  String get currencyDanishKrone => 'Corona Danesa';

  @override
  String get currencySwedishKrona => 'Corona Sueca';

  @override
  String get currencyCanadianDollar => 'Dólar Canadiense';

  @override
  String get caseMaterialNotEntered => 'No Introducido';

  @override
  String get caseMaterialSteel => 'Acero';

  @override
  String get caseMaterialTitanium => 'Titanio';

  @override
  String get caseMaterialGold => 'Oro';

  @override
  String get caseMaterialTwoTone => 'Bicolor (Two-Tone)';

  @override
  String get caseMaterialPlatinum => 'Platino';

  @override
  String get caseMaterialBronze => 'Bronce';

  @override
  String get caseMaterialCeramic => 'Cerámica';

  @override
  String get caseMaterialCarbon => 'Carbono';

  @override
  String get caseMaterialResin => 'Resina';

  @override
  String get caseMaterialPlastic => 'Plástico';

  @override
  String get caseMaterialOther => 'Otro';

  @override
  String get caseMaterialPVDDLC => 'Acero PVD/DLC';

  @override
  String get caseMaterialTungsten => 'Tungsteno';

  @override
  String get notSelected => 'No Seleccionado';

  @override
  String get categoryDiver => 'Buceo (Diver)';

  @override
  String get categorySports => 'Deportivo';

  @override
  String get categoryFlight => 'Aviador (Flieger/Flight)';

  @override
  String get categoryField => 'Militar (Field)';

  @override
  String get categoryDress => 'De Vestir (Dress)';

  @override
  String get categoryTool => 'Herramienta (Tool watch)';

  @override
  String get categoryChronograph => 'Cronógrafo';

  @override
  String get categoryTravel => 'Viaje / GMT';

  @override
  String get notEntered => 'No Introducido';

  @override
  String get movementMechanicalManual => 'Mecánico - Cuerda Manual';

  @override
  String get movementMechanicalAutomatic => 'Mecánico - Automático';

  @override
  String get movementAnalogueQuartz => 'Cuarzo Analógico';

  @override
  String get movementDigitalQuartz => 'Cuarzo Digital';

  @override
  String get movementAnaDigiQuartz => 'Cuarzo Ana-Digi';

  @override
  String get movementKinetic => 'Kinetic';

  @override
  String get movementMechaQuartz => 'Mecha-Quartz';

  @override
  String get movementSmartWatch => 'Smartwatch';

  @override
  String get movementTourbillon => 'Tourbillon';

  @override
  String get movementSolarQuartz => 'Cuarzo Solar';

  @override
  String get movementTuningFork => 'Diapasón (Tuning Fork)';

  @override
  String get other => 'Otro';

  @override
  String get movementSpringDrive => 'Spring Drive';

  @override
  String get archiveScreenTitle => 'Relojes Archivados';

  @override
  String get archiveEmptyMessage => 'Tu archivo está actualmente vacío';

  @override
  String get archiveDeleteDialogConfirmTitle => 'Confirmar Eliminación';

  @override
  String archiveDeleteDialogConfirmText(Object watchName) {
    return '¿Estás seguro de que quieres eliminar $watchName? Esto no se puede deshacer.';
  }

  @override
  String get archiveRestoreDialogTitle => 'Restaurar Reloj';

  @override
  String archiveRestoreDialogText(Object watchName) {
    return '¿Quieres restaurar $watchName?';
  }

  @override
  String get archiveRestoreDialogStatusPicker => 'Restaurar al estado:';

  @override
  String get archiveRestoreButtonLabel => 'Restaurar';

  @override
  String get archiveBackgroundRestoreLabel => 'Restaurando...';

  @override
  String get archiveBackgroundDeleteLabel => 'Eliminando...';

  @override
  String get enableDailyWearReminder => 'Activar Recordatorio de Uso Diario';

  @override
  String get morning => 'Mañana (8 am)';

  @override
  String get afternoon => 'Tarde (12 pm)';

  @override
  String get evening => 'Noche (6 pm)';

  @override
  String get customTime => 'Hora Personalizada';

  @override
  String yourReminderIsSetForTime(Object hourTimeStamp) {
    return 'Tu recordatorio diario está programado para las $hourTimeStamp';
  }

  @override
  String yourSecondReminderIsSetFor(Object hourTimeStamp) {
    return 'Tu segundo recordatorio está programado para las $hourTimeStamp';
  }

  @override
  String get notificationTitle => 'Recordatorio de WristTrack';

  @override
  String get notificationOneBody =>
      '¡No olvides registrar qué llevas en la muñeca hoy!';

  @override
  String notificationConfirmationBody(Object hourTimeStamp) {
    return '¡Tus notificaciones han sido programadas para las $hourTimeStamp todos los días!';
  }

  @override
  String get notificationTwoBody =>
      '¡Es hora de registrar qué llevas en la muñeca!';

  @override
  String notificationTwoConfirmationBody(Object hourTimeStamp) {
    return '¡Tu segunda notificación está configurada para las $hourTimeStamp todos los días!';
  }

  @override
  String get enableSecondDailyWearReminder =>
      'Activar Segundo Recordatorio Diario';

  @override
  String get search => 'Buscar';

  @override
  String get searchOptionsTitle => 'Opciones de búsqueda';

  @override
  String get searchByNotesLabel => 'Buscar en notas';

  @override
  String get searchByLugWidthLabel => 'Buscar por ancho de asas';

  @override
  String get noResultsFound => 'No se Encontraron Resultados';

  @override
  String nWears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usado $countString veces',
      one: 'Usado 1 vez',
      zero: 'Sin usos registrados',
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
      other: '$countString relojes',
      one: '1 reloj',
      zero: 'Sin relojes',
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
      other: '$countString días',
      one: '1 día',
      zero: '0 días',
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
      other: '$countString años',
      one: '1 año',
      zero: '0 años',
    );
    return '$_temp0';
  }

  @override
  String get deleteWarning =>
      'Al presionar Aceptar se eliminarán todos los datos de los relojes, incluyendo tu lista de deseos y todas las imágenes guardadas.\n \n ESTO NO SE PUEDE DESHACER';

  @override
  String get backupInstruction =>
      'Presiona el botón de abajo para crear una copia de la base de datos de la app (¡esto puede tardar unos segundos!). \n\nUna vez creada, debería aparecer una ventana emergente para \'compartir\', lo que te permitirá elegir a dónde enviar el archivo de copia de seguridad.';

  @override
  String get imageBackupInstructions =>
      'Las imágenes de los relojes se pueden exportar por separado.';

  @override
  String get altExtractsGuidance =>
      '**Extracciones de Datos Alternativas**\n\nEstas opciones permiten extraer tus datos de relojes y de uso de **WristTrack**\n\nEstán pensadas para liberar tus datos, no como una copia de seguridad _(consulta las opciones de Copia de seguridad/Restaurar si solo buscas mover datos de un dispositivo a otro)._\n\nLa extracción simple proporciona una lista de todos los datos de los relojes, incluyendo el recuento de usos y las notas **(una fila por reloj)**.\n\nLa extracción detallada proporciona una línea de datos por cada **fecha de uso registrada** y solo incluye los relojes que tienen usos registrados **(múltiples filas por reloj)**.\n\nEstos datos brutos se exportan en formato CSV, lo que permite importarlos fácilmente en tu aplicación de hojas de cálculo favorita.';

  @override
  String get watchChartsUpgradeCopy =>
      '**Gráficos de Uso del Reloj**\n\nLos gráficos de relojes son una función de **WristTrack Pro**.\n\nTelas permiten ver gráficos que desglosan en qué meses y días se ha usado este reloj.\n\n¿Quieres saber más sobre **WristTrack Pro**? Haz clic en el botón de abajo...';

  @override
  String get addWearSnackbarTitle => 'Uso Registrado';

  @override
  String addWearSnackbarText(Object shortDate, Object watchName) {
    return '$watchName se usó el $shortDate';
  }

  @override
  String get dateDeletedSnackbarTitle => 'Fecha Eliminada';

  @override
  String dateDeletedSnackbarText(Object shortDate, Object watchName) {
    return 'Se eliminó el $shortDate del registro de $watchName';
  }

  @override
  String get collectionDeletedSnackbarTitle => 'Colección Vaciada';

  @override
  String get collectionDeletedSnackbarText =>
      'Tu colección de relojes está ahora vacía';

  @override
  String get deleteWatchPermanentlySnackbarTitle => 'Reloj Eliminado';

  @override
  String deleteWatchPermanentlySnackbarText(Object watchName) {
    return '$watchName ha sido eliminado permanentemente';
  }

  @override
  String get restoreWatchSnackbarTitle => 'Reloj Restaurado';

  @override
  String restoreWatchSnackbarText(Object returnText, Object watchName) {
    return '$watchName ha sido restaurado con el estado $returnText';
  }

  @override
  String get reminderSetSnackbarTitle => 'Recordatorio Configurado';

  @override
  String reminderSetSnackbarText(Object returnText) {
    return 'Recibirás un recordatorio todos los días a las $returnText';
  }

  @override
  String get copiedSnackbarTitle => 'Copiado';

  @override
  String get appUserIDCopiedSnackbarText =>
      'appUserID guardado en el portapapeles';

  @override
  String get serviceIntervalTitle => 'Intervalo de Mantenimiento';

  @override
  String get serviceIntervalText =>
      'Al establecer un intervalo de mantenimiento, se calculará una \'fecha de próximo mantenimiento\' y se mostrará en la pantalla de Mantenimiento de la app (siempre que se haya definido una fecha de compra o una fecha de último mantenimiento).\n  \nEl valor de este campo puede dejarse en cero para desactivarlo en este reloj.';

  @override
  String get duplicateWearTitle => 'Advertencia de Fecha Duplicada';

  @override
  String get duplicateWearText =>
      '¡Parece que ya has usado este reloj en la fecha indicada! \n \nSi quieres registrar un uso adicional, selecciona \'Añadir de Nuevo\' para guardarlo. \n \nDe lo contrario, cancela para volver.';

  @override
  String get duplicateWearConfirm => 'Añadir de Nuevo';

  @override
  String get collectionStatsDialogTitle => 'Estadísticas de la Colección';

  @override
  String get collectionStatsDialogText =>
      'Todos los valores se basan en los datos guardados dentro de tu colección de relojes.\n\nCuando los cálculos se realizan en función de fechas (como \'reloj más antiguo\'), la precisión depende de la información que se haya introducido en la aplicación.\n\nPuedes editar los datos asociados a relojes individuales navegando hacia ellos a través de las pantallas principales de la caja de relojes.';

  @override
  String get archivedHelpDialogTitle => 'Archivo de Relojes';

  @override
  String get archivedHelpDialogText =>
      'Cuando el estado de un reloj se marca como \'Archivado\', se quita de la colección主 y se almacena aquí.\n\nLos relojes del archivo se pueden eliminar de forma permanente deslizándolos hacia la izquierda o restaurarse en tu caja de relojes deslizándolos hacia la derecha.';

  @override
  String get backupHelpDialogTitle =>
      'Ayuda de Copia de Seguridad de Base de Datos';

  @override
  String get backupHelpDialogText =>
      '¿Tienes un teléfono nuevo o simplemente quieres un respaldo por si ocurre lo peor?\n ¡Estás en el lugar correcto!\n\nCrea una copia de seguridad de tu caja de relojes o restaura una copia existente.\n\nNota: Al restaurar la base de datos se borrarán todos los datos existentes y se REEMPLAZARÁN con la copia de seguridad.\n\nSi surge algún problema durante el proceso de copia de seguridad o restauración, a menudo se puede resolver cerrando por completo y reiniciando la aplicación.';

  @override
  String get incorrectFilenameDialogTitle => 'Archivo incorrecto';

  @override
  String incorrectFilenameDialogText(Object fileName) {
    return 'El archivo $fileName no coincide con el archivo esperado watchbox.hive\n\nPor favor, selecciona un archivo watchbox.hive';
  }

  @override
  String get confirmRestoreDialogTitle => 'Restaurar desde Copia de Seguridad';

  @override
  String get confirmRestoreDialogText =>
      'Restaurar esta copia de seguridad sobrescribirá tu caja de relojes actual.\n\n¿Quieres continuar?';

  @override
  String get restoreFailedTitle => 'Error al Restaurar';

  @override
  String restoreFailedText(Object error) {
    return 'No se pudo restaurar desde la copia de seguridad, ocurrió un error:\n\n$error\n\nPor favor, inténtalo de nuevo; si el problema persiste, ponte en contacto con el desarrollador de la app';
  }

  @override
  String get restoreSuccessDialogTitle => 'Restauración Exitosa';

  @override
  String get restoreSuccessDialogText =>
      '¡Base de datos restaurada correctamente!\n\nSi los relojes no se muestran inmediatamente, intenta navegar entre las pestañas principales.';

  @override
  String get backupLocationNullDialogText =>
      'No se ha especificado ninguna ubicación para la copia de seguridad. Por favor, selecciona primero dónde deseas guardar el archivo.';

  @override
  String backupFailedDialogText(Object error) {
    return 'Error en la copia de seguridad\n\n$error\n\nEs posible que la ubicación seleccionada no sea accesible para la aplicación. Inténtalo con una ubicación diferente.\n\nSi esto no funciona, envíanos tus comentarios al desarrollador a través de la tienda de aplicaciones.';
  }

  @override
  String watchboxFailedErrorDialog(Object error) {
    return 'No se pudo volver a abrir la caja de relojes\n\n$error\n\nAlgunos errores se pueden resolver cerrando por completo y reiniciando la aplicación.\n\nSi esto no funciona, envía tus comentarios al desarrollador a través de la tienda de aplicaciones.';
  }

  @override
  String get backupCompleteDialogTitle => 'Copia de Seguridad Completada';

  @override
  String get backupCompleteDialogText =>
      'Los datos de la Caja de Relojes se han guardado.';

  @override
  String get wristTrackUpdatedBottomSheetTitle =>
      'WristTrack se acaba de actualizar...';

  @override
  String get futureDateErrorDialogText =>
      'Las fechas de uso deben ser en el pasado, por favor selecciona una fecha diferente.';

  @override
  String get notificationSettingsHelpDialogTitle => 'Ajustes de Notificaciones';

  @override
  String get notificationsSettingsHelpDialogText =>
      'Cuando está activada, se activará una notificación diariamente a la hora seleccionada.';

  @override
  String get notificationSettingsHelpDialogTextAndroid =>
      '\n\nNota: Algunos fabricantes de dispositivos utilizan versiones personalizadas de Android OS que pueden afectar la capacidad de la aplicación para generar notificaciones cuando está en segundo plano.\n\nDesafortunadamente, como desarrollador hay poco que se pueda hacer para evitar esto. \n\nSe sabe que esto afecta a los teléfonos Huawei y Xiaomi, pero también podría afectar a otros.';

  @override
  String get wearDatesHelpDialogTitle => 'Historial de Uso';

  @override
  String get wearDatesHelpDialogText =>
      'Este calendario muestra las fechas en que se usó este reloj, así como otras fechas rastreadas para el mismo.\n\nPara añadir o eliminar fechas de uso directamente, mantén pulsada una fecha individual.';

  @override
  String get deleteImageDialogTitle => 'Eliminar Imagen';

  @override
  String get deleteImageDialogText =>
      '¿Quieres eliminar esta imagen?\nEsto no se puede deshacer';

  @override
  String get deleteWatchTitle => 'Eliminar Reloj';

  @override
  String get deleteWatchDialogText =>
      '¿Quieres quitar este reloj de tu colección?\n\n(Los relojes eliminados por error se pueden restaurar desde el Archivo, que se encuentra en Ajustes)';

  @override
  String get deleteWatchSnackbarConfirmation => 'Reloj Eliminado';

  @override
  String deleteWatchSnackbarText(Object watchName) {
    return '$watchName ha sido trasladado al Archivo';
  }

  @override
  String get failedToPickImageDialogTitle => 'Error al Seleccionar Imagen';

  @override
  String failedToPickImageDialogText(Object error) {
    return 'La plataforma encontró un error:\n\n$error';
  }

  @override
  String get setupDailyReminderDialogTitle =>
      'Configurar Recordatorios Diarios';

  @override
  String get setupDailyRemindersDialogText =>
      'WristTrack puede enviarte un recordatorio diario para registrar qué estás usando hoy.\n\n¿Te gustaría configurar uno?\n\n(Esto se puede cambiar en cualquier momento desde el menú de ajustes)';

  @override
  String get soldStatusPopupDialogText =>
      'Estás marcando este reloj como vendido:\n\nAhora puedes añadir una fecha de venta, el precio de venta e información sobre el comprador en las pestañas de fechas y valor.';

  @override
  String get preorderStatusPopupDialogTitle => 'Relojes en Preventa';

  @override
  String get preorderStatusPopupDialogText =>
      'Estás marcando este reloj como en Preventa:\n\nAhora puedes añadir una fecha estimada de entrega en la pestaña de fechas.\nEsto activará una cuenta atrás para la fecha indicada.';

  @override
  String get noImagesFoundPopupTitle => 'No se Encontraron Imágenes';

  @override
  String get noImagesFoundPopupText =>
      'No se ha generado ninguna copia de seguridad porque no se identificaron imágenes de relojes';

  @override
  String get failedToBackupImagesDialogTitle => 'Error al Respaldar Imágenes';

  @override
  String failedToBackupImagesDialogText(Object error) {
    return 'Error al respaldar las imágenes, se devolvió el siguiente error:\n$error';
  }

  @override
  String imageBackupSuccessDialogText(Object count) {
    return '$count imágenes respaldadas con éxito';
  }

  @override
  String get watchboxSuccessfullyBackedUpText =>
      'Caja de relojes respaldada con éxito';

  @override
  String get extractSuccessfullyCreatedDialogText =>
      'Extracción Creada con Éxito';

  @override
  String get generalErrorDialogTitle => '¡Algo salió mal!';

  @override
  String generalErrorDialogText(Object error) {
    return 'Ocurrió un error inesperado con el mensaje: $error';
  }

  @override
  String get proDialogText =>
      'Esta es una función de WristTrack Pro.\n\nPara saber más y actualizar, haz clic abajo.';

  @override
  String get saveUpdates => 'Guardar Actualizaciones';

  @override
  String get updatesSaved => 'Actualizaciones Guardadas';

  @override
  String get unknown => 'Desconocido';

  @override
  String get editWatchUnsavedChangesTitle => 'Tienes cambios sin guardar';

  @override
  String get editWatchUnsavedChangesCopy =>
      '¿Estás seguro de que quieres salir?\nLos cambios sin guardar se perderán.';

  @override
  String get editWatchUnsavedChangesExitOption => 'Salir sin guardar';

  @override
  String get editWatchUnsavedChangesContinueEditingOption =>
      'Continuar editando';
}
