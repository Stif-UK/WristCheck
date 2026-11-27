import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wristcheck/controllers/uploads_controller.dart';
import 'package:wristcheck/controllers/wristcheck_controller.dart';
import 'package:wristcheck/l10n/app_localizations.dart';
import 'package:wristcheck/model/enums/complication_enums/date_complication_enum.dart';
import 'package:wristcheck/model/enums/upload_status_enum.dart';
import 'package:wristcheck/model/extract_methods.dart';
import 'package:wristcheck/model/upload_methods.dart';
import 'package:wristcheck/model/upload_models.dart';
import 'package:wristcheck/model/watches.dart';
import 'package:wristcheck/model/wristcheck_preferences.dart';
import 'package:wristcheck/ui/uploads/uploads_landing.dart';
import 'package:wristcheck/ui/uploads/uploads_validation.dart';
import 'package:wristcheck/ui/uploads/watch_validation.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    await initializeDateFormatting();
    tempDir = await Directory.systemTemp.createTemp('wristcheck_uploads_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WatchesAdapter());
    }
  });

  setUp(() async {
    Get.reset();
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').clear();
    } else {
      await Hive.openBox<Watches>('WatchBox');
    }
    SharedPreferences.setMockInitialValues({
      'appPurchased': false,
      'locale': 'en_US',
    });
    await WristCheckPreferences.init();
  });

  tearDownAll(() async {
    if (Hive.isBoxOpen('WatchBox')) {
      await Hive.box<Watches>('WatchBox').close();
    }
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Watches buildExistingWatch({
    required String manufacturer,
    required String model,
    String status = 'In Collection',
    String? referenceNumber,
    int? purchasePrice,
    List<DateTime>? wearList,
  }) {
    return Watches.fromJson({
      'manufacturer': manufacturer,
      'model': model,
      'status': status,
      'reference_number': referenceNumber,
      'purchase_price': purchasePrice,
      'favourite': false,
      'service_interval': 0,
      'wear_list': (wearList ?? <DateTime>[]).map((d) => d.toIso8601String()).toList(),
    })
      ..ensureInitialized();
  }

  group('CSV header analysis & flexible parsing', () {
    test('analyzeHeader matches aliases in any order and flags unrecognized headers', () {
      final header = ['  Make ', 'Custom Column', 'Watch Model', 'Wear Date', 'Price Paid'];
      final result = UploadMethods.analyzeHeader(header);

      expect(result.isValid, isTrue);
      expect(result.missingRequiredFields, isEmpty);
      expect(result.matchedColumns[CsvFieldKey.manufacturer], 0);
      expect(result.matchedColumns[CsvFieldKey.model], 2);
      expect(result.matchedColumns[CsvFieldKey.dateWorn], 3);
      expect(result.matchedColumns[CsvFieldKey.purchasePrice], 4);
      expect(result.unrecognizedHeaders, ['Custom Column']);
    });

    test('analyzeHeader reports missing required fields when Manufacturer or Model absent', () {
      final result = UploadMethods.analyzeHeader(['Status', 'Brand', 'Purchase Price']);
      expect(result.isValid, isFalse);
      expect(result.missingRequiredFields, [CsvFieldKey.model]);
    });

    test('parseAndGroupRows groups multiple wear-date rows and supports delimited fallback', () {
      const csvText = '\uFEFFMake,Model,Date Worn,Purchase Price,Case Diameter,Reference Number\n'
          'Omega,Speedmaster,2025-01-05,£6500,42mm,310.30.42.50.01.001\n'
          'Omega,Speedmaster,2025-01-12; 2025-01-20,,,\n'
          'Omega,Speedmaster,2025-01-12,,,\n'
          'Seiko,SPB143,15/02/2025,null,40.5,null\n';

      final rows = UploadMethods.parseCsvString(csvText);
      final header = UploadMethods.analyzeHeader(rows.first);
      final candidates = UploadMethods.parseAndGroupRows(
        rows,
        header,
        nowOverride: DateTime(2026, 1, 1),
      );

      expect(candidates.length, 2);

      final omega = candidates[0];
      expect(omega.manufacturer, 'Omega');
      expect(omega.model, 'Speedmaster');
      expect(omega.sourceRowNumbers, [2, 3, 4]);
      expect(omega.purchasePrice, 6500);
      expect(omega.caseDiameter, 42.0);
      expect(omega.referenceNumber, '310.30.42.50.01.001');
      expect(omega.wearDates.length, 3);
      expect(omega.computedStatus, UploadStatusEnum.pass);

      final seiko = candidates[1];
      expect(seiko.manufacturer, 'Seiko');
      expect(seiko.model, 'SPB143');
      expect(seiko.purchasePrice, isNull);
      expect(seiko.referenceNumber, isNull);
      expect(seiko.wearDates, [DateTime(2025, 2, 15)]);
      expect(seiko.computedStatus, UploadStatusEnum.pass);
    });

    test('invalid or future wear dates produce warnings without failing valid watches', () {
      const csvText = 'Manufacturer,Model,Date Worn,Case Diameter\n'
          'Casio,F-91W,not-a-date; 2099-01-01,not-a-num\n';

      final rows = UploadMethods.parseCsvString(csvText);
      final header = UploadMethods.analyzeHeader(rows.first);
      final candidates = UploadMethods.parseAndGroupRows(
        rows,
        header,
        nowOverride: DateTime(2026, 1, 1),
      );

      expect(candidates.length, 1);
      final casio = candidates.first;
      expect(casio.wearDates, isEmpty);
      expect(casio.invalidWearDateValues.length, 2);
      expect(casio.hasWarnings, isTrue);
      expect(casio.computedStatus, UploadStatusEnum.partialpass);
    });
  });

  group('Duplicate detection, merge, and commit', () {
    test('detects Make + Model duplicate and defaults to mergeFillEmpty', () async {
      final box = Hive.box<Watches>('WatchBox');
      final existing = buildExistingWatch(
        manufacturer: 'Omega',
        model: 'Speedmaster',
        referenceNumber: 'EXISTING-REF',
        purchasePrice: null,
        wearList: [DateTime(2025, 1, 5)],
      );
      await box.add(existing);

      const csvText = 'Manufacturer,Model,Reference Number,Purchase Price,Date Worn\n'
          ' omega , speedmaster ,NEW-REF,6500,2025-01-05\n'
          ' omega , speedmaster ,NEW-REF,6500,2025-01-12\n';

      final rows = UploadMethods.parseCsvString(csvText);
      final header = UploadMethods.analyzeHeader(rows.first);
      final candidates = UploadMethods.parseAndGroupRows(
        rows,
        header,
        nowOverride: DateTime(2026, 1, 1),
      );

      expect(candidates.length, 1);
      final candidate = candidates.first;
      expect(candidate.isDuplicate, isTrue);
      expect(candidate.duplicateResolution, DuplicateResolution.mergeFillEmpty);
      expect(candidate.computedStatus, UploadStatusEnum.duplicate);
      expect(candidate.countNewWearDatesFor(existing), 1);

      final commitResult = await UploadMethods.commitImport(candidates, triggerSync: false);
      expect(commitResult.mergedCount, 1);
      expect(commitResult.createdCount, 0);
      expect(commitResult.wearDatesAdded, 1);
      expect(commitResult.wearDatesSkippedDuplicate, 1);

      final updated = box.values.first;
      // Existing non-empty reference should be preserved on fill-blank merge
      expect(updated.referenceNumber, 'EXISTING-REF');
      // Blank purchasePrice should be filled
      expect(updated.purchasePrice, 6500);
      // Wear dates should have 2025-01-05 + 2025-01-12
      expect(updated.wearList.length, 2);
      expect(updated.isDirty, isTrue);
    });

    test('supports mergeOverwrite and createNew resolutions', () async {
      final box = Hive.box<Watches>('WatchBox');
      await box.add(buildExistingWatch(
        manufacturer: 'Seiko',
        model: 'SKX007',
        referenceNumber: 'OLD-REF',
      ));
      await box.add(buildExistingWatch(
        manufacturer: 'Tudor',
        model: 'Black Bay 58',
        referenceNumber: 'TUDOR-1',
      ));

      const csvText = 'Manufacturer,Model,Reference Number,Date Worn\n'
          'Seiko,SKX007,NEW-REF,2025-02-01\n'
          'Tudor,Black Bay 58,TUDOR-2,2025-02-02\n';

      final rows = UploadMethods.parseCsvString(csvText);
      final header = UploadMethods.analyzeHeader(rows.first);
      final candidates = UploadMethods.parseAndGroupRows(
        rows,
        header,
        nowOverride: DateTime(2026, 1, 1),
      );

      candidates[0].duplicateResolution = DuplicateResolution.mergeOverwrite;
      candidates[1].duplicateResolution = DuplicateResolution.createNew;

      final result = await UploadMethods.commitImport(candidates, triggerSync: false);
      expect(result.mergedCount, 1);
      expect(result.createdCount, 1);
      expect(result.wearDatesAdded, 2);
      expect(box.values.length, 3);

      final seiko = box.values.firstWhere((w) => w.manufacturer == 'Seiko');
      expect(seiko.referenceNumber, 'NEW-REF');

      final tudors = box.values.where((w) => w.manufacturer == 'Tudor').toList();
      expect(tudors.length, 2);
    });
  });

  group('Uploads UI flow widget tests', () {
    Widget buildTestApp(Widget home) {
      return GetMaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      );
    }

    testWidgets('UploadsLanding -> UploadsValidation -> WatchValidation -> Commit flow',
        (tester) async {
      final box = Hive.box<Watches>('WatchBox');
      await tester.runAsync(() => box.add(buildExistingWatch(
        manufacturer: 'Omega',
        model: 'Seamaster',
        wearList: [DateTime(2025, 1, 1)],
      )));

      Get.put(WristCheckController());
      final uploadsController = Get.put(UploadsController());

      const csvText = 'Make,Model,Date Worn,Ignored Col\n'
          'Omega,Seamaster,2025-01-10,foo\n'
          'Rolex,Explorer,2025-01-15,bar\n';
      final parsedRows = UploadMethods.parseCsvString(csvText);

      await tester.pumpWidget(
        buildTestApp(
          UploadsLanding(
            csvPickerOverride: () async => parsedRows,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Select CSV File'), findsOneWidget);
      await tester.tap(find.text('Select CSV File'));
      await tester.pumpAndSettle();

      // Should navigate to UploadsValidation
      expect(find.text('Data Review'), findsOneWidget);
      expect(find.textContaining('Columns Detected (3 of'), findsOneWidget);
      expect(find.text('2 Watches'), findsOneWidget);
      expect(find.text('Omega Seamaster'), findsOneWidget);
      expect(find.text('Rolex Explorer'), findsOneWidget);

      // Navigate to WatchValidation for Rolex Explorer
      await tester.tap(find.text('Rolex Explorer'));
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
      // Save without losing data and return
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Data Review'), findsOneWidget);

      // Verify state was preserved and trigger commit via UploadsValidation with sync disabled
      expect(uploadsController.readyToImportCount, 2);
      final result = await tester.runAsync(
        () => uploadsController.commitImport(triggerSync: false),
      );
      expect(result!.mergedCount, 1);
      expect(result.createdCount, 1);
      expect(box.values.length, 2);
    });

    testWidgets('UploadsValidation commits and shows Import Complete dialog', (tester) async {
      Get.put(WristCheckController());
      final controller = Get.put(UploadsController());
      final rows = UploadMethods.parseCsvString(
        'Manufacturer,Model,Date Worn\nNomos,Tangente,2025-03-01\n',
      );
      controller.loadParsedRows(rows);

      await tester.pumpWidget(
        buildTestApp(
          UploadsValidation(triggerSyncOnCommit: false),
        ),
      );
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.text('Import Watches'));
        await tester.pump();
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();

      expect(find.text('Import Complete'), findsOneWidget);
      expect(find.text('New watches created: 1'), findsOneWidget);
      expect(find.text('Wear dates added: 1'), findsOneWidget);
      expect(Hive.box<Watches>('WatchBox').values.length, 1);
    });

    testWidgets('WatchValidation allows editing fields and persists back to controller',
        (tester) async {
      Get.put(WristCheckController());
      final controller = Get.put(UploadsController());
      final rows = UploadMethods.parseCsvString(
        'Manufacturer,Model\nSeiko,Alpinist\n',
      );
      controller.loadParsedRows(rows);

      await tester.pumpWidget(
        buildTestApp(
          Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () => Get.to(() => WatchValidation(index: 0)),
                child: const Text('Open Editor'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Editor'));
      await tester.pumpAndSettle();

      // Edit Model text field
      final modelField = find.widgetWithText(TextFormField, 'Alpinist');
      expect(modelField, findsOneWidget);
      await tester.enterText(modelField, 'Prospex Alpinist');
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(controller.candidates.first.model, 'Prospex Alpinist');
    });

    testWidgets('UploadsLanding enum-validated column chips open accepted values dialog',
        (tester) async {
      await tester.pumpWidget(buildTestApp(UploadsLanding()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Recognised Column Titles & Formats'));
      await tester.tap(find.text('Recognised Column Titles & Formats'));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Status'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Status'));
      await tester.pumpAndSettle();

      expect(find.text('Status Values'), findsOneWidget);
      expect(find.text('In Collection'), findsOneWidget);
      expect(find.text('Pre-Order'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Status Values'), findsNothing);
    });

    test('generateAiAssistantPrompt includes required fields, wear date rule, and enum values', () {
      final prompt = UploadMethods.generateAiAssistantPrompt();
      expect(prompt, contains('Manufacturer, Model'));
      expect(prompt, contains('Date Worn'));
      expect(prompt, contains('YYYY-MM-DD'));
      expect(prompt, contains('In Collection'));
      expect(prompt, contains('PVD/DLC Steel'));
      expect(prompt, contains('Counter-Clockwise'));
      expect(prompt, contains('Big Date'));
    });

    test('DateComplicationEnum and parseDateComplication support Big Date', () {
      expect(DateComplicationEnum.bigdate.toDbString(), 'Big Date');
      expect(
        DateComplicationEnumLocalization.fromDbString('Big Date'),
        DateComplicationEnum.bigdate,
      );
      expect(UploadMethods.parseDateComplication('Big Date'), 'Big Date');
      expect(UploadMethods.parseDateComplication('big date'), 'Big Date');
    });

    testWidgets('UploadsLanding AI assistant card copies prompt to clipboard', (tester) async {
      String? copiedText;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedText = (call.arguments as Map)['text'] as String?;
        }
        return null;
      });
      addTearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null);
      });

      await tester.pumpWidget(buildTestApp(UploadsLanding()));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Prepare CSV with an AI Assistant'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Prepare CSV with an AI Assistant'));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView).first, const Offset(0, -500));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Copy Prompt'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy Prompt'));
      await tester.pumpAndSettle();

      expect(copiedText, isNotNull);
      expect(copiedText, contains('WristTrack'));
      expect(find.text('AI prompt copied to clipboard'), findsOneWidget);
    });
  });

  group('ExtractMethods CSV export & round-trip compatibility', () {
    test('buildSimpleExtractCsv includes new fields, omits null strings and deleted watches', () {
      final active = Watches.fromJson({
        'manufacturer': 'Omega',
        'model': 'Speedmaster',
        'favourite': true,
        'status': 'In Collection',
        'primary_colour': 'Black',
        'secondary_colour': 'Silver',
        'year': 2023,
        'service_interval': 5,
        'next_service_due': '2028-01-10T00:00:00.000',
        'purchase_date': '2023-01-10T00:00:00.000',
        'value': 6800,
        'power_reserve': 50,
        'notes': 'Moonwatch',
        'wear_list': ['2025-01-05T00:00:00.000'],
      });
      final deleted = Watches.fromJson({
        'manufacturer': 'DeletedBrand',
        'model': 'DeletedModel',
        'is_deleted': true,
        'wear_list': <String>[],
      });

      final csv = ExtractMethods.buildSimpleExtractCsv([active, deleted]);
      final rows = UploadMethods.parseCsvString(csv);

      expect(rows.length, 2);
      expect(rows.first, containsAll(['Favourite', 'Primary Colour', 'Secondary Colour', 'Model Year', 'Delivery Date', 'Service Interval', 'Next Service Due', 'Current Value', 'Power Reserve', 'Notes', 'Tracked Wear Count']));
      expect(csv, isNot(contains('DeletedBrand')));
      expect(csv, isNot(contains(',null,')));
      expect(csv, contains('2023-01-10'));
      expect(csv, contains('Moonwatch'));
    });

    test('buildComplexExtractCsv preserves unworn watches and round-trips through UploadMethods', () {
      final worn = Watches.fromJson({
        'manufacturer': 'Seiko',
        'model': 'SPB143',
        'favourite': true,
        'status': 'In Collection',
        'primary_colour': 'Grey',
        'year': 2022,
        'power_reserve': 70,
        'value': 1100,
        'notes': 'Should stay out of complex extract',
        'wear_list': ['2025-01-10T00:00:00.000', '2025-01-15T00:00:00.000'],
      });
      final unworn = Watches.fromJson({
        'manufacturer': 'Nomos',
        'model': 'Tangente',
        'status': 'Wishlist',
        'wear_list': <String>[],
      });

      final csv = ExtractMethods.buildComplexExtractCsv([worn, unworn]);
      final rows = UploadMethods.parseCsvString(csv);

      // Header + 2 rows for worn watch + 1 row for unworn watch
      expect(rows.length, 4);
      expect(rows.first, isNot(contains('Notes')));
      expect(csv, isNot(contains('Should stay out of complex extract')));

      final header = UploadMethods.analyzeHeader(rows.first);
      expect(header.isValid, isTrue);

      final candidates = UploadMethods.parseAndGroupRows(
        rows,
        header,
        nowOverride: DateTime(2026, 1, 1),
      );
      expect(candidates.length, 2);
      expect(candidates[0].manufacturer, 'Seiko');
      expect(candidates[0].wearDates.length, 2);
      expect(candidates[0].favourite, isTrue);
      expect(candidates[0].primaryColour, 'Grey');
      expect(candidates[0].year, 2022);
      expect(candidates[0].powerReserve, 70);
      expect(candidates[0].value, 1100);
      expect(candidates[1].manufacturer, 'Nomos');
      expect(candidates[1].wearDates, isEmpty);
      expect(candidates[1].status, 'Wishlist');
    });
  });
}
