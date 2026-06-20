// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get watchBox => 'Шкатулка';

  @override
  String get favouriteWatches => 'Любимые часы';

  @override
  String get wishlist => 'Список желаний';

  @override
  String get preOrders => 'Предзаказы';

  @override
  String get retiredWatches => 'Бывшие';

  @override
  String get onLoanWatches => 'Выданные часы';

  @override
  String get randomWatch => 'Случайные часы';

  @override
  String get statusInCollection => 'В коллекции';

  @override
  String get statusSold => 'Проданы';

  @override
  String get statusWishlist => 'В списке желаний';

  @override
  String get statusPreOrder => 'Предзаказ';

  @override
  String get statusRetired => 'Бывшие';

  @override
  String get statusArchived => 'В архиве';

  @override
  String get statusOnLoan => 'Выданы';

  @override
  String get collection => 'Коллекция';

  @override
  String get stats => 'Статистика';

  @override
  String get calendar => 'Календарь';

  @override
  String get time => 'Время';

  @override
  String get more => 'Еще';

  @override
  String get settings => 'Настройки';

  @override
  String get appData => 'Данные приложения';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get removeAds => 'Удалить рекламу';

  @override
  String get support => 'Поддержать WristTrack';

  @override
  String get review => 'Оставить отзыв';

  @override
  String get about => 'О приложении';

  @override
  String get follow => 'Читать WristTrack';

  @override
  String get email => 'Обратная связь по почте';

  @override
  String get visitWristTrackWeb => 'Посетить www.wristtrack.app';

  @override
  String get aboutWristTrack => 'О WristTrack';

  @override
  String get aboutTheDeveloper => 'Разработчик';

  @override
  String get acknowledgements => 'Благодарности';

  @override
  String get versionHistory => 'История версий';

  @override
  String get viewOptionsPageTitle => 'Параметры отображения';

  @override
  String get collectionDisplaySectionTitle => 'Отображение коллекции';

  @override
  String get collectionDisplayShowAsList => 'Показывать списком';

  @override
  String get collectionDisplayShowAsGrid => 'Показывать сеткой';

  @override
  String get collectionOrderSectionTitle => 'Сортировка коллекции';

  @override
  String get collectionInOrderOfEntry => 'В порядке добавления';

  @override
  String get collectionInReverseOrderOfEntry => 'В обратном порядке добавления';

  @override
  String get collectionOrderAZ => 'А-Я по производителю';

  @override
  String get collectionOrderZA => 'Я-А по производителю';

  @override
  String get collectionOrderMostWorn => 'По частоте ношения (частые)';

  @override
  String get collectionOrderLastWornDate => 'По дате последнего ношения';

  @override
  String get startPageSectionTitle => 'Стартовая страница';

  @override
  String get startPageWatchCollection => 'Коллекция часов';

  @override
  String get startPageCalendarView => 'Просмотр календаря';

  @override
  String get startPageTimeSetting => 'Настройка времени';

  @override
  String get calendarOptionsSectionTitle => 'Параметры календаря';

  @override
  String get firstDayOfTheWeekText => 'Первый день недели: ';

  @override
  String get themeSectionTitle => 'Светлая / Темная тема';

  @override
  String get matchSystem => 'Как в системе';

  @override
  String get lightTheme => 'Светлая тема';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get wrUnitsSectionTitle => 'Ед. водонепроницаемости';

  @override
  String get languageLink => 'Язык';

  @override
  String get reminderLink => 'Ежедневное напоминание';

  @override
  String get currencyLink => 'Параметры валюты';

  @override
  String get chartOptionsLink => 'Параметры графиков';

  @override
  String get appPreferencesLink => 'Настройки приложения';

  @override
  String get showArchiveLink => 'Показывать архивные часы';

  @override
  String get showDemoLink => 'Показать демо при первом запуске';

  @override
  String get appUserIDTitle => 'ID пользователя приложения';

  @override
  String get appVersion => 'Версия приложения: ';

  @override
  String get unknownAppVersionText => 'Не определена';

  @override
  String get wearStatsButton => 'Статистика ношения';

  @override
  String get collectionStatsButton => 'Статистика коллекции';

  @override
  String get wristRecap => 'Обзор на запястье';

  @override
  String get lastSync => 'Посл. синхр.:';

  @override
  String get deviation => 'Погрешность системного времени:';

  @override
  String get inProgress => 'Синхронизация... Отображается системное время...';

  @override
  String get beepCountdown => 'Звуковой отсчет';

  @override
  String get timeFormat => '24-часовой формат';

  @override
  String get moonPhase => 'Текущая фаза Луны';

  @override
  String get gallery => 'Галерея';

  @override
  String get timeline => 'Хроника';

  @override
  String lastWorn(Object shortDate) {
    return 'Последний раз: $shortDate';
  }

  @override
  String get wornToday => 'Надеты сегодня';

  @override
  String get wearToday => 'Надеть сегодня';

  @override
  String editTitle(Object watchName) {
    return 'Изменить: $watchName';
  }

  @override
  String get addWatch => 'Добавить часы';

  @override
  String get addOptionalDetails => 'Добавить доп. сведения?';

  @override
  String get addedToWatchbox => 'добавлено в шкатулку';

  @override
  String get favouriteLabel => 'В избранное';

  @override
  String get caseDiameterRowTitle => 'Диаметр корпуса (мм):';

  @override
  String get caseDiameterRowHintText => 'Диаметр корпуса';

  @override
  String get caseThicknessRowTitle => 'Толщина корпуса (мм):';

  @override
  String get caseThicknessRowHintText => 'Толщина корпуса';

  @override
  String get lastServicedDateRowTitle => 'Дата последнего сервиса:';

  @override
  String get lastServicedDateRowHintText => 'Дата последнего сервиса';

  @override
  String get lug2lugRowTitle => 'Lug to Lug (мм):';

  @override
  String get lug2lugRowHintText => 'Расстояние между ушками (Lug to Lug)';

  @override
  String get lugWidthRowTitle => 'Ширина ремешка (мм):';

  @override
  String get lugWidthHintText => 'Ширина ремешка';

  @override
  String get manufacturerRowTitle => 'Производитель:';

  @override
  String get manufacturerRowHintText => 'Производитель';

  @override
  String get modelRowTitle => 'Модель:';

  @override
  String get modelRowHintText => 'Модель';

  @override
  String get purchaseDateRowTitle => 'Дата покупки:';

  @override
  String get purchaseDateRowHintText => 'Дата покупки';

  @override
  String get purchasePriceRowTitle => 'Цена покупки:';

  @override
  String get purchasePriceRowHintText => 'Цена покупки';

  @override
  String get purchasedFromRowTitle => 'Где куплены:';

  @override
  String get purchasedFromHintText => 'Место покупки';

  @override
  String get referenceNumberRowTitle => 'Референс-номер:';

  @override
  String get referenceNumberOptionalTitle => 'Референс-номер (опционально):';

  @override
  String get referenceNumberRowHelpText => 'Референс-номер';

  @override
  String get serialNumberRowTitle => 'Серийный номер:';

  @override
  String get serialNumberOptionalTitle => 'Серийный номер (опционально):';

  @override
  String get serialNumberRowHintText => 'Серийный номер';

  @override
  String get soldDateRowTitle => 'Дата продажи:';

  @override
  String get soldDateRowHintText => 'Дата продажи';

  @override
  String get soldPriceRowTitle => 'Цена продажи:';

  @override
  String get soldPriceRowHintText => 'Цена продажи';

  @override
  String get soldToRowTitle => 'Кому проданы:';

  @override
  String get soldToRowHintText => 'Покупатель';

  @override
  String get warrantyEndRowTitle => 'Срок действия гарантии:';

  @override
  String get warrantyEndRowHintText => 'Истечение срока гарантии';

  @override
  String waterResistanceRowTitle(Object units) {
    return 'Водонепроницаемость ($units):';
  }

  @override
  String get waterResistanceRowHintText => 'Водонепроницаемость';

  @override
  String get movementRowTitle => 'Калибр / Механизм:';

  @override
  String get categoryRowTitle => 'Категория:';

  @override
  String get watchDetailsSectionTitle => 'Детали часов';

  @override
  String get caseMaterialRowTitle => 'Материал корпуса:';

  @override
  String get winderSettingsSectionTitle => 'Настройки виндера';

  @override
  String get tpdRowTitle => 'TPD (оборотов в сутки):';

  @override
  String get winderDirectionRowTitle => 'Направление вращения:';

  @override
  String get dateComplicationRowTitle => 'Усложнение даты:';

  @override
  String get notesRowTitle => 'Заметки:';

  @override
  String get notesRowHintText => 'Заметки';

  @override
  String get costPerWearRowTitle => 'Стоимость одного ношения:';

  @override
  String get accuracyRowTitle => 'Точность хода:';

  @override
  String get preOrderDueDateRowTitle => 'Ожидаемая дата:';

  @override
  String get preOrderDueDateRowHintText => 'Ожидаемая дата';

  @override
  String get timeInCollectionRowTitle => 'Время в коллекции';

  @override
  String get serviceIntervalRowTitle => 'Интервал обслуживания:';

  @override
  String get serviceIntervalRowHintText => 'Интервал обслуживания (лет)';

  @override
  String get nextServiceDueRowTitle => 'Следующий сервис:';

  @override
  String get nextServiceDueRowHintText => 'Срок следующего сервиса:';

  @override
  String get mustBeNumber2decimals =>
      'Только числа, максимум с двумя знаками после запятой';

  @override
  String get mustBeWholeNumberLessThan99 =>
      'Должно быть целым числом меньше 99';

  @override
  String get manufacturerInvalidError =>
      'Отсутствует производитель или используются недопустимые символы';

  @override
  String get modelInvalidError =>
      'Отсутствует модель или используются недопустимые символы';

  @override
  String get digitsNoDecimalsError =>
      'Вводите только цифры без точек и запятых, остальное мы сделаем сами!';

  @override
  String get invalidCharactersDetected => 'Обнаружены недопустимые символы.';

  @override
  String get referenceNumberErrorText =>
      'Отсутствует референс или используются недопустимые символы';

  @override
  String get serialNumberErrorText =>
      'Серийный номер содержит недопустимые символы';

  @override
  String get mustBeAValidWholeNumber => 'Должно быть целым числом';

  @override
  String get mustBe099orBlank => 'Должно быть от 0 до 99 или пустым';

  @override
  String get infoTabLabel => 'Инфо';

  @override
  String get scheduleTabLabel => 'Даты';

  @override
  String get valueTabLabel => 'Ценность';

  @override
  String get proDataTabLabel => 'Pro-данные';

  @override
  String get notesTabLabel => 'Заметки';

  @override
  String get all => 'Все';

  @override
  String get january => 'Январь';

  @override
  String get february => 'Февраль';

  @override
  String get march => 'Март';

  @override
  String get april => 'Апрель';

  @override
  String get may => 'Май';

  @override
  String get june => 'Июнь';

  @override
  String get july => 'Июль';

  @override
  String get august => 'Август';

  @override
  String get september => 'Сентябрь';

  @override
  String get october => 'Октябрь';

  @override
  String get november => 'Ноябрь';

  @override
  String get december => 'Декабрь';

  @override
  String get day => 'День';

  @override
  String get month => 'Месяц';

  @override
  String get year => 'Год';

  @override
  String get monday => 'Понедельник';

  @override
  String get tuesday => 'Вторник';

  @override
  String get wednesday => 'Среда';

  @override
  String get thursday => 'Четверг';

  @override
  String get friday => 'Пятница';

  @override
  String get saturday => 'Суббота';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get filter => 'Фильтр:';

  @override
  String get wearsByDay => 'Ношение по дням недели';

  @override
  String get wearsByMonth => 'Ношение по месяцам';

  @override
  String get wearsByYear => 'Ношение по годам';

  @override
  String get thisYear => 'Этот год';

  @override
  String get lastYear => 'Прошлый год';

  @override
  String get last12Months => 'Последние 12 месяцев';

  @override
  String get last90days => 'Последние 90 дней';

  @override
  String get emptyWearListWatchCharts =>
      'Вы еще не зафиксировали ни одной даты ношения этих часов.\n\nДобавляйте данные, нажимая «Надеты сегодня» на странице часов или выбирая даты в календаре.\n\nПосле этого здесь появятся графики со статистикой по месяцам и дням недели.';

  @override
  String get wearChartFiltersSheetTitle => 'Фильтры графиков ношения';

  @override
  String get showAll => 'Показать все';

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String get lastMonth => 'Прошлый месяц';

  @override
  String get last30days => 'Последние 30 дней';

  @override
  String get last365days => 'Последние 365 дней';

  @override
  String get sinceLastPurchase => 'С последней покупки';

  @override
  String get selectMonthYear => 'Выбрать месяц/год';

  @override
  String get betweenSelectedDates => 'В выбранном диапазоне дат';

  @override
  String get monthColon => 'Месяц:';

  @override
  String get yearColon => 'Год:';

  @override
  String get startDate => 'Дата начала:';

  @override
  String get endDate => '  Дата конца:';

  @override
  String get resetToDefaults => 'Сбросить настройки';

  @override
  String get chartGrouping => 'Группировка графиков';

  @override
  String get includeCurrentCollection => 'Включая текущую коллекцию';

  @override
  String get includeSoldWatches => 'Включая проданные часы';

  @override
  String get includeRetiredWatches => 'Включая выведенные часы';

  @override
  String get includeArchivedWatches => 'Включая архивные часы';

  @override
  String get includeOnLoanWatches => 'Включая выданные часы';

  @override
  String get filterByCategory => 'Фильтр по категориям';

  @override
  String get filterByMovement => 'Фильтр по механизмам';

  @override
  String get allData => 'Все данные';

  @override
  String get wornThisYear => 'Надевались в этом году';

  @override
  String get wornThisMonth => 'Надевались в этом месяце';

  @override
  String get wornLastMonth => 'Надевались в прошлом месяце';

  @override
  String get wornLastYear => 'Надевались в прошлом году';

  @override
  String get wornInLast30Days => 'Надевались за последние 30 дней';

  @override
  String get wornInLast90Days => 'Надевались за последние 90 дней';

  @override
  String get wornInLast365Days => 'Надевались за последние 365 дней';

  @override
  String wornBetweenDates(Object shortDate, Object shortDate2) {
    return 'Надевались в период с $shortDate по $shortDate2';
  }

  @override
  String yearSelected(Object yearValue) {
    return 'Год: $yearValue';
  }

  @override
  String monthSelected(Object monthValue) {
    return 'Месяц: $monthValue';
  }

  @override
  String advancedFilterHeaderLastPurchase(Object returnText, Object shortDate) {
    return '$returnText Последняя покупка: $shortDate, ';
  }

  @override
  String advancedFilterHeaderGrouping(Object filterText, Object returnText) {
    return '$returnText Группировка по $filterText, ';
  }

  @override
  String advancedFilterHeaderCategories(Object filterText, Object returnText) {
    return '$returnText Категории($filterText), ';
  }

  @override
  String advancedFilterHeaderMovements(Object filterText, Object returnText) {
    return '$returnText Механизмы($filterText), ';
  }

  @override
  String advancedFilterHeaderHideCollection(Object returnText) {
    return '$returnText скрыть Коллекцию, ';
  }

  @override
  String advancedFilterHeaderIncSold(Object returnText) {
    return '$returnText вкл. Проданные, ';
  }

  @override
  String advancedFilterHeaderIncRetired(Object returnText) {
    return '$returnText вкл. Выведенные, ';
  }

  @override
  String advancedFilterHeaderIncArchived(Object returnText) {
    return '$returnText вкл. Архивные, ';
  }

  @override
  String advancedFilterHeaderIncOnLoan(Object returnText) {
    return '$returnText вкл. Выданные, ';
  }

  @override
  String get chartsEmptyBackgroundText => 'Нет данных для выбранного фильтра';

  @override
  String get generatedWithWristTrackPro => 'График создан в WristTrack Pro';

  @override
  String get generatedWithWristTrack => 'График создан в WristTrack';

  @override
  String get pieChart => 'Круговая диаграмма';

  @override
  String get barChart => 'Столбчатая диаграмма';

  @override
  String get chartOptionsPageTitle => 'Параметры графиков';

  @override
  String get wearChartsDefaultFilterSectionTitle =>
      'Фильтр статистики ношения по умолчанию';

  @override
  String get wearChartsFilterGuidanceText =>
      'Установите фильтр по умолчанию для страницы статистики. График можно будет менять вручную, но при открытии он всегда будет загружать этот вариант.';

  @override
  String get showAllRecordedWears => 'Показывать все записи ношения';

  @override
  String get wearStatsResultsOrderSectionTitle =>
      'Сортировка результатов статистики';

  @override
  String get wearStatsResultsOrderGuidanceText =>
      'Порядок отображения часов на графике. По умолчанию они выводятся так же, как в коллекции, но можно настроить вывод по возрастанию или убыванию частоты ношения.';

  @override
  String get showResultsInCollectionOrder => 'В порядке отображения коллекции';

  @override
  String get showResultsAscendingByWearCount =>
      'По возрастанию количества дней ношения';

  @override
  String get showResultsDescendingByWearCount =>
      'По убыванию количества дней ношения';

  @override
  String get defaultChartTypeSectionTitle => 'Тип графика по умолчанию';

  @override
  String get defaultChartTypeGuidanceText =>
      'Выберите базовый вид графика. Вы сможете переключать его на самом экране статистики, приложение запомнит последний выбор.';

  @override
  String get watch => 'Часы';

  @override
  String get movement => 'Механизм';

  @override
  String get category => 'Категория';

  @override
  String get manufacturer => 'Производитель';

  @override
  String get caseMaterial => 'Материал корпуса';

  @override
  String get dateComplication => 'Усложнение даты';

  @override
  String get pageTitleCollectionStats => 'Статистика коллекции';

  @override
  String get labelCharts => 'Графики';

  @override
  String get labelInfo => 'Инфо';

  @override
  String get labelValue => 'Стоимость';

  @override
  String get collectionCost => 'Текущая стоимость коллекции';

  @override
  String get noValue => 'Стоимость не указана';

  @override
  String get totalSpend => 'Всего потрачено на коллекцию';

  @override
  String get totalSold => 'Общая сумма продаж';

  @override
  String get averageResale => 'Средний % перепродажи';

  @override
  String get noDataTracked => 'Нет данных';

  @override
  String get resaleRatio => 'Коэффициент перепродажи =';

  @override
  String get sizeOfCollection => 'Размер коллекции';

  @override
  String get oldestWatch => 'Самые старые часы';

  @override
  String get newestWatch => 'Самые новые часы';

  @override
  String get mostWorn => 'Самые ходовые';

  @override
  String get leastWorn => 'Самые редкие в ношении';

  @override
  String get wishListCount => 'Часы в списке желаний';

  @override
  String get soldWatches => 'Проданные часы';

  @override
  String get noPurchaseDatesTracked => 'Даты покупки не указаны';

  @override
  String get upgradeToProForMoreCharts =>
      'Перейдите на WristTrack Pro для дополнительных графиков...';

  @override
  String get movements => 'Механизмы';

  @override
  String get categories => 'Категории';

  @override
  String get dateComplications => 'Усложнения даты';

  @override
  String get caseDiameter => 'Диаметр корпуса';

  @override
  String get lugWidth => 'Ширина ремешка';

  @override
  String get lugToLug => 'Lug to Lug';

  @override
  String get caseThickness => 'Толщина корпуса';

  @override
  String get waterResistance => 'Водонепроницаемость';

  @override
  String get caseMaterials => 'Материалы корпуса';

  @override
  String get costPerWear => 'Цена одного ношения';

  @override
  String timeInCollectionDays(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дней',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
      zero: '0 дней',
    );
    return '$_temp0';
  }

  @override
  String timeInCollectionYears(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'лет',
      many: 'лет',
      few: 'года',
      one: 'год',
    );
    return '$count+ $_temp0';
  }

  @override
  String get timeInCollectionThreePlusMonths => '3+ месяца';

  @override
  String get timeInCollectionSixPlusMonths => '6+ месяцев';

  @override
  String get timeInCollectionNinePlusMonths => '9+ месяцев';

  @override
  String get showPaymentOptions => 'Показать варианты оплаты';

  @override
  String get donateAgain => 'Поддержать еще раз';

  @override
  String get removeAdsMainCopy =>
      'Базовые функции **WristTrack** бесплатны и поддерживаются за счет небольшой рекламы.\n\nВы можете отключить ее, выбрав любой вариант поддержки ниже — каждый из них обновит приложение до версии **WristTrack Pro**.\n\n**WristTrack Pro** также открывает:\n\n* Возможность установить второе ежедневное напоминание\n* Индивидуальные графики ношения конкретных часов по месяцам и дням недели\n* Дополнительные инфо-поля и расширенную статистику';

  @override
  String get supporterCopy =>
      'Спасибо за поддержку WristTrack!\n\nДля меня это очень важно. Благодаря вам я могу продолжать развивать этот проект и создавать новые приложения.\n\nЕсли вам нравится WristTrack, расскажите о нем друзьям или оставьте отзыв в магазине, поделившись своими впечатлениями и пожеланиями по функциям!\n\nЕсли вы захотите поддержать проект повторно, сделать дополнительное пожертвование можно в любое время.';

  @override
  String get purchaseRestored => 'Покупка восстановлена';

  @override
  String get youreAdFree => 'Реклама отключена!';

  @override
  String get restoreFailed => 'Не удалось восстановить';

  @override
  String get noPurchaseFound =>
      'Прошлых или активных покупок для этого пользователя не найдено';

  @override
  String get restorePurchase => 'Восстановить статус покупки';

  @override
  String get noOptionsFound => 'Варианты не найдены, попробуйте позже';

  @override
  String get supportWristTrack => 'Поддержать WristTrack';

  @override
  String get payWhatYouLike =>
      'Платите сколько хотите! Любой вариант откроет WristTrack Pro';

  @override
  String get noDataRecorded => 'Нет записей';

  @override
  String get warning => 'Предупреждение';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Да';

  @override
  String get noThanks => 'Нет, спасибо';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get done => 'Готово';

  @override
  String get tellMeMore => 'Подробнее';

  @override
  String get soldSuffix => '(Проданы)';

  @override
  String get retiredSuffix => '(Выведены)';

  @override
  String get archivedSuffix => '(В архиве)';

  @override
  String get onLoanSuffix => '(Выданы)';

  @override
  String get watchColon => 'Часы:';

  @override
  String get deleting => 'Удаление';

  @override
  String get errorHeader => 'Ошибка';

  @override
  String get dontShowThisMessageAgain => 'Больше не показывать';

  @override
  String get success => 'Успешно!';

  @override
  String get today => 'Сегодня';

  @override
  String get notWornYet => 'Еще не надевались';

  @override
  String lastWornDate(Object shortDate) {
    return 'Последний раз: $shortDate';
  }

  @override
  String wearCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Надеты $count раз',
      many: 'Надеты $count раз',
      few: 'Надеты $count раза',
      one: 'Надеты $count раз',
      zero: 'Ни разу не надевались',
    );
    return '$_temp0';
  }

  @override
  String get notRecorded => 'Не указано';

  @override
  String soldDetails(Object price, Object shortDate) {
    return 'Проданы $shortDate \nза $price';
  }

  @override
  String get countDownNA => 'Отсчет: Н/Д';

  @override
  String dueInXDays(Object nDays) {
    return 'Осталось: $nDays';
  }

  @override
  String overdueXDays(Object nDays) {
    return 'Просрочено: $nDays';
  }

  @override
  String get basic => 'Базовый';

  @override
  String get advanced => 'Расширенный';

  @override
  String get na => 'Н/Д';

  @override
  String schedule(Object nYears) {
    return 'Раз в $nYears';
  }

  @override
  String get meters => 'м';

  @override
  String get feet => 'футов';

  @override
  String get backupRestore => 'Резервное копирование базы данных';

  @override
  String get altExports => 'Альтернативный экспорт';

  @override
  String get dataImport => 'Импорт данных';

  @override
  String get deleteCollection => 'Удалить коллекцию';

  @override
  String get backupRestoreHeader => 'Бэкап / Восстановление';

  @override
  String get backup => 'Создать бэкап';

  @override
  String get restore => 'Восстановить';

  @override
  String get backupDatabase => 'Создать копию БД';

  @override
  String get restoreDatabase => 'Восстановить БД';

  @override
  String get pleaseSelectFile => 'Пожалуйста, выберите файл бэкапа';

  @override
  String get selectFile => 'Выбрать файл бэкапа';

  @override
  String get fileSelected => 'Выбран файл: ';

  @override
  String get readyToLoad => 'Готово к загрузке';

  @override
  String get restoreFromBackup => 'Восстановить из бэкапа';

  @override
  String get backupWatchImages => 'Резервная копия изображений';

  @override
  String get simpleExtractButton => 'Краткий экспорт (CSV)';

  @override
  String get detailedExtractButton => 'Подробный экспорт (CSV)';

  @override
  String get wristTrackProFeature => 'Функция WristTrack Pro';

  @override
  String get proFeature => 'Pro-функция';

  @override
  String get track => 'Отметить';

  @override
  String get trackWear => 'Отметить ношение';

  @override
  String get removeWear => 'Удалить ношение';

  @override
  String get removeDate => 'Удалить дату';

  @override
  String get date => 'Дата:';

  @override
  String get pickWatch => 'Выбрать часы';

  @override
  String get pleaseSelectAWatch => 'Пожалуйста, выберите часы';

  @override
  String get searchByName => 'Поиск по названию часов';

  @override
  String get deleteWear => 'Удалить запись о ношении';

  @override
  String get deleteFromCalendar => 'Удалить ношение из календаря';

  @override
  String get addWearToCalendar => 'Добавить ношение в календарь';

  @override
  String get serviceDue => 'Требуется сервис';

  @override
  String get warrantyExpires => 'Гарантия истекает';

  @override
  String get deliveryExpected => 'Ожидается доставка';

  @override
  String get longPressToAddRemove =>
      'Долгое нажатие для добавления/удаления дат ношения';

  @override
  String get tapToAddMultipleDates =>
      'Нажмите здесь, чтобы добавить несколько дат';

  @override
  String get deleteDate => 'Удалить дату';

  @override
  String watchWorn(Object watchName) {
    return '$watchName: надеты';
  }

  @override
  String get noDatesForWatch => 'Для этих часов нет записей.';

  @override
  String get allDatesWorn => 'Все даты ношения';

  @override
  String get selectDatesToAdd => 'Выберите даты для добавления';

  @override
  String get selectionMode => 'Режим выбора';

  @override
  String get rangeDefinition => 'Диапазон (выберите начало и конец)';

  @override
  String get individualSelectionDefinition =>
      'По отдельности (выберите несколько дат)';

  @override
  String get thereWasAProblemWithSomeDates =>
      'С некоторыми датами возникла проблема';

  @override
  String get dateAlreadyExists => 'Дата уже существует';

  @override
  String get dateIsInTheFuture => 'Дата находится в будущем';

  @override
  String get watchAccuracy => 'Точность часов';

  @override
  String get accuracyTracker => 'Замер точности хода';

  @override
  String timeSynced(Object timeStamp) {
    return 'Время синхронизировано с сервером: \n$timeStamp';
  }

  @override
  String get showAccuracyResultsOptions =>
      'Показывать погрешность в секундах за:';

  @override
  String get baseLineMeasurement => 'Базовое измерение (ориентир):';

  @override
  String get setBaseLineGuide =>
      'Задайте новую базовую линию, если вы только что выставили точное время на часах';

  @override
  String lastBaseLine(Object timeStamp) {
    return 'Предыдущий ориентир: $timeStamp';
  }

  @override
  String get addCheckPoint => 'Добавить точку замера:';

  @override
  String get seconds => 'Секунды:';

  @override
  String get saved => 'Сохранено!';

  @override
  String get record => 'Запись';

  @override
  String get records => 'Записи';

  @override
  String get baseLine => 'Ориентир';

  @override
  String get result => 'Результат';

  @override
  String get noRecordsTracked => 'Нет записей замеров';

  @override
  String get measurementInProgress => 'Выполняется замер...';

  @override
  String get noRateFound => 'Показатель не найден';

  @override
  String get systemTimeInUse => '... используется системное время';

  @override
  String get accuracyHelpTextIntro =>
      'Отслеживайте точность хода ваших часов, создавая контрольные точки. WristTrack сравнивает изменение времени на часах с эталонным временем атомных часов и рассчитывает, спешат они или отстают.\n\n';

  @override
  String get accuracyHelpTextBaselines =>
      '**Базовые линии (Ориентиры)**\n\nКогда вы устанавливаете замер как базовый, все последующие измерения будут сравниваться именно с ним. Новую базовую линию нужно создавать каждый раз, когда вы вручную корректировали время на часах с момента последнего замера.\n\nЕсли у вас нет сохраненных записей, самый первый созданный замер автоматически отмечается как базовый.\n\n';

  @override
  String get accuracyHelpTextAddAMeasurement =>
      '**Как сделать замер**\n\nЧтобы зафиксировать точку данных, укажите в блоке «Добавить точку замера» то время, которое часы *будут* показывать через мгновение (по умолчанию предлагается на минуту вперед). Когда секундная стрелка дойдет до 12 часов, нажмите кнопку «00 секунд». Либо укажите текущее время и нажмите кнопки «15/30/45 секунд» в момент прохождения стрелки через эти деления.\n\nПолученные результаты появятся в списке «Записи» ниже вместе с расчетом точности, произведенным относительно последней базовой линии (для самих ориентиров точность не выводится).\n\n';

  @override
  String get accuracyHelpTextDeletingARecord =>
      '**Удаление записей**\n\nЕсли вы зафиксировали точку ошибочно, ее можно удалить, просто смахнув эту строку справа налево в списке «Записи».\n\n';

  @override
  String get accuracyHelpTextWhenToCapture =>
      '**Когда делать замеры**\n\nЧем дольше интервал между базовым измерением и контрольной точкой, тем точнее будет результат (так как секундные погрешности от скорости нажатия кнопок сглаживаются). Рекомендуется делать паузу в 12–24 часа между проверками.\n\n';

  @override
  String get accuracyHelpTextOutro =>
      '_*Вы можете снова открыть это информационное окно в любое время, нажав на знак вопроса в верхнем правом углу страницы.*_\n\n ';

  @override
  String secondsPerUnit(Object rateUnit) {
    return 'сек/$rateUnit';
  }

  @override
  String get servicingTab => 'Обслуживание';

  @override
  String get warrantyTab => 'Гарантия';

  @override
  String get helpTab => 'Справка';

  @override
  String nextServiceBy(Object timeStamp) {
    return 'Срок следующего сервиса: $timeStamp';
  }

  @override
  String warrantyExpiresOn(Object timeStamp) {
    return 'Гарантия истекает: $timeStamp';
  }

  @override
  String get emptyServiceText =>
      'Нет данных о сервисе\n\nЧтобы сформировать график обслуживания, укажите даты покупки, даты сервиса и межсервисные интервалы в карточках ваших часов.\n\n';

  @override
  String get emptyWarrantyText =>
      'Нет данных о гарантии\n\nЧтобы отслеживать сроки окончания гарантии, заполните поле окончания срока гарантии в карточках ваших часов.\n';

  @override
  String get serviceScheduleHelpText =>
      'График сервиса и гарантии\n\nЭта страница позволяет отслеживать сроки сервисного обслуживания (рассчитываются автоматически на основе внесенных дат и периодичности) и даты окончания гарантии, указанные вручную для каждой модели.\n';

  @override
  String get pass => 'Пройдено';

  @override
  String get fail => 'Ошибка';

  @override
  String get partialPass => 'Частично';

  @override
  String get duplicateFound => 'Найдено дублирование';

  @override
  String get successSubtitle => 'Все поля часов успешно прошли валидацию';

  @override
  String get failureSubtitle =>
      'Данная запись не может быть загружена. Не удалось определить производителя или модель часов.';

  @override
  String get partialPassSubtitle =>
      'Некоторые поля не прошли валидацию и будут проигнорированы, если их не исправить';

  @override
  String get duplicateFoundSubtitle =>
      'В приложении уже есть запись с такой маркой и моделью. Пожалуйста, убедитесь в уникальности данных';

  @override
  String get clockwise => 'По часовой';

  @override
  String get counterClockwise => 'Против часовой';

  @override
  String get both => 'В обе стороны';

  @override
  String get dateComplicationsDate => 'Дата';

  @override
  String get dateComplicationsNoDate => 'Без даты';

  @override
  String get dateComplicationsDayDate => 'День недели и дата (Day-Date)';

  @override
  String get dateComplicationsPointerDate => 'Стрелочный указатель даты';

  @override
  String get dateComplicationsSubDialDate => 'Дата на суб-циферблате';

  @override
  String get dateComplicationsPerpetualDate => 'Вечный календарь';

  @override
  String get dateComplicationsDigitalDate => 'Цифровая дата';

  @override
  String get emptyWatchboxCopy =>
      'Ваша шкатулка пуста.\n\nНажмите красную кнопку, чтобы добавить часы в коллекцию.\n\nНастроить параметры (например, формат валюты) можно нажатием на иконку шестеренки в верхнем правом углу.';

  @override
  String get emptySoldCopy =>
      'У вас нет проданных часов в коллекции.\n\nВы можете перевести часы в статус проданных через меню редактирования.\n';

  @override
  String get emptyWishlistCopy =>
      'Ваш список желаний пуст.\n\nЧтобы добавить часы в список желаний, создайте новую запись и выберите статус «В списке желаний». \n';

  @override
  String get emptyFavouritesCopy =>
      'Вы еще не добавили ни одни часы в избранное.\n\nСделать это можно с помощью переключателя на экране подробной информации о часах.\n';

  @override
  String get emptyPreOrderCopy =>
      'Вы не отслеживаете предзаказы.\n\nЧтобы включить обратный отсчет для ожидаемых часов, создайте запись со статусом «Предзаказ».';

  @override
  String get emptyOnLoanCopy =>
      'У вас пока нет часов со статусом «Выданы».\n\nВы можете изменить статус часов в меню редактирования.';

  @override
  String get listViewTitle => 'Список';

  @override
  String get gridViewTitle => 'Сетка';

  @override
  String get displayOrderTitle => 'Порядок отображения:';

  @override
  String get inOrderOfEntry => 'В порядке добавления';

  @override
  String get inReverseOrderOfEntry => 'В обратном порядке добавления';

  @override
  String get azByManufacturer => 'А-Я по производителю';

  @override
  String get zaByManufacturer => 'Я-А по производителю';

  @override
  String get orderByMostWorn => 'По частоте ношения (частые)';

  @override
  String get orderByLastWornDate => 'По дате последнего ношения';

  @override
  String get showLastWornDateOption => 'Показывать даты последнего ношения';

  @override
  String get showWearCountOption => 'Показывать количество ношений';

  @override
  String watchNamePurchased(Object watchName) {
    return '$watchName: куплены';
  }

  @override
  String watchNameSold(Object watchName) {
    return '$watchName: проданы';
  }

  @override
  String watchNamePreOrderDue(Object watchName) {
    return '$watchName: ожидается доставка предзаказа';
  }

  @override
  String watchNameLastServiced(Object watchName) {
    return '$watchName: выполнен сервис';
  }

  @override
  String watchNameNextService(Object watchName) {
    return '$watchName: плановый сервис';
  }

  @override
  String watchNameWarrantyExpires(Object watchName) {
    return '$watchName: истекает гарантия';
  }

  @override
  String get timelineSettings => 'Настройки хроники';

  @override
  String get orderAscending => 'Сортировка: по возрастанию.';

  @override
  String get orderDescending => 'Сортировка: по убыванию.';

  @override
  String get showWatchesPurchased => 'Показывать купленные часы.';

  @override
  String get showWatchesSold => 'Показывать проданные часы.';

  @override
  String get showPreOrderDueDates => 'Показывать даты предзаказов.';

  @override
  String get showLastServicedDates => 'Показывать даты последнего сервиса.';

  @override
  String get showNextServiceDates => 'Показывать даты планового сервиса.';

  @override
  String get showWarrantyEndDates => 'Показывать сроки окончания гарантии.';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacySettings => 'Настройки конфиденциальности';

  @override
  String get privacySettingsUpdated =>
      'Ваш выбор настроек конфиденциальности обновлен';

  @override
  String get privacyError =>
      'Произошла ошибка при обновлении настроек — пожалуйста, попробуйте еще раз';

  @override
  String get anAppForEnthusiasts =>
      'Приложение для часовых энтузиастов. \nСмахните, чтобы узнать о возможностях WristTrack...';

  @override
  String get yourDigitalWatchbox => 'Цифровая шкатулка';

  @override
  String get recordAllYourWatches =>
      'Вносите все свои часы — быстрый поиск, организация структуры или случайный выбор дня';

  @override
  String get trackTheDetail => 'Внимание к деталям';

  @override
  String get categoriseAndCaptureTheDetails =>
      'Классифицируйте параметры моделей, фиксируйте характеристики или добавляйте свои заметки';

  @override
  String get analyseTheData => 'Анализ данных';

  @override
  String get getInsightsWithDataAndCharts =>
      'Изучайте инсайты и наглядную статистику вашей коллекции по графикам';

  @override
  String get letsGo => 'Поехали!';

  @override
  String get skip => 'ПРОПУСТИТЬ';

  @override
  String get next => 'ДАЛЕЕ';

  @override
  String get primaryImage => 'Основное фото';

  @override
  String get updateImage => 'Обновить фото';

  @override
  String get deleteImage => 'Удалить фото';

  @override
  String imageBottomSheetTitle(Object count, Object watchName) {
    return '$watchName\nФото $count';
  }

  @override
  String get takeWithCamera => 'Сделать снимок';

  @override
  String get selectFromGallery => 'Выбрать из галереи';

  @override
  String get cropImage => 'Обрезать изображение';

  @override
  String get longPressToEditOrDelete =>
      'Долгое нажатие для редактирования или удаления';

  @override
  String watchGallery(Object watchName) {
    return 'Фотографии $watchName';
  }

  @override
  String get galleryTitle => 'Галерея часов';

  @override
  String get galleryEmptyFilterReturn =>
      'Для этого фильтра изображений не найдено';

  @override
  String galleryError(Object error) {
    return 'Произошла ошибка: $error';
  }

  @override
  String get galleryCollectionTab => 'Часы в коллекции';

  @override
  String get galleryArchivedTab => 'Архивные часы';

  @override
  String get galleryWishlistedWatchesTab => 'Из списка желаний';

  @override
  String get galleryEverythingTab => 'Все подряд';

  @override
  String get notRecordedBrackets => '(Не зафиксировано)';

  @override
  String gallerySubHeaderInCollection(Object returnText, Object watchStatus) {
    return '$watchStatus - $returnText';
  }

  @override
  String gallerySubHeaderSold(Object shortDate, Object watchStatus) {
    return '$watchStatus\nПроданы: $shortDate';
  }

  @override
  String gallerySubHeaderPreOrder(Object shortDate, Object watchStatus) {
    return '$watchStatus\nОжидаются: $shortDate';
  }

  @override
  String get currencyOptionsTitle => 'Параметры валюты';

  @override
  String get currencyOptionsGuideText =>
      'WristTrack может вести учет стоимости отдельных часов и коллекции в целом, отображая суммы в выбранном вами формате.\n\nПримечание: для корректности расчетов все цены часов должны быть внесены в одной и той же валюте.';

  @override
  String get currencyPleaseSelect =>
      'Выберите предпочтительный формат отображения валюты:';

  @override
  String get currencyExample => 'Пример вывода';

  @override
  String get currencyAdditionRequest =>
      'Не нашли нужную валюту? Свяжитесь с разработчиком, чтобы отправить запрос на добавление!';

  @override
  String get currencySterling => 'Британский фунт';

  @override
  String get currencyEuroIreland => 'Евро (Ирландия)';

  @override
  String get currencyIndianRupee => 'Индийская рупия';

  @override
  String get currencyUSDollar => 'Доллар США';

  @override
  String get currencyYen => 'Японская иена';

  @override
  String get currencyEuroTrailing => 'Евро (символ после суммы)';

  @override
  String get currencyEuroLeading => 'Евро (символ перед суммой)';

  @override
  String get currencySwissFranc => 'Швейцарский франк';

  @override
  String get currencyHungarianForint => 'Венгерский форинт';

  @override
  String get currencyPolishZloty => 'Польский злотый';

  @override
  String get currencyThaiBaht => 'Таиландский бат';

  @override
  String get currencyNorwegianKrone => 'Норвежская крона';

  @override
  String get currencyCzechKoruna => 'Чешская крона';

  @override
  String get currencyMalaysianRinggit => 'Малайзийский ринггит';

  @override
  String get currencyPhilippinePeso => 'Филиппинское песо';

  @override
  String get currencyKoreanWon => 'Южнокорейская вона';

  @override
  String get currencyBrazilianReal => 'Бразильский реал';

  @override
  String get currencyDanishKrone => 'Датская крона';

  @override
  String get currencySwedishKrona => 'Шведская крона';

  @override
  String get currencyCanadianDollar => 'Канадский доллар';

  @override
  String get caseMaterialNotEntered => 'Не указан';

  @override
  String get caseMaterialSteel => 'Сталь';

  @override
  String get caseMaterialTitanium => 'Титан';

  @override
  String get caseMaterialGold => 'Золото';

  @override
  String get caseMaterialTwoTone => 'Комбинированный (Two-Tone)';

  @override
  String get caseMaterialPlatinum => 'Платина';

  @override
  String get caseMaterialBronze => 'Бронза';

  @override
  String get caseMaterialCeramic => 'Керамика';

  @override
  String get caseMaterialCarbon => 'Карбон';

  @override
  String get caseMaterialResin => 'Полимер (Resin)';

  @override
  String get caseMaterialPlastic => 'Пластик';

  @override
  String get caseMaterialOther => 'Другой';

  @override
  String get caseMaterialPVDDLC => 'Сталь с PVD/DLC';

  @override
  String get caseMaterialTungsten => 'Вольфрам';

  @override
  String get notSelected => 'Не выбрана';

  @override
  String get categoryDiver => 'Дайверы (Diver)';

  @override
  String get categorySports => 'Спортивные';

  @override
  String get categoryFlight => 'Пилоты (Flight)';

  @override
  String get categoryField => 'Полевые (Field)';

  @override
  String get categoryDress => 'Костюмные (Dress)';

  @override
  String get categoryTool => 'Инструментальные (Tool)';

  @override
  String get categoryChronograph => 'Хронографы';

  @override
  String get categoryTravel => 'Для путешествий / GMT';

  @override
  String get notEntered => 'Не указан';

  @override
  String get movementMechanicalManual => 'Механика - ручной завод';

  @override
  String get movementMechanicalAutomatic => 'Механика - автоподзавод';

  @override
  String get movementAnalogueQuartz => 'Кварц (аналоговый)';

  @override
  String get movementDigitalQuartz => 'Кварц (цифровой)';

  @override
  String get movementAnaDigiQuartz => 'Кварц (аналогово-цифровой)';

  @override
  String get movementKinetic => 'Кинетик (Kinetic)';

  @override
  String get movementMechaQuartz => 'Мехакварц (Mecha-Quartz)';

  @override
  String get movementSmartWatch => 'Умные часы (Smartwatch)';

  @override
  String get movementTourbillon => 'Турбийон';

  @override
  String get movementSolarQuartz => 'Кварц на солнечной батарее';

  @override
  String get movementTuningFork => 'Камертонный механизм';

  @override
  String get other => 'Другой';

  @override
  String get movementSpringDrive => 'Spring Drive';

  @override
  String get archiveScreenTitle => 'Архивные часы';

  @override
  String get archiveEmptyMessage => 'Ваш архив пуст';

  @override
  String get archiveDeleteDialogConfirmTitle => 'Подтверждение удаления';

  @override
  String archiveDeleteDialogConfirmText(Object watchName) {
    return 'Вы уверены, что хотите окончательно удалить $watchName? Это действие нельзя отменить.';
  }

  @override
  String get archiveRestoreDialogTitle => 'Восстановление часов';

  @override
  String archiveRestoreDialogText(Object watchName) {
    return 'Хотите восстановить $watchName?';
  }

  @override
  String get archiveRestoreDialogStatusPicker => 'Восстановить в статус:';

  @override
  String get archiveRestoreButtonLabel => 'Восстановить';

  @override
  String get archiveBackgroundRestoreLabel => 'Восстановление...';

  @override
  String get archiveBackgroundDeleteLabel => 'Удаление...';

  @override
  String get enableDailyWearReminder => 'Напоминание о ношении';

  @override
  String get morning => 'Утро (8:00)';

  @override
  String get afternoon => 'День (12:00)';

  @override
  String get evening => 'Вечер (18:00)';

  @override
  String get customTime => 'Свое время';

  @override
  String yourReminderIsSetForTime(Object hourTimeStamp) {
    return 'Ежедневное напоминание запланировано на $hourTimeStamp';
  }

  @override
  String yourSecondReminderIsSetFor(Object hourTimeStamp) {
    return 'Второе напоминание установлено на $hourTimeStamp';
  }

  @override
  String get notificationTitle => 'Напоминание WristTrack';

  @override
  String get notificationOneBody =>
      'Не забудьте отметить, какие часы сегодня у вас на запястье!';

  @override
  String notificationConfirmationBody(Object hourTimeStamp) {
    return 'Напоминания успешно настроены на $hourTimeStamp каждый день!';
  }

  @override
  String get notificationTwoBody =>
      'Пора зафиксировать, что вы носите сегодня!';

  @override
  String notificationTwoConfirmationBody(Object hourTimeStamp) {
    return 'Второе уведомление установлено на $hourTimeStamp ежедневно!';
  }

  @override
  String get enableSecondDailyWearReminder => 'Включить второе напоминание';

  @override
  String get search => 'Поиск';

  @override
  String get noResultsFound => 'Ничего не найдено';

  @override
  String nWears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Надеты $countString раз',
      many: 'Надеты $countString раз',
      few: 'Надеты $countString раза',
      one: 'Надеты $countString раз',
      zero: 'Дни ношения не фиксировались',
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
      other: '$countString часов',
      many: '$countString часов',
      few: '$countString часов',
      one: '$countString часы',
      zero: 'Нет часов',
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
      other: '$countString дней',
      many: '$countString дней',
      few: '$countString дня',
      one: '$countString день',
      zero: '0 дней',
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
      other: '$countString лет',
      many: '$countString лет',
      few: '$countString года',
      one: '$countString год',
      zero: '0 лет',
    );
    return '$_temp0';
  }

  @override
  String get deleteWarning =>
      'Нажатие кнопки ОК безвозвратно удалит все данные о часах, включая ваш список желаний и все сохраненные фотографии.\n \n ЭТО ДЕЙСТВИЕ НЕЛЬЗЯ ОТМЕНИТЬ';

  @override
  String get backupInstruction =>
      'Нажмите кнопку ниже, чтобы создать резервную копию базы данных приложения (это может занять несколько секунд!). \n\nПосле завершения появится системное меню отправки файла, в котором вы сможете выбрать, куда сохранить или переслать бэкап.';

  @override
  String get imageBackupInstructions =>
      'Изображения часов можно экспортировать отдельно.';

  @override
  String get altExtractsGuidance =>
      '**Альтернативный экспорт данных**\n\nЭти параметры позволяют выгрузить ваши данные о часах и их ношении из **WristTrack**.\n\nОни предназначены для личного использования информации, а не для классического резервного копирования _(если вам нужно просто перенести данные на другое устройство, используйте функции Бэкапа/Восстановления)._\n\nКраткий экспорт формирует плоский список с основными характеристиками, общим количеством дней ношения и вашими заметками **(одна строка на одну модель)**.\n\nПодробный экспорт генерирует лог-файл, где каждая строчка представляет собой **отдельную дату ношения**. В него попадают только те часы, ношение которых фиксировалось **(несколько строк на одну модель)**.\n\nВыгрузка происходит в универсальном формате CSV, который легко открывается в Excel, Google Таблицах или Numbers.';

  @override
  String get watchChartsUpgradeCopy =>
      '**Графики ношения часов**\n\nГрафики распределения ношения по дням и месяцам доступны пользователям **WristTrack Pro**.\n\nОни наглядно демонстрируют, в какие периоды года и дни недели эта модель использовалась чаще всего.\n\nХотите узнать больше о возможностях премиум-версии? Нажмите кнопку ниже...';

  @override
  String get addWearSnackbarTitle => 'Ношение добавлено';

  @override
  String addWearSnackbarText(Object shortDate, Object watchName) {
    return '$watchName: зафиксировано ношение $shortDate';
  }

  @override
  String get dateDeletedSnackbarTitle => 'Дата удалена';

  @override
  String dateDeletedSnackbarText(Object shortDate, Object watchName) {
    return '$shortDate удалено из истории ношения $watchName';
  }

  @override
  String get collectionDeletedSnackbarTitle => 'Коллекция очищена';

  @override
  String get collectionDeletedSnackbarText =>
      'Ваша часовая коллекция теперь пуста';

  @override
  String get deleteWatchPermanentlySnackbarTitle => 'Часы удалены';

  @override
  String deleteWatchPermanentlySnackbarText(Object watchName) {
    return '$watchName окончательно удалены из базы данных';
  }

  @override
  String get restoreWatchSnackbarTitle => 'Часы восстановлены';

  @override
  String restoreWatchSnackbarText(Object returnText, Object watchName) {
    return '$watchName восстановлены со статусом $returnText';
  }

  @override
  String get reminderSetSnackbarTitle => 'Напоминание установлено';

  @override
  String reminderSetSnackbarText(Object returnText) {
    return 'Вы будете получать напоминание каждый день в $returnText';
  }

  @override
  String get copiedSnackbarTitle => 'Скопировано';

  @override
  String get appUserIDCopiedSnackbarText =>
      'ID пользователя скопирован в буфер обмена';

  @override
  String get serviceIntervalTitle => 'Интервал обслуживания';

  @override
  String get serviceIntervalText =>
      'Если задать межсервисный интервал, приложение автоматически рассчитает ориентировочную дату следующего обслуживания и выведет ее на экран сервиса (при условии, что указана дата покупки или дата последнего сервиса).\n  \nЗначение можно оставить равным нулю, чтобы отключить этот расчет для данной модели.';

  @override
  String get duplicateWearTitle => 'Предупреждение о дублировании';

  @override
  String get duplicateWearText =>
      'Похоже, вы уже отмечали ношение этих часов в указанный день! \n \nЕсли вы хотите зафиксировать еще один сеанс ношения за эти сутки, выберите «Добавить еще раз». \n \nВ противном случае нажмите кнопку отмены.';

  @override
  String get duplicateWearConfirm => 'Добавить еще раз';

  @override
  String get collectionStatsDialogTitle => 'Статистика коллекции';

  @override
  String get collectionStatsDialogText =>
      'Все показатели формируются строго на основе данных карточек ваших часов.\n\nТам, где расчеты завязаны на датах (например, «самые старые часы»), итоговый результат напрямую зависит от полноты и корректности информации, внесенной в приложение.\n\nВы можете изменить или дополнить информацию о любых часах, перейдя в их карточки через основные экраны шкатулки.';

  @override
  String get archivedHelpDialogTitle => 'Архив часов';

  @override
  String get archivedHelpDialogText =>
      'Когда часам присваивается статус «В архиве», они убираются из основного пространства шкатулки и переносятся сюда.\n\nЗаписи в архиве можно окончательно стереть свайпом влево или вернуть обратно в коллекцию, сделав свайп вправо.';

  @override
  String get backupHelpDialogTitle => 'Резервное копирование БД';

  @override
  String get backupHelpDialogText =>
      'Переходите на новый телефон или хотите застраховаться от непредвиденных сбоев?\n Вы в правильном месте!\n\nСоздайте локальный бэкап вашей шкатулки или восстановите данные из ранее сохраненного файла.\n\nВнимание: Восстановление данных полностью сотрет текущую информацию в приложении и ЗАМЕНИТ ее содержимым бэкапа.\n\nЕсли во время импорта/экспорта возникли зависания, обычно это решается принудительным перезапуском приложения.';

  @override
  String get incorrectFilenameDialogTitle => 'Неверный файл';

  @override
  String incorrectFilenameDialogText(Object fileName) {
    return 'Файл $fileName не совпадает с ожидаемым системным именем watchbox.hive\n\nПожалуйста, выберите корректный файл watchbox.hive';
  }

  @override
  String get confirmRestoreDialogTitle => 'Восстановление из бэкапа';

  @override
  String get confirmRestoreDialogText =>
      'Импорт этого бэкапа полностью перезапишет текущее содержимое вашей шкатулки.\n\nВы действительно хотите продолжить?';

  @override
  String get restoreFailedTitle => 'Ошибка восстановления';

  @override
  String restoreFailedText(Object error) {
    return 'Не удалось выполнить восстановление данных. Ошибка:\n\n$error\n\nПожалуйста, попробуйте еще раз. Если проблема повторится, свяжитесь с разработчиком приложения.';
  }

  @override
  String get restoreSuccessDialogTitle => 'Восстановление выполнено';

  @override
  String get restoreSuccessDialogText =>
      'База данных успешно восстановлена!\n\nЕсли список часов не обновился мгновенно, попробуйте переключиться между основными вкладками меню.';

  @override
  String get backupLocationNullDialogText =>
      'Не указано место для сохранения бэкапа. Сначала выберите целевую папку или директорию.';

  @override
  String backupFailedDialogText(Object error) {
    return 'Ошибка бэкапа\n\n$error\n\nВозможно, у приложения нет прав доступа к выбранной папке. Попробуйте выбрать другой путь на устройстве.\n\nЕсли это не помогло, пожалуйста, отправьте отчет разработчику через страницу магазина приложений.';
  }

  @override
  String watchboxFailedErrorDialog(Object error) {
    return 'Не удалось повторно открыть шкатулку\n\n$error\n\nПодобные сбои часто устраняются путем полного закрытия и перезапуска приложения.\n\nЕсли проблема сохраняется, направьте обращение разработчику через магазин приложений.';
  }

  @override
  String get backupCompleteDialogTitle => 'Резервная копия создана';

  @override
  String get backupCompleteDialogText => 'Данные WatchBox успешно сохранены.';

  @override
  String get wristTrackUpdatedBottomSheetTitle =>
      'Приложение WristTrack обновилось...';

  @override
  String get futureDateErrorDialogText =>
      'Дата ношения не может быть в будущем. Пожалуйста, выберите корректный день.';

  @override
  String get notificationSettingsHelpDialogTitle => 'Настройки уведомлений';

  @override
  String get notificationsSettingsHelpDialogText =>
      'При активации приложение будет ежедневно присылать напоминание в выбранное вами время.';

  @override
  String get notificationSettingsHelpDialogTextAndroid =>
      '\n\nПримечание: Некоторые производители устройств используют агрессивные встроенные алгоритмы экономии заряда батареи в Android ОС, что может блокировать отправку фоновых уведомлений.\n\nК сожалению, на уровне разработки обойти эти системные ограничения невозможно. \n\nЧаще всего с этой проблемой сталкиваются владельцы смартфонов Huawei и Xiaomi, но она может проявляться и на устройствах других брендов.';

  @override
  String get wearDatesHelpDialogTitle => 'История ношения';

  @override
  String get wearDatesHelpDialogText =>
      'В этом календаре отмечаются дни, когда вы надевали данные часы, а также другие важные контрольные даты этой модели.\n\nЧтобы быстро добавить или стереть запись ношения прямо отсюда, используйте долгое нажатие на нужную ячейку календаря.';

  @override
  String get deleteImageDialogTitle => 'Удалить изображение';

  @override
  String get deleteImageDialogText =>
      'Вы действительно хотите удалить эту фотографию?\nЭто действие нельзя отменить.';

  @override
  String get deleteWatchTitle => 'Удалить часы';

  @override
  String get deleteWatchDialogText =>
      'Вы хотите удалить эти часы из своей коллекции?\n\n(Часы, удаленные по ошибке, можно найти и восстановить через Архив в Настройках приложения).';

  @override
  String get deleteWatchSnackbarConfirmation => 'Часы удалены';

  @override
  String deleteWatchSnackbarText(Object watchName) {
    return '$watchName перенесены в Архив';
  }

  @override
  String get failedToPickImageDialogTitle => 'Ошибка выбора изображения';

  @override
  String failedToPickImageDialogText(Object error) {
    return 'Операционная система вернула ошибку:\n\n$error';
  }

  @override
  String get setupDailyReminderDialogTitle => 'Настройка напоминаний';

  @override
  String get setupDailyRemindersDialogText =>
      'WristTrack может присылать вам ежедневное напоминание, чтобы вы не забывали фиксировать, какую модель носите сегодня.\n\nХотите настроить напоминание сейчас?\n\n(Вы всегда сможете включить или изменить его позже через меню настроек).';

  @override
  String get soldStatusPopupDialogText =>
      'Вы переводите часы в статус проданных:\n\nТеперь вы можете внести точную дату сделки, финальную цену продажи и данные о покупателе на вкладках «Даты» и «Ценность».';

  @override
  String get preorderStatusPopupDialogTitle => 'Предзаказы часов';

  @override
  String get preorderStatusPopupDialogText =>
      'Вы переводите часы в статус предзаказа:\n\nТеперь вы можете указать ожидаемую дату поставки на вкладке «Даты», чтобы запустить таймер обратного отсчета.';

  @override
  String get noImagesFoundPopupTitle => 'Изображения не найдены';

  @override
  String get noImagesFoundPopupText =>
      'Экспорт не выполнен, так как в приложении отсутствуют загруженные фотографии часов.';

  @override
  String get failedToBackupImagesDialogTitle => 'Ошибка экспорта изображений';

  @override
  String failedToBackupImagesDialogText(Object error) {
    return 'Не удалось создать резервную копию фотографий. Ошибка устройства:\n$error';
  }

  @override
  String imageBackupSuccessDialogText(Object count) {
    return 'Успешно экспортировано изображений: $count';
  }

  @override
  String get watchboxSuccessfullyBackedUpText =>
      'Резервная копия шкатулки успешно создана';

  @override
  String get extractSuccessfullyCreatedDialogText =>
      'Файл экспорта успешно сформирован';

  @override
  String get generalErrorDialogTitle => 'Что-то пошло не так!';

  @override
  String generalErrorDialogText(Object error) {
    return 'Произошла непредвиденная ошибка: $error';
  }

  @override
  String get proDialogText =>
      'Эта функция доступна в версии WristTrack Pro.\n\nНажмите ниже, чтобы узнать больше и перейти на Pro.';

  @override
  String get saveUpdates => 'Сохранить изменения';

  @override
  String get updatesSaved => 'Изменения сохранены';

  @override
  String get editWatchUnsavedChangesTitle => 'Есть несохраненные изменения';

  @override
  String get editWatchUnsavedChangesCopy =>
      'Вы действительно хотите выйти? Все внесенные несохраненные правки будут потеряны.';

  @override
  String get editWatchUnsavedChangesExitOption => 'Выйти без сохранения';

  @override
  String get editWatchUnsavedChangesContinueEditingOption =>
      'Продолжить редактирование';
}
